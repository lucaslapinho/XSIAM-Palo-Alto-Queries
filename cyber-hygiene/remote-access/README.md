# Remote Access / Remote Administration

[Open query](detect-remote-access-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **6 products / 12 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| AnyDesk | `anydesk` | `anydesk` | [Inherited candidate](https://anydesk.com/) |
| RealVNC Connect | `realvnc-connect` | `realvnc connect`; `realvnc server`; `realvnc viewer` | [Inherited candidate](https://www.realvnc.com/en/connect/) |
| RustDesk | `rustdesk` | `rustdesk` | [Inherited candidate](https://rustdesk.com/) |
| ScreenConnect | `screenconnect` | `connectwise control`; `screenconnect`; `screenconnect client` | [Inherited candidate](https://www.screenconnect.com/) |
| Splashtop Streamer | `splashtop-streamer` | `splashtop streamer` | [Product-name candidate](https://www.splashtop.com/downloads) |
| TeamViewer Remote | `teamviewer` | `teamviewer`; `teamviewer host`; `teamviewer quicksupport` | [Inherited candidate](https://www.teamviewer.com/en/products/remote/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Support and administration; review access ownership, unattended access, authentication and session logging.

Added a distinct Splashtop Streamer candidate. Operator apps, host services and custom tenant-branded ScreenConnect clients need separate identities. Whole-name filters intentionally miss customer-specific names; avoid generic remote or control substrings.

- **Splashtop Streamer**: Streamer and operator-side Business App are distinct components. Do not infer an active remote session.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
