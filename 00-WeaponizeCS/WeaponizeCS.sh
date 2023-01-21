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

SITE="https://github.com/snovvcrash/WeaponizeKali.sh/tree/main/00-WeaponizeCS"
VERSION="0.1.1"

echo -e "${red_bold}                                                            (${nocolor}"
echo -e "${red_bold} (  (                                                  (    )\ )           )${nocolor}"
echo -e "${red_bold} )\))(   '   (     )                    (         (    )\  (()/(        ( /(${nocolor}"
echo -e "${red_bold}((_)()\ )   ))\ ( /(  \`  )    (    (    )\  (    ))\ (((_)  /(_))   (   )\())${nocolor}"
echo -e "${red_bold}_(())\_)() /((_))(_)) /(/(    )\   )\ )((_) )\  /((_))\___ (_))     )\ ((_)\ ${nocolor}"
echo -e "${light_gray}\ \((_)/ /(_)) ((_)_ ((_)_\  ((_) _(_/( (_)((_)(_)) ((/ __|/ __|   ((_)| |(_)${nocolor}"
echo -e "${light_gray} \ \/\/ / / -_)/ _\` || '_ \)/ _ \| ' \))| ||_ // -_) | (__ \__ \ _ (_-<| ' \ ${nocolor}"
echo -e "${light_gray}  \_/\_/  \___|\__,_|| .__/ \___/|_||_| |_|/__|\___|  \___||___/(_)/__/|_||_|${nocolor}"
echo -e "${light_gray}                     |_|${nocolor}"
echo    "                                    adversary simulation? red team operation?"
echo -e "${magenta_bold}{${dark_gray} ${SITE} ${magenta_bold}} ${magenta_bold}{${dark_gray} v${VERSION} ${magenta_bold}}${nocolor}"
echo

# -----------------------------------------------------------------------------
# ----------------------------------- Init ------------------------------------
# -----------------------------------------------------------------------------

filesystem() {
	mkdir Profiles Scripts Toolkits
}

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
	echo -e "${magenta_bold}[WPNZCS] Installing $1${nocolor}"
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
		sudo apt install $pkg_name -y
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

dependencies() {
	_jq
}

# -----------------------------------------------------------------------------
# ---------------------------------- Scripts ----------------------------------
# -----------------------------------------------------------------------------

AceLdr() {
	_pushd Scripts
	progress "AceLdr"
	cloneRepository "https://github.com/kyleavery/AceLdr.git"
	cd AceLdr
	make
	_popd
}

BOF-RegSave() {
	_pushd Scripts
	progress "BOF-RegSave"
	cloneRepository "https://github.com/EncodeGroup/BOF-RegSave.git"
	cd BOF-RegSave
	make
	_popd
}

BOFs() {
	_pushd Scripts
	progress "BOFs"
	cloneRepository "https://github.com/ajpc500/BOFs.git"
	_popd
}

BeaconDownloadSync() {
	_pushd Scripts
	progress "BeaconDownloadSync"
	cloneRepository "https://github.com/EspressoCake/BeaconDownloadSync.git"
	_popd
}

BofRoast() {
	_pushd Scripts
	progress "BofRoast"
	cloneRepository "https://github.com/cube0x0/BofRoast.git"
	_popd
}

BokuLoader() {
	_pushd Scripts
	progress "BokuLoader"
	cloneRepository "https://github.com/boku7/BokuLoader.git"
	cd BokuLoader
	make
	_popd
}

C2-Tool-Collection() {
	_pushd Scripts
	progress "C2-Tool-Collection"
	cloneRepository "https://github.com/outflanknl/C2-Tool-Collection.git"
	_popd
}

CS-Remote-OPs-BOF() {
	_pushd Scripts
	progress "CS-Remote-OPs-BOF"
	cloneRepository "https://github.com/trustedsec/CS-Remote-OPs-BOF.git"
	cd CS-Remote-OPs-BOF/BOF
	make
	_popd
}

CS-Situational-Awareness-BOF() {
	_pushd Scripts
	progress "CS-Situational-Awareness-BOF"
	cloneRepository "https://github.com/trustedsec/CS-Situational-Awareness-BOF.git"
	cd CS-Situational-Awareness-BOF
	./make_all.sh
	_popd
}

Chisel-Strike() {
	_pushd Scripts
	progress "CS-Situational-Awareness-BOF"
	cloneRepository "https://github.com/m3rcer/Chisel-Strike.git"
	cd Chisel-Strike
	chmod +x -R chisel-modules
	chmod +x -R tools
	_popd
}

CobaltWhispers() {
	_pushd Scripts
	progress "CobaltWhispers"
	cloneRepository "https://github.com/NVISOsecurity/CobaltWhispers.git"
	_popd
}

DelegationBOF() {
	_pushd Scripts
	progress "DelegationBOF"
	cloneRepository "https://github.com/IcebreakerSecurity/DelegationBOF.git"
	cd DelegationBOF
	make
	_popd
}

ExecuteAssembly() {
	_pushd Scripts
	progress "ExecuteAssembly"
	cloneRepository "https://github.com/med0x2e/ExecuteAssembly.git"
	_popd
}

FindObjects-BOF() {
	_pushd Scripts
	progress "FindObjects-BOF"
	cloneRepository "https://github.com/outflanknl/FindObjects-BOF.git"
	cd FindObjects-BOF
	make
	_popd
}

HelpColor() {
	_pushd Scripts
	progress "HelpColor"
	cloneRepository "https://github.com/outflanknl/HelpColor.git"
	_popd
}

InlineExecute-Assembly() {
	_pushd Scripts
	progress "InlineExecute-Assembly"
	cloneRepository "https://github.com/anthemtotheego/InlineExecute-Assembly.git"
	_popd
}

Invoke-CredentialPhisher() {
	_pushd Scripts
	progress "Invoke-CredentialPhisher"
	cloneRepository "https://github.com/fox-it/Invoke-CredentialPhisher.git"
	_popd
}

LdapSignCheck() {
	_pushd Scripts
	progress "LdapSignCheck"
	cloneRepository "https://github.com/cube0x0/LdapSignCheck.git"
	_popd
}

PersistBOF() {
	_pushd Scripts
	progress "PersistBOF"
	cloneRepository "https://github.com/IcebreakerSecurity/PersistBOF.git"
	cd PersistBOF
	make
	_popd
}

PortBender() {
	_pushd Scripts
	progress "PortBender"
	cloneRepository "https://github.com/praetorian-inc/PortBender.git"
	_popd
}

Quser-BOF() {
	_pushd Scripts
	progress "Quser-BOF"
	cloneRepository "https://github.com/netero1010/Quser-BOF.git"
	_popd
}

RdpThief() {
	_pushd Scripts
	progress "RdpThief"
	cloneRepository "https://github.com/0x09AL/RdpThief.git"
	_popd
}

ScreenshotBOF() {
	_pushd Scripts
	progress "ScreenshotBOF"
	cloneRepository "https://github.com/CodeXTF2/ScreenshotBOF.git"
	_popd
}

SyscallPack() {
	_pushd Scripts
	progress "SyscallPack"
	cloneRepository "https://github.com/cube0x0/SyscallPack.git"
	_popd
}

SysmonQuiet() {
	_pushd Scripts
	progress "SysmonQuiet"
	cloneRepository "https://github.com/ScriptIdiot/SysmonQuiet.git"
	_popd
}

cs-token-vault() {
	_pushd Scripts
	progress "cs-token-vault"
	cloneRepository "https://github.com/Henkru/cs-token-vault.git"
	cd cs-token-vault
	make all
	_popd
}

freeBokuLoader() {
	_pushd Scripts
	progress "freeBokuLoader"
	cloneRepository "https://github.com/S4ntiagoP/freeBokuLoader.git"
	cd freeBokuLoader
	make
	_popd
}

inject-assembly() {
	_pushd Scripts
	progress "inject-assembly"
	cloneRepository "https://github.com/kyleavery/inject-assembly.git"
	cd inject-assembly
	make
	_popd
}

injectAmsiBypass() {
	_pushd Scripts
	progress "injectAmsiBypass"
	cloneRepository "https://github.com/boku7/injectAmsiBypass.git"
	cd injectAmsiBypass
	x86_64-w64-mingw32-gcc -c inject-amsiBypass.c -o inject-amsiBypass.o
	_popd
}

injectEtwBypass() {
	_pushd Scripts
	progress "injectEtwBypass"
	cloneRepository "https://github.com/boku7/injectEtwBypass.git"
	cd injectEtwBypass
	bash compile.sh
	_popd
}

mimikatz() {
	_pushd Scripts
	progress "mimikatz"
	cloneRepository "https://gist.github.com/tothi/2809d548f7407de781892c4f840fdee1.git" /tmp/mimikatz
	mv "/tmp/mimikatz/mimikatz.cna" mimikatz.cna
	rm -rf /tmp/mimikatz
	_popd
}

nanodump() {
	_pushd Scripts
	progress "nanodump"
	cloneRepository "https://github.com/helpsystems/nanodump.git"
	_popd
}

Scripts() {
	AceLdr
	BOF-RegSave
	BOFs
	BeaconDownloadSync
	BofRoast
	BokuLoader
	C2-Tool-Collection
	CS-Remote-OPs-BOF
	CS-Situational-Awareness-BOF
	Chisel-Strike
	DelegationBOF
	ExecuteAssembly
	FindObjects-BOF
	HelpColor
	InlineExecute-Assembly
	Invoke-CredentialPhisher
	LdapSignCheck
	PersistBOF
	PortBender
	RdpThief
	SyscallPack
	cs-token-vault
	freeBokuLoader
	inject-assembly
	injectAmsiBypass
	injectEtwBypass
	mimikatz
	nanodump
}

# -----------------------------------------------------------------------------
# --------------------------------- Profiles ----------------------------------
# -----------------------------------------------------------------------------

BC-SECURITY-Malleable-C2-Profiles() {
	_pushd Profiles
	progress "BC-SECURITY-Malleable-C2-Profiles"
	cloneRepository "https://github.com/BC-SECURITY/Malleable-C2-Profiles.git"
	_popd
}

C2concealer() {
	_pushd Profiles
	progress "C2concealer"
	cloneRepository "https://github.com/FortyNorthSecurity/C2concealer.git"
	python3 -m pip install .
	_popd
}

CobaltNotion() {
	_pushd Profiles
	progress "CobaltNotion"
	cloneRepository "https://github.com/HuskyHacks/CobaltNotion.git"
	_popd
}

SourcePoint() {
	_pushd Profiles
	progress "SourcePoint"
	mkdir SourcePoint
	eget -qs linux/amd64 "Tylous/SourcePoint" --to SourcePoint
	_popd
}

minimal-defender-bypass() {
	_pushd Profiles
	progress "minimal-defender-bypass"
	cloneRepository "https://gist.github.com/tothi/8abd2de8f4948af57aa2d027f9e59efe.git" /tmp/minimal-defender-bypass
	mv "/tmp/minimal-defender-bypass/minimal-defender-bypass.profile" minimal-defender-bypass.profile
	rm -rf /tmp/minimal-defender-bypass
	_popd
}

random_c2_profile() {
	_pushd Profiles
	progress "random_c2_profile"
	cloneRepository "https://github.com/threatexpress/random_c2_profile.git"
	cd random_c2_profile
	python3 -m pip install -r requirements.txt
	_popd
}

threatexpress-malleable-c2() {
	_pushd Profiles
	progress "threatexpress-malleable-c2"
	cloneRepository "https://github.com/threatexpress/malleable-c2.git"
	_popd
}

Profiles() {
	BC-SECURITY-Malleable-C2-Profiles
	C2concealer
	CobaltNotion
	SourcePoint
	minimal-defender-bypass
	random_c2_profile
	threatexpress-malleable-c2
}

# -----------------------------------------------------------------------------
# ----------------------------------- Main ------------------------------------
# -----------------------------------------------------------------------------

filesystem
dependencies
Scripts
Profiles
