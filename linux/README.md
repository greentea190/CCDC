# Linux README.md

## Scripts

---

Scripts for Linux OS systems.

### harden.sh

---

harden.sh automates commands used to improve the security posture of a compromised Linux system.

<details><summary>VIEW MORE</summary>


harden.sh preforms the following actions:

- Remove existing chrontab jobs
- Stop remote administration services (SSH)
- Create a new administrator user
- Run updates
- Install packages
- Set a DNS server

</details>

### iptables.sh

---

iptables.sh configures iptables firewall rules for specific services. Below is a list of services iptables.sh configures.

> [!NOTE]
> This script must be run with root privileges.

    1) Web Application Server
    2) DNS Server 
    3) Mail Server
    4) Splunk Server
    5) SSH Server
    6) SSH Client
    7) NTP Server
    0) Quit

Running iptables.sh:

1. Make the file executable. 

```
sudo chmod u+x iptables.sh
```

2. Run the script.

```
sudo ./iptables.sh
```
3. Select multiple options separated by a space ' ' 

- Example, the following command configures rules for the Web Application Server (1) Splunk Server (4) and SSH Client (6):

```
1 4 6
```

# Credit

iptables.sh inspired by @thomasfr [thomasfr/iptables.sh](https://gist.github.com/thomasfr/9712418)
