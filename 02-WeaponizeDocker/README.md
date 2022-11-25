WeaponizeDocker.sh
==========

Install within an [Exegol](https://github.com/ShutdownRepo/Exegol) [container](https://github.com/ShutdownRepo/Exegol-images):

```console
~$ git clone https://github.com/ShutdownRepo/Exegol-images
~$ cd Exegol-images
~$ curl -sSL https://github.com/snovvcrash/WeaponizeKali.sh/raw/main/02-WeaponizeDocker/cloud.dockerfile > cloud.dockerfile
~$ curl -sSL https://github.com/snovvcrash/WeaponizeKali.sh/raw/main/02-WeaponizeDocker/WeaponizeDocker.sh > WeaponizeDocker.sh
~$ docker build -t exegol . -f cloud.dockerfile
```

## `/opt/tools`

- [x] [CrackMapExec](https://github.com/Porchetta-Industries/CrackMapExec)
- [x] [DivideAndScan](https://github.com/snovvcrash/DivideAndScan)
- [x] [PEASS](https://github.com/carlospolop/PEASS-ng/releases)
- [ ] [Whaler](https://github.com/P3GLEG/Whaler)
- [x] [amicontained](https://github.com/genuinetools/amicontained/releases)
- [x] [audit2rbac](https://github.com/liggitt/audit2rbac/releases)
- [x] [badPods](https://github.com/BishopFox/badPods)
- [ ] [ccat](https://github.com/RhinoSecurityLabs/ccat)
- [ ] [clair](https://github.com/quay/clair)
- [ ] [conftest](https://github.com/open-policy-agent/conftest)
- [x] [deepce](https://github.com/stealthcopter/deepce)
- [x] [dnsx](https://github.com/projectdiscovery/dnsx/releases)
- [x] [docker-bench-security](https://github.com/docker/docker-bench-security)
- [x] [dockerfilelint](https://github.com/replicatedhq/dockerfilelint)
- [ ] [dockerscan](https://github.com/cr0hn/dockerscan)
- [x] [dockscan](https://github.com/kost/dockscan)
- [x] [dsniff](https://github.com/tecknicaltom/dsniff)
- [x] [dwn](https://github.com/sensepost/dwn)
- [x] [etcd](https://github.com/etcd-io/etcd/releases)
- [ ] [falco](https://github.com/falcosecurity/falco)
- [x] [feroxbuster](https://github.com/epi052/feroxbuster)
- [x] [ffuf](https://github.com/ffuf/ffuf/releases)
- [x] [gitleaks](https://github.com/zricethezav/gitleaks)
- [x] [grype](https://github.com/anchore/grype/releases)
- [x] [kube-bench](https://github.com/aquasecurity/kube-bench/releases)
- [x] [kube-hunter](https://github.com/aquasecurity/kube-hunter)
- [x] [kubeaudit](https://github.com/Shopify/kubeaudit/releases)
- [x] [kubectl-who-can](https://github.com/aquasecurity/kubectl-who-can/releases)
- [x] [kubelet-anon-rce](https://github.com/serain/kubelet-anon-rce)
- [x] [kubeletctl](https://github.com/cyberark/kubeletctl/releases)
- [x] [kubesec](https://github.com/controlplaneio/kubesec/releases)
- [ ] [kubestriker](https://github.com/vchinnipilli/kubestriker)
- [x] [linPEAS](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS)
- [ ] [lynis](https://github.com/CISOfy/lynis)
- [ ] [popeye](https://github.com/derailed/popeye)
- [x] [masscan](https://github.com/robertdavidgraham/masscan)
- [x] [seclists](https://github.com/danielmiessler/SecLists)
- [x] [ssb](https://github.com/kitabisa/ssb/releases)
- [ ] [trivy](https://github.com/aquasecurity/trivy)
