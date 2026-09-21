# Corporate Cyber Hygiene software taxonomy — Phase 3

Research cut: **2026-09-20**. The [machine-readable catalog](../catalog/software-catalog.yaml) contains **124 product records across all 30 requested categories**, scoped exclusively to Cyber Hygiene. Category assignments describe function and review context. They do not declare a product malicious, inherently unsafe, unauthorized, or universally inappropriate.

This phase follows [official XQL research](research/palo-alto-xql-research.md) and [reference repository analysis](research/reference-repository-analysis.md). It creates no XQL, alerts, policy enforcement, tenant bindings or deployment. The taxonomy is an authored research artifact; every proposed Cortex application display-name pattern remains **UNVERIFIED / TENANT-UNVERIFIED**.

## Identity, matching and policy are separate

A vendor or project page establishes product-family context. It does not establish the application's exact name in Cortex inventory, installed edition, legal publisher string, endpoint presence or organization approval. The catalog's `vendor` is a curated brand/project label for humans, not a vendor-field predicate or proof of present legal ownership. Source references were retrieved or attempted on the research date; vendor labels must be corroborated before operational identity matching.

There are 119 records with retrieved primary product/project references, four with limited public-page evidence (TikTok, Instagram, Facebook, CCleaner), and one whose primary-source retrieval failed (PuTTY). Retrieved titles/navigation suffice only as limited product-family references; they do not verify every component or alias listed. PuTTY is retained as an explicitly unresolved research candidate. No failed retrieval is treated as evidence of product absence or discontinuation.

All `application_name_patterns` are **candidate full-string, case-insensitive literals**. No wildcard, regex or substring semantics is implied. This deliberately avoids generic tokens such as `AI`, `VPN`, `remote`, `cloud`, `agent`, `security`, `IDM`, or a vendor brand used as a catch-all. Product names that are ordinary words, such as Cursor, Jan, Continue, Signal and Transmission, still need publisher/package corroboration even under exact comparison.

An identity candidate is not a confirmed identity. An approved corporate installation can be a correct inventory match; it must not be counted as a policy false positive until someone has incorrectly asserted a violation. `expected_false_positives` separates those two failure modes. `detection_confidence` describes qualitative name specificity only: LOW or MODERATE, with no measured accuracy and no tenant validation. Neither level is a risk score.

`review_priority` is `POLICY_DEPENDENT_UNASSIGNED` throughout. Before prioritizing or calling anything shadow IT, bind organization policy to product/version, business purpose, asset group, user or service scope, account/workspace ownership, approver, effective period and exceptions. Missing policy is Unknown, not Denied. Antivirus and EDR records support management/coverage review; installation alone does not establish active protection or conflicting products.

## Requested category coverage

Counts use primary category only. Secondary memberships never create additional products.

| # | Stable category ID | Requested category | Products |
|---|---|---|---:|
| 1 | `penetration-testing` | Penetration Testing / Dual-Use Security Tools | 4 |
| 2 | `remote-access` | Remote Access / Remote Administration | 5 |
| 3 | `vpn-tunneling-proxy` | VPN / Tunneling / Proxy | 6 |
| 4 | `antivirus` | Antivirus | 4 |
| 5 | `endpoint-security` | EDR / Endpoint Security | 4 |
| 6 | `ai-tools` | Artificial Intelligence Tools | 4 |
| 7 | `ai-development` | AI Development Tools | 4 |
| 8 | `local-ai` | Local AI / LLM Runtimes | 4 |
| 9 | `development-ides` | Development Tools / IDEs | 4 |
| 10 | `developer-utilities` | Developer Utilities | 4 |
| 11 | `social-applications` | Social Applications | 4 |
| 12 | `messaging` | Communication / Messaging | 5 |
| 13 | `gaming` | Gaming Platforms | 4 |
| 14 | `cloud-storage` | Cloud Storage / File Synchronization | 4 |
| 15 | `file-transfer` | File Transfer Tools | 4 |
| 16 | `p2p-torrent` | P2P / Torrent | 4 |
| 17 | `browsers` | Browsers | 4 |
| 18 | `password-managers` | Password Managers | 4 |
| 19 | `virtualization` | Virtualization | 4 |
| 20 | `containers` | Containers | 4 |
| 21 | `network-utilities` | Network Utilities | 4 |
| 22 | `system-administration` | System Administration Tools | 4 |
| 23 | `database-clients` | Database Clients | 4 |
| 24 | `remote-shell-ssh` | Remote Shell / SSH Tools | 4 |
| 25 | `scripting-automation` | Scripting / Automation Tools | 4 |
| 26 | `screen-capture` | Screen Recording / Capture | 4 |
| 27 | `personal-collaboration` | Personal Collaboration Tools | 4 |
| 28 | `crypto-mining` | Crypto / Mining Tools | 4 |
| 29 | `privacy-anonymization` | Privacy / Anonymization Tools | 4 |
| 30 | `other-shadow-it` | Other Corporate-Risk / Shadow-IT Applications | 4 |
| | | **Total** | **124** |

The requested Other Corporate-Risk / Shadow-IT name is retained for traceability. Its four records have concrete subcategories: system optimization, software removal, download management and mobile-app emulation. It is never a fallback for unknown software. `UNMAPPED` is the correct outcome when no catalog record matches.

## Stable records and overlap

Each `product_id` is a stable slug independent of category and current marketing name. Never recycle an ID. Rename the canonical display label when evidence warrants it, retain useful historical names descriptively, and use a new record when product identity changes materially. Store merge/split decisions in a future change record before changing consumers.

One primary category supplies ownership and default navigation; `secondary_categories` expose relevant overlaps. Examples include:

- Tor Browser: primary privacy/anonymization; secondary browsers and VPN/tunneling/proxy.
- Nmap: primary assessment tools; secondary network utilities.
- Wireshark: primary network utilities; secondary assessment tools.
- Cursor: primary AI development; secondary IDEs.
- Jan and AnythingLLM: primary AI assistants; secondary local runtimes.
- Syncthing: primary synchronization; secondary P2P, without claiming it uses BitTorrent.
- BlueStacks: primary additional review candidates; secondary virtualization and gaming.
- WinSCP and MobaXterm: primary transfer and remote shell respectively, with explicitly related secondary views.

These memberships describe possible product functions, not use of those functions. Optional AI, VPN, sharing or remote-access features do not prove that the endpoint enabled or exercised them.

Maintain one product record even if several queries later reference it. A multi-category report may show the same product in multiple views; a fleet total must deduplicate by validated endpoint identity and product ID. Preserve raw rows for versions, editions and components before any product-level aggregation. Do not turn multiple inventory rows into multiple installations without an explicit grain.

If the same raw label matches different product IDs, return `AMBIGUOUS` plus every candidate. Do not use first-match category order. Additional publisher/package evidence can resolve a candidate only after that evidence and its fields have been validated. The initial exact-literal catalog has no cross-product literal collisions, but this is a maintainability property, not proof that name spoofing or real-world ambiguity is absent.

## Pattern contract

1. Compare the complete source string case-insensitively and preserve the original string as evidence. Missing, null and empty names remain unclassified. Do not silently convert null to a word or strip punctuation.
2. `alternate_names` documents marketing names, historical brands and package/executable aliases. It is **not** an enabled match list. For example, `pwsh`, `@anthropic-ai/claude-code`, `Traps` and `IDM` must not automatically become application-name patterns.
3. Exact literals intentionally miss unlisted version, locale, architecture, component and edition suffixes. A product-specific suffix rule may be added only with sanitized positive and negative samples, a documented grammar and verified target-language behavior.
4. Do not generalize a product into every record containing its vendor. Microsoft Edge WebView2 Runtime is not Microsoft Edge; FileZilla Server is not FileZilla Client; VirtualBox Guest Additions is not the host hypervisor.
5. A product reference is not an installer manifest or tenant observation. Record platform, packaging source, original display name, corroborating publisher/package identity, version and collection time when validating an actual label. No specific spelling of a Cortex publisher/vendor field is assumed here.
6. Keep the taxonomy independent of XQL syntax. A later implementation must explicitly map `equals_ci` to a supported operation on a validated string field, preserve ambiguity and null behavior, and follow the Phase 1 snapshot/schema contract.

Illustrative **authored fixtures**, not tenant observations or executed classifier results:

| Input label | Intended candidate result | Reason |
|---|---|---|
| Microsoft Edge | `microsoft-edge` | Exact proposed name; identity corroboration still required |
| Microsoft Edge WebView2 Runtime | UNMAPPED | Different component |
| GitHub Desktop | `github-desktop` | Never match the `Git` substring |
| Git | `git-for-windows`, low specificity | Requires Windows/package evidence; other platforms may represent a different packaging identity |
| PuTTY 0.83 (64-bit) | UNMAPPED | Suffix rule intentionally absent |
| Signal | `signal-desktop`, low specificity | Publisher/package required |
| Nmap security helper | UNMAPPED | Additional text is not an approved alias |
| empty / null | UNMAPPED | No usable application label |

## Inventory coverage and unresolved boundaries

Cortex inventory names were not sampled. The availability of the application preset does not prove complete coverage or validate endpoint/report fields. The Phase 1 full-snapshot, delta, latest-empty-report, retention, freshness and permission gaps still apply. A product absent from results may be absent, unregistered, embedded, stale, out of scope, or invisible to collection.

Application-name inventory is particularly incomplete for:

- Browser extensions and IDE plugins, including Continue; extensions require their own identity/collection contract.
- Standalone binaries, source builds and package environments, including ngrok, rclone, XMRig, llama.cpp, Aider and CLI coding agents.
- OS-integrated services and capabilities, including Defender for Endpoint and OpenSSH; installed-app absence is not lack of protection or remote-shell support.
- PWAs, web/mobile services and unofficial desktop wrappers, especially social platforms. Their entries are review candidates if an actual trusted inventory representation exists, not evidence that browser use can be discovered with application names.
- Embedded runtimes, models, guest operating systems and container images. Host software entries do not inventory every nested component.
- Rebranded clients and versioned editions. Preserve specific aliases with evidence rather than broadening the entire vendor family.

The [Continue project page](https://continue.dev/) reported acquisition by Cursor when reviewed. The catalog retains Continue for existing installations, with historical ownership context; it does not assume current support, a replacement package, or a shared identity with Cursor. [Ollama](https://ollama.com/) describes local and hosted model options, so its presence cannot establish offline-only processing. [LM Studio documentation](https://lmstudio.ai/docs/app) distinguishes desktop, headless and developer interfaces; these are coverage boundaries rather than proof of an enabled listener.

## Maintenance and validation

For each addition or change, record the product source and research date, product/component boundaries, proposed exact names, descriptive aliases, platform/packaging assumptions, negative lookalikes and category overlap. When a primary reference becomes unavailable, retain the retrieval gap instead of claiming the identity was revalidated. Reassess renamed products, ownership changes, edition transitions and retired clients during scheduled catalog review and whenever a new inventory label appears. No universal review interval or software approval baseline is imposed here.

A deployment-specific extension should record evidence separately from this public catalog: sanitized observed name, environment alias, collection date, collector/product version, source fields, identity corroboration, fixture outcomes, policy decision and owner. Avoid tenant identifiers, usernames or proprietary allowlists in the public catalog.

Validation performed for this artifact: YAML safe parsing and structural checks for required fields, unique product/category IDs, valid category references, nonempty exact-name candidates, duplicate cross-product literals, and complete 30-category coverage. These checks establish catalog integrity only. No XQL compiler, Cortex tenant, endpoint installation, runtime behavior, protection state, policy engine, detection rate or performance test was exercised.

| Evidence level | Phase 3 result |
|---|---|
| S — controlled static catalog validation | Structural checks performed; independent behavioral evaluation NOT RUN |
| D — documentation | Primary product references retrieved/attempted with recorded limits; Cortex display names UNVERIFIED |
| C — target schema/compiler | NOT RUN |
| E — tenant execution/results | NOT RUN |

## Product reference register

These are the same product-family references carried in the YAML. They support product discovery and maintenance; they do not certify exact installer names, publisher strings, category-exclusive behavior or current licensing. Category assignment and corporate review context are INFERRED editorial guidance.

### Penetration Testing / Dual-Use Security Tools

- `nmap` — [Nmap](https://nmap.org/); curated vendor/project label: Nmap Project.
- `burp-suite` — [Burp Suite](https://portswigger.net/burp); curated vendor/project label: PortSwigger.
- `metasploit-framework` — [Metasploit Framework](https://www.metasploit.com/); curated vendor/project label: Rapid7 / Metasploit contributors.
- `bloodhound-community` — [BloodHound Community Edition](https://bloodhound.specterops.io/); curated vendor/project label: SpecterOps.

### Remote Access / Remote Administration

- `teamviewer` — [TeamViewer Remote](https://www.teamviewer.com/en/products/remote/); curated vendor/project label: TeamViewer.
- `anydesk` — [AnyDesk](https://anydesk.com/); curated vendor/project label: AnyDesk Software.
- `rustdesk` — [RustDesk](https://rustdesk.com/); curated vendor/project label: RustDesk project.
- `screenconnect` — [ScreenConnect](https://www.screenconnect.com/); curated vendor/project label: ConnectWise.
- `realvnc-connect` — [RealVNC Connect](https://www.realvnc.com/en/connect/); curated vendor/project label: RealVNC.

### VPN / Tunneling / Proxy

- `globalprotect` — [GlobalProtect](https://www.paloaltonetworks.com/sase/globalprotect); curated vendor/project label: Palo Alto Networks.
- `cisco-secure-client` — [Cisco Secure Client](https://www.cisco.com/site/us/en/products/security/secure-client/index.html); curated vendor/project label: Cisco.
- `openvpn-connect` — [OpenVPN Connect](https://openvpn.net/client/); curated vendor/project label: OpenVPN.
- `wireguard` — [WireGuard](https://www.wireguard.com/); curated vendor/project label: WireGuard project.
- `tailscale` — [Tailscale](https://tailscale.com/); curated vendor/project label: Tailscale.
- `ngrok` — [ngrok](https://ngrok.com/); curated vendor/project label: ngrok.

### Antivirus

- `avast-free-antivirus` — [Avast Free Antivirus](https://www.avast.com/free-antivirus-download); curated vendor/project label: Avast / Gen Digital.
- `avg-antivirus-free` — [AVG AntiVirus FREE](https://www.avg.com/en-us/free-antivirus-download); curated vendor/project label: AVG / Gen Digital.
- `eset-nod32` — [ESET NOD32 Antivirus](https://www.eset.com/int/home/antivirus/); curated vendor/project label: ESET.
- `clamav` — [ClamAV](https://www.clamav.net/); curated vendor/project label: Cisco / ClamAV contributors.

### EDR / Endpoint Security

- `cortex-xdr-agent` — [Cortex XDR Agent](https://www.paloaltonetworks.com/cortex/cortex-xdr); curated vendor/project label: Palo Alto Networks.
- `crowdstrike-falcon-sensor` — [CrowdStrike Falcon Sensor](https://www.crowdstrike.com/en-us/platform/endpoint-security/); curated vendor/project label: CrowdStrike.
- `sentinelone-agent` — [SentinelOne Agent](https://www.sentinelone.com/platform/); curated vendor/project label: SentinelOne.
- `microsoft-defender-endpoint` — [Microsoft Defender for Endpoint](https://www.microsoft.com/en-us/security/business/endpoint-security/microsoft-defender-endpoint); curated vendor/project label: Microsoft.

### Artificial Intelligence Tools

- `chatgpt-desktop` — [ChatGPT desktop app](https://chatgpt.com/download/); curated vendor/project label: OpenAI.
- `claude-desktop` — [Claude desktop app](https://claude.com/download); curated vendor/project label: Anthropic.
- `jan` — [Jan](https://jan.ai/); curated vendor/project label: Jan project.
- `anythingllm` — [AnythingLLM Desktop](https://anythingllm.com/); curated vendor/project label: Mintplex Labs.

### AI Development Tools

- `cursor` — [Cursor](https://cursor.com/); curated vendor/project label: Anysphere.
- `claude-code` — [Claude Code](https://code.claude.com/docs/en/overview); curated vendor/project label: Anthropic.
- `continue` — [Continue](https://www.continue.dev/); curated vendor/project label: Continue Dev (historical); acquired by Cursor.
- `aider` — [Aider](https://aider.chat/); curated vendor/project label: Aider project.

### Local AI / LLM Runtimes

- `ollama` — [Ollama](https://ollama.com/); curated vendor/project label: Ollama.
- `lm-studio` — [LM Studio](https://lmstudio.ai/docs/app); curated vendor/project label: Element Labs.
- `gpt4all` — [GPT4All](https://www.nomic.ai/gpt4all); curated vendor/project label: Nomic AI.
- `llama-cpp` — [llama.cpp](https://github.com/ggml-org/llama.cpp); curated vendor/project label: ggml-org contributors.

### Development Tools / IDEs

- `visual-studio-code` — [Visual Studio Code](https://code.visualstudio.com/); curated vendor/project label: Microsoft.
- `intellij-idea` — [IntelliJ IDEA](https://www.jetbrains.com/idea/); curated vendor/project label: JetBrains.
- `pycharm` — [PyCharm](https://www.jetbrains.com/pycharm/); curated vendor/project label: JetBrains.
- `sublime-text` — [Sublime Text](https://www.sublimetext.com/); curated vendor/project label: Sublime HQ.

### Developer Utilities

- `git-for-windows` — [Git for Windows](https://gitforwindows.org/); curated vendor/project label: Git for Windows contributors.
- `postman` — [Postman](https://www.postman.com/product/api-client/); curated vendor/project label: Postman.
- `insomnia` — [Insomnia](https://insomnia.rest/); curated vendor/project label: Kong.
- `github-desktop` — [GitHub Desktop](https://desktop.github.com/); curated vendor/project label: GitHub / Microsoft.

### Social Applications

- `reddit` — [Reddit](https://www.redditinc.com/); curated vendor/project label: Reddit.
- `tiktok` — [TikTok](https://www.tiktok.com/); curated vendor/project label: TikTok.
- `instagram` — [Instagram](https://about.instagram.com/); curated vendor/project label: Meta.
- `facebook` — [Facebook](https://www.facebook.com/); curated vendor/project label: Meta.

### Communication / Messaging

- `microsoft-teams` — [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-teams/group-chat-software); curated vendor/project label: Microsoft.
- `slack` — [Slack](https://slack.com/); curated vendor/project label: Slack / Salesforce.
- `signal-desktop` — [Signal Desktop](https://signal.org/download/); curated vendor/project label: Signal Messenger.
- `telegram-desktop` — [Telegram Desktop](https://desktop.telegram.org/); curated vendor/project label: Telegram.
- `discord` — [Discord](https://discord.com/); curated vendor/project label: Discord.

### Gaming Platforms

- `steam` — [Steam](https://store.steampowered.com/about/); curated vendor/project label: Valve.
- `epic-games-launcher` — [Epic Games Launcher](https://store.epicgames.com/download); curated vendor/project label: Epic Games.
- `gog-galaxy` — [GOG GALAXY](https://www.gog.com/galaxy); curated vendor/project label: GOG.
- `battle-net` — [Battle.net](https://download.battle.net/); curated vendor/project label: Blizzard Entertainment.

### Cloud Storage / File Synchronization

- `onedrive` — [Microsoft OneDrive](https://www.microsoft.com/en-us/microsoft-365/onedrive/online-cloud-storage); curated vendor/project label: Microsoft.
- `google-drive-desktop` — [Google Drive for desktop](https://www.google.com/drive/download/); curated vendor/project label: Google.
- `dropbox` — [Dropbox desktop app](https://www.dropbox.com/desktop); curated vendor/project label: Dropbox.
- `syncthing` — [Syncthing](https://syncthing.net/); curated vendor/project label: Syncthing Foundation / contributors.

### File Transfer Tools

- `winscp` — [WinSCP](https://winscp.net/); curated vendor/project label: WinSCP project.
- `filezilla-client` — [FileZilla Client](https://filezilla-project.org/); curated vendor/project label: FileZilla project.
- `cyberduck` — [Cyberduck](https://cyberduck.io/); curated vendor/project label: iterate.
- `rclone` — [rclone](https://rclone.org/); curated vendor/project label: rclone project.

### P2P / Torrent

- `qbittorrent` — [qBittorrent](https://www.qbittorrent.org/); curated vendor/project label: qBittorrent project.
- `transmission` — [Transmission](https://transmissionbt.com/); curated vendor/project label: Transmission project.
- `deluge` — [Deluge](https://github.com/deluge-torrent/deluge); curated vendor/project label: Deluge Team.
- `bittorrent-classic` — [BitTorrent Classic](https://www.bittorrent.com/products/); curated vendor/project label: BitTorrent.

### Browsers

- `google-chrome` — [Google Chrome](https://www.google.com/chrome/); curated vendor/project label: Google.
- `microsoft-edge` — [Microsoft Edge](https://www.microsoft.com/en-us/edge); curated vendor/project label: Microsoft.
- `mozilla-firefox` — [Mozilla Firefox](https://www.mozilla.org/firefox/); curated vendor/project label: Mozilla.
- `brave-browser` — [Brave Browser](https://brave.com/); curated vendor/project label: Brave Software.

### Password Managers

- `1password` — [1Password](https://1password.com/); curated vendor/project label: 1Password.
- `bitwarden` — [Bitwarden](https://bitwarden.com/); curated vendor/project label: Bitwarden.
- `keepass` — [KeePass Password Safe](https://keepass.info/); curated vendor/project label: Dominik Reichl / KeePass project.
- `keepassxc` — [KeePassXC](https://keepassxc.org/); curated vendor/project label: KeePassXC Team.

### Virtualization

- `virtualbox` — [Oracle VirtualBox](https://www.oracle.com/virtualization/virtualbox/); curated vendor/project label: Oracle.
- `vmware-workstation` — [VMware Workstation Pro](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion); curated vendor/project label: Broadcom / VMware.
- `parallels-desktop` — [Parallels Desktop](https://www.parallels.com/products/desktop/); curated vendor/project label: Parallels / Alludo.
- `qemu` — [QEMU](https://www.qemu.org/); curated vendor/project label: QEMU project.

### Containers

- `docker-desktop` — [Docker Desktop](https://www.docker.com/products/docker-desktop/); curated vendor/project label: Docker.
- `podman-desktop` — [Podman Desktop](https://podman-desktop.io/); curated vendor/project label: Podman Desktop community.
- `rancher-desktop` — [Rancher Desktop](https://rancherdesktop.io/); curated vendor/project label: SUSE / Rancher.
- `minikube` — [minikube](https://minikube.sigs.k8s.io/docs/); curated vendor/project label: Kubernetes contributors.

### Network Utilities

- `wireshark` — [Wireshark](https://www.wireshark.org/); curated vendor/project label: Wireshark Foundation.
- `angry-ip-scanner` — [Angry IP Scanner](https://angryip.org/); curated vendor/project label: Angry IP Scanner contributors.
- `iperf3` — [iperf3](https://software.es.net/iperf/); curated vendor/project label: ESnet.
- `fiddler-everywhere` — [Fiddler Everywhere](https://www.telerik.com/fiddler/fiddler-everywhere); curated vendor/project label: Progress Software / Telerik.

### System Administration Tools

- `windows-admin-center` — [Windows Admin Center](https://learn.microsoft.com/windows-server/manage/windows-admin-center/overview); curated vendor/project label: Microsoft.
- `sysinternals-suite` — [Sysinternals Suite](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite); curated vendor/project label: Microsoft.
- `microsoft-powertoys` — [Microsoft PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/); curated vendor/project label: Microsoft.
- `pdq-deploy` — [PDQ Deploy](https://www.pdq.com/pdq-deploy/); curated vendor/project label: PDQ.

### Database Clients

- `dbeaver-community` — [DBeaver Community](https://dbeaver.io/); curated vendor/project label: DBeaver.
- `heidisql` — [HeidiSQL](https://www.heidisql.com/); curated vendor/project label: HeidiSQL project.
- `pgadmin4` — [pgAdmin 4](https://www.pgadmin.org/); curated vendor/project label: pgAdmin Development Team.
- `mysql-workbench` — [MySQL Workbench](https://www.mysql.com/products/workbench/); curated vendor/project label: Oracle.

### Remote Shell / SSH Tools

- `putty` — [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/); curated vendor/project label: Simon Tatham / PuTTY contributors.
- `openssh` — [OpenSSH](https://www.openssh.com/); curated vendor/project label: OpenBSD / OpenSSH contributors.
- `mobaxterm` — [MobaXterm](https://mobaxterm.mobatek.net/); curated vendor/project label: Mobatek.
- `termius` — [Termius](https://termius.com/); curated vendor/project label: Termius.

### Scripting / Automation Tools

- `powershell7` — [PowerShell 7](https://learn.microsoft.com/powershell/); curated vendor/project label: Microsoft.
- `python` — [Python](https://www.python.org/); curated vendor/project label: Python Software Foundation.
- `autohotkey` — [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey); curated vendor/project label: AutoHotkey Foundation / contributors.
- `nodejs` — [Node.js](https://nodejs.org/); curated vendor/project label: OpenJS Foundation / contributors.

### Screen Recording / Capture

- `obs-studio` — [OBS Studio](https://obsproject.com/); curated vendor/project label: OBS Project.
- `sharex` — [ShareX](https://getsharex.com/); curated vendor/project label: ShareX Team.
- `snagit` — [Snagit](https://www.techsmith.com/snagit/); curated vendor/project label: TechSmith.
- `loom` — [Loom](https://www.loom.com/); curated vendor/project label: Atlassian.

### Personal Collaboration Tools

- `notion` — [Notion](https://www.notion.com/desktop); curated vendor/project label: Notion Labs.
- `obsidian` — [Obsidian](https://obsidian.md/); curated vendor/project label: Dynalist.
- `evernote` — [Evernote](https://evernote.com/download); curated vendor/project label: Evernote / Bending Spoons.
- `joplin` — [Joplin](https://joplinapp.org/); curated vendor/project label: Joplin project.

### Crypto / Mining Tools

- `xmrig` — [XMRig](https://xmrig.com/); curated vendor/project label: XMRig contributors.
- `nicehash-miner` — [NiceHash Miner](https://www.nicehash.com/mining); curated vendor/project label: NiceHash.
- `electrum` — [Electrum](https://electrum.org/); curated vendor/project label: Electrum developers.
- `bitcoin-core` — [Bitcoin Core](https://bitcoincore.org/); curated vendor/project label: Bitcoin Core contributors.

### Privacy / Anonymization Tools

- `tor-browser` — [Tor Browser](https://www.torproject.org/); curated vendor/project label: The Tor Project.
- `i2p` — [I2P](https://geti2p.net/); curated vendor/project label: I2P project.
- `veracrypt` — [VeraCrypt](https://veracrypt.io/en/Home.html); curated vendor/project label: IDRIX / VeraCrypt contributors.
- `cryptomator` — [Cryptomator](https://cryptomator.org/); curated vendor/project label: Skymatic / Cryptomator contributors.

### Other Corporate-Risk / Shadow-IT Applications

- `ccleaner` — [CCleaner](https://www.ccleaner.com/ccleaner); curated vendor/project label: Piriform / Gen Digital.
- `revo-uninstaller` — [Revo Uninstaller](https://www.revouninstaller.com/); curated vendor/project label: VS Revo Group.
- `internet-download-manager` — [Internet Download Manager](https://www.internetdownloadmanager.com/); curated vendor/project label: Tonec.
- `bluestacks` — [BlueStacks](https://www.bluestacks.com/); curated vendor/project label: BlueStacks.
