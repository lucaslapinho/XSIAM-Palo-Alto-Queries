# Remote Access / Remote Administration

[Open query](detect-remote-access-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **18 product/family candidates / 27 labels**.

Related coverage: [remote shell / SSH clients](../remote-shell-ssh/README.md).

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| AnyDesk | `anydesk` | `anydesk` | [Inherited candidate](https://anydesk.com/) |
| DWAgent | `dwagent` | `dwagent` | [Product-name candidate](https://docs.dwservice.net/docs/site/basic-definitions/install-the-agent/) |
| HopToDesk | `hoptodesk` | `hoptodesk` | [Community manifest app label](https://github.com/microsoft/winget-pkgs/blob/7e1c45b2bf03d0c8ef7547a92822d1ef7c9def44/manifests/h/HopToDesk/HopToDesk/1.46.55/HopToDesk.HopToDesk.installer.yaml) |
| LogMeIn Resolve / GoTo Resolve family | `logmein-resolve` | `goto resolve`; `logmein resolve` | [Documented rename candidate](https://www.logmein.com/products/resolve) |
| MeshCentral Agent family | `meshcentral-agent` | `meshagent`; `meshcentral agent` | [Product-name candidate](https://github.com/Ylianst/MeshAgent) |
| mRemoteNG | `mremoteng` | `mremoteng` | [Product-name candidate](https://github.com/mRemoteNG/mRemoteNG/blob/7a6dda4b1ede0120039a09d1b1c8bd0c00a9baab/README.md) |
| NoMachine | `nomachine` | `nomachine` | [Product-name candidate](https://download.nomachine.com/) |
| Parsec | `parsec` | `parsec` | [Product-name candidate](https://parsec.app/downloads) |
| RealVNC Connect | `realvnc-connect` | `realvnc connect`; `realvnc server`; `realvnc viewer` | [Inherited candidate](https://www.realvnc.com/en/connect/) |
| Remote Utilities Host / Viewer family | `remote-utilities` | `remote utilities host`; `remote utilities viewer` | [Product-name candidate](https://www.remoteutilities.com/download/) |
| RustDesk | `rustdesk` | `rustdesk` | [Inherited candidate](https://rustdesk.com/) |
| ScreenConnect | `screenconnect` | `connectwise control`; `screenconnect`; `screenconnect client` | [Inherited candidate](https://www.screenconnect.com/) |
| Splashtop Streamer | `splashtop-streamer` | `splashtop streamer` | [Product-name candidate](https://www.splashtop.com/downloads) |
| TeamViewer Remote | `teamviewer` | `teamviewer`; `teamviewer host`; `teamviewer quicksupport` | [Inherited candidate](https://www.teamviewer.com/en/products/remote/) |
| TightVNC | `tightvnc` | `tightvnc` | [Product-name candidate](https://www.tightvnc.com/download/) |
| UltraVNC | `ultravnc` | `ultravnc` | [Product-name candidate](https://uvnc.com/) |
| Veyon | `veyon` | `veyon` | [Product-name candidate](https://docs.veyon.io/en/latest/admin/installation.html) |
| Zoho Assist | `zoho-assist` | `zoho assist` | [Product-name candidate](https://www.zoho.com/assist/unattended-remote-access.html) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, package/CLI identifiers, vendor-installed-app labels, documented renames, upstream packaging names, community manifest declarations and inherited entries. A configured packaging name is not an observed installed label; a community manifest is not a vendor assertion. Every enabled name remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Support and administration; review access ownership, unattended access, authentication and session logging.

Expanded VNC families, support agents, remote desktops and endpoint-management families. Host, Viewer, server and run-only modes have distinct semantics; the name match does not establish an active listener or session. Custom MeshCentral/ScreenConnect branding, transient agents and operator web clients remain gaps. No generic remote, agent, host, viewer or VNC substring is enabled.

Source-backed follow-up adds manifest-declared HopToDesk, first-party mRemoteNG desktop distribution and Veyon classroom-management candidates. Viewer, host, unattended service, support session and classroom roles remain distinct. Discovery-only gateways/RMM metadata and the Tabby basename collision are not promoted.

- **Splashtop Streamer**: Streamer and operator-side Business App are distinct components. Do not infer an active remote session.
- **NoMachine**: Remote desktop family candidate; client/server role, service state and active sessions remain unknown.
- **TightVNC**: VNC package candidate; server/viewer component selection, listener exposure and connections require separate evidence.
- **UltraVNC**: VNC family candidate. Do not use generic VNC substring matching or infer an installed component is active.
- **DWAgent**: Vendor docs distinguish Run and Install modes. Run-only copies can have no installed-app entry; no remote session or approval is established.
- **MeshCentral Agent family**: Agent project-name candidates. Custom branding and installed-name suffixes are intentionally not guessed; the MeshCentral web server is a different component.
- **Parsec**: Remote-access client/host family candidate; game-related use does not change primary category or establish an active session.
- **Zoho Assist**: Support/unattended-access family candidate. Technician web use, custom agent packages and run-only sessions may be absent.
- **LogMeIn Resolve / GoTo Resolve family**: The vendor explicitly links the old and new names. Endpoint-management presence does not prove every optional remote-access capability is enabled.
- **Remote Utilities Host / Viewer family**: Vendor docs distinguish Host, Viewer and run-only Agent. Whole product-name candidates do not establish their installed display strings; generic Host/Viewer/Agent labels are excluded.
- **HopToDesk**: Pinned WinGet AppsAndFeaturesEntries explicitly declares HopToDesk and its publisher for version 1.46.55. This is a community manifest assertion, not a vendor or Cortex observation. Portable copies can leave no application entry; no unattended service, connection or approval is inferred. [Additional reference](https://www.hoptodesk.com/).
- **mRemoteNG**: The first-party project and a pinned MSI distribution support this desktop connection-manager candidate. No AppsAndFeatures DisplayName was declared in the sampled manifest. Connection-manager presence does not establish an installed server, listener or remote session. [Additional reference](https://github.com/microsoft/winget-pkgs/blob/7e1c45b2bf03d0c8ef7547a92822d1ef7c9def44/manifests/m/mRemoteNG/mRemoteNG/1.76.20.24615/mRemoteNG.mRemoteNG.installer.yaml).
- **Veyon**: First-party installation guidance describes the computer-monitoring/classroom-management package. The whole product name is a candidate, not a captured uninstall label. Component selection, service state, teacher/student role and authorized classroom scope remain separate questions.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
