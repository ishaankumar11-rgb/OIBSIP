# Common Network Security Threats

**Intern:** Ishaan Giri
**Track:** Security Analyst
**Internship:** Oasis Infobyte (OIBSIP) — Task 4 (Research Report)

## Introduction

Network security threats matter because nearly every modern organisation
depends on continuous, trustworthy network connectivity to operate —
from e-commerce and banking to healthcare and critical infrastructure.
A successful attack on the network layer can take services offline,
intercept sensitive data in transit, or silently redirect users to
malicious destinations, often without the victim realising anything is
wrong until the damage is done. Understanding how these attacks work is
the first step toward defending against them.

---

## 1. DoS / DDoS Attacks

**How it works:** A Denial-of-Service (DoS) attack floods a target
system or network with an overwhelming volume of traffic or requests,
exhausting its bandwidth, processing power, or memory until it can no
longer respond to legitimate users. A Distributed Denial-of-Service
(DDoS) attack is the same concept carried out from many machines at
once — typically a "botnet" of compromised devices — making the
traffic harder to block and far larger in volume.

**Real-world example:** In October 2016, the DNS provider Dyn was hit
by a massive DDoS attack carried out largely by the Mirai botnet — a
network built from hijacked, poorly secured Internet-of-Things devices
such as home routers, IP cameras, and DVRs. Security firm Flashpoint reported
that tens of millions of distinct IP addresses tied to the Mirai botnet took part in the assault.
Because Dyn's DNS infrastructure translates domain names into IP addresses for a huge number of websites,
the attack made major platforms including Twitter, Spotify, Reddit, and Amazon-hosted services unreachable for users across the US East Coast and parts of Europe for several hours.

**Impact:** Extended service outages, direct revenue loss, damaged
customer trust, and — in the Dyn case — a demonstration that even
everyday consumer devices can be weaponised at massive scale if left
insecure.

**Mitigation strategies:**
1. Use DDoS protection/scrubbing services (e.g., Cloudflare, AWS
   Shield, Akamai) that absorb and filter malicious traffic before it
   reaches origin servers.
2. Implement rate limiting and traffic filtering at the network edge to
   cap how many requests a single source can make in a given time.
3. Maintain redundant DNS providers and geographically distributed
   infrastructure so that an attack on one provider or region doesn't
   take the entire service offline.

---

## 2. Man-in-the-Middle (MITM) Attacks

**How it works:** In a MITM attack, an attacker secretly positions
themselves between two communicating parties — for example, a user and
a website — intercepting, and sometimes altering, the data passing
between them. This is commonly done by exploiting insecure Wi-Fi
networks, ARP spoofing on a local network, or compromising a trusted
piece of software that sits in the traffic path.

**Real-world example:** In 2015, it was discovered that Lenovo had
shipped consumer laptops with pre-installed adware called Superfish,
which inserted its own root certificate into each machine's trust
store. This allowed Superfish (and anyone who reverse-engineered its
private key, which researchers quickly did) to transparently intercept
and decrypt HTTPS traffic for any website the user visited, without
triggering browser security warnings — a textbook MITM setup baked
directly into the hardware supply chain.

**Impact:** Attackers can read or modify supposedly "secure" traffic,
harvest login credentials, inject malicious content into web pages, or
impersonate trusted services entirely.

**Mitigation strategies:**
1. Enforce HTTPS everywhere and use HSTS (HTTP Strict Transport
   Security) so browsers refuse to downgrade to plain HTTP.
2. Avoid performing sensitive transactions over unsecured public Wi-Fi,
   or use a trusted VPN when doing so.
3. Audit and restrict what root certificates are trusted on managed
   devices, and avoid installing software that silently modifies the
   system's certificate store.

---

## 3. IP Spoofing

**How it works:** IP spoofing involves crafting network packets with a
forged ("spoofed") source IP address, making traffic appear to come
from a trusted or different machine than it actually did. This is used
both to hide an attacker's real origin and, in volumetric attacks, to
make a victim's server flood a third party with unwanted response
traffic (reflection/amplification).

**Real-world example:** The 2013 attack on Spamhaus, at the time one
of the largest DDoS attacks ever recorded (peaking around 300 Gbps),
relied heavily on DNS reflection/amplification using spoofed source IP
addresses. Attackers sent DNS queries to open DNS resolvers with the
source address forged to match Spamhaus's IP, causing those resolvers
to flood Spamhaus with amplified responses it never requested.

**Impact:** Victims can be overwhelmed by traffic they didn't invite,
attackers can evade IP-based access controls or blocklists, and
forensic investigation becomes significantly harder since the apparent
source of the attack is fake.

**Mitigation strategies:**
1. Implement ingress/egress filtering (e.g., BCP38) at the network
   edge so routers drop packets with source addresses that couldn't
   legitimately originate from that network.
2. Disable or properly configure open DNS resolvers so they cannot be
   abused for amplification attacks.
3. Use authentication mechanisms that don't rely solely on IP address
   (e.g., cryptographic tokens, mutual TLS) for any sensitive access
   control decisions.

---

## 4. DNS Poisoning / Spoofing

**How it works:** DNS poisoning (also called DNS cache poisoning or
spoofing) corrupts the data a DNS resolver stores, so that a domain
name resolves to an attacker-controlled IP address instead of the
legitimate one. Victims typing a normal, trusted URL can be silently
redirected to a malicious site without any visible sign that something
is wrong.

**Real-world example:** In 2008, security researcher Dan Kaminsky
disclosed a fundamental flaw in the DNS protocol itself that made
cache poisoning dramatically easier and faster across virtually all
DNS software in use at the time. The flaw was serious enough that it
triggered an unprecedented, coordinated, simultaneous patch release
across major DNS vendors before the technical details were made
public, to give the internet time to update before attackers could
exploit it widely.

**Impact:** Users can be redirected to phishing sites that harvest
credentials, malware can be served from what looks like a trusted
domain, and attackers can intercept email or other traffic by
redirecting mail servers.

**Mitigation strategies:**
1. Deploy DNSSEC (DNS Security Extensions), which cryptographically
   signs DNS records so resolvers can verify responses haven't been
   tampered with.
2. Use randomised query IDs and source ports for DNS requests to make
   blind-guessing attacks (like the Kaminsky flaw) far harder to pull off.
3. Keep DNS resolver software patched and avoid running open resolvers
   that are accessible to the whole internet.

---

## Comparison Table

| Threat | Attack Vector | Who Is at Risk | Difficulty to Execute | Ease of Mitigation |
|---|---|---|---|---|
| DoS/DDoS | Traffic flooding (often via botnets) | Any internet-facing service | Low–Medium (botnets for hire exist) | Medium (needs dedicated infra/services) |
| MITM | Intercepting traffic in transit | Users on untrusted networks, HTTPS-reliant services | Medium | Medium (HTTPS/HSTS helps a lot) |
| IP Spoofing | Forged source IP addresses | Networks with weak egress filtering, open resolvers | Medium | Medium (requires ISP/network-level filtering) |
| DNS Poisoning | Corrupting DNS cache/responses | Any domain relying on unsigned DNS | Medium–High (modern defenses raise the bar) | Medium (DNSSEC adoption is still uneven) |

---

## Conclusion — Key Takeaways for a Network Administrator

1. **Defense in depth matters more than any single control.** No one
   mitigation (a firewall, HTTPS, or DNSSEC alone) stops every threat —
   these attacks target different layers of the stack, so defenses need
   to be layered too.
2. **"No open ports" or "connection refused" is itself a valid, good
   finding.** A correctly configured firewall or resolver that silently
   rejects unsolicited or forged traffic is doing its job — administrators
   shouldn't assume a quiet result means nothing was tested.
3. **Many of the most damaging real-world incidents exploited basic
   hygiene gaps** — default passwords on IoT devices (Mirai), unverified
   root certificates (Superfish), or unpatched protocol-level flaws
   (Kaminsky DNS bug) — reinforcing that fundamentals (patching, strong
   defaults, least privilege) prevent more damage than most advanced
   tooling.

---

## References

1. NIST — National Institute of Standards and Technology. https://www.nist.gov
2. CISA — Cybersecurity and Infrastructure Security Agency. https://www.cisa.gov
3. SANS Institute Reading Room. https://www.sans.org/reading-room
4. MITRE ATT&CK Framework. https://attack.mitre.org
5. Krebs on Security — reporting on the 2016 Dyn/Mirai DDoS attack. https://krebsonsecurity.com
6. Wikipedia — "DDoS attacks on Dyn" (summary of the October 2016 incident timeline).
