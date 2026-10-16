# Coverage review — October 16, 2026

[Query index](README.md) · [Consolidated query guide](all-detected-tools.md)

Across the October 16 reviews, **30 categories** were assessed and **125 product/family candidates** were added: **124 → 249 families** and **160 → 312 exact labels**. The latest source-backed subset is described first; the earlier eight-category release is retained as history. Antivirus retains its earlier expansion from **4 → 15 families**; endpoint security from **4 → 8**. Family counts group some related editions and do not measure independent installations, active protections or market share.

The goal is useful, traceable application-inventory coverage. It is not a complete market catalog. No tenant inventory export, schema observation, compilation or execution was available. **Zero enabled labels are tenant-observed or tenant-validated.**

## Source-backed desktop expansion

Relative to published commit `7350bdf`, this release promotes **16 of the 50 curated research candidates**: **233 → 249 families** and **293 → 312 exact labels**. Seven category queries and the master expand; the other **23 category query contents are unchanged**. The 50-candidate assessment was a bounded sample of the 21 supplied sources, not an exhaustive catalog scrape.

| Category | Families before → after | Labels before → after |
|---|---:|---:|
| [ai-development](ai-development/README.md) | 12 → 14 | 16 → 19 |
| [ai-tools](ai-tools/README.md) | 12 → 13 | 15 → 16 |
| [browsers](browsers/README.md) | 16 → 19 | 19 → 22 |
| [development-ides](development-ides/README.md) | 5 → 6 | 10 → 12 |
| [file-transfer](file-transfer/README.md) | 13 → 17 | 15 → 20 |
| [gaming](gaming/README.md) | 13 → 15 | 14 → 16 |
| [remote-access](remote-access/README.md) | 15 → 18 | 24 → 27 |

### Why these candidates

Prioritize independently described desktop distributions, explicit vendor-installed labels, literal upstream packaging names and narrowly scoped manifest-declared names. Each promoted family has the exact enabled labels, evidence link and limitations in its adjacent category guide. Community metadata is not presented as vendor verification. No executable basename, PE ProductName, bucket title or package identifier was silently converted into an installed-app name.

- Upstream packaging substantiates LocalSend, ChatALL, T3 Code / T3 Code (Nightly), and Codex Monitor naming. Build configuration is not proof that an installer was built, installed or captured by Cortex.
- Vendor Windows instructions explicitly distinguish Resilio Sync from Resilio Sync Service. Their shared review family does not remove component distinctions from the raw label.
- Pinned WinGet metadata declares HopToDesk, Thorium (Portable), and the VSCodium (User) variant. A community declaration or portable registration is not evidence that this preset collects it. No bare Thorium label or version-stripping logic is enabled.
- The remaining desktop labels are explicitly classified product-name candidates, corroborated by first-party distribution/installation material and, where cited, a pinned installer manifest. A ProductCode/UpgradeCode by itself is not DisplayName evidence.

### Candidates deliberately deferred

The other **34 candidates** remain research-only. This is not a claim that they cannot be monitored.

- **Portable/CLI and script tooling:** croc, ffuf, Nuclei, feroxbuster, Gobuster, NetExec, Impacket, GPTScript, KoboldCpp and Ludusavi need a substantiated application entry or separately validated package/process/file telemetry. Existing CLI candidates in the previous release are not silently removed, but this round does not extend that weaker evidence tier.
- **Identity collisions and component ambiguity:** Tabby terminal and TabbyML can both use `tabby.exe`; ungoogled-chromium can use `chrome.exe` and Chromium naming. GitHub Copilot's desktop environment needs separate identity work from GitHub Desktop, CLI, extension and Microsoft Copilot. No ambiguous executable or generic label is enabled.
- **Server/web/gateway sources:** LocalAI, LibreChat, Nextcloud, Guacamole and other discovery-only remote-access/tunnel entries need component, platform and deployment-channel corroboration. They are not presumed desktop inventory entries.
- **RMM metadata:** FleetDeck, PDQ Connect and Pulseway leads include PE metadata, incomplete rows or shared network infrastructure; these are not current uninstall-label contracts. No domains, signatures or heuristics were blindly copied into XQL.
- **Security labs:** Ghidra, x64dbg, dnSpyEx, FLOSS and PE-bear require a separately approved category/collection design. FLARE/Commando profiles can inform role review, not automatic global allowlisting.
- **LOLBAS and protection-health proposals:** behavior-specific and service/driver/health correlations remain outside these installed-software queries. Native Windows binaries are not added as malicious software, and a query hit is not an incident or action authorization.

### Review and validation boundary

All **293 labels and 233 family mappings** from `7350bdf` are retained without modification. The seven output columns, source/preset, 30-day window, full-string case-insensitive matching, null/empty-name handling, duplicate-row retention and 1,000-row cap are unchanged. No runtime schema fields, process rule, wildcard, regex, write or automated response was introduced.

Offline tests parse the actual files using a limited independent interpreter, compare the original, 167-family and 233-family snapshots, exercise new labels and collision/near-match negatives, and check category/master parity, duplicates, caps and documentation links. These local artifact checks are not the Cortex compiler or an independent production-readiness certification. Complete-query **S/D/C/E: NOT RUN**; overall evidence remains **VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED**. The current language/preset pages were refreshed, but the four source-field spellings still rely on the historical XDR example. The next owner is the tenant's XQL/platform administrator: verify product/build, entitlement, schema/types, identity scope and sanitized labels, then compile and run a bounded category query before the master. Repository publication does not deploy a tenant detection.

## Earlier eight-category follow-up (published at 7350bdf)

Relative to published commit `8723fce`, this follow-up adds **66 families** in the eight requested categories, taking the library from **167 to 233 families** and **212 to 293 exact labels**. The other 22 categories retain their published query content.

| Requested category | Families before → after | Labels before → after |
|---|---:|---:|
| [ai-development](ai-development/README.md) | 5 → 12 | 6 → 16 |
| [ai-tools](ai-tools/README.md) | 4 → 12 | 5 → 15 |
| [browsers](browsers/README.md) | 5 → 16 | 7 → 19 |
| [file-transfer](file-transfer/README.md) | 5 → 13 | 6 → 15 |
| [gaming](gaming/README.md) | 6 → 13 | 7 → 14 |
| [local-ai](local-ai/README.md) | 5 → 13 | 5 → 15 |
| [remote-access](remote-access/README.md) | 6 → 15 | 12 → 24 |
| [penetration-testing](penetration-testing/README.md) | 5 → 13 | 6 → 17 |

The category guides linked every family added in that earlier release to a primary source and explain packaging gaps. New literals are candidates, not names observed in a Cortex export. Native-client distribution can be substantiated without substantiating the precise `application_name` value. Short brand labels still need independent package/publisher evidence.

### Role and lifecycle decisions

- FileZilla Server is a distinct server record, never a client alias. Remote Utilities Host and Viewer are a grouped review family; component role must be corroborated before interpreting remote-access exposure.
- Product renames are grouped to avoid counting old/new branding as two installations: Copilot app names, GoTo/LogMeIn Resolve, Backyard AI/Faraday, Acunetix/Invicti Web + API and Netsparker/Invicti Standard. Renames do not establish installed labels or current packaging.
- [Backyard AI's current desktop page](https://desktop.backyard.ai/) declares that client deprecated and unsupported. Its historical names are included for inventory review, not as an installation recommendation. [The vendor rebranding post](https://backyard.ai/blog/rebranding-to-backyard) supports the Faraday relation.
- ZAP is now a deliberate exact-name product candidate, replacing an earlier negative-decoy fixture. Its [desktop startup documentation](https://www.zaproxy.org/faq/how-can-you-start-zap/) identifies ZAP.app and the Zed Attack Proxy distribution. No contains/wildcard rule was introduced.
- Codex CLI includes the documented `@openai/codex` package identifier as a **package-name candidate**. npm/standalone installations may produce no application row, and this does not claim separate Codex desktop-app coverage.
- Hashcat, sqlmap and Nikto remain conditional CLI/package inventory candidates. Container-only, portable or checked-out script use can be invisible to this preset. Queries provide no process/file, active-session, game-execution, AI-use or exploitation monitoring.
- No plain Copilot, Zen, Host, Viewer, Agent, FTP or remote keyword is enabled. CrossFTP was held because the retrieved official site was suspended; no replacement domain was assumed. Tor/Mullvad browsers and SecureCRT remain in their existing primary categories, with category-guide cross-links.

The follow-up preserves all **212 previously enabled labels**, IDs and mappings, the seven output columns, 30-day window, duplicate behavior and 1,000-row cap. Offline tests compare against both the original library and the exact published 167-family query snapshot, including new names, near-matches, cross-category exclusions, cap behavior and unchanged queries outside scope. These checks do not establish Cortex engine behavior or tenant acceptance.


## Name evidence

| Evidence label | What it supports | What it does not support |
|---|---|---|
| `COMMUNITY_MANIFEST_APP_LABEL` | A pinned community manifest explicitly declares the application-entry name for a specific package/version/channel. | A vendor assertion, actual installed label or Cortex collection. |
| `UPSTREAM_PACKAGING_APP_NAME` | Pinned first-party packaging configuration defines the product/AppName. | A successful build, an installed artifact, universal ARP name or Cortex population. |
| `PRODUCT_NAME_CANDIDATE` | A first-party product/distribution page substantiates the product name; a whole-name match is proposed. | An actual installed-app label or Cortex population. |
| `PACKAGE_NAME_CANDIDATE` | A first-party installation reference documents a package identifier or CLI product name. | That npm, a portable binary or another package channel creates an application-preset row. |
| `VENDOR_INSTALLED_APP_LABEL` | Vendor instructions explicitly name an installed app, such as Avira Security. | The same name in every edition, platform or Cortex tenant. |
| `HISTORICAL_VENDOR_INSTALLED_APP_LABEL` | A version-scoped vendor document names an installed app, such as Kaspersky Endpoint Security for Windows in version 11 guidance. | A current universal field or packaging contract. |
| `VENDOR_DOCUMENTED_RENAME_CANDIDATE` | A current primary source explicitly links old/new branding, as the Windsurf/Devin Desktop download page does. | Runtime identity, a universal installed-app alias or unrelated plugins. |
| `INHERITED_PRODUCT_NAME_CANDIDATE` | The prior catalog retains a product reference and its original retrieval status/date. | Fresh retrieval of all 124 old references or an observed inventory label. |

The adjacent category guides link each product/family to its name evidence. A product name, package identifier and application display name are different identifiers. For example, Cloudflare documents `cloudflare-warp` as a Linux package; matching that string in `application_name` remains a candidate until its tenant representation is observed. Do not infer publisher/signature identity from a label.

## Category review

Every category guide now includes a specific review of packaging, runtime and policy gaps. The table compares the original 124-family library with the current state; the source-backed table above isolates this release's delta. Source links support product/distribution context; the evidence labels above define the narrower matching claim.

| Category | Families before → after | Labels before → after | Decision | Example evidence |
|---|---:|---:|---|---|
| [AI Development Tools](ai-development/README.md) | 4 → 14 | 4 → 19 | Add sourced candidate families; see guide | [Reference](https://kiro.dev/downloads/) |
| [Antivirus](antivirus/README.md) | 4 → 15 | 4 → 20 | Add sourced candidate families; see guide | [Reference](https://support.avira.com/hc/en-us/articles/360003162153-Uninstallation-of-Avira-for-Windows) |
| [Artificial Intelligence Tools](ai-tools/README.md) | 4 → 13 | 5 → 16 | Add sourced candidate families; see guide | [Reference](https://support.microsoft.com/en-us/microsoft-365-copilot/what-is-microsoft-copilot-app) |
| [Browsers](browsers/README.md) | 4 → 19 | 6 → 22 | Add sourced candidate families; see guide | [Reference](https://www.opera.com/download) |
| [Cloud Storage / File Synchronization](cloud-storage/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Reference](https://github.com/meganz/MEGAsync) |
| [Communication / Messaging](messaging/README.md) | 5 → 6 | 7 → 8 | Add sourced candidate families; see guide | [Reference](https://www.zoom.com/en/products/collaboration-tools/) |
| [Containers](containers/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Reference](https://orbstack.dev/) |
| [Crypto / Mining Tools](crypto-mining/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Reference](https://www.getmonero.org/downloads/) |
| [Database Clients](database-clients/README.md) | 4 → 5 | 5 → 7 | Add sourced candidate families; see guide | [Reference](https://www.oracle.com/database/sqldeveloper/) |
| [Developer Utilities](developer-utilities/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Reference](https://www.usebruno.com/) |
| [Development Tools / IDEs](development-ides/README.md) | 4 → 6 | 9 → 12 | Add sourced candidate families; see guide | [Reference](https://developer.android.com/studio) |
| [EDR / Endpoint Security](endpoint-security/README.md) | 4 → 8 | 5 → 9 | Add sourced candidate families; see guide | [Reference](https://www.bitdefender.com/business/support/en/77211-376358-security-agents.html) |
| [File Transfer Tools](file-transfer/README.md) | 4 → 17 | 5 → 20 | Add sourced candidate families; see guide | [Reference](https://www.coreftp.com/) |
| [Gaming Platforms](gaming/README.md) | 4 → 15 | 5 → 16 | Add sourced candidate families; see guide | [Reference](https://support.riotgames.com/en-us/riot/account/logging-into-the-riot-client-with-a-qr-code) |
| [Local AI / LLM Runtimes](local-ai/README.md) | 4 → 13 | 4 → 15 | Add sourced candidate families; see guide | [Reference](https://comfy.org/download) |
| [Network Utilities](network-utilities/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Reference](https://www.advanced-ip-scanner.com/) |
| [Other Corporate-Risk / Shadow-IT Applications](other-shadow-it/README.md) | 4 → 5 | 6 → 7 | Add sourced candidate families; see guide | [Reference](https://peazip.github.io/) |
| [P2P / Torrent](p2p-torrent/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Reference](https://tixati.com/) |
| [Password Managers](password-managers/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Reference](https://help.enpass.io/personal/latest/all/enpass-apps-installation) |
| [Penetration Testing / Dual-Use Security Tools](penetration-testing/README.md) | 4 → 13 | 5 → 17 | Add sourced candidate families; see guide | [Reference](https://www.zaproxy.org/faq/how-can-you-start-zap/) |
| [Personal Collaboration Tools](personal-collaboration/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Reference](https://github.com/logseq/logseq) |
| [Privacy / Anonymization Tools](privacy-anonymization/README.md) | 4 → 5 | 4 → 5 | Add sourced candidate families; see guide | [Reference](https://mullvad.net/en/browser) |
| [Remote Access / Remote Administration](remote-access/README.md) | 5 → 18 | 11 → 27 | Add sourced candidate families; see guide | [Reference](https://download.nomachine.com/) |
| [Remote Shell / SSH Tools](remote-shell-ssh/README.md) | 4 → 5 | 8 → 9 | Add sourced candidate families; see guide | [Reference](https://www.vandyke.com/products/securecrt/) |
| [Screen Recording / Capture](screen-capture/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Reference](https://www.techsmith.com/camtasia/) |
| [Scripting / Automation Tools](scripting-automation/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Reference](https://www.autoitscript.com/site/autoit/) |
| [Social Applications](social-applications/README.md) | 4 → 4 | 4 → 4 | Retain; explicit application-inventory gap | [Reference](https://www.tiktok.com/explore) |
| [System Administration Tools](system-administration/README.md) | 4 → 5 | 5 → 6 | Add sourced candidate families; see guide | [Reference](https://www.pdq.com/pdq-inventory/) |
| [Virtualization](virtualization/README.md) | 4 → 5 | 6 → 7 | Add sourced candidate families; see guide | [Reference](https://knowledge.broadcom.com/external/article/368734/support.broadcom.com) |
| [VPN / Tunneling / Proxy](vpn-tunneling-proxy/README.md) | 6 → 8 | 7 → 11 | Add sourced candidate families; see guide | [Reference](https://www.fortinet.com/support/product-downloads) |

The social-applications source returned only limited page content in the earlier review. No new pattern was enabled there; existing labels remain weak inherited candidates and web/PWA use needs another surface. The earlier hold on Perplexity was lifted after its substantive first-party desktop changelog was retrieved; its enabled label remains a candidate, not a Cortex observation.

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

The expanded master has 249 mapping stages; compiler/runtime size limits are unmeasured. Start tenant validation with category queries, a narrow window and a small cap. Do not silently drop products to make a rejected master compile.

## Presence versus authorization

The query answers whether an admitted inventory row has a listed name. To call the product unauthorized, independently establish package identity, asset scope, business need, policy owner, effective dates, approval and exceptions. Missing policy data is **Unknown**, and approved software is a legitimate inventory match. The other-shadow-it category is a curated utility group, not an automatic classification of all unknown software.

## Next evidence needed

Obtain sanitized application rows and corroborated package/publisher evidence for each relevant OS and packaging channel. Keep the raw name, reported version, collection context and date; record whether a proposed alias actually appeared. Confirm target fields/types, then compile and execute bounded positive/negative fixtures in the authorized tenant. Use separate validated telemetry for browser/PWA activity, IDE extensions, containers, OS features, portable tools, execution and security-agent health.

New source material was inspected on **2026-10-16**. Inherited source statuses/dates remain in the maintained authoring catalog outside the query-only repository. No query-metadata YAML, generator, catalog or test artifact is added to the community folder. Tenant validation remains pending.
