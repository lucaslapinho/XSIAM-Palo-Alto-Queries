# AI Development Tools

[Open query](detect-ai-development-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **12 product/family candidates / 16 labels**.

Related coverage: [general-purpose AI assistants](../ai-tools/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Aider | `aider` | `aider` | [Inherited candidate](https://aider.chat/) |
| Claude Code | `claude-code` | `claude code` | [Inherited candidate](https://code.claude.com/docs/en/overview) |
| Continue | `continue` | `continue` | [Inherited candidate](https://www.continue.dev/) |
| Cursor | `cursor` | `cursor` | [Inherited candidate](https://cursor.com/) |
| Google Antigravity | `google-antigravity` | `antigravity`; `google antigravity` | [Product-name candidate](https://antigravity.google/download) |
| Kiro | `kiro` | `kiro` | [Product-name candidate](https://kiro.dev/downloads/) |
| OpenAI Codex CLI | `openai-codex-cli` | `@openai/codex`; `codex cli` | [Package/CLI candidate](https://github.com/openai/codex) |
| OpenCode family | `opencode` | `opencode`; `opencode desktop` | [Product-name candidate](https://opencode.ai/download) |
| Qoder | `qoder` | `qoder` | [Product-name candidate](https://qoder.com/download) |
| TRAE | `trae` | `trae` | [Product-name candidate](https://www.trae.ai/download) |
| Windsurf / Devin Desktop family | `windsurf-devin-desktop` | `devin desktop`; `windsurf` | [Documented rename candidate](https://devin.ai/download) |
| Zed | `zed` | `zed` | [Product-name candidate](https://zed.dev/download) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

AI-assisted engineering; review repository access, generated changes, agent privileges and data handling.

Expanded standalone agent/editor clients plus a separately identified Codex CLI/package candidate. IDE extensions such as GitHub Copilot, Cline or Amazon Q are not inferred from the host editor. Zed can be used without AI; CLI/portable installations may produce no inventory row. Product installation is not repository access, prompt transmission or agent execution.

- **Windsurf / Devin Desktop family**: The current download page explicitly describes the Windsurf-to-Devin Desktop rename. Neither label is a tenant observation; do not match generic Devin or IDE plugins.
- **Kiro**: IDE product-name candidate. Installation does not prove a coding agent ran, credentials were used or source code was uploaded.
- **TRAE**: Standalone editor candidate; do not infer account tenancy, model provider or AI feature activation.
- **Qoder**: Desktop product-name candidate; web access and IDE integrations can have different inventory coverage.
- **Google Antigravity**: Two product-name forms are candidates, not observed display-name aliases. Neither establishes agent activity or repository access.
- **OpenCode family**: The vendor offers Desktop and CLI channels. A matched product label does not identify the channel; portable CLI copies can be absent.
- **OpenAI Codex CLI**: The first-party README documents Codex CLI and the @openai/codex npm package. A package identifier is not an application display name, and npm or standalone installs may produce no preset row. No separate Codex desktop-app coverage is claimed.
- **Zed**: AI-capable editor candidate. An installation can be used without AI; do not infer an enabled assistant or executed agent.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
