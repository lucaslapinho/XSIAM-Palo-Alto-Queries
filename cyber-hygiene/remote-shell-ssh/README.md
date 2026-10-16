# Remote Shell / SSH Tools

[Open query](detect-remote-shell-ssh-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **4 products / 8 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case |
|---|---|---|
| MobaXterm | `mobaxterm` | `mobaxterm`; `mobaxterm personal edition`; `mobaxterm professional edition` |
| OpenSSH | `openssh` | `openssh`; `openssh client`; `openssh server` |
| PuTTY | `putty` | `putty` |
| Termius | `termius` | `termius` |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

## Review focus

Remote command access; review keys, server trust, session destinations and forwarding configuration.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
