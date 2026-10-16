# File Transfer Tools

[Open query](detect-file-transfer-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **17 product/family candidates / 20 labels**.

Related coverage: [SecureCRT and other SSH tools](../remote-shell-ssh/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Core FTP client family | `core-ftp-client` | `core ftp le`; `core ftp pro` | [Product-name candidate](https://www.coreftp.com/) |
| CuteFTP | `cuteftp` | `cuteftp` | [Product-name candidate](https://www.globalscape.com/cuteftp) |
| Cyberduck | `cyberduck` | `cyberduck` | [Inherited candidate](https://cyberduck.io/) |
| FileZilla Client | `filezilla-client` | `filezilla`; `filezilla client` | [Inherited candidate](https://filezilla-project.org/) |
| FileZilla Server | `filezilla-server` | `filezilla server` | [Product-name candidate](https://filezilla-project.org/download.php?type=server) |
| ForkLift | `forklift` | `forklift` | [Product-name candidate](https://binarynights.com/) |
| FreeFileSync | `freefilesync` | `freefilesync` | [Product-name candidate](https://freefilesync.org/) |
| GoodSync | `goodsync` | `goodsync` | [Product-name candidate](https://www.goodsync.com/faq) |
| LocalSend | `localsend` | `localsend` | [Upstream packaging name](https://github.com/localsend/localsend/blob/d01fdb14c978fa8b2b13e29a50cc0feaefe5c1b9/support/scripts/compile_windows_exe-inno.iss) |
| Mountain Duck | `mountain-duck` | `mountain duck` | [Product-name candidate](https://mountainduck.io/) |
| OnionShare | `onionshare` | `onionshare` | [Product-name candidate](https://docs.onionshare.org/2.6/en/install.html) |
| rclone | `rclone` | `rclone` | [Inherited candidate](https://rclone.org/) |
| Resilio Sync client / service family | `resilio-sync` | `resilio sync`; `resilio sync service` | [Vendor app label](https://help.resilio.com/hc/en-us/articles/204775029-How-to-uninstall-Sync) |
| SecureFX | `securefx` | `securefx` | [Product-name candidate](https://www.vandyke.com/products/securefx/) |
| SmartFTP | `smartftp` | `smartftp` | [Product-name candidate](https://www.smartftp.com/en-us/) |
| Transmit | `transmit` | `transmit` | [Product-name candidate](https://panic.com/transmit/) |
| WinSCP | `winscp` | `winscp` | [Inherited candidate](https://winscp.net/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames, upstream packaging names, community manifest declarations and inherited entries. A configured packaging name is not an observed installed label; a community manifest is not a vendor assertion. Every enabled name remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

File movement; review destinations, credentials, encryption configuration and permitted data.

Expanded native clients, remote-drive mounting, synchronization and a distinct FileZilla Server record. Client/server identities are never aliases. Sync can be entirely local; server presence does not prove a running or exposed service. CrossFTP was held after its official site redirected to a suspended-account page; no invented replacement or broad FTP keyword was added.

Source-backed follow-up adds LocalSend's upstream packaging name, OnionShare and GoodSync desktop candidates, and vendor-documented Resilio Sync client/service labels. LAN sharing, privacy tooling, backups and service components have different semantics; no transfer, exfiltration, active service or peer is inferred. Portable croc remains deferred.

- **SmartFTP**: Installer variants, portable copies and transfers require separate evidence.
- **Core FTP client family**: Client edition-name candidates; they do not identify a server, configured destination or transfer.
- **CuteFTP**: Client product-name candidate. Verify installed version and vendor lifecycle independently before interpreting support or risk.
- **Transmit**: Mac file-transfer client candidate; product/version suffixes and account destinations are outside the exact label match.
- **ForkLift**: File manager and transfer client candidate. Local file-manager use does not establish remote transfer activity.
- **Mountain Duck**: Remote storage mounting client; a reported name does not establish a mounted destination or synchronized content.
- **FreeFileSync**: Synchronization/backup utility candidate. Local synchronization is a legitimate use; the label does not imply exfiltration.
- **SecureFX**: Transfer client distinct from SecureCRT. Bundled installations and actual protocol/destination use require corroboration.
- **FileZilla Server**: A separate server record, never a FileZilla Client alias. Presence does not prove the service is running, exposed or transferring files.
- **LocalSend**: The pinned upstream Inno Setup source explicitly defines MyAppName as LocalSend and uses it for AppName. Packaging-source evidence does not prove an installer was built, installed or reported by Cortex. LAN sharing capability is not evidence of an actual transfer or exfiltration.
- **OnionShare**: Version-scoped upstream installation instructions and a pinned MSI distribution support this desktop name candidate. The sampled manifest supplies an UpgradeCode, not DisplayName. CLI/portable copies and actual Tor use need other evidence. Privacy overlap does not create a duplicate family in another category. [Additional reference](https://github.com/microsoft/winget-pkgs/blob/7e1c45b2bf03d0c8ef7547a92822d1ef7c9def44/manifests/o/OnionShare/OnionShare/2.6.5/OnionShare.OnionShare.installer.yaml).
- **GoodSync**: The vendor FAQ documents installed clients and uninstallation; a pinned Windows installer corroborates distribution. GoodSync is still a product-name candidate, not a universal uninstall label. Server/runner components, configured jobs, account ownership and active synchronization are not inferred. [Additional reference](https://github.com/microsoft/winget-pkgs/blob/7e1c45b2bf03d0c8ef7547a92822d1ef7c9def44/manifests/s/SiberSystems/GoodSync/12.11.9.9/SiberSystems.GoodSync.installer.yaml).
- **Resilio Sync client / service family**: Vendor Windows uninstall instructions explicitly distinguish Resilio Sync and Resilio Sync Service in Control Panel. They are grouped under one review family; retain the raw label to distinguish the components. Do not merge Resilio Active Everywhere/Connect or infer an active service, synchronization, peer or transferred data.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
