# Virtualization

[Open query](detect-virtualization-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **5 products / 7 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Oracle VirtualBox | `virtualbox` | `oracle virtualbox`; `oracle vm virtualbox` | [Inherited candidate](https://www.oracle.com/virtualization/virtualbox/) |
| Parallels Desktop | `parallels-desktop` | `parallels desktop` | [Inherited candidate](https://www.parallels.com/products/desktop/) |
| QEMU | `qemu` | `qemu` | [Inherited candidate](https://www.qemu.org/) |
| VMware Fusion | `vmware-fusion` | `vmware fusion` | [Product-name candidate](https://knowledge.broadcom.com/external/article/368734/support.broadcom.com) |
| VMware Workstation Pro | `vmware-workstation` | `vmware workstation`; `vmware workstation pro` | [Inherited candidate](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Guest environments; review guest patching, virtual networking, images and asset visibility.

Added VMware Fusion with current vendor download guidance. Hyper-V/WSL are OS features rather than guaranteed application entries. Guest images, running VMs and guest-installed software require separate collection.

- **VMware Fusion**: Host application presence says nothing about guest inventory or running virtual machines.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
