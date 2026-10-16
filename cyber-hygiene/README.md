# Cyber Hygiene XQL Queries

Community queries for reviewing software reported by Cortex application inventory: **30 category queries, one consolidated query, 124 product candidates and 160 exact labels**.

Start with a category below. Use [all-detected-tools.xql](all-detected-tools.xql) for a combined view; its [guide](all-detected-tools.md) explains the larger query. Every query is self-contained and read-only.

## Query index

| Category | Products | Query |
|---|---:|---|
| [AI Development Tools](ai-development/README.md) | 4 | [XQL](ai-development/detect-ai-development-tools.xql) |
| [Antivirus](antivirus/README.md) | 4 | [XQL](antivirus/detect-antivirus-tools.xql) |
| [Artificial Intelligence Tools](ai-tools/README.md) | 4 | [XQL](ai-tools/detect-ai-tools.xql) |
| [Browsers](browsers/README.md) | 4 | [XQL](browsers/detect-browsers-tools.xql) |
| [Cloud Storage / File Synchronization](cloud-storage/README.md) | 4 | [XQL](cloud-storage/detect-cloud-storage-tools.xql) |
| [Communication / Messaging](messaging/README.md) | 5 | [XQL](messaging/detect-messaging-tools.xql) |
| [Containers](containers/README.md) | 4 | [XQL](containers/detect-containers-tools.xql) |
| [Crypto / Mining Tools](crypto-mining/README.md) | 4 | [XQL](crypto-mining/detect-crypto-mining-tools.xql) |
| [Database Clients](database-clients/README.md) | 4 | [XQL](database-clients/detect-database-clients-tools.xql) |
| [Developer Utilities](developer-utilities/README.md) | 4 | [XQL](developer-utilities/detect-developer-utilities-tools.xql) |
| [Development Tools / IDEs](development-ides/README.md) | 4 | [XQL](development-ides/detect-development-ides-tools.xql) |
| [EDR / Endpoint Security](endpoint-security/README.md) | 4 | [XQL](endpoint-security/detect-endpoint-security-tools.xql) |
| [File Transfer Tools](file-transfer/README.md) | 4 | [XQL](file-transfer/detect-file-transfer-tools.xql) |
| [Gaming Platforms](gaming/README.md) | 4 | [XQL](gaming/detect-gaming-tools.xql) |
| [Local AI / LLM Runtimes](local-ai/README.md) | 4 | [XQL](local-ai/detect-local-ai-tools.xql) |
| [Network Utilities](network-utilities/README.md) | 4 | [XQL](network-utilities/detect-network-utilities-tools.xql) |
| [Other Corporate-Risk / Shadow-IT Applications](other-shadow-it/README.md) | 4 | [XQL](other-shadow-it/detect-other-shadow-it-tools.xql) |
| [P2P / Torrent](p2p-torrent/README.md) | 4 | [XQL](p2p-torrent/detect-p2p-torrent-tools.xql) |
| [Password Managers](password-managers/README.md) | 4 | [XQL](password-managers/detect-password-managers-tools.xql) |
| [Penetration Testing / Dual-Use Security Tools](penetration-testing/README.md) | 4 | [XQL](penetration-testing/detect-penetration-testing-tools.xql) |
| [Personal Collaboration Tools](personal-collaboration/README.md) | 4 | [XQL](personal-collaboration/detect-personal-collaboration-tools.xql) |
| [Privacy / Anonymization Tools](privacy-anonymization/README.md) | 4 | [XQL](privacy-anonymization/detect-privacy-anonymization-tools.xql) |
| [Remote Access / Remote Administration](remote-access/README.md) | 5 | [XQL](remote-access/detect-remote-access-tools.xql) |
| [Remote Shell / SSH Tools](remote-shell-ssh/README.md) | 4 | [XQL](remote-shell-ssh/detect-remote-shell-ssh-tools.xql) |
| [Screen Recording / Capture](screen-capture/README.md) | 4 | [XQL](screen-capture/detect-screen-capture-tools.xql) |
| [Scripting / Automation Tools](scripting-automation/README.md) | 4 | [XQL](scripting-automation/detect-scripting-automation-tools.xql) |
| [Social Applications](social-applications/README.md) | 4 | [XQL](social-applications/detect-social-applications-tools.xql) |
| [System Administration Tools](system-administration/README.md) | 4 | [XQL](system-administration/detect-system-administration-tools.xql) |
| [Virtualization](virtualization/README.md) | 4 | [XQL](virtualization/detect-virtualization-tools.xql) |
| [VPN / Tunneling / Proxy](vpn-tunneling-proxy/README.md) | 6 | [XQL](vpn-tunneling-proxy/detect-vpn-tunneling-proxy-tools.xql) |

## Before running

Intended surface: **interactive Query Center**. The application preset is listed in the current [Cortex XSIAM](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets.md) and [Cortex XDR](https://cortex-docs.paloaltonetworks.com/cortex-xdr-5.x/reference-and-developer-docs/cortex-xdr-xql/get-started-with-xql/datasets-and-presets.md) documentation. Field spellings come from the historical [Unit 42 Cortex XDR inventory example](https://unit42.paloaltonetworks.com/openssl-vulnerabilities/), updated November 4, 2022. A current preset listing does not establish a current field contract for either product.

1. Confirm your product/build, inventory entitlement and collection, retention, and Query Center access.
2. Find `host_inventory_applications` in your tenant and confirm `endpoint_name`, `platform`, `application_name`, and `version`. `application_name` must be a string; the other three fields are projected without conversion.
3. Open a category's `.xql` file in Query Center. Begin with a shorter window, such as `1d`, and lower `limit`, such as `20`. These settings are review controls, not collection or performance guarantees.
4. Compile and run the file in your authorized tenant. Check real raw labels, mixed case, a nonmatching label, null/empty names, repeated rows and a known approved product.
5. Review results against business ownership, approved software and exceptions. Keep hostname and any extra system fields private when sharing results.

## Query pattern

All queries use the same sequence: configuration → application preset → null/empty-name filter → source projection → lowercase matching copy → exact label filter → product mapping → output projection → result cap.

The lookback is **30 days** and the cap is **1,000 rows**. Matching compares complete lowercase strings. The original source name remains unchanged. Unlisted labels are excluded; there is no generic fallback category. Every product has one primary category and disjoint labels. The query adds no joins, aggregation, deduplication, sorting, writes or automated response actions.

## Output

| Column | Meaning |
|---|---|
| `endpoint_name` | Source hostname; not assumed to be a unique endpoint identifier. |
| `platform` | Unmodified source platform value. |
| `application_name` | Complete source inventory label. |
| `version` | Unmodified reported application version; not a vulnerability assessment. |
| `detected_product` | Curated product candidate assigned by the label match. |
| `product_id` | Stable local ID for that candidate. |
| `tool_family` | Its primary software category. |

The normalized matching copy is internal. Product-defined system fields can also appear if present; [fields](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/fields.md) documents fields that cannot be excluded.

## Evidence and limitations

Review date: **2026-10-16**. Overall status: **VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED**. Current language and preset pages were inspected; the four input field spellings still rely on the historical XDR example. Complete-query S/D/C/E validation remains **NOT RUN**: there is no named target build, complete current field/type contract, tenant compilation or execution record. XSIAM field compatibility remains **UNVERIFIED**.

Offline checks cover the 31 query files, all 160 labels, original-to-revised mapping consistency, null/negative fixtures, category/master consistency and documentation links. They do not simulate the Cortex engine or establish runtime performance, compiler limits, precision or recall.

Each returned row is one admitted matching inventory row. Duplicate reports and versions remain separate, null source context is preserved, and result ordering is unspecified. Counts are not unique installations or endpoints. The cap can truncate results, and the master can require more compiler/runtime resources; prefer category queries for initial validation.

Historical inventory can contain removed software. Exact matching misses unlisted packaging, locales and suffixes; portable binaries, embedded components, extensions and web use may not have an inventory entry. A matching label can be spoofed or shared by another package. Corroborate package/publisher/signature evidence separately. Zero rows do not establish absence; check collection, permissions, retention and raw names.

Category membership is review context, not a risk score or policy verdict. These queries do not establish execution, network sessions, current installation, protection health, malicious behavior or unauthorized use. Rule, API and XQLp compatibility require separate validation.

## Maintenance and review

Use lowercase whole labels, one entry per line in the admission list, a stable product ID and a single primary category. Add a name only after checking sanitized inventory evidence. Update the category and master together, then check positive, mixed-case, near-match and null cases. Keep descriptive notes in the adjacent English guide.

The October 16 revision removed YAML metadata and the auxiliary project structure, shortened the guides, formatted filters and mappings into readable blocks, and reduced the requested output from 12 columns to seven. It preserves the original 160 admitted labels, 124 product mappings, 30-day window, 1,000-row cap and duplicate-row behavior. No tenant equivalence or speedup is claimed.

## Language references

Reviewed directly on 2026-10-16: [config](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/config.md), [preset](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/presets.md), [filter](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter.md), [alter](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/alter.md), [lowercase](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/lowercase.md), [if](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/if.md), [fields](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/fields.md), and [limit](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/limit.md).

Licensed under [Apache-2.0](LICENSE). Community-maintained content; not an official Palo Alto Networks library.
