# File Transfer Tools

[Open query](detect-file-transfer-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **13 product/family candidates / 15 labels**.

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
| Mountain Duck | `mountain-duck` | `mountain duck` | [Product-name candidate](https://mountainduck.io/) |
| rclone | `rclone` | `rclone` | [Inherited candidate](https://rclone.org/) |
| SecureFX | `securefx` | `securefx` | [Product-name candidate](https://www.vandyke.com/products/securefx/) |
| SmartFTP | `smartftp` | `smartftp` | [Product-name candidate](https://www.smartftp.com/en-us/) |
| Transmit | `transmit` | `transmit` | [Product-name candidate](https://panic.com/transmit/) |
| WinSCP | `winscp` | `winscp` | [Inherited candidate](https://winscp.net/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

File movement; review destinations, credentials, encryption configuration and permitted data.

Expanded native clients, remote-drive mounting, synchronization and a distinct FileZilla Server record. Client/server identities are never aliases. Sync can be entirely local; server presence does not prove a running or exposed service. CrossFTP was held after its official site redirected to a suspended-account page; no invented replacement or broad FTP keyword was added.

- **SmartFTP**: Installer variants, portable copies and transfers require separate evidence.
- **Core FTP client family**: Client edition-name candidates; they do not identify a server, configured destination or transfer.
- **CuteFTP**: Client product-name candidate. Verify installed version and vendor lifecycle independently before interpreting support or risk.
- **Transmit**: Mac file-transfer client candidate; product/version suffixes and account destinations are outside the exact label match.
- **ForkLift**: File manager and transfer client candidate. Local file-manager use does not establish remote transfer activity.
- **Mountain Duck**: Remote storage mounting client; a reported name does not establish a mounted destination or synchronized content.
- **FreeFileSync**: Synchronization/backup utility candidate. Local synchronization is a legitimate use; the label does not imply exfiltration.
- **SecureFX**: Transfer client distinct from SecureCRT. Bundled installations and actual protocol/destination use require corroboration.
- **FileZilla Server**: A separate server record, never a FileZilla Client alias. Presence does not prove the service is running, exposed or transferring files.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
