# EDR / Endpoint Security

[Open query](detect-endpoint-security-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **8 products / 9 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Bitdefender Endpoint Security Tools | `bitdefender-best` | `bitdefender endpoint security tools` | [Product-name candidate](https://www.bitdefender.com/business/support/en/77211-376358-security-agents.html) |
| Cortex XDR Agent | `cortex-xdr-agent` | `cortex xdr`; `cortex xdr agent` | [Inherited candidate](https://www.paloaltonetworks.com/cortex/cortex-xdr) |
| CrowdStrike Falcon Sensor | `crowdstrike-falcon-sensor` | `crowdstrike falcon sensor` | [Inherited candidate](https://www.crowdstrike.com/en-us/platform/endpoint-security/) |
| Elastic Agent | `elastic-agent` | `elastic agent` | [Product-name candidate](https://www.elastic.co/docs/reference/fleet/install-elastic-agents) |
| Microsoft Defender for Endpoint | `microsoft-defender-endpoint` | `microsoft defender for endpoint` | [Inherited candidate](https://www.microsoft.com/en-us/security/business/endpoint-security/microsoft-defender-endpoint) |
| SentinelOne Agent | `sentinelone-agent` | `sentinelone agent` | [Inherited candidate](https://www.sentinelone.com/platform/) |
| Sophos Endpoint Agent | `sophos-endpoint-agent` | `sophos endpoint agent` | [Product-name candidate](https://docs.sophos.com/central/customer/help/en-us/ManageYourProducts/MDR/MDRSettings/installAgents/InstallMDRWindows/index.html) |
| Symantec Endpoint Protection | `symantec-endpoint-protection` | `symantec endpoint protection` | [Product-name candidate](https://knowledge.broadcom.com/external/article/156148/uninstall-symantec-endpoint-protection.html) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Endpoint protection and response; installation does not establish sensor health, enrollment or coverage.

Separate protection clients, management agents, sensor-only modes and activated modules. BEST, Sophos and Elastic Agent illustrate why installation is not proof that EDR is enabled. Trellix/Apex One names remain deferred pending a sufficiently specific component/installed-label source.

- **Bitdefender Endpoint Security Tools**: BEST is an endpoint agent. EDR activation and licensed modules must be verified separately.
- **Sophos Endpoint Agent**: Sophos agent installation does not establish the selected Endpoint, XDR, sensor-only or MDR mode.
- **Symantec Endpoint Protection**: Match the client family, not Endpoint Protection Manager. Managed state and component activation remain unknown.
- **Elastic Agent**: A general Elastic Agent installation does not prove the Elastic Defend integration or endpoint protection is enabled.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
