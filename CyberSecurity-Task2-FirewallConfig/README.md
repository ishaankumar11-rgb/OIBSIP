Task 2 — Basic Firewall Configuration with UFW
Intern: Ishaan Giri
Track: Security Analyst
Internship: Oasis Infobyte (OIBSIP)
Objective
Set up and configure a basic firewall on Kali Linux using UFW
(Uncomplicated Firewall), applying rules to allow and deny specific
types of network traffic, and verify that those rules actually work.
What is a Firewall?
A firewall is a network security system that monitors and controls
incoming and outgoing traffic based on a defined set of rules. It acts
as a barrier between a trusted internal network (or a single machine)
and untrusted external networks, deciding which connections are
allowed through and which are blocked. UFW (Uncomplicated Firewall) is
a simplified front-end for Linux's iptables, designed to make firewall
management straightforward from the command line.
Installation
UFW was not pre-installed on this Kali Linux VM, so it was installed
manually:
Code
Verified with:
Code
Output confirmed UFW version 0.36.2.
Enabling UFW
Code
Output: Firewall is active and enabled on system startup
Rules Configured
#
Rule
Command
Reason
1
Allow SSH (port 22)
sudo ufw allow ssh
SSH is needed for secure remote administration of the machine. Blocking it entirely would lock out legitimate remote access.
2
Deny HTTP (port 80)
sudo ufw deny http
Plain HTTP is unencrypted. Denying it forces any web traffic to use the encrypted HTTPS alternative instead.
3
Allow HTTPS (port 443)
sudo ufw allow https
HTTPS encrypts traffic in transit, so it is safe to allow for any web services this machine might run.
4
Deny Telnet (port 23)
sudo ufw deny 23
Telnet transmits credentials and data in plaintext and is considered an obsolete, insecure protocol. It should never be exposed.
All 4 rules were applied for both IPv4 and IPv6.
Verifying Active Rules
Code
Code
(Full output saved in ufw_status.txt)
Testing That Denied Traffic Is Actually Blocked
A connection test alone from the same machine (localhost) isn't fully
reliable, since "connection refused" can also mean nothing is
listening on that port — not necessarily that the firewall is the one
blocking it. To get a genuine test, the block was verified from an
external machine (the Windows host) instead:
Started a temporary test web server on Kali, listening on port 80:
Code
From the Windows host machine (10.62.160.83), attempted to connect
to the Kali VM (10.62.160.204) on port 80 using PowerShell:
Code
Result: TcpTestSucceeded : False
This confirms the deny http rule is actually working — even with a
real server listening on port 80, an external connection attempt was
successfully blocked by UFW.
(Full test details in test_results.txt)
Configuration Script
All rules above are captured in ufw_configuration.sh, a runnable
script that applies the full configuration in sequence. To run it:
Code
Security Analysis — Why These Rules?
SSH allowed: Needed for legitimate remote administration;
blocking it would be overly restrictive for a machine that may need
remote management.
HTTP denied / HTTPS allowed: This pairing nudges all web traffic
toward the encrypted protocol, reducing the risk of credentials or
session data being intercepted in plaintext.
Telnet denied: Telnet has no encryption at all and is considered
a legacy protocol with no place in a modern, security-conscious
configuration. SSH is the secure replacement for it.
Default deny incoming: UFW's default policy denies all incoming
connections unless explicitly allowed, following the security
principle of "deny by default, allow by exception" — a far safer
posture than allowing everything and trying to block known-bad
traffic.
Files in This Repository
README.md — this file
ufw_status.txt — output of sudo ufw status verbose
test_results.txt — details and result of the external connectivity test
ufw_configuration.sh — runnable script that applies all rules
/screenshots — terminal screenshots of configuration and verification
