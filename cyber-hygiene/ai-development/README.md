# AI Development Tools

[Open query](detect-ai-development-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **5 products / 6 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Aider | `aider` | `aider` | [Inherited candidate](https://aider.chat/) |
| Claude Code | `claude-code` | `claude code` | [Inherited candidate](https://code.claude.com/docs/en/overview) |
| Continue | `continue` | `continue` | [Inherited candidate](https://www.continue.dev/) |
| Cursor | `cursor` | `cursor` | [Inherited candidate](https://cursor.com/) |
| Windsurf / Devin Desktop family | `windsurf-devin-desktop` | `devin desktop`; `windsurf` | [Documented rename candidate](https://devin.ai/download) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

AI-assisted engineering; review repository access, generated changes, agent privileges and data handling.

Added the vendor-documented Windsurf/Devin Desktop rename as one candidate family. Copilot and other IDE extensions need an extension inventory surface; installing an IDE does not establish an assistant is enabled or repository content was uploaded.

- **Windsurf / Devin Desktop family**: The current download page explicitly describes the Windsurf-to-Devin Desktop rename. Neither label is a tenant observation; do not match generic Devin or IDE plugins.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
