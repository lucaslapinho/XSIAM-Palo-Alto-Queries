# Local AI / LLM Runtimes

[Open query](detect-local-ai-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **13 product/family candidates / 15 labels**.

Related coverage: [Jan, AnythingLLM and multi-provider assistants](../ai-tools/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Alpaca | `alpaca` | `alpaca` | [Product-name candidate](https://jeffser.com/alpaca/) |
| Backyard AI / Faraday legacy desktop family | `backyard-ai-legacy` | `backyard ai`; `faraday` | [Documented rename candidate](https://desktop.backyard.ai/) |
| ComfyUI / Comfy Desktop family | `comfyui-desktop` | `comfy desktop`; `comfyui` | [Product-name candidate](https://comfy.org/download) |
| FreeChat | `freechat` | `freechat` | [Product-name candidate](https://github.com/psugihara/FreeChat) |
| GPT4All | `gpt4all` | `gpt4all` | [Inherited candidate](https://www.nomic.ai/gpt4all) |
| llama.cpp | `llama-cpp` | `llama.cpp` | [Inherited candidate](https://github.com/ggml-org/llama.cpp) |
| LM Studio | `lm-studio` | `lm studio` | [Inherited candidate](https://lmstudio.ai/docs/app) |
| Msty Studio | `msty-studio` | `msty studio` | [Product-name candidate](https://msty.ai/) |
| Ollama | `ollama` | `ollama` | [Inherited candidate](https://ollama.com/) |
| Pinokio | `pinokio` | `pinokio` | [Product-name candidate](https://pinokio.co/) |
| Private LLM | `private-llm` | `private llm` | [Product-name candidate](https://privatellm.app/en) |
| RecurseChat | `recursechat` | `recursechat` | [Product-name candidate](https://recurse.chat/) |
| Stability Matrix | `stability-matrix` | `stability matrix` | [Product-name candidate](https://github.com/LykosAI/StabilityMatrix) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Local model execution; review model provenance, resource use, listener exposure and optional cloud connections.

Expanded chat clients, AI workflow desktops and package/launcher managers. Local-capable software can use remote services; presence does not prove local-only inference, GPU activity, model files or generated output. Backyard AI desktop is explicitly deprecated by its current source, with Faraday retained as a documented historical rename. LocalAI/vLLM containers and Python packages still need a different collection surface.

- **Msty Studio**: A desktop workspace can use local or remote models; presence does not establish where prompts or inference went.
- **ComfyUI / Comfy Desktop family**: Native desktop and engine product-name candidates. Portable/Python installs can be absent; local-capable software does not prove local-only inference.
- **Pinokio**: AI application/automation launcher candidate. Installed child applications, model weights and executed workflows require separate evidence.
- **Backyard AI / Faraday legacy desktop family**: DEPRECATED: the current vendor page says the desktop app is no longer supported. The vendor's 2024 rebranding post links Faraday and Backyard AI. These legacy candidates support inventory review, not a claim of current support. [Additional primary source](https://backyard.ai/blog/rebranding-to-backyard).
- **RecurseChat**: Native client candidate. Presence does not establish which model, data source or inference endpoint was used.
- **FreeChat**: First-party project documents a macOS chat app. The name can be reused by other apps; verify package/publisher identity.
- **Private LLM**: Mac/mobile product-name candidate; no inference-location, offline-state or prompt-handling observation follows from inventory.
- **Alpaca**: Linux desktop client candidate. This short name can be shared by unrelated software; model/runtime dependencies need separate inspection.
- **Stability Matrix**: AI package/launcher manager candidate. It does not enumerate installed engines, model files, GPU use or generated content.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
