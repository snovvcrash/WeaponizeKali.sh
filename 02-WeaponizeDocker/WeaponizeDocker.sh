#!/usr/bin/env bash

nocolor="\033[0m"
green="\033[0;32m"
yellow="\033[0;33m"
red="\033[0;31m"
red_bold="\033[1;31m"
blue="\033[0;34m"
light_gray="\033[0;37m"
dark_gray="\033[1;30m"
magenta_bold="\033[1;35m"

SITE="https://github.com/snovvcrash/WeaponizeKali.sh/tree/main/02-WeaponizeDocker"
VERSION="0.1.0"

echo -e "${red_bold}                                                      (${nocolor}"
echo -e "${red_bold} (  (                                                 )\ )                )                      )${nocolor}"
echo -e "${red_bold} )\))(   '   (     )                    (         (  (()/(             ( /(    (   (          ( /(${nocolor}"
echo -e "${red_bold}((_)()\ )   ))\ ( /(  \`  )    (    (    )\  (    ))\  /(_))   (    (   )\())  ))\  )(     (   )\())${nocolor}"
echo -e "${red_bold}_(())\_)() /((_))(_)) /(/(    )\   )\ )((_) )\  /((_)(_))_    )\   )\ ((_)\  /((_)(()\    )\ ((_)\ ${nocolor}"
echo -e "${light_gray}\ \((_)/ /(_)) ((_)_ ((_)_\  ((_) _(_/( (_)((_)(_))   |   \  ((_) ((_)| |(_)(_))   ((_)  ((_)| |(_)${nocolor}"
echo -e "${light_gray} \ \/\/ / / -_)/ _\` || '_ \)/ _ \| ' \))| ||_ // -_)  | |) |/ _ \/ _| | / / / -_) | '_|_ (_-<| ' \ ${nocolor}"
echo -e "${light_gray}  \_/\_/  \___|\__,_|| .__/ \___/|_||_| |_|/__|\___|  |___/ \___/\__| |_\_\ \___| |_| (_)/__/|_||_|${nocolor}"
echo -e "${light_gray}                     |_|${nocolor}"
echo    "                                                                                     are u a whale?"
echo -e "         ${magenta_bold}{${dark_gray} ${SITE} ${magenta_bold}} ${magenta_bold}{${dark_gray} v${VERSION} ${magenta_bold}}${nocolor}"
echo

# -----------------------------------------------------------------------------
# --------------------------------- Messages ----------------------------------
# -----------------------------------------------------------------------------

info() {
	echo -e "${blue}[*] $1${nocolor}"
}

success() {
	echo -e "${green}[+] $1${nocolor}"
}

warning() {
	echo -e "${yellow}[!] $1${nocolor}"
}

fail() {
	echo -e "${red}[-] $1${nocolor}"
}

progress() {
	echo -e "${magenta_bold}[WPNZDCKR] Installing $1${nocolor}"
}

# -----------------------------------------------------------------------------
# ---------------------------------- Helpers ----------------------------------
# -----------------------------------------------------------------------------

_pushd() {
	pushd $1 2>&1 > /dev/null
}

_popd() {
	popd 2>&1 > /dev/null
}

installDebPackage() {
	pkg_name=$1
	if ! /usr/bin/dpkg-query -f '${Status}' -W $pkg_name 2>&1 | /bin/grep "ok installed" > /dev/null; then
		warning "$pkg_name not found, installing with apt"
		apt install $pkg_name -y
	fi
	success "Installed deb package(s): $pkg_name"
}

cloneRepository() {
	url=$1
	repo_name=${url##*/}
	repo_name=${repo_name%.*}

	if [ -z "$2" ]; then
		dname=$repo_name
	else
		dname=$2
	fi

	if git clone --recurse-submodules -q $url $dname; then
		success "Cloned repository: $repo_name"
	else
		fail "Failed to clone repository: $repo_name"
	fi
}

downloadRawFile() {
	url=$1
	filename=$2
	if curl -sSL $url -o $filename; then
		success "Downloaded raw file: $filename"
	else
		fail "Failed to download raw file: $filename"
	fi
}

# -----------------------------------------------------------------------------
# ------------------------------- Dependencies --------------------------------
# -----------------------------------------------------------------------------

_jq() {
	installDebPackage "jq"
}

_eget() {
	_pushd /tmp
	curl "https://zyedidia.github.io/eget.sh" | sh
	mkdir /opt/eget
	mv eget /opt/eget
	ln -sv "/opt/eget/eget" /usr/local/bin/eget
	_popd
}

dependencies() {
	_jq
	_eget
}

# -----------------------------------------------------------------------------
# ----------------------------------- tools -----------------------------------
# -----------------------------------------------------------------------------

CrackMapExec() {
	progress "CrackMapExec"
	pipx install -f "git+https://github.com/Porchetta-Industries/CrackMapExec.git"
}

DivideAndScan() {
	progress "DivideAndScan"
	pipx install -f "git+https://github.com/snovvcrash/DivideAndScan.git"
}

PEASS() {
	installDebPackage "peass"
}

amicontained() {
	_pushd /opt/tools
	progress "amicontained"
	echo 1 | eget -qs linux/amd64 "genuinetools/amicontained" --to amicontained
	_popd
}

audit2rbac() {
	_pushd /opt/tools
	progress "audit2rbac"
	eget -qs linux/amd64 "liggitt/audit2rbac" --to audit2rbac
	_popd
}

badPods() {
	_pushd /opt/tools
	progress "badPods"
	cloneRepository "https://github.com/BishopFox/badPods.git"
	_popd
}

ccat() {
	_pushd /opt/tools
	progress "ccat"
	cloneRepository "https://github.com/RhinoSecurityLabs/ccat.git"
	cd ccat
	python3 setup.py install
	_popd
}

deepce() {
	_pushd /opt/tools
	progress "deepce"
	cloneRepository "https://github.com/stealthcopter/deepce.git"
	_popd
}

dnsx() {
	_pushd /opt/tools
	progress "dnsx"
	mkdir dnsx
	eget -qs linux/amd64 "projectdiscovery/dnsx" --to dnsx
	_popd
}

docker-bench-security() {
	_pushd /opt/tools
	progress "docker-bench-security"
	cloneRepository "https://github.com/docker/docker-bench-security.git"
	_popd
}

dockerfilelint() {
	progress "dockerfilelint"
	npm install -g dockerfilelint
}

dockscan() {
	progress "dockscan"
	gem install dockscan
}

dsniff() {
	progress "dsniff"
	#sysctl -w net.ipv4.ip_forward=1
	#sh -c 'echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf'
	installDebPackage "dsniff"
}

dwn() {
	progress "dwn"
	pipx install -f "git+https://github.com/sensepost/dwn.git"
}

etcd() {
	_pushd /opt/tools
	progress "etcd"
	eget -qs linux/amd64 "etcd-io/etcd" --to etcd
	_popd
}

feroxbuster() {
	_pushd /opt/tools
	progress "feroxbuster"
	echo 1 | eget -qs linux/amd64 "epi052/feroxbuster" --to feroxbuster
	_popd
}

ffuf() {
	progress "ffuf"
	installDebPackage "ffuf"
}

gitleaks() {
	_pushd /opt/tools
	progress "gitleaks"
	eget -qs linux/amd64 "zricethezav/gitleaks" --to gitleaks
	_popd
}

grype() {
	_pushd /opt/tmp
	progress "grype"
	echo 1 | eget -qs linux/amd64 "anchore/grype" --to grype.deb
	dpkg -i grype.deb
	rm grype.deb
	_popd
}

http-server() {
	progress "http-server"
	npm install -g http-server
}

httpx() {
	_pushd /opt/tools
	progress "httpx"
	mkdir httpx
	eget -qs linux/amd64 "projectdiscovery/httpx" --to httpx
	_popd
}

kube-bench() {
	_pushd /opt/tools
	progress "kube-bench"
	echo 1 | eget -qs linux/amd64 "aquasecurity/kube-bench" --to kube-bench.deb
	dpkg -i kube-bench.deb
	rm kube-bench.deb
	_popd
}

kube-hunter() {
	progress "kube-hunter"
	pipx install -f "git+https://github.com/aquasecurity/kube-hunter.git"
}

kubeaudit() {
	_pushd /opt/tools
	progress "kubeaudit"
	eget -qs linux/amd64 "Shopify/kubeaudit" --to kubeaudit
	_popd
}

kubectl-who-can() {
	_pushd /opt/tools
	progress "kubectl-who-can"
	eget -qs linux/amd64 "aquasecurity/kubeaudit" --to kubectl-who-can
	_popd
}

kubelet-anon-rce() {
	_pushd /opt/tools
	progress "kubelet-anon-rce"
	cloneRepository "https://github.com/serain/kubelet-anon-rce.git"
	cd kubelet-anon-rce
	python3 -m pip install -U -r requirements.txt
	_popd
}

kubeletctl() {
	_pushd /opt/tools
	progress "kubeletctl"
	eget -qs linux/amd64 "cyberark/kubeletctl" --to kubeletctl
	_popd
}

kubesec() {
	_pushd /opt/tools
	progress "kubesec"
	eget -qs linux/amd64 "controlplaneio/kubesec" --to kubesec
	_popd
}

masscan() {
	_pushd /opt/tools
	progress "masscan"
	cloneRepository "https://github.com/robertdavidgraham/masscan.git"
	cd masscan
	make
	make install
	_popd
}

seclists() {
	progress "seclists"
	installDebPackage "seclists"
}

ssb() {
	_pushd /opt/tools
	progress "ssb"
	eget -qs linux/amd64 "kitabisa/ssb" --to ssb
	_popd
}

tools() {
	CrackMapExec
	DivideAndScan
	PEASS
	amicontained
	audit2rbac
	badPods
	#ccat
	deepce
	dnsx
	docker-bench-security
	dockerfilelint
	dockscan
	dsniff
	dwn
	etcd
	feroxbuster
	ffuf
	gitleaks
	grype
	http-server
	httpx
	kube-bench
	kube-hunter
	kubeaudit
	kubectl-who-can
	kubelet-anon-rce
	kubeletctl
	kubesec
	masscan
	seclists
	ssb
}

# -----------------------------------------------------------------------------
# ----------------------------------- Main ------------------------------------
# -----------------------------------------------------------------------------

apt update
dependencies
tools
