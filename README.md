<p align="center">
  <img src="https://user-images.githubusercontent.com/23141800/114306819-c1877380-9ae5-11eb-967c-d7d71935cca6.png" alt="banner" />
</p>

**WeaponizeKali.sh** is a Bash script aimed at automating the process of downloading and installing extra tools for internal penetration tests with Kali Linux.

Basic principles behind this project are:

1. Use bleeding-edge versions of offensive toolkits to possess their latest features and fixes.
2. When installing 3rd party software, use isolated environments to minimize potential dependency hell.
3. Keep Windows exploitation scripts and binaries on hand in case you find yourself in an "offline situation".

The script will create two directories within CWD: `tools` and `www`. The [first](#tools) one contains all the tools that will be installed on Kali. The [second](#www) one contains all the scripts and binaries that will be downloaded and may be delivered onto the victim host later.

## Usage

WeaponizeKali.sh heavily relies on Python virtual environments and uses [pipx](https://pipxproject.github.io/pipx/) and [poetry](https://python-poetry.org/) to orchestra venvs.

In order to launch the bleeding-edge version of a tool installed with pipx and not the version that is already shipped with Kali, you should modify the `PATH` variables:

1. Modify `PATH` for a normal user with any method you want (`.bashrc` / `.profile` / `.zshrc` / etc.): `export PATH="$HOME/.local/bin:$PATH"`.
2. Modify `PATH` for the superuser by modifying `secure_path` within sudoers (`sudo visudo`):

![sudoers](https://user-images.githubusercontent.com/23141800/103461896-b5e02000-4d32-11eb-936e-6764ceae1372.png)

Now you can download WeaponizeKali.sh and run it from your home directory (pip may prompt for unlocking the keyring during the process). When it's done, you can check the results in `~/tools` and `~/www`:

```console
~$ cd
~$ curl -sL https://github.com/penetrarnya-tm/WeaponizeKali.sh/raw/main/WeaponizeKali.sh | bash -s -- -idtw
~$ ls -la tools www
```

:warning: **Warning:** when using the `-i` switch, existing `./tools` and `./www` directories will be deleted.

If you only want to get the deliverable scripts and binaries (i.e., `www` directory), you can do it like this:

```console
~$ mkdir www
~$ curl -sL https://github.com/penetrarnya-tm/WeaponizeKali.sh/raw/main/WeaponizeKali.sh | bash -s -- -w
~$ ls -la www
```

It's recommended to run WeaponizeKali.sh once on a clean installation of Kali Linux.

### Rerun the Installations

To execute WeaponizeKali.sh with full set of arguments again after it has already been ran once, remove the existent virtual environments first and then run the script:

```console
~$ cd
~$ rm -rf .local/pipx tools www
~$ ./WeaponizeKali.sh -idtw
```

### Help

```
~$ ./WeaponizeKali.sh -h
                                                         )
 (  (                                                  ( /(       (                )
 )\))(   '   (     )                    (         (    )\())   )  )\ (          ( /(
((_)()\ )   ))\ ( /(  `  )    (    (    )\  (    ))\  ((_)\ ( /( ((_))\     (   )\())
_(())\_)() /((_))(_)) /(/(    )\   )\ )((_) )\  /((_) _ ((_))(_)) _ ((_)    )\ ((_)\
\ \((_)/ /(_)) ((_)_ ((_)_\  ((_) _(_/( (_)((_)(_))  | |/ /((_)_ | | (_)   ((_)| |(_
 \ \/\/ / / -_)/ _` || '_ \)/ _ \| ' \))| ||_ // -_) | ' < / _` || | | | _ (_-<| ' \
  \_/\_/  \___|\__,_|| .__/ \___/|_||_| |_|/__|\___| |_|\_\\__,_||_| |_|(_)/__/|_||_|
                     |_|
                           "the more tools you install, the more you are able to PWN"
                    { https://github.com/penetrarnya-tm/WeaponizeKali.sh } { vX.Y.Z }

usage: WeaponizeKali.sh [-h] [-i] [-d] [-t] [w]

optional arguments:
  -h                    show this help message and exit
  -i                    initialize filesystem (re-create ./tools and ./www directories)
  -d                    resolve dependencies
  -t                    download and install tools on Kali Linux
  -w                    download scripts and binaries for delivering onto the victim host
```

## Available Tools

### `tools`

* [x] [BloodHound.py](https://github.com/fox-it/BloodHound.py)
* [x] [BloodHound](https://github.com/BloodHoundAD/BloodHound/releases)
* [x] [CVE-2019-1040-scanner](https://github.com/fox-it/cve-2019-1040-scanner)
* [x] [CVE-2020-1472-checker](https://github.com/SecuraBV/CVE-2020-1472)
* [x] [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec)
* [x] [DivideAndScan](https://github.com/snovvcrash/DivideAndScan)
* [x] [Ebowla](https://github.com/Genetic-Malware/Ebowla)
* [x] [Empire](https://github.com/BC-SECURITY/Empire)
* [x] [LDAPPER](https://github.com/shellster/LDAPPER)
* [x] [MS17-010](https://github.com/helviojunior/MS17-010)
* [x] [Neo-reGeorg](https://github.com/L-codes/Neo-reGeorg)
* [x] [Nim](https://nim-lang.org/install_unix.html) · [choosenim](https://github.com/dom96/choosenim)
* [x] [Nim-Scripts](https://github.com/S3cur3Th1sSh1t/Creds/tree/master/nim)
* [x] [PCredz](https://github.com/lgandx/PCredz)
* [x] [PrivExchange](https://github.com/dirkjanm/PrivExchange)
* [x] [Responder](https://github.com/lgandx/Responder)
* [x] [RustScan](https://github.com/RustScan/RustScan/releases)
* [x] [ShellPop](https://github.com/0x00-0x00/ShellPop)
* [x] [TrustVisualizer](https://github.com/HarmJ0y/TrustVisualizer)
* [x] [Windows-Exploit-Suggester](https://github.com/AonCyberLabs/Windows-Exploit-Suggester)
* [x] [ack3](https://github.com/beyondgrep/ack3)
* [x] [aclpwn.py](https://github.com/fox-it/aclpwn.py)
* [x] [adidnsdump](https://github.com/dirkjanm/adidnsdump)
* [x] [aquatone](https://github.com/michenriksen/aquatone/releases)
* [x] [bettercap](https://github.com/bettercap/bettercap/releases)
* [x] [bloodhound-quickwin](https://github.com/kaluche/bloodhound-quickwin)
* [x] [chisel](https://github.com/jpillora/chisel/releases)
* [x] [crowbar](https://github.com/galkan/crowbar)
* [x] [dementor.py](https://gist.github.com/3xocyte/cfaf8a34f76569a8251bde65fe69dccc)
* [x] [dsniff](https://github.com/tecknicaltom/dsniff)
* [x] [enum4linux-ng](https://github.com/cddmp/enum4linux-ng)
* [x] [evil-winrm](https://github.com/Hackplayers/evil-winrm)
* [x] [ffuf](https://github.com/ffuf/ffuf/releases)
* [x] [gateway-finder-imp](https://github.com/whitel1st/gateway-finder-imp)
* [x] [gitjacker](https://github.com/liamg/gitjacker/releases)
* [x] [gobuster](https://github.com/OJ/gobuster/releases)
* [x] [htbenum](https://github.com/SolomonSklash/htbenum)
* [x] [impacket](https://github.com/SecureAuthCorp/impacket)
* [x] [ipmitool](https://github.com/ipmitool/ipmitool)
* [x] [kerbrute](https://github.com/ropnop/kerbrute/releases)
* [x] [krbrelayx](https://github.com/dirkjanm/krbrelayx)
* [x] [ldapdomaindump](https://github.com/dirkjanm/ldapdomaindump)
* [x] [lsassy](https://github.com/Hackndo/lsassy)
* [x] [masscan](https://github.com/robertdavidgraham/masscan)
* [x] [mitm6](https://github.com/fox-it/mitm6)
* [x] [naabu](https://github.com/projectdiscovery/naabu/releases)
* [x] [nishang](https://github.com/samratashok/nishang)
* [x] [ntlm-scanner](https://github.com/preempt/ntlm-scanner)
* [x] [ntlmv1-multi](https://github.com/evilmog/ntlmv1-multi)
* [x] [nullinux](https://github.com/m8r0wn/nullinux)
* [x] [odat](https://github.com/quentinhardy/odat)
* [x] [pyGPOAbuse](https://github.com/Hackndo/pyGPOAbuse)
* [x] [pypykatz](https://github.com/skelsec/pypykatz)
* [x] [pywerview](https://github.com/the-useless-one/pywerview)
* [x] [rbcd-attack](https://github.com/tothi/rbcd-attack)
* [x] [rbcd_permissions](https://github.com/NinjaStyle82/rbcd_permissions)
* [x] [rdp-tunnel](https://github.com/NotMedic/rdp-tunnel)
* [x] [spraykatz](https://github.com/aas-n/spraykatz)
* [x] [updog](https://github.com/sc0tfree/updog)
* [x] [xc](https://github.com/xct/xc)

### `www`

* [x] [ADRecon.ps1](https://github.com/adrecon/ADRecon/blob/master/ADRecon.ps1)
* [x] [ASREPRoast.ps1](https://github.com/HarmJ0y/ASREPRoast/blob/master/ASREPRoast.ps1)
* [x] [AccessChk (Sysinternals)](https://docs.microsoft.com/en-us/sysinternals/downloads/accesschk) · [AccessChk (accepteula)](https://xor.cat/2017/09/05/sysinternals-accesschk-accepteula/)
* [x] [Bypass-AMSI.ps1](https://gist.github.com/snovvcrash/5c9ee38bb9a8802a674ec3d3d33b4717)
* [x] [Bypass-UAC.ps1](https://gist.github.com/snovvcrash/362be57caaa167e7f5667156ac80f445)
* [x] [Discover-PSMSExchangeServers](https://github.com/PyroTek3/PowerShell-AD-Recon/blob/master/Discover-PSMSExchangeServers)
* [x] [Discover-PSMSSQLServers](https://github.com/PyroTek3/PowerShell-AD-Recon/blob/master/Discover-PSMSSQLServers)
* [x] [DomainPasswordSpray.ps1](https://github.com/dafthack/DomainPasswordSpray/blob/master/DomainPasswordSpray.ps1)
* [x] [Intercept-NG](http://sniff.su/)
* [x] [Inveigh.ps1](https://github.com/Kevin-Robertson/Inveigh/blob/master/Inveigh.ps1)
* [x] [InveighZero](https://github.com/Kevin-Robertson/InveighZero) · [Pre-Compiled](https://github.com/Flangvik/SharpCollection/blob/master/NetFramework_4.0_x64/Inveigh.exe) · [PowerSharpPack.ps1](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpPack.ps1)
* [x] [Invoke-ACLPwn.ps1](https://github.com/fox-it/Invoke-ACLPwn/blob/master/Invoke-ACLPwn.ps1)
* [x] [Invoke-ImpersonateUser-PTH.ps1](https://github.com/S3cur3Th1sSh1t/NamedPipePTH/blob/main/Invoke-ImpersonateUser-PTH.ps1)
* [x] [Invoke-Kerberoast.ps1 (Empire)](https://github.com/BC-SECURITY/Empire/blob/master/data/module_source/credentials/Invoke-Kerberoast.ps1)
* [x] [Invoke-Mimikatz.ps1 (Empire)](https://github.com/BC-SECURITY/Empire/blob/master/data/module_source/credentials/Invoke-Mimikatz.ps1)
* [x] [Invoke-Portscan.ps1 (PowerSploit)](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/Invoke-Portscan.ps1)
* [x] [Invoke-RunasCs.ps1](https://github.com/antonioCoco/RunasCs/blob/master/Invoke-RunasCs.ps1)
* [x] [Invoke-SMBClient.ps1](https://github.com/Kevin-Robertson/Invoke-TheHash/blob/master/Invoke-SMBClient.ps1)
* [x] [Invoke-SMBEnum.ps1](https://github.com/Kevin-Robertson/Invoke-TheHash/blob/master/Invoke-SMBEnum.ps1)
* [x] [Invoke-SMBExec.ps1](https://github.com/Kevin-Robertson/Invoke-TheHash/blob/master/Invoke-SMBExec.ps1)
* [x] [Invoke-WMIExec.ps1](https://github.com/Kevin-Robertson/Invoke-TheHash/blob/master/Invoke-WMIExec.ps1)
* [x] [JAWS](https://github.com/411Hall/JAWS/blob/master/jaws-enum.ps1)
* [x] [JuicyPotato64](https://github.com/ohpe/juicy-potato/releases) · [JuicyPotato32](https://github.com/ivanitlearning/Juicy-Potato-x86/releases)
* [x] [Out-EncryptedScript.ps1 (PowerSploit)](https://github.com/PowerShellMafia/PowerSploit/blob/master/ScriptModification/Out-EncryptedScript.ps1)
* [x] [PEASS](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite) · [linPEAS.sh](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/blob/master/linPEAS/linpeas.sh) · [winPEAS.exe](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/blob/master/winPEAS/winPEASexe/binaries/Release/winPEASany.exe)
* [x] [PowerUp.ps1 (PowerSploit)](https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1)
* [x] [PowerUpSQL.ps1](https://github.com/NetSPI/PowerUpSQL/blob/master/PowerUpSQL.ps1)
* [x] [PowerView2.ps1 (PowerSploit)](https://github.com/PowerShellEmpire/PowerTools/blob/master/PowerView/powerview.ps1)
* [x] [PowerView3.ps1 (PowerSploit)](https://github.com/PowerShellMafia/PowerSploit/blob/26a0757612e5654b4f792b012ab8f10f95d391c9/Recon/PowerView.ps1) [(New-GPOImmediateTask)](https://www.harmj0y.net/blog/redteaming/abusing-gpo-permissions/)
* [x] [PowerView3.ps1 (PowerSploit)](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1)
* [x] [PowerView4.ps1](https://github.com/ZeroDayLab/PowerSploit/blob/master/Recon/PowerView.ps1) [(ZeroDayLab)](https://exploit.ph/powerview.html)
* [x] [Powermad.ps1](https://github.com/Kevin-Robertson/Powermad/blob/master/Powermad.ps1)
* [x] [PrivescCheck.ps1](https://github.com/itm4n/PrivescCheck/blob/master/PrivescCheck.ps1)
* [x] [PrintSpoofer](https://github.com/itm4n/PrintSpoofer) · [Invoke-BadPotato.ps1 (PowerSharpPack)](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpBinaries/Invoke-BadPotato.ps1)
* [x] [ProcDump (Sysinternals)](https://docs.microsoft.com/en-us/sysinternals/downloads/procdump)
* [x] [RoguePotato](https://github.com/antonioCoco/RoguePotato)
* [x] [Rubeus](https://github.com/GhostPack/Rubeus) · [Pre-Compiled](https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/blob/master/Rubeus.exe) · [Invoke-Rubeus.ps1 (Empire)](https://github.com/BC-SECURITY/Empire/blob/master/data/module_source/credentials/Invoke-Rubeus.ps1) · [Invoke-Rubeus.ps1 (PowerSharpPack)](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpBinaries/Invoke-Rubeus.ps1)
* [x] [Seatbelt](https://github.com/GhostPack/Seatbelt) · [Pre-Compiled](https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/blob/master/Seatbelt.exe) · [Invoke-Seatbelt.ps1 (PowerSharpPack)](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpBinaries/Invoke-Seatbelt.ps1)
* [x] [SessionGopher.ps1](https://github.com/Arvanaghi/SessionGopher/blob/master/SessionGopher.ps1)
* [x] [Set-GpoStatus.ps1](https://gist.github.com/snovvcrash/ecdc639b061fe787617d8d92d8549801)
* [x] [SharpDPAPI](https://github.com/GhostPack/SharpDPAPI) · [Pre-Compiled](https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/blob/master/SharpDPAPI.exe)  · [Invoke-SharpDPAPI.ps1 (PowerSharpPack)](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpBinaries/Invoke-SharpDPAPI.ps1)
* [x] [SharpGPOAbuse](https://github.com/FSecureLABS/SharpGPOAbuse) · [Pre-Compiled](https://github.com/Flangvik/SharpCollection/blob/master/NetFramework_4.0_x64/SharpGPOAbuse.exe) · [Invoke-SharpGPOAbuse.ps1 (PowerSharpPack)](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpBinaries/Invoke-SharpGPOAbuse.ps1)
* [x] [SharpHound.exe](https://github.com/BloodHoundAD/BloodHound/blob/master/Collectors/SharpHound.exe)
* [x] [SharpHound.ps1](https://github.com/BloodHoundAD/BloodHound/blob/master/Collectors/SharpHound.ps1)
* [x] [Sherlock.ps1](https://github.com/rasta-mouse/Sherlock/blob/master/Sherlock.ps1)
* [x] [SpoolSample](https://github.com/leechristensen/SpoolSample/) · [Pre-Compiled](https://github.com/BlackDiverX/WinTools/blob/master/SpoolSample-Printerbug/SpoolSample.exe) · [Invoke-Spoolsample.ps1 (PowerSharpPack)](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpBinaries/Invoke-Spoolsample.ps1)
* [x] [Watson](https://github.com/rasta-mouse/Watson) · [Pre-Compiled](https://github.com/BlackDiverX/WinTools/blob/master/Watson/Watson.exe) · [Invoke-SharpWatson.ps1 (PowerSharpPack)](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/blob/master/PowerSharpBinaries/Invoke-SharpWatson.ps1)
* [x] [WinPwn](https://github.com/S3cur3Th1sSh1t/WinPwn)
* [x] [chisel](https://github.com/jpillora/chisel/releases)
* [x] [htbenum.sh](https://github.com/SolomonSklash/htbenum/blob/master/htbenum.sh)
* [x] [impacket-examples-windows](https://github.com/maaaaz/impacket-examples-windows)
* [x] [les.sh](https://github.com/mzet-/linux-exploit-suggester/blob/master/linux-exploit-suggester.sh)
* [x] [lse.sh](https://github.com/diego-treitos/linux-smart-enumeration/blob/master/lse.sh)
* [x] [mimikatz](https://github.com/gentilkiwi/mimikatz/releases)
* [x] [netcat for Windows](https://eternallybored.org/misc/netcat/)
* [x] [plink](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
* [x] [powercat.ps1](https://github.com/besimorhino/powercat/blob/master/powercat.ps1)
* [x] [pspy](https://github.com/DominicBreuker/pspy/releases)
* [x] [pypykatz.exe](https://github.com/skelsec/pypykatz/releases)
* [x] [rdp2tcp.exe](https://github.com/NotMedic/rdp-tunnel/blob/master/rdp2tcp.exe)
* [x] [revshells.com](https://revshells.com)

