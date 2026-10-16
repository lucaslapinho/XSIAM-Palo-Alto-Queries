# Development Tools / IDEs

[Open query](detect-development-ides-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **6 product/family candidates / 12 labels**.



## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Android Studio | `android-studio` | `android studio` | [Product-name candidate](https://developer.android.com/studio) |
| IntelliJ IDEA | `intellij-idea` | `intellij idea`; `intellij idea community edition`; `intellij idea ultimate edition` | [Inherited candidate](https://www.jetbrains.com/idea/) |
| PyCharm | `pycharm` | `pycharm`; `pycharm community edition`; `pycharm professional edition` | [Inherited candidate](https://www.jetbrains.com/pycharm/) |
| Sublime Text | `sublime-text` | `sublime text` | [Inherited candidate](https://www.sublimetext.com/) |
| Visual Studio Code | `visual-studio-code` | `microsoft visual studio code`; `visual studio code` | [Inherited candidate](https://code.visualstudio.com/) |
| VSCodium | `vscodium` | `vscodium`; `vscodium (user)` | [Product-name candidate](https://vscodium.com/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames, upstream packaging names, community manifest declarations and inherited entries. A configured packaging name is not an observed installed label; a community manifest is not a vendor assertion. Every enabled name remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Software engineering; review extensions, supported versions, code trust and approved development scope.

Added Android Studio. Versioned product editions, per-user installers and portable/Toolbox-managed copies can use different labels. Do not infer extensions, AI feature activation, SDKs or execution from IDE presence.

Source-backed follow-up adds VSCodium as a desktop editor, not an automatic AI tool. VSCodium is a first-party product-name candidate; VSCodium (User) is also a manifest-declared per-user variant. An editor match does not establish installed extensions, AI use or corporate approval.

- **Android Studio**: The IDE does not prove emulator use, Gemini activation or a particular SDK installation.
- **VSCodium**: VSCodium is a first-party distribution-name candidate; VSCodium (User) is additionally declared by the pinned WinGet user-scope installer entries. Neither was observed in Cortex. Machine, portable and per-user installs can have different names; this editor is not automatically an AI tool or proof of any extension. [Additional reference](https://github.com/microsoft/winget-pkgs/blob/7e1c45b2bf03d0c8ef7547a92822d1ef7c9def44/manifests/v/VSCodium/VSCodium/1.140.06880/VSCodium.VSCodium.installer.yaml).

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
