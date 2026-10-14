#!/bin/bash

set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[1;33m'
CYN='\033[0;36m'
RST='\033[0m'

# ─── Usage ────────────────────────────────────────────────────────────────────
usage() {
    echo -e "\
${YEL}Usage:${RST}
  ${0##*/} <TIMEOUT> <IP> <PORT> [RESOLVE_FLAG] [THREADS]

${CYN}Arguments:${RST}
  TIMEOUT     Connection timeout in seconds (integer)
  IP          Target host(s) — accepts:
                • Single IP/hostname          192.168.1.1 / host.example.com
                • Comma-separated list        192.168.1.1,192.168.1.2
                • CIDR notation               192.168.1.0/24
                • IP range (dash)             10.0.0.1-10.0.0.20
                • Short range                 192.168.1.1-20
                • File (one target per line)   /path/to/hosts.txt
  PORT        Target port(s) — accepts:
                • Single port                 80
                • Comma-separated             22,80,443
                • Range (dash)                20-25
  RESOLVE     (optional) 'r' or 'resolve' — omit -n from nc to enable DNS resolution
  THREADS     (optional) Number of parallel jobs, 2 or more (requires GNU parallel)
               0 or 1 = sequential mode — one check at a time (default: 0)

${CYN}Examples:${RST}
  ${0##*/} 3 192.168.1.1 22
  ${0##*/} 3 192.168.1.0/24 80,443 r 50
  ${0##*/} 3 targets.txt 22-25 resolve 20"
    exit 1
}

# ─── Argument validation ─────────────────────────────────────────────────────
[[ $# -lt 3 ]] && usage

TIMEOUT="$1"
IP_ARG="$2"
PORT_ARG="$3"
RESOLVE_FLAG="${4:-}"
THREADS="${5:-}"

# Validate timeout
if ! [[ "$TIMEOUT" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}[!] Error: TIMEOUT must be a positive integer.${RST}" >&2
    exit 1
fi

# Validate resolve flag
RESOLVE=false
if [[ "${RESOLVE_FLAG,,}" == "r" || "${RESOLVE_FLAG,,}" == "resolve" ]]; then
    RESOLVE=true
elif [[ -n "$RESOLVE_FLAG" && "$RESOLVE_FLAG" =~ ^[0-9]+$ && -z "$THREADS" ]]; then
    # User skipped resolve flag and passed threads as 4th arg
    THREADS="$RESOLVE_FLAG"
elif [[ -n "$RESOLVE_FLAG" && ! "$RESOLVE_FLAG" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}[!] Error: Unrecognised RESOLVE flag '${RESOLVE_FLAG}'. Use 'r', 'resolve', or leave empty.${RST}" >&2
    exit 1
fi

# Validate threads (0 and 1 = sequential mode: one check at a time)
if [[ -n "$THREADS" ]]; then
    if ! [[ "$THREADS" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}[!] Error: THREADS must be a non-negative integer.${RST}" >&2
        exit 1
    fi
    if [[ "$THREADS" -gt 1 ]] && ! command -v parallel &>/dev/null; then
        echo -e "${RED}[!] Error: GNU parallel is required when THREADS is greater than 1.${RST}" >&2
        echo -e "${YEL}    Install: sudo apt install parallel  /  brew install parallel${RST}" >&2
        echo -e "${YEL}    Or use THREADS=0 or 1 for sequential mode.${RST}" >&2
        exit 1
    fi
fi
THREADS="${THREADS:-0}"   # default: sequential mode

# ─── Dependency check ────────────────────────────────────────────────────────
if ! command -v nc &>/dev/null; then
    echo -e "${RED}[!] Missing dependency: nc (netcat)${RST}" >&2
    echo -e "${YEL}    Install: sudo apt install netcat-openbsd${RST}" >&2
    exit 1
fi

# ─── IP arithmetic helpers (pure bash — no external processes) ───────────────
_ip_to_int() {
    local IFS='.'
    read -r a b c d <<< "$1"
    echo $(( (10#$a << 24) + (10#$b << 16) + (10#$c << 8) + 10#$d ))
}

_int_to_ip() {
    local ip="$1"
    printf '%d.%d.%d.%d\n' \
        $(( (ip >> 24) & 255 )) \
        $(( (ip >> 16) & 255 )) \
        $(( (ip >> 8)  & 255 )) \
        $((  ip        & 255 ))
}

# Strip leading/trailing whitespace (replaces `echo | xargs`)
_trim() {
    local s="$1"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s' "$s"
}

# Validate a dotted-quad IPv4 (all octets 0-255)
_valid_ipv4() {
    local ip="$1"
    [[ "$ip" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]] || return 1
    (( 10#${BASH_REMATCH[1]} <= 255 && 10#${BASH_REMATCH[2]} <= 255 \
    && 10#${BASH_REMATCH[3]} <= 255 && 10#${BASH_REMATCH[4]} <= 255 ))
}

# ─── Expand IP targets (pure bash — no xargs/prips subprocesses) ────────────
expand_ips() {
    local input="$1"
    local items=()

    # Split on commas
    IFS=',' read -ra items <<< "$input"

    local item
    for item in "${items[@]}"; do
        item="$(_trim "$item")"
        [[ -z "$item" ]] && continue

        if [[ -f "$item" ]]; then
            # ── File: read each line and recursively expand
            local line
            while IFS= read -r line || [[ -n "$line" ]]; do
                line="$(_trim "$line")"
                [[ -z "$line" || "$line" == \#* ]] && continue
                expand_ips "$line"
            done < "$item"

        elif [[ "$item" =~ ^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/([0-9]{1,2})$ ]]; then
            # ── CIDR notation (replaces prips)
            local net="${BASH_REMATCH[1]}" pfx=$((10#${BASH_REMATCH[2]}))
            if ! _valid_ipv4 "$net" || (( pfx > 32 )); then
                echo -e "${RED}[!] Error: Invalid CIDR '${item}'.${RST}" >&2
                exit 1
            fi
            local mask start end ip
            if (( pfx == 0 )); then
                mask=0
            else
                mask=$(( (0xFFFFFFFF << (32 - pfx)) & 0xFFFFFFFF ))
            fi
            local base=$(_ip_to_int "$net")
            start=$(( base & mask ))
            end=$((   start | (mask ^ 0xFFFFFFFF) ))
            for (( ip = start; ip <= end; ip++ )); do
                _int_to_ip "$ip"
            done

        elif [[ "$item" =~ ^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})-([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$ ]]; then
            # ── Full IP range: 10.0.0.1-10.0.0.20
            local range_start="${BASH_REMATCH[1]}" range_end="${BASH_REMATCH[2]}"
            if ! _valid_ipv4 "$range_start" || ! _valid_ipv4 "$range_end"; then
                echo -e "${RED}[!] Error: Invalid IP range '${item}'.${RST}" >&2
                exit 1
            fi
            local start_int end_int ip
            start_int=$(_ip_to_int "$range_start")
            end_int=$(_ip_to_int "$range_end")
            for (( ip = start_int; ip <= end_int; ip++ )); do
                _int_to_ip "$ip"
            done

        elif [[ "$item" =~ ^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)([0-9]{1,3})-([0-9]{1,3})$ ]]; then
            # ── Short range: 192.168.1.1-20
            local prefix="${BASH_REMATCH[1]}" lo="${BASH_REMATCH[2]}" hi="${BASH_REMATCH[3]}"
            if ! _valid_ipv4 "${prefix}${lo}" || (( 10#$hi > 255 )); then
                echo -e "${RED}[!] Error: Invalid IP range '${item}'.${RST}" >&2
                exit 1
            fi
            local i
            for (( i = 10#$lo; i <= 10#$hi; i++ )); do
                echo "${prefix}${i}"
            done

        elif [[ "$item" == *"/"* ]]; then
            echo -e "${RED}[!] Error: Invalid CIDR '${item}'.${RST}" >&2
            exit 1

        else
            # ── Single IP or hostname
            echo "$item"
        fi
    done
}

# ─── Expand ports (pure bash) ────────────────────────────────────────────────
expand_ports() {
    local input="$1"
    local items=()
    IFS=',' read -ra items <<< "$input"

    local item
    for item in "${items[@]}"; do
        item="$(_trim "$item")"
        if [[ "$item" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            local p
            for (( p = 10#${BASH_REMATCH[1]}; p <= 10#${BASH_REMATCH[2]}; p++ )); do
                echo "$p"
            done
        elif [[ "$item" =~ ^[0-9]+$ ]]; then
            echo "$item"
        else
            echo -e "${RED}[!] Invalid port: $item${RST}" >&2
            exit 1
        fi
    done
}

# ─── Core check function ────────────────────────────────────────────────────
check_port() {
    local timeout="$1"
    local host="$2"
    local port="$3"
    local force_resolve="$4"

    # With resolve:    nc  -vzw<T>  (lets nc do DNS resolution / shows resolved name)
    # Without resolve: nc -nvzw<T>  (-n skips DNS)
    local nc_flags
    if [[ "$force_resolve" == "true" ]] || ! [[ "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        nc_flags="-vzw${timeout}"
    else
        nc_flags="-nvzw${timeout}"
    fi

    local output rc line
    rc=0
    # nc writes connection info to stderr; capture it to keep nc's own
    # chatter out of the results
    output=$(nc $nc_flags "$host" "$port" 2>&1) || rc=$?

    # Re-emit proxychains diagnostics (chain/DNS/proxy-error lines) that
    # landed in the capture; skip the per-process "DLL init" banner.
    # Prints nothing when not running under proxychains.
    while IFS= read -r line; do
        [[ "$line" == *"[proxychains]"* && "$line" != *"DLL init"* ]] && printf '%s\n' "$line" >&2
    done <<< "$output"

    if [[ "$rc" -eq 0 ]]; then
        echo -e "${GRN}[OPEN]${RST} ${host}:${port}"
    else
        echo -e "${RED}[CLOSED]${RST} ${host}:${port}" >&2
    fi
}

# Export for GNU parallel
export -f check_port 2>/dev/null || true
export RED GRN YEL CYN RST 2>/dev/null || true

# ─── Build target list (pure bash dedup — no sort/grep/awk processes) ───────
IP_LIST=()
declare -A _seen_ip=()
while IFS= read -r _ip; do
    [[ -z "$_ip" ]] && continue
    [[ -n "${_seen_ip[$_ip]:-}" ]] && continue
    _seen_ip["$_ip"]=1
    IP_LIST+=("$_ip")
done < <(expand_ips "$IP_ARG")

PORT_LIST=()
declare -A _seen_port=()
while IFS= read -r _port; do
    [[ -z "$_port" ]] && continue
    [[ -n "${_seen_port[$_port]:-}" ]] && continue
    _seen_port["$_port"]=1
    PORT_LIST+=("$_port")
done < <(expand_ports "$PORT_ARG")

TOTAL_IPS=${#IP_LIST[@]}
TOTAL_PORTS=${#PORT_LIST[@]}
TOTAL_CHECKS=$(( TOTAL_IPS * TOTAL_PORTS ))

if [[ "$TOTAL_IPS" -eq 0 ]]; then
    echo -e "${RED}[!] No valid targets resolved from '${IP_ARG}'.${RST}" >&2
    exit 1
fi

if [[ "$TOTAL_PORTS" -eq 0 ]]; then
    echo -e "${RED}[!] No valid ports resolved from '${PORT_ARG}'.${RST}" >&2
    exit 1
fi

# echo -e "${YEL}──────────────────────────────────────────────────${RST}"
# echo -e "${CYN} tnc.sh — TCP Port Checker${RST}"
# echo -e "${YEL}──────────────────────────────────────────────────${RST}"
# echo -e " Targets : ${TOTAL_IPS} host(s)"
# echo -e " Ports   : ${TOTAL_PORTS} port(s)  [${PORT_ARG}]"
# echo -e " Checks  : ${TOTAL_CHECKS} total"
# echo -e " Timeout : ${TIMEOUT}s"
# echo -e " Resolve : ${RESOLVE}"
# [[ "$THREADS" -gt 1 ]] && echo -e " Threads : ${THREADS} (GNU parallel)"
# echo -e "${YEL}──────────────────────────────────────────────────${RST}"
# echo ""

# ─── Execute checks ─────────────────────────────────────────────────────────
if [[ "$THREADS" -gt 1 ]]; then
    # ── Parallel mode (job list streams from a process substitution:
    #    no mktemp/rm processes, and Ctrl-C leaves no temp file behind) ────
    parallel --will-cite -j "$THREADS" --colsep ' ' \
        check_port {1} {2} {3} {4} < <(
            for host in "${IP_LIST[@]}"; do
                for port in "${PORT_LIST[@]}"; do
                    echo "$TIMEOUT $host $port $RESOLVE"
                done
            done
        )
else
    # ── Sequential mode ───────────────────────────────────────────────────
    for host in "${IP_LIST[@]}"; do
        for port in "${PORT_LIST[@]}"; do
            check_port "$TIMEOUT" "$host" "$port" "$RESOLVE"
        done
    done
fi

# echo ""
# echo -e "${YEL}──────────────────────────────────────────────────${RST}"
# echo -e "${GRN} Done. ${TOTAL_CHECKS} check(s) completed.${RST}"
# echo -e "${YEL}──────────────────────────────────────────────────${RST}"
