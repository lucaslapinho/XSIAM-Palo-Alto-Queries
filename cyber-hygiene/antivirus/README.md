# Antivirus

[Open query](detect-antivirus-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **15 products / 20 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Avast Free Antivirus | `avast-free-antivirus` | `avast free antivirus` | [Inherited candidate](https://www.avast.com/free-antivirus-download) |
| AVG AntiVirus FREE | `avg-antivirus-free` | `avg antivirus free` | [Inherited candidate](https://www.avg.com/en-us/free-antivirus-download) |
| Avira Security | `avira-security` | `avira security` | [Vendor app label](https://support.avira.com/hc/en-us/articles/360003162153-Uninstallation-of-Avira-for-Windows) |
| Bitdefender consumer security family | `bitdefender-consumer` | `bitdefender antivirus plus`; `bitdefender total security` | [Product-name candidate](https://www.bitdefender.com/en-us/consumer/antivirus) |
| ClamAV | `clamav` | `clamav` | [Inherited candidate](https://www.clamav.net/) |
| Emsisoft Anti-Malware Home | `emsisoft-anti-malware` | `emsisoft anti-malware home` | [Product-name candidate](https://www.emsisoft.com/en/anti-malware-home/) |
| ESET endpoint protection family | `eset-endpoint-protection` | `eset endpoint antivirus`; `eset endpoint security` | [Product-name candidate](https://help.eset.com/ees/13/en-US/installation.html) |
| ESET NOD32 Antivirus | `eset-nod32` | `eset nod32 antivirus` | [Inherited candidate](https://www.eset.com/int/home/antivirus/) |
| F-Secure Total | `f-secure-total` | `f-secure total` | [Product-name candidate](https://www.f-secure.com/en/total) |
| Kaspersky Endpoint Security for Windows | `kaspersky-endpoint-windows` | `kaspersky endpoint security for windows` | [Historical vendor app label](https://support.kaspersky.com/KESWin/11/en-US/127987.htm) |
| Malwarebytes consumer family | `malwarebytes-consumer` | `malwarebytes`; `malwarebytes premium` | [Product-name candidate](https://www.malwarebytes.com/premium) |
| McAfee Total Protection | `mcafee-total-protection` | `mcafee total protection` | [Product-name candidate](https://www.mcafee.com/en-us/antivirus/mcafee-total-protection.html) |
| Norton 360 family | `norton-360` | `norton 360`; `norton 360 deluxe` | [Product-name candidate](https://us.norton.com/products/norton-360-deluxe) |
| Panda Dome family | `panda-dome` | `panda dome`; `panda dome free` | [Product-name candidate](https://www.pandasecurity.com/en/homeusers/free-antivirus/) |
| Trend Micro Maximum Security | `trend-micro-maximum-security` | `trend micro maximum security` | [Product-name candidate](https://www.trendmicro.com/en_us/forHome/products/maximum-security.html) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Malware protection; verify management, update state and coexistence separately from installation.

Broadened consumer and business families. Also review endpoint-security: suites overlap functionally. Installed entries cannot establish engine health, signature freshness, active/passive mode, co-management or AV conflicts. Built-in Windows Defender can have no standalone installed-app entry; do not infer missing protection from zero rows.

- **Avira Security**: Vendor uninstall instructions name Avira Security; Cortex population remains unknown.
- **Bitdefender consumer security family**: Two consumer editions share one review family; names do not establish subscription tier or active protection.
- **ESET endpoint protection family**: Business endpoint editions are distinct from NOD32. Do not infer EDR, management enrollment or protection state.
- **Kaspersky Endpoint Security for Windows**: Version 11 uninstall instructions name the installed application. Current packaging and tenant applicability require confirmation.
- **Norton 360 family**: Edition names are candidates, not proof of license or inventory naming.
- **McAfee Total Protection**: Do not generalize this name to Trellix ENS, McAfee Agent or every McAfee-branded component.
- **Malwarebytes consumer family**: The label does not distinguish free scanning, paid protection or managed ThreatDown products.
- **F-Secure Total**: ASCII punctuation is a candidate spelling. Do not silently equate Unicode hyphens or infer active bundled features.
- **Panda Dome family**: Suite family matching does not identify a paid tier, VPN configuration or current protection.
- **Emsisoft Anti-Malware Home**: Do not equate this consumer name with Enterprise Security, Business Security or a remediation kit.
- **Trend Micro Maximum Security**: Do not generalize this consumer suite to Apex One or every Trend Micro agent.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
