Task 1 — Basic Network Scanning with Nmap
Intern: Ishaan Giri
Track: Security Analyst
Internship: Oasis Infobyte (OIBSIP)
Objective
Perform a network scan using Nmap to identify open ports, running services, and
operating system details of a target machine on the local network, and document
the security implications of the findings.
What is Nmap?
Nmap (Network Mapper) is a free, open-source tool used to discover hosts and
services on a computer network. It works by sending specially crafted packets
to a target and analysing the responses. Security professionals use it to map
out a network's attack surface — i.e., to find out what is reachable and what
might be vulnerable, before an attacker does.
Why Network Scanning Matters
Before any system can be secured, it needs to be understood. Network scanning
reveals which services are exposed to the network, which ports are open, and
what software/versions are running — all of which could be potential entry
points for an attacker. Regular scanning is a core part of a proactive
security posture.
Installation
Nmap comes pre-installed on Kali Linux, so no installation was required.
Verified with:
Code
Output confirmed Nmap version 7.99 was already present.
Lab Setup
Item
Details
Attacker machine
Kali Linux (VirtualBox VM)
Target machine
Windows 11 Host (physical machine, same Wi-Fi network)
VM Network Mode
Bridged Adapter (VM gets its own IP on the LAN)
Kali IP
10.62.160.204
Target (Windows host) IP
10.62.160.83
Bridged mode was used instead of NAT so that the VM and host communicate as
two genuinely separate devices on the same network — closer to a real-world
scanning scenario than scanning localhost.
Scans Performed
1. Basic Scan
Code
Result: All 1000 scanned TCP ports were reported as filtered
(no response received). Host was confirmed up (0.00028s latency).
2. Service Version Scan
Code
Result: Same as above — all ports filtered, so no service/version
banners could be retrieved.
3. OS Detection Scan
Code
Result: OS could not be fingerprinted with confidence — too many OS
signatures matched the filtered-port pattern to give a specific result.
(See nmap_scan_results.txt for the full raw terminal output of all three
scans, and /screenshots for terminal captures.)
Open Ports Found
None. All 1000 commonly scanned TCP ports returned no response
("filtered"), meaning the target's firewall is silently dropping unsolicited
probe packets rather than replying with an explicit "closed" (RST) or "open"
(SYN-ACK) response.
Security Analysis
Finding
Explanation
Risk
All ports filtered
Windows Defender Firewall (or equivalent) is configured to drop unsolicited inbound connection attempts silently
Low — this is actually the correct, secure default behaviour
No service banners retrieved
Because no ports responded, Nmap had nothing to fingerprint
N/A
OS undetectable
Filtered ports deny Nmap the TCP/IP stack behaviour clues it needs for OS fingerprinting
N/A — a side-effect of good firewall hygiene
Conclusion: This scan did not reveal open ports or running services —
which, from a defender's perspective, is a good outcome. It demonstrates
that the target's host-based firewall is correctly blocking unsolicited
inbound network probes, significantly reducing its attack surface. A
misconfigured firewall that responded with open ports would represent a much
higher risk, as each open port is a potential entry point that could be
targeted by an attacker for exploitation.
Ethical Use Statement
This scan was performed only against a machine I own (my own Windows
laptop), from a virtual machine on the same device, on my own private home
network. No external, third-party, or production systems were scanned.
Unauthorized scanning of systems without explicit permission is illegal
under laws such as the Computer Fraud and Abuse Act (US) and the IT Act,
2000 (India), and is never performed as part of this internship's tasks.
Files in this Repository
README.md — this file
nmap_scan_results.txt — combined raw output of all three scans
/screenshots — terminal screenshots of each scan being run
