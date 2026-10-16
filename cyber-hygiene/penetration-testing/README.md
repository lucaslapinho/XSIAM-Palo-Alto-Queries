# Penetration Testing / Dual-Use Security Tools

[Open query](detect-penetration-testing-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **13 product/family candidates / 17 labels**.

Related coverage: [Wireshark, Fiddler and network utilities](../network-utilities/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Acunetix / Invicti Web + API family | `acunetix-invicti-web` | `acunetix`; `invicti web + api` | [Documented rename candidate](https://www.acunetix.com/support/docs/wvs/installing-acunetix-wvs/) |
| BloodHound Community Edition | `bloodhound-community` | `bloodhound community edition` | [Inherited candidate](https://bloodhound.specterops.io/) |
| Burp Suite | `burp-suite` | `burp suite community edition`; `burp suite professional` | [Inherited candidate](https://portswigger.net/burp) |
| hashcat | `hashcat` | `hashcat` | [Product-name candidate](https://hashcat.net/hashcat/) |
| Invicti Standard / Netsparker Standard family | `invicti-standard` | `invicti standard`; `netsparker standard` | [Documented rename candidate](https://www.invicti.com/changelog/8-mar-2022-v6-4-0-35166) |
| Maltego | `maltego` | `maltego` | [Product-name candidate](https://www.maltego.com/downloads/) |
| Metasploit Framework | `metasploit-framework` | `metasploit framework` | [Inherited candidate](https://www.metasploit.com/) |
| mitmproxy | `mitmproxy` | `mitmproxy` | [Product-name candidate](https://docs.mitmproxy.org/stable/overview/installation/) |
| Nikto | `nikto` | `nikto` | [Product-name candidate](https://github.com/sullo/nikto) |
| Nmap | `nmap` | `nmap` | [Inherited candidate](https://nmap.org/) |
| sqlmap | `sqlmap` | `sqlmap` | [Product-name candidate](https://sqlmap.org/) |
| Tenable Nessus | `tenable-nessus` | `nessus` | [Product-name candidate](https://www.tenable.com/products/nessus) |
| ZAP / Zed Attack Proxy family | `zap` | `zap`; `zed attack proxy` | [Product-name candidate](https://www.zaproxy.org/faq/how-can-you-start-zap/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Authorized assessment tooling; review engagement scope, credential handling and permitted operators.

Expanded desktop assessment tools and explicitly conditional CLI/package candidates. ZAP is promoted from a negative decoy to a specific exact-name product candidate using first-party desktop documentation. Hashcat, sqlmap and Nikto are not guaranteed app-inventory entries. Cobalt Strike, Mimikatz, Impacket and other portable/script tooling need independently validated process/file/package telemetry; absence here is not absence of the tool or malicious activity.

- **Tenable Nessus**: Scanner presence is not a scan, exploitation or an authorization verdict.
- **ZAP / Zed Attack Proxy family**: The project documents standalone desktop distribution and ZAP.app. ZAP is now an explicit whole-name candidate, not a generic keyword predicate. Version-suffixed labels and portable/Docker copies can be missed; identity must be corroborated. [Additional primary source](https://www.zaproxy.org/faq/where-is-zap-installed/).
- **Maltego**: Desktop assessment/analysis client candidate. Presence does not prove a transform, data collection, engagement authorization or malicious use.
- **Acunetix / Invicti Web + API family**: The vendor documentation links Acunetix to Invicti Web + API. One family avoids duplicate rename records; scanner services, agents and container deployments need separate evidence.
- **Invicti Standard / Netsparker Standard family**: The 2022 first-party release notes document the Standard-product rename. These historical name candidates are separate from the Acunetix/Invicti Web + API family; no universal current packaging contract is claimed.
- **hashcat**: CLI/package product-name candidate. Portable binaries and unpacked distributions often yield no application row. No password recovery, cracking activity or authorization is established.
- **sqlmap**: CLI/package product-name candidate; script/archive copies can be absent from inventory. This is not SQL injection activity or exploitation evidence.
- **Nikto**: CLI/package product-name candidate. A checked-out script directory need not register as an application, and no web scan is established.
- **mitmproxy**: Vendor docs describe Windows installer, macOS cask and standalone/package paths. The proposed label does not prove proxying, traffic interception or a trusted certificate was installed.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
