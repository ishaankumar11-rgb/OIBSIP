# Task 7 — Vulnerability Scanning with Nikto

**Intern:** Ishaan Giri
**Track:** Security Analyst
**Internship:** Oasis Infobyte (OIBSIP)

## Objective

Use Nikto to perform an automated vulnerability scan against a web
server, analyse the results, and document identified security issues
with recommended remediation steps.

## What is Nikto?

Nikto is an open-source web server scanner that performs comprehensive
automated checks against a web server, testing for thousands of
potentially dangerous files/programs, outdated server software,
missing security headers, and other common misconfigurations. It
works by sending a large volume of HTTP requests and analysing the
server's responses for known signatures of vulnerabilities or
weaknesses.

## Installation

Nikto was already pre-installed on this Kali Linux VM. Verified with:

```
nikto -Version
```

Output confirmed Nikto version 2.6.1 (database version LW 2.5).

## Test Target Setup

Since this task was performed as a quick, self-contained lab exercise
rather than against DVWA, a local Apache web server was used as the
scan target:

```
sudo systemctl start apache2
sudo systemctl status apache2
```

Confirmed Apache 2.4.68 (Debian) was running and active on
`http://localhost` (port 80).

## Scans Performed

### 1. Basic Nikto Scan

```
nikto -h http://localhost | tee nikto_scan_results.txt
```

Full raw output saved in `nikto_scan_results.txt`. Scan completed in
41 seconds, sending 7,837 requests, with 9 items reported.

### 2. SSL Check Scan

```
nikto -h http://localhost -ssl | tee nikto_ssl_scan.txt
```

**Result:** Connection failed — because this test server only runs
plain HTTP (no HTTPS/SSL configured on port 80), Nikto could not
establish an SSL connection to scan. This is itself a valid finding:
the server offers no encrypted transport at all, which is documented
as a finding below.

## Findings

| # | Finding | Severity | Explanation | Fix |
|---|---|---|---|---|
| 1 | No SSL/HTTPS available | **High** | The server only serves plain HTTP; all traffic (including any future forms, logins, or cookies) would travel unencrypted. | Configure Apache with a TLS certificate (e.g., via Let's Encrypt/Certbot) and redirect all HTTP traffic to HTTPS. |
| 2 | `/server-status` endpoint exposed | **Medium** | The `mod_status` module reveals internal Apache server information (active connections, requests) to anyone who requests this path. | Disable `mod_status`, or restrict access to `/server-status` to localhost/trusted IPs only in the Apache config. |
| 3 | Missing `Content-Security-Policy` header | **Medium** | Without a CSP header, the browser has no server-defined restriction on what scripts/resources a page can load, increasing exposure to XSS-style attacks. | Add a `Content-Security-Policy` header in the Apache config defining allowed content sources. |
| 4 | Missing `Strict-Transport-Security` header | **Medium** | Without HSTS, browsers won't be told to always use HTTPS for this site, leaving room for protocol-downgrade attacks once HTTPS is added. | Add `Strict-Transport-Security` header once HTTPS is configured (finding #1). |
| 5 | Missing `X-Content-Type-Options` header | **Low** | Without this header, browsers may try to "guess" (MIME-sniff) content types, which can be abused to trick a browser into executing something unexpected. | Add `X-Content-Type-Options: nosniff` to server responses. |
| 6 | Missing `X-Frame-Options`/frame-ancestors protection | **Low** | Without this protection, the site could potentially be embedded in a malicious iframe on another site (clickjacking risk). | Add `Content-Security-Policy: frame-ancestors 'self'` (the modern replacement for the deprecated X-Frame-Options header). |
| 7 | Missing `Referrer-Policy` header | **Low** | Without this header, the browser's default referrer behaviour may leak full URLs (including any sensitive query parameters) to third-party sites when links are clicked. | Add a `Referrer-Policy` header, e.g. `strict-origin-when-cross-origin`. |
| 8 | Missing `Permissions-Policy` header | **Low** | Without this header, there's no explicit restriction on which browser features (camera, geolocation, etc.) the page can access. | Add a `Permissions-Policy` header restricting unneeded browser features. |
| 9 | Allowed HTTP methods disclosed (GET, POST, OPTIONS, HEAD) | **Informational** | Not a vulnerability by itself, but confirms no unusual/dangerous HTTP methods (e.g., PUT, DELETE, TRACE) are enabled on this server. | No action needed — this is a good result, included for completeness. |

## Nikto vs. Nmap — What's the Difference?

Nmap operates at the network/port level: it tells you *what* ports and
services are open and reachable (e.g., "port 80 is open, running
Apache 2.4.68"). Nikto operates one layer higher, at the
**application** level: once it knows a web server is running, it
actively probes *that specific web application* for known
misconfigurations, outdated software, dangerous files, and missing
security headers. In short: Nmap finds the door: Nikto checks whether
that door is actually locked properly.

## A Note on Nikto's Limitations

Nikto is intentionally a "noisy" scanner — it sends thousands of
requests in a short time (7,837 in this scan alone) and makes no
attempt to hide its activity or blend in with normal traffic. This
makes it fast and thorough for authorized testing, but it is **not**
suitable for stealthy or covert security assessments, and running it
against a system without permission would almost certainly trigger
intrusion detection systems and be easily traceable in server logs.
Nikto also reports many findings as "potential" issues based on
signatures and headers — not every finding is automatically a
confirmed, exploitable vulnerability; each one still needs human
judgement to assess real-world risk and priority, as done in the
findings table above.

## Ethical Use Statement

This scan was performed only against a local Apache instance running
on my own Kali Linux VM, which I own and administer. No external,
third-party, or production web servers were scanned.

## Files in This Repository

- `README.md` — this file
- `nikto_scan_results.txt` — full raw output of the basic Nikto scan
- `nikto_ssl_scan.txt` — output/result of the SSL check attempt
- `/screenshots` — terminal screenshots of Nikto running and its output
