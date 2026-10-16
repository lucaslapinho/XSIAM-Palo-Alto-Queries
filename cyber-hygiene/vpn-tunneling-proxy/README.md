# VPN / Tunneling / Proxy

[Open query](detect-vpn-tunneling-proxy-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **8 products / 11 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| Cisco Secure Client | `cisco-secure-client` | `cisco anyconnect secure mobility client`; `cisco secure client` | [Inherited candidate](https://www.cisco.com/site/us/en/products/security/secure-client/index.html) |
| Cloudflare WARP / One Client family | `cloudflare-warp` | `cloudflare warp`; `cloudflare-warp` | [Product-name candidate](https://developers.cloudflare.com/warp-client/get-started/) |
| FortiClient family | `forticlient` | `forticlient`; `forticlient vpn` | [Product-name candidate](https://www.fortinet.com/support/product-downloads) |
| GlobalProtect | `globalprotect` | `globalprotect` | [Inherited candidate](https://www.paloaltonetworks.com/sase/globalprotect) |
| ngrok | `ngrok` | `ngrok` | [Inherited candidate](https://ngrok.com/) |
| OpenVPN Connect | `openvpn-connect` | `openvpn connect` | [Inherited candidate](https://openvpn.net/client/) |
| Tailscale | `tailscale` | `tailscale` | [Inherited candidate](https://tailscale.com/) |
| WireGuard | `wireguard` | `wireguard` | [Inherited candidate](https://www.wireguard.com/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Connectivity and routing; review approved destinations, split tunneling and network-control requirements.

Added FortiClient and Cloudflare candidates, including a documented Linux package name. Vendor suites have optional capabilities. A label does not identify configured routes, tenant enrollment, an active tunnel or bypass activity; generic VPN/proxy strings stay disabled.

- **FortiClient family**: FortiClient has VPN-only, ZTNA and EPP editions. A family label does not prove a configured or active VPN.
- **Cloudflare WARP / One Client family**: The vendor documents cloudflare-warp as a Linux package; display-name normalization and consumer versus Zero Trust enrollment remain unknown.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
