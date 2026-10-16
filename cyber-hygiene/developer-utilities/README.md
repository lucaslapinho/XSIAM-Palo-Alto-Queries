# Developer Utilities

[Open query](detect-developer-utilities-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **5 products / 6 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Bruno | `bruno` | `bruno` | [Product-name candidate](https://www.usebruno.com/) |
| Git family | `git-for-windows` | `git`; `git for windows` | [Inherited candidate](https://gitforwindows.org/) |
| GitHub Desktop | `github-desktop` | `github desktop` | [Inherited candidate](https://desktop.github.com/) |
| Insomnia | `insomnia` | `insomnia` | [Inherited candidate](https://insomnia.rest/) |
| Postman | `postman` | `postman` | [Inherited candidate](https://www.postman.com/product/api-client/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Engineering support; review package provenance, credentials, API targets and update ownership.

Added Bruno. Existing Git for Windows labels include Git, which cannot prove Windows packaging or platform; the canonical display name is corrected to Git family while retaining the legacy ID. API clients do not establish requests or credential use.

- **Bruno**: API client presence does not establish a target API, secret exposure or request execution.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
