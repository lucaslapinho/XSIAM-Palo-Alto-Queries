# Artificial Intelligence Tools

[Open query](detect-ai-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **12 product/family candidates / 15 labels**.

Related coverage: [AI development clients](../ai-development/README.md) and [local AI tools](../local-ai/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| AnythingLLM Desktop | `anythingllm` | `anythingllm`; `anythingllm desktop` | [Inherited candidate](https://anythingllm.com/) |
| BoltAI | `boltai` | `boltai` | [Product-name candidate](https://boltai.com/) |
| Chatbox AI | `chatbox` | `chatbox`; `chatbox ai` | [Product-name candidate](https://chatboxai.app/en) |
| ChatGPT desktop app | `chatgpt-desktop` | `chatgpt` | [Inherited candidate](https://chatgpt.com/download/) |
| ChatWise | `chatwise` | `chatwise` | [Product-name candidate](https://chatwise.app/) |
| Cherry Studio | `cherry-studio` | `cherry studio` | [Product-name candidate](https://github.com/CherryHQ/cherry-studio) |
| Claude desktop app | `claude-desktop` | `claude` | [Inherited candidate](https://claude.com/download) |
| Jan | `jan` | `jan` | [Inherited candidate](https://jan.ai/) |
| Microsoft Copilot app family | `microsoft-copilot-app` | `microsoft 365 copilot`; `microsoft copilot` | [Documented rename candidate](https://support.microsoft.com/en-us/microsoft-365-copilot/what-is-microsoft-copilot-app) |
| MindMac | `mindmac` | `mindmac` | [Product-name candidate](https://mindmac.app/) |
| Perplexity desktop | `perplexity-desktop` | `perplexity` | [Product-name candidate](https://www.perplexity.ai/changelog/personal-computer-on-mac-launch-and-computer-updates---april-17-2026) |
| Poe desktop | `poe` | `poe` | [Product-name candidate](https://poe.com/download) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

AI assistance; review account tenancy, submitted data, retention and approved connectors.

Expanded native multi-provider assistants and the now-substantiated Perplexity desktop candidate. Microsoft documents a Copilot productivity-app rename; that app does not prove a paid AI entitlement. Cloud chat services, browser/PWA use, local clients and model providers are different surfaces; no generic Copilot or AI keyword match is enabled.

- **Microsoft Copilot app family**: Microsoft documents the Microsoft 365 Copilot app rename. This can identify a productivity shell, not a paid Copilot entitlement or AI use. Bare Copilot is excluded to avoid mixing unrelated assistants. [Additional primary source](https://support.microsoft.com/en-us/microsoft-365-copilot/access-microsoft-365-copilot-on-windows).
- **Poe desktop**: The official download page lists desktop distribution. A short brand label needs independent publisher/package corroboration.
- **Cherry Studio**: Desktop client candidate; model providers, connectors and submitted content are outside inventory evidence.
- **Chatbox AI**: Two product-name forms are candidates. Generic third-party clients can share labels; verify package/publisher identity.
- **ChatWise**: Native client presence does not identify which local or remote model was configured or used.
- **MindMac**: macOS client candidate; a product label does not establish API key ownership, account tenancy or prompt transmission.
- **BoltAI**: Native Mac client candidate; do not infer connector permissions, inference location or AI activity.
- **Perplexity desktop**: The official April 2026 changelog substantiates a Mac desktop app. The string remains an inventory candidate, not proof of native versus PWA packaging or feature availability. Comet has a separate browser record.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
