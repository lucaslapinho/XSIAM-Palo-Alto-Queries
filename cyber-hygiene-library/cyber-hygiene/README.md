# Cyber Hygiene query library

**30 category queries and one [master query](all-detected-tools.xql)** classify **124 product records / 160 exact candidate labels** from the [catalog](../catalog/software-catalog.yaml). [Master guide](all-detected-tools.md) · [Master metadata](all-detected-tools.metadata.yaml).

Target: **Cortex XDR interactive Query Center**, using a historical Cortex XDR field example. **VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED**. Complete-query **S/D/C/E: NOT RUN** for every file. XSIAM compatibility is **UNVERIFIED** and requires separate field binding. These are software-inventory review candidates, not production detections or a malicious-software list.

Each row reports a whole-name candidate in the admitted 30-day inventory window. Raw names are preserved; all derived product/category/vendor/context values come from the catalog. Primary ownership avoids duplicating products across category views. Priority remains `POLICY_DEPENDENT_UNASSIGNED`. No current-state, latest-snapshot, execution, approval or fleet-completeness claim is made. Each query returns at most 1,000 rows without guaranteed ordering. Master-query compiler limits, resource use and result size are unmeasured.

| Primary category | Products | Query |
|---|---:|---|
| [Penetration Testing / Dual-Use Security Tools](penetration-testing/README.md) | 4 | [XQL](penetration-testing/detect-penetration-testing-tools.xql) |
| [Remote Access / Remote Administration](remote-access/README.md) | 5 | [XQL](remote-access/detect-remote-access-tools.xql) |
| [VPN / Tunneling / Proxy](vpn-tunneling-proxy/README.md) | 6 | [XQL](vpn-tunneling-proxy/detect-vpn-tunneling-proxy-tools.xql) |
| [Antivirus](antivirus/README.md) | 4 | [XQL](antivirus/detect-antivirus-tools.xql) |
| [EDR / Endpoint Security](endpoint-security/README.md) | 4 | [XQL](endpoint-security/detect-endpoint-security-tools.xql) |
| [Artificial Intelligence Tools](ai-tools/README.md) | 4 | [XQL](ai-tools/detect-ai-tools.xql) |
| [AI Development Tools](ai-development/README.md) | 4 | [XQL](ai-development/detect-ai-development-tools.xql) |
| [Local AI / LLM Runtimes](local-ai/README.md) | 4 | [XQL](local-ai/detect-local-ai-tools.xql) |
| [Development Tools / IDEs](development-ides/README.md) | 4 | [XQL](development-ides/detect-development-ides-tools.xql) |
| [Developer Utilities](developer-utilities/README.md) | 4 | [XQL](developer-utilities/detect-developer-utilities-tools.xql) |
| [Social Applications](social-applications/README.md) | 4 | [XQL](social-applications/detect-social-applications-tools.xql) |
| [Communication / Messaging](messaging/README.md) | 5 | [XQL](messaging/detect-messaging-tools.xql) |
| [Gaming Platforms](gaming/README.md) | 4 | [XQL](gaming/detect-gaming-tools.xql) |
| [Cloud Storage / File Synchronization](cloud-storage/README.md) | 4 | [XQL](cloud-storage/detect-cloud-storage-tools.xql) |
| [File Transfer Tools](file-transfer/README.md) | 4 | [XQL](file-transfer/detect-file-transfer-tools.xql) |
| [P2P / Torrent](p2p-torrent/README.md) | 4 | [XQL](p2p-torrent/detect-p2p-torrent-tools.xql) |
| [Browsers](browsers/README.md) | 4 | [XQL](browsers/detect-browsers-tools.xql) |
| [Password Managers](password-managers/README.md) | 4 | [XQL](password-managers/detect-password-managers-tools.xql) |
| [Virtualization](virtualization/README.md) | 4 | [XQL](virtualization/detect-virtualization-tools.xql) |
| [Containers](containers/README.md) | 4 | [XQL](containers/detect-containers-tools.xql) |
| [Network Utilities](network-utilities/README.md) | 4 | [XQL](network-utilities/detect-network-utilities-tools.xql) |
| [System Administration Tools](system-administration/README.md) | 4 | [XQL](system-administration/detect-system-administration-tools.xql) |
| [Database Clients](database-clients/README.md) | 4 | [XQL](database-clients/detect-database-clients-tools.xql) |
| [Remote Shell / SSH Tools](remote-shell-ssh/README.md) | 4 | [XQL](remote-shell-ssh/detect-remote-shell-ssh-tools.xql) |
| [Scripting / Automation Tools](scripting-automation/README.md) | 4 | [XQL](scripting-automation/detect-scripting-automation-tools.xql) |
| [Screen Recording / Capture](screen-capture/README.md) | 4 | [XQL](screen-capture/detect-screen-capture-tools.xql) |
| [Personal Collaboration Tools](personal-collaboration/README.md) | 4 | [XQL](personal-collaboration/detect-personal-collaboration-tools.xql) |
| [Crypto / Mining Tools](crypto-mining/README.md) | 4 | [XQL](crypto-mining/detect-crypto-mining-tools.xql) |
| [Privacy / Anonymization Tools](privacy-anonymization/README.md) | 4 | [XQL](privacy-anonymization/detect-privacy-anonymization-tools.xql) |
| [Other Corporate-Risk / Shadow-IT Applications](other-shadow-it/README.md) | 4 | [XQL](other-shadow-it/detect-other-shadow-it-tools.xql) |

Read the adjacent guide and metadata before tenant validation. Confirm the deployed XDR build, preset, source fields/types, collection, retention and access; compile incrementally and execute bounded fixtures. Zero rows do not prove absence. Rule/API/XQLp conversion needs a separate review.

Maintenance: run `python tools/generate_query_library.py` from the repository root after installing PyYAML. Run `python tools/generate_query_library.py --check` for deterministic artifact drift and structural validation. These author checks do not change S/D/C/E. The generator writes only its 94 declared query/guide/metadata/index artifacts and never deletes unrelated files.
