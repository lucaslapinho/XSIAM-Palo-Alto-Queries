# Communication / Messaging

[Open query](detect-messaging-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **6 products / 8 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Discord | `discord` | `discord` | [Inherited candidate](https://discord.com/) |
| Microsoft Teams | `microsoft-teams` | `microsoft teams`; `microsoft teams classic` | [Inherited candidate](https://www.microsoft.com/en-us/microsoft-teams/group-chat-software) |
| Signal Desktop | `signal-desktop` | `signal`; `signal desktop` | [Inherited candidate](https://signal.org/download/) |
| Slack | `slack` | `slack` | [Inherited candidate](https://slack.com/) |
| Telegram Desktop | `telegram-desktop` | `telegram desktop` | [Inherited candidate](https://desktop.telegram.org/) |
| Zoom Workplace | `zoom-workplace` | `zoom workplace` | [Product-name candidate](https://www.zoom.com/en/products/collaboration-tools/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Messaging and meetings; review external participants, retention, file sharing and organizational tenancy.

Added Zoom Workplace. Classic Teams, VDI add-ins, machine-wide installers, web clients and per-user clients require separate handling. Current names do not automatically authorize historical brand aliases or prove account tenancy.

- **Zoom Workplace**: Legacy Zoom labels and VDI plugins need separate evidence. Presence does not identify a meeting or account tenancy.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
