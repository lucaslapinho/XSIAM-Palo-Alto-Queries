# Gaming Platforms

[Open query](detect-gaming-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **15 product/family candidates / 16 labels**.

Related coverage: [Parsec and other remote-access tools](../remote-access/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Battle.net | `battle-net` | `battle.net`; `blizzard battle.net` | [Inherited candidate](https://download.battle.net/) |
| EA app | `ea-app` | `ea app` | [Product-name candidate](https://www.ea.com/ea-app) |
| Epic Games Launcher | `epic-games-launcher` | `epic games launcher` | [Inherited candidate](https://store.epicgames.com/download) |
| GOG GALAXY | `gog-galaxy` | `gog galaxy` | [Inherited candidate](https://www.gog.com/galaxy) |
| Heroic Games Launcher | `heroic-games-launcher` | `heroic games launcher` | [Product-name candidate](https://heroicgameslauncher.com/) |
| itch desktop app | `itch-desktop` | `itch` | [Product-name candidate](https://itch.io/app) |
| Lutris | `lutris` | `lutris` | [Product-name candidate](https://lutris.net/) |
| Moonlight streaming client | `moonlight-streaming` | `moonlight` | [Product-name candidate](https://moonlight-stream.org/) |
| Playnite | `playnite` | `playnite` | [Product-name candidate](https://playnite.link/) |
| Prism Launcher | `prism-launcher` | `prism launcher` | [Product-name candidate](https://prismlauncher.org/) |
| Riot Client | `riot-client` | `riot client` | [Product-name candidate](https://support.riotgames.com/en-us/riot/account/logging-into-the-riot-client-with-a-qr-code) |
| Rockstar Games Launcher | `rockstar-games-launcher` | `rockstar games launcher` | [Product-name candidate](https://support.rockstargames.com/articles/4extB4aITvMKdDEZzsFAwE/rockstar-games-launcher-download) |
| Steam | `steam` | `steam` | [Inherited candidate](https://store.steampowered.com/about/) |
| Sunshine streaming host | `sunshine-streaming-host` | `sunshine` | [Product-name candidate](https://docs.lizardbyte.dev/projects/sunshine/latest/md_docs_2getting__started.html) |
| Ubisoft Connect | `ubisoft-connect` | `ubisoft connect` | [Product-name candidate](https://www.ubisoft.com/en-us/ubisoft-connect) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames, upstream packaging names, community manifest declarations and inherited entries. A configured packaging name is not an observed installed label; a community manifest is not a vendor assertion. Every enabled name remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Gaming and distribution; assess business justification, background updates and resource consumption.

Expanded launchers and library managers across desktop platforms. Do not infer Riot Vanguard or individual games from Riot Client. Portable launchers, managed instances, web/cloud gaming and per-user packaging are coverage gaps. A launcher match is not gameplay or a corporate policy violation.

Source-backed follow-up adds the Moonlight streaming client and Sunshine streaming host. These are not game launchers; client, host, listener, pairing and active streaming need separate evidence. Ludusavi remains deferred as portable backup tooling rather than a presumed installed-app entry.

- **Ubisoft Connect**: Launcher presence is not proof a game ran or that corporate policy prohibits it.
- **EA app**: Do not enable the generic string EA or treat historical Origin as an automatic alias.
- **Riot Client**: PC/Mac client candidate. Do not equate it with Riot Vanguard, Riot Mobile or individual games.
- **Rockstar Games Launcher**: Launcher name is documented by vendor support. It does not establish game execution or account ownership.
- **itch desktop app**: Desktop distribution is documented. The short brand label needs identity corroboration; web access is a separate coverage surface.
- **Heroic Games Launcher**: Third-party launcher candidate. It does not prove a particular store account, game installation or execution.
- **Lutris**: Linux game-management platform candidate; runners and games are not enumerated by this application label.
- **Playnite**: Library-manager candidate; portable mode can leave no installed-app entry. A library listing is not gameplay evidence.
- **Prism Launcher**: Minecraft launcher candidate; managed game instances and modpacks are not automatically separate inventory records.
- **Moonlight streaming client**: The first-party project describes the game-streaming client and the pinned WinGet manifest supplies a Windows installer. The sampled manifest does not declare DisplayName. Moonlight is a client, not a launcher or the Sunshine host; installation is neither gameplay nor an active streaming session. [Additional reference](https://github.com/microsoft/winget-pkgs/blob/7e1c45b2bf03d0c8ef7547a92822d1ef7c9def44/manifests/m/MoonlightGameStreamingProject/Moonlight/6.2.0.0/MoonlightGameStreamingProject.Moonlight.installer.yaml).
- **Sunshine streaming host**: Upstream getting-started material and a pinned Windows MSI distribution support the host product-name candidate. Gaming is its primary review category, with remote-access context cross-linked. Presence does not establish a running service, listener, network exposure, pairing or approval. [Additional reference](https://github.com/microsoft/winget-pkgs/blob/7e1c45b2bf03d0c8ef7547a92822d1ef7c9def44/manifests/l/LizardByte/Sunshine/2026.914.233613/LizardByte.Sunshine.installer.yaml).

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
