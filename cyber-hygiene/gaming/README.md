# Gaming Platforms

[Open query](detect-gaming-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **6 products / 7 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Battle.net | `battle-net` | `battle.net`; `blizzard battle.net` | [Inherited candidate](https://download.battle.net/) |
| EA app | `ea-app` | `ea app` | [Product-name candidate](https://www.ea.com/ea-app) |
| Epic Games Launcher | `epic-games-launcher` | `epic games launcher` | [Inherited candidate](https://store.epicgames.com/download) |
| GOG GALAXY | `gog-galaxy` | `gog galaxy` | [Inherited candidate](https://www.gog.com/galaxy) |
| Steam | `steam` | `steam` | [Inherited candidate](https://store.steampowered.com/about/) |
| Ubisoft Connect | `ubisoft-connect` | `ubisoft connect` | [Product-name candidate](https://www.ubisoft.com/en-us/ubisoft-connect) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Gaming and distribution; assess business justification, background updates and resource consumption.

Added Ubisoft Connect and EA app. Generic EA and historical Origin aliases are not automatically enabled. Launchers, individual games and web/cloud gaming have different coverage; a legitimate inventory match is not a policy violation.

- **Ubisoft Connect**: Launcher presence is not proof a game ran or that corporate policy prohibits it.
- **EA app**: Do not enable the generic string EA or treat historical Origin as an automatic alias.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
