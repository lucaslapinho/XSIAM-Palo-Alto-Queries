# Browsers

[Open query](detect-browsers-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **16 product/family candidates / 19 labels**.

Related coverage: [Tor Browser and Mullvad Browser](../privacy-anonymization/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Arc browser | `arc-browser` | `arc` | [Product-name candidate](https://arc.net/download) |
| Brave Browser | `brave-browser` | `brave`; `brave browser` | [Inherited candidate](https://brave.com/) |
| Chromium | `chromium` | `chromium` | [Product-name candidate](https://www.chromium.org/getting-involved/download-chromium/) |
| Comet browser | `comet-browser` | `comet` | [Product-name candidate](https://www.perplexity.ai/comet) |
| Dia browser | `dia-browser` | `dia` | [Product-name candidate](https://www.diabrowser.com/) |
| DuckDuckGo browser | `duckduckgo-browser` | `duckduckgo` | [Product-name candidate](https://duckduckgo.com/app) |
| Floorp | `floorp` | `floorp` | [Product-name candidate](https://floorp.app/download) |
| Google Chrome | `google-chrome` | `google chrome` | [Inherited candidate](https://www.google.com/chrome/) |
| LibreWolf | `librewolf` | `librewolf` | [Product-name candidate](https://librewolf.net/installation/) |
| Microsoft Edge | `microsoft-edge` | `microsoft edge` | [Inherited candidate](https://www.microsoft.com/en-us/edge) |
| Mozilla Firefox | `mozilla-firefox` | `firefox`; `mozilla firefox` | [Inherited candidate](https://www.mozilla.org/firefox/) |
| Opera browser family | `opera-browser` | `opera`; `opera gx` | [Product-name candidate](https://www.opera.com/download) |
| Safari | `apple-safari` | `safari` | [Product-name candidate](https://support.apple.com/en-us/102665) |
| Vivaldi | `vivaldi` | `vivaldi` | [Product-name candidate](https://vivaldi.com/) |
| Waterfox | `waterfox` | `waterfox` | [Product-name candidate](https://www.waterfox.com/download/) |
| Zen Browser | `zen-browser` | `zen browser` | [Product-name candidate](https://zen-browser.app/download/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Web access; review update ownership, extensions, profile management and enterprise configuration.

Expanded browser families, including AI-capable browsers. Safari can be OS-bundled; Chromium and portable builds can lack app entries. Tor Browser and Mullvad Browser retain primary ownership in privacy-anonymization. Short labels such as Arc, Dia and Comet require identity corroboration; bare Zen is deliberately held. Installation does not establish AI use, profiles, extensions or visited sites.

- **Vivaldi**: Profiles, extensions, managed enrollment and visited sites are outside application inventory.
- **Opera browser family**: Related browser editions share one review family. No generic opera substring or guessed version/channel suffix is enabled.
- **Chromium**: Development builds and portable archives may not register as installed apps. Chromium-based applications are not automatically Chromium browser matches.
- **Waterfox**: Native browser candidate; edition/version suffixes and portable copies need separate label evidence.
- **LibreWolf**: Distribution packages and portable copies differ; do not infer a profile, privacy configuration or browsing destination.
- **Floorp**: Browser family candidate. AI features, extensions and visited sites are not established by installation.
- **Zen Browser**: Only the full browser-name candidate is enabled. Bare Zen is held because it can name unrelated software; actual platform labels are still needed.
- **DuckDuckGo browser**: Desktop distribution is documented, but a matched brand label does not establish web search use or a specific app packaging channel.
- **Arc browser**: A short brand label needs corroboration. Check release/support status separately; a download page is not a maintenance guarantee.
- **Dia browser**: AI-capable browser candidate. A short label can be shared by unrelated software and does not prove assistant use.
- **Comet browser**: Browser product-name candidate, separate from the Perplexity desktop client. A short label does not authenticate identity or prove agent activity.
- **Safari**: Apple documents Safari as part of the OS update path. Built-in/system-app coverage varies; zero rows cannot establish Safari is absent.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
