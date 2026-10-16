# Coverage review — October 16, 2026

[Query index](README.md) · [Consolidated query guide](all-detected-tools.md)

This research round reviews all **30 categories** and adds **43 product/family candidates**: **124 → 167 families** and **160 → 212 exact labels**. Antivirus expands from **4 → 15 families**; endpoint security from **4 → 8**. Family counts group some related editions and do not measure independent installations, active protections or market share.

The goal is useful, traceable application-inventory coverage. It is not a complete market catalog. No tenant inventory export, schema observation, compilation or execution was available. **Zero enabled labels are tenant-observed or tenant-validated.**

## Name evidence

| Evidence label | What it supports | What it does not support |
|---|---|---|
| `PRODUCT_NAME_CANDIDATE` | A first-party product/distribution page substantiates the product name; a whole-name match is proposed. | An actual installed-app label or Cortex population. |
| `VENDOR_INSTALLED_APP_LABEL` | Vendor instructions explicitly name an installed app, such as Avira Security. | The same name in every edition, platform or Cortex tenant. |
| `HISTORICAL_VENDOR_INSTALLED_APP_LABEL` | A version-scoped vendor document names an installed app, such as Kaspersky Endpoint Security for Windows in version 11 guidance. | A current universal field or packaging contract. |
| `VENDOR_DOCUMENTED_RENAME_CANDIDATE` | A current primary source explicitly links old/new branding, as the Windsurf/Devin Desktop download page does. | Runtime identity, a universal installed-app alias or unrelated plugins. |
| `INHERITED_PRODUCT_NAME_CANDIDATE` | The prior catalog retains a product reference and its original retrieval status/date. | Fresh retrieval of all 124 old references or an observed inventory label. |

The adjacent category guides link each product/family to its name evidence. A product name, package identifier and application display name are different identifiers. For example, Cloudflare documents `cloudflare-warp` as a Linux package; matching that string in `application_name` remains a candidate until its tenant representation is observed. Do not infer publisher/signature identity from a label.

## Category review

Every category guide now includes a specific review of packaging, runtime and policy gaps. The table shows which categories expanded and which were deliberately held. Source links support product/distribution context; the evidence labels above define the narrower matching claim.

| Category | Families before → after | Labels before → after | Decision | This-round source |
|---|---:|---:|---|---|
| [AI Development Tools](ai-development/README.md) | 4 → 5 | 4 → 6 | Add sourced candidate families; see guide | [Primary source](https://devin.ai/download) |
| [Antivirus](antivirus/README.md) | 4 → 15 | 4 → 20 | Add sourced candidate families; see guide | [Primary source](https://support.avira.com/hc/en-us/articles/360003162153-Uninstallation-of-Avira-for-Windows) |
| [Artificial Intelligence Tools](ai-tools/README.md) | 4 → 4 | 5 → 5 | Retain; explicit application-inventory gap | [Primary source](https://chatgpt.com/download/) |
| [Browsers](browsers/README.md) | 4 → 5 | 6 → 7 | Add sourced candidate families; see guide | [Primary source](https://vivaldi.com/) |
| [Cloud Storage / File Synchronization](cloud-storage/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://github.com/meganz/MEGAsync) |
| [Communication / Messaging](messaging/README.md) | 5 → 6 | 7 → 8 | Add sourced candidate families; see guide | [Primary source](https://www.zoom.com/en/products/collaboration-tools/) |
| [Containers](containers/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Primary source](https://orbstack.dev/) |
| [Crypto / Mining Tools](crypto-mining/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Primary source](https://www.getmonero.org/downloads/) |
| [Database Clients](database-clients/README.md) | 4 → 5 | 5 → 7 | Add sourced candidate families; see guide | [Primary source](https://www.oracle.com/database/sqldeveloper/) |
| [Developer Utilities](developer-utilities/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://www.usebruno.com/) |
| [Development Tools / IDEs](development-ides/README.md) | 4 → 5 | 9 → 10 | Add sourced candidate families; see guide | [Primary source](https://developer.android.com/studio) |
| [EDR / Endpoint Security](endpoint-security/README.md) | 4 → 8 | 5 → 9 | Add sourced candidate families; see guide | [Primary source](https://www.bitdefender.com/business/support/en/77211-376358-security-agents.html) |
| [File Transfer Tools](file-transfer/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://www.smartftp.com/en-us/) |
| [Gaming Platforms](gaming/README.md) | 4 → 6 | 5 → 7 | Add sourced candidate families; see guide | [Primary source](https://www.ubisoft.com/en-us/ubisoft-connect) |
| [Local AI / LLM Runtimes](local-ai/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Primary source](https://msty.ai/) |
| [Network Utilities](network-utilities/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Primary source](https://www.advanced-ip-scanner.com/) |
| [Other Corporate-Risk / Shadow-IT Applications](other-shadow-it/README.md) | 4 → 5 | 6 → 7 | Add sourced candidate families; see guide | [Primary source](https://peazip.github.io/) |
| [P2P / Torrent](p2p-torrent/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Primary source](https://tixati.com/) |
| [Password Managers](password-managers/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://help.enpass.io/personal/latest/all/enpass-apps-installation) |
| [Penetration Testing / Dual-Use Security Tools](penetration-testing/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://www.tenable.com/products/nessus) |
| [Personal Collaboration Tools](personal-collaboration/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Primary source](https://github.com/logseq/logseq) |
| [Privacy / Anonymization Tools](privacy-anonymization/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Primary source](https://mullvad.net/en/browser) |
| [Remote Access / Remote Administration](remote-access/README.md) | 5 → 6 | 11 → 12 | Add sourced candidate families; see guide | [Primary source](https://www.splashtop.com/downloads) |
| [Remote Shell / SSH Tools](remote-shell-ssh/README.md) | 4 → 5 | 8 → 9 | Add sourced candidate families; see guide | [Primary source](https://www.vandyke.com/products/securecrt/) |
| [Screen Recording / Capture](screen-capture/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://www.techsmith.com/camtasia/) |
| [Scripting / Automation Tools](scripting-automation/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://www.autoitscript.com/site/autoit/) |
| [Social Applications](social-applications/README.md) | 4 → 4 | 4 → 4 | Retain; explicit application-inventory gap | [Primary source](https://www.tiktok.com/explore) |
| [System Administration Tools](system-administration/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Primary source](https://www.pdq.com/pdq-inventory/) |
| [Virtualization](virtualization/README.md) | 4 → 5 | 6 → 7 | Add sourced candidate families; see guide | [Primary source](https://knowledge.broadcom.com/external/article/368734/support.broadcom.com) |
| [VPN / Tunneling / Proxy](vpn-tunneling-proxy/README.md) | 6 → 8 | 7 → 11 | Add sourced candidate families; see guide | [Primary source](https://www.fortinet.com/support/product-downloads) |

The social-applications source returned only limited page content. No new pattern was enabled there. Existing labels remain weak inherited candidates; web/PWA use needs another telemetry surface. AI tools retained their four families after checking native ChatGPT distribution; insufficient primary page content prevented adding a Perplexity desktop pattern in this round.

## Antivirus and endpoint security

Coverage now includes the original Avast, AVG, NOD32 and ClamAV candidates plus Avira, Bitdefender consumer editions, ESET business endpoint editions, Kaspersky Endpoint Security for Windows, Norton, McAfee Total Protection, Malwarebytes, F-Secure, Panda, Emsisoft and Trend Micro candidates. Editions are grouped where the query only supports a family-level review.

The separate endpoint-security category includes BEST, Sophos Endpoint Agent, Symantec Endpoint Protection and Elastic Agent alongside the previous Cortex, CrowdStrike, SentinelOne and Microsoft Defender candidates. Primary category ownership prevents duplicate catalog records; it does not imply products in one bucket lack capabilities associated with another.

Do not interpret two inventory rows as conflicting real-time engines. They can be historical reports, components or versions. Agent presence does not establish management enrollment, sensor health or licensed modules. [Bitdefender's EDR guidance](https://www.bitdefender.com/business/support/en/77212-157519-edr.html) requires separate activation; [Sophos software-package guidance](https://docs.sophos.com/central/customer/help/en-US/ManageYourProducts/GlobalSettings/ProductsServices/Endpoint/SoftwarePackages/SoftwarePackagesFAQ/index.html) distinguishes core agent and licensed protection components. Elastic Agent can exist without Elastic Defend.

Built-in Windows protection can be absent from installed-app inventory. Check product-specific configuration/health evidence before assessing protection gaps. Do not add generic `Defender`, `Security Agent`, `Endpoint Security` or brand-only catch-all predicates to compensate for missing telemetry.

## Changes and validation

- All original 160 exact labels and stable IDs remain enabled. The original `git-for-windows` ID now displays **Git family** because `Git` alone cannot establish Windows packaging. This is an intentional semantic correction, covered by an explicit regression expectation.
- Queries retain the same seven output columns, preset, 30-day window, null/empty-name handling, full-string matching, duplicate retention and 1,000-row cap. The master contains the same product/label mapping as the category union.
- No substring, wildcard, guessed version-removal or broad regex rule was introduced. Version, architecture, locale, component and customer-specific suffixes remain coverage gaps unless explicitly listed.
- Offline fixtures cover every enabled label, case variants, whitespace/prefix/suffix/version near-matches, generic decoys, cross-product decoys, null context, duplicate rows and cap behavior. Baseline comparisons allow only declared additions and the Git-family correction. Source/date/classification fields, category coverage and documentation links are also checked.
- Offline checks do not simulate the Cortex engine or prove full-query documentation conformance, tenant schema, compilation, execution, performance or precision/recall. Complete-query **S/D/C/E: NOT RUN**; overall evidence remains **VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED**.

The expanded master has 167 mapping stages; compiler/runtime size limits are unmeasured. Start tenant validation with category queries, a narrow window and a small cap. Do not silently drop products to make a rejected master compile.

## Presence versus authorization

The query answers whether an admitted inventory row has a listed name. To call the product unauthorized, independently establish package identity, asset scope, business need, policy owner, effective dates, approval and exceptions. Missing policy data is **Unknown**, and approved software is a legitimate inventory match. The other-shadow-it category is a curated utility group, not an automatic classification of all unknown software.

## Next evidence needed

Obtain sanitized application rows and corroborated package/publisher evidence for each relevant OS and packaging channel. Keep the raw name, reported version, collection context and date; record whether a proposed alias actually appeared. Confirm target fields/types, then compile and execute bounded positive/negative fixtures in the authorized tenant. Use separate validated telemetry for browser/PWA activity, IDE extensions, containers, OS features, portable tools, execution and security-agent health.

New sources were inspected on **2026-10-16**. Inherited source statuses/dates remain in the maintained authoring catalog outside the query-only repository. No query-metadata YAML, generator, catalog or test artifact is added to the community folder. Tenant validation remains pending.
