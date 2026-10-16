config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "1password",
    "advanced ip scanner",
    "aider",
    "android studio",
    "angry ip scanner",
    "anydesk",
    "anythingllm",
    "anythingllm desktop",
    "autohotkey",
    "autoit",
    "avast free antivirus",
    "avg antivirus free",
    "avira security",
    "battle.net",
    "bitcoin core",
    "bitdefender antivirus plus",
    "bitdefender endpoint security tools",
    "bitdefender total security",
    "bittorrent classic",
    "bitwarden",
    "blizzard battle.net",
    "bloodhound community edition",
    "bluestacks",
    "bluestacks app player",
    "brave",
    "brave browser",
    "bruno",
    "burp suite community edition",
    "burp suite professional",
    "camtasia",
    "ccleaner",
    "chatgpt",
    "cisco anyconnect secure mobility client",
    "cisco secure client",
    "clamav",
    "claude",
    "claude code",
    "cloudflare warp",
    "cloudflare-warp",
    "connectwise control",
    "continue",
    "cortex xdr",
    "cortex xdr agent",
    "crowdstrike falcon sensor",
    "cryptomator",
    "cursor",
    "cyberduck",
    "dbeaver",
    "dbeaver community",
    "deluge",
    "devin desktop",
    "discord",
    "docker desktop",
    "dropbox",
    "ea app",
    "elastic agent",
    "electrum",
    "emsisoft anti-malware home",
    "enpass",
    "epic games launcher",
    "eset endpoint antivirus",
    "eset endpoint security",
    "eset nod32 antivirus",
    "evernote",
    "f-secure total",
    "facebook",
    "fiddler everywhere",
    "filezilla",
    "filezilla client",
    "firefox",
    "forticlient",
    "forticlient vpn",
    "git",
    "git for windows",
    "github desktop",
    "globalprotect",
    "gog galaxy",
    "google chrome",
    "google drive",
    "google drive for desktop",
    "gpt4all",
    "heidisql",
    "i2p",
    "insomnia",
    "instagram",
    "intellij idea",
    "intellij idea community edition",
    "intellij idea ultimate edition",
    "internet download manager",
    "iperf3",
    "jan",
    "joplin",
    "kaspersky endpoint security for windows",
    "keepass password safe",
    "keepass password safe 2",
    "keepassxc",
    "llama.cpp",
    "lm studio",
    "logseq",
    "loom",
    "malwarebytes",
    "malwarebytes premium",
    "mcafee total protection",
    "megasync",
    "metasploit framework",
    "microsoft defender for endpoint",
    "microsoft edge",
    "microsoft onedrive",
    "microsoft powertoys",
    "microsoft teams",
    "microsoft teams classic",
    "microsoft visual studio code",
    "minikube",
    "mobaxterm",
    "mobaxterm personal edition",
    "mobaxterm professional edition",
    "monero gui wallet",
    "mozilla firefox",
    "msty studio",
    "mullvad browser",
    "mysql workbench",
    "nessus",
    "ngrok",
    "nicehash miner",
    "nmap",
    "node.js",
    "norton 360",
    "norton 360 deluxe",
    "notion",
    "obs studio",
    "obsidian",
    "ollama",
    "openssh",
    "openssh client",
    "openssh server",
    "openvpn connect",
    "oracle sql developer",
    "oracle virtualbox",
    "oracle vm virtualbox",
    "orbstack",
    "panda dome",
    "panda dome free",
    "parallels desktop",
    "pdq deploy",
    "pdq inventory",
    "peazip",
    "pgadmin 4",
    "podman desktop",
    "postman",
    "powershell",
    "powershell 7",
    "powertoys",
    "putty",
    "pycharm",
    "pycharm community edition",
    "pycharm professional edition",
    "python",
    "qbittorrent",
    "qemu",
    "rancher desktop",
    "rclone",
    "realvnc connect",
    "realvnc server",
    "realvnc viewer",
    "reddit",
    "revo uninstaller",
    "revo uninstaller pro",
    "rustdesk",
    "screenconnect",
    "screenconnect client",
    "securecrt",
    "sentinelone agent",
    "sharex",
    "signal",
    "signal desktop",
    "slack",
    "smartftp",
    "snagit",
    "sophos endpoint agent",
    "splashtop streamer",
    "sql developer",
    "steam",
    "sublime text",
    "symantec endpoint protection",
    "syncthing",
    "sysinternals suite",
    "tailscale",
    "teamviewer",
    "teamviewer host",
    "teamviewer quicksupport",
    "techsmith snagit",
    "telegram desktop",
    "termius",
    "tiktok",
    "tixati",
    "tor browser",
    "transmission",
    "trend micro maximum security",
    "ubisoft connect",
    "veracrypt",
    "visual studio code",
    "vivaldi",
    "vmware fusion",
    "vmware workstation",
    "vmware workstation pro",
    "windows admin center",
    "windsurf",
    "winscp",
    "wireguard",
    "wireshark",
    "xmrig",
    "zoom workplace"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "UNMAPPED"

| alter detected_product = if(
            application_name_normalized = "1password",
            "1Password",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "1password",
            "1password",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "1password",
            "Password Managers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "advanced ip scanner",
            "Advanced IP Scanner",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "advanced ip scanner",
            "advanced-ip-scanner",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "advanced ip scanner",
            "Network Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "aider",
            "Aider",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "aider",
            "aider",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "aider",
            "AI Development Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "android studio",
            "Android Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "android studio",
            "android-studio",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "android studio",
            "Development Tools / IDEs",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "angry ip scanner",
            "Angry IP Scanner",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "angry ip scanner",
            "angry-ip-scanner",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "angry ip scanner",
            "Network Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "anydesk",
            "AnyDesk",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "anydesk",
            "anydesk",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "anydesk",
            "Remote Access / Remote Administration",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("anythingllm", "anythingllm desktop"),
            "AnythingLLM Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("anythingllm", "anythingllm desktop"),
            "anythingllm",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("anythingllm", "anythingllm desktop"),
            "Artificial Intelligence Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "autohotkey",
            "AutoHotkey",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "autohotkey",
            "autohotkey",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "autohotkey",
            "Scripting / Automation Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "autoit",
            "AutoIt",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "autoit",
            "autoit",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "autoit",
            "Scripting / Automation Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "avast free antivirus",
            "Avast Free Antivirus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avast free antivirus",
            "avast-free-antivirus",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "avast free antivirus",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "avg antivirus free",
            "AVG AntiVirus FREE",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avg antivirus free",
            "avg-antivirus-free",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "avg antivirus free",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "avira security",
            "Avira Security",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avira security",
            "avira-security",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "avira security",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("battle.net", "blizzard battle.net"),
            "Battle.net",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("battle.net", "blizzard battle.net"),
            "battle-net",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("battle.net", "blizzard battle.net"),
            "Gaming Platforms",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "bitcoin core",
            "Bitcoin Core",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bitcoin core",
            "bitcoin-core",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "bitcoin core",
            "Crypto / Mining Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("bitdefender antivirus plus", "bitdefender total security"),
            "Bitdefender consumer security family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("bitdefender antivirus plus", "bitdefender total security"),
            "bitdefender-consumer",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("bitdefender antivirus plus", "bitdefender total security"),
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "bitdefender endpoint security tools",
            "Bitdefender Endpoint Security Tools",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bitdefender endpoint security tools",
            "bitdefender-best",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "bitdefender endpoint security tools",
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "bittorrent classic",
            "BitTorrent Classic",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bittorrent classic",
            "bittorrent-classic",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "bittorrent classic",
            "P2P / Torrent",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "bitwarden",
            "Bitwarden",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bitwarden",
            "bitwarden",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "bitwarden",
            "Password Managers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "bloodhound community edition",
            "BloodHound Community Edition",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bloodhound community edition",
            "bloodhound-community",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "bloodhound community edition",
            "Penetration Testing / Dual-Use Security Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("bluestacks", "bluestacks app player"),
            "BlueStacks",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("bluestacks", "bluestacks app player"),
            "bluestacks",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("bluestacks", "bluestacks app player"),
            "Other Corporate-Risk / Shadow-IT Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("brave", "brave browser"),
            "Brave Browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("brave", "brave browser"),
            "brave-browser",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("brave", "brave browser"),
            "Browsers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "bruno",
            "Bruno",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bruno",
            "bruno",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "bruno",
            "Developer Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("burp suite community edition", "burp suite professional"),
            "Burp Suite",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("burp suite community edition", "burp suite professional"),
            "burp-suite",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("burp suite community edition", "burp suite professional"),
            "Penetration Testing / Dual-Use Security Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "camtasia",
            "Camtasia",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "camtasia",
            "camtasia",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "camtasia",
            "Screen Recording / Capture",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "ccleaner",
            "CCleaner",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ccleaner",
            "ccleaner",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "ccleaner",
            "Other Corporate-Risk / Shadow-IT Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "chatgpt",
            "ChatGPT desktop app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "chatgpt",
            "chatgpt-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "chatgpt",
            "Artificial Intelligence Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("cisco anyconnect secure mobility client", "cisco secure client"),
            "Cisco Secure Client",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("cisco anyconnect secure mobility client", "cisco secure client"),
            "cisco-secure-client",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("cisco anyconnect secure mobility client", "cisco secure client"),
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "clamav",
            "ClamAV",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "clamav",
            "clamav",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "clamav",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "claude code",
            "Claude Code",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "claude code",
            "claude-code",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "claude code",
            "AI Development Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "claude",
            "Claude desktop app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "claude",
            "claude-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "claude",
            "Artificial Intelligence Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("cloudflare warp", "cloudflare-warp"),
            "Cloudflare WARP / One Client family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("cloudflare warp", "cloudflare-warp"),
            "cloudflare-warp",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("cloudflare warp", "cloudflare-warp"),
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "continue",
            "Continue",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "continue",
            "continue",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "continue",
            "AI Development Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("cortex xdr", "cortex xdr agent"),
            "Cortex XDR Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("cortex xdr", "cortex xdr agent"),
            "cortex-xdr-agent",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("cortex xdr", "cortex xdr agent"),
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "crowdstrike falcon sensor",
            "CrowdStrike Falcon Sensor",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "crowdstrike falcon sensor",
            "crowdstrike-falcon-sensor",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "crowdstrike falcon sensor",
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "cryptomator",
            "Cryptomator",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cryptomator",
            "cryptomator",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "cryptomator",
            "Privacy / Anonymization Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "cursor",
            "Cursor",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cursor",
            "cursor",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "cursor",
            "AI Development Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "cyberduck",
            "Cyberduck",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cyberduck",
            "cyberduck",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "cyberduck",
            "File Transfer Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("dbeaver", "dbeaver community"),
            "DBeaver Community",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("dbeaver", "dbeaver community"),
            "dbeaver-community",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("dbeaver", "dbeaver community"),
            "Database Clients",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "deluge",
            "Deluge",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "deluge",
            "deluge",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "deluge",
            "P2P / Torrent",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "discord",
            "Discord",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "discord",
            "discord",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "discord",
            "Communication / Messaging",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "docker desktop",
            "Docker Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "docker desktop",
            "docker-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "docker desktop",
            "Containers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "dropbox",
            "Dropbox desktop app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "dropbox",
            "dropbox",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "dropbox",
            "Cloud Storage / File Synchronization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "ea app",
            "EA app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ea app",
            "ea-app",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "ea app",
            "Gaming Platforms",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "elastic agent",
            "Elastic Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "elastic agent",
            "elastic-agent",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "elastic agent",
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "electrum",
            "Electrum",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "electrum",
            "electrum",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "electrum",
            "Crypto / Mining Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "emsisoft anti-malware home",
            "Emsisoft Anti-Malware Home",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "emsisoft anti-malware home",
            "emsisoft-anti-malware",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "emsisoft anti-malware home",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "enpass",
            "Enpass",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "enpass",
            "enpass",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "enpass",
            "Password Managers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "epic games launcher",
            "Epic Games Launcher",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "epic games launcher",
            "epic-games-launcher",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "epic games launcher",
            "Gaming Platforms",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("eset endpoint antivirus", "eset endpoint security"),
            "ESET endpoint protection family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("eset endpoint antivirus", "eset endpoint security"),
            "eset-endpoint-protection",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("eset endpoint antivirus", "eset endpoint security"),
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "eset nod32 antivirus",
            "ESET NOD32 Antivirus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "eset nod32 antivirus",
            "eset-nod32",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "eset nod32 antivirus",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "evernote",
            "Evernote",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "evernote",
            "evernote",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "evernote",
            "Personal Collaboration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "f-secure total",
            "F-Secure Total",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "f-secure total",
            "f-secure-total",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "f-secure total",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "facebook",
            "Facebook",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "facebook",
            "facebook",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "facebook",
            "Social Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "fiddler everywhere",
            "Fiddler Everywhere",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "fiddler everywhere",
            "fiddler-everywhere",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "fiddler everywhere",
            "Network Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("filezilla", "filezilla client"),
            "FileZilla Client",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("filezilla", "filezilla client"),
            "filezilla-client",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("filezilla", "filezilla client"),
            "File Transfer Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("forticlient", "forticlient vpn"),
            "FortiClient family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("forticlient", "forticlient vpn"),
            "forticlient",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("forticlient", "forticlient vpn"),
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("git", "git for windows"),
            "Git family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("git", "git for windows"),
            "git-for-windows",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("git", "git for windows"),
            "Developer Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "github desktop",
            "GitHub Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "github desktop",
            "github-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "github desktop",
            "Developer Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "globalprotect",
            "GlobalProtect",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "globalprotect",
            "globalprotect",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "globalprotect",
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "gog galaxy",
            "GOG GALAXY",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "gog galaxy",
            "gog-galaxy",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "gog galaxy",
            "Gaming Platforms",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "google chrome",
            "Google Chrome",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "google chrome",
            "google-chrome",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "google chrome",
            "Browsers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("google drive", "google drive for desktop"),
            "Google Drive for desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("google drive", "google drive for desktop"),
            "google-drive-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("google drive", "google drive for desktop"),
            "Cloud Storage / File Synchronization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "gpt4all",
            "GPT4All",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "gpt4all",
            "gpt4all",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "gpt4all",
            "Local AI / LLM Runtimes",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "heidisql",
            "HeidiSQL",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "heidisql",
            "heidisql",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "heidisql",
            "Database Clients",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "i2p",
            "I2P",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "i2p",
            "i2p",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "i2p",
            "Privacy / Anonymization Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "insomnia",
            "Insomnia",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "insomnia",
            "insomnia",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "insomnia",
            "Developer Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "instagram",
            "Instagram",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "instagram",
            "instagram",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "instagram",
            "Social Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("intellij idea", "intellij idea community edition", "intellij idea ultimate edition"),
            "IntelliJ IDEA",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("intellij idea", "intellij idea community edition", "intellij idea ultimate edition"),
            "intellij-idea",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("intellij idea", "intellij idea community edition", "intellij idea ultimate edition"),
            "Development Tools / IDEs",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "internet download manager",
            "Internet Download Manager",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "internet download manager",
            "internet-download-manager",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "internet download manager",
            "Other Corporate-Risk / Shadow-IT Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "iperf3",
            "iperf3",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "iperf3",
            "iperf3",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "iperf3",
            "Network Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "jan",
            "Jan",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "jan",
            "jan",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "jan",
            "Artificial Intelligence Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "joplin",
            "Joplin",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "joplin",
            "joplin",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "joplin",
            "Personal Collaboration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "kaspersky endpoint security for windows",
            "Kaspersky Endpoint Security for Windows",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "kaspersky endpoint security for windows",
            "kaspersky-endpoint-windows",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "kaspersky endpoint security for windows",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("keepass password safe", "keepass password safe 2"),
            "KeePass Password Safe",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("keepass password safe", "keepass password safe 2"),
            "keepass",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("keepass password safe", "keepass password safe 2"),
            "Password Managers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "keepassxc",
            "KeePassXC",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "keepassxc",
            "keepassxc",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "keepassxc",
            "Password Managers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "llama.cpp",
            "llama.cpp",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "llama.cpp",
            "llama-cpp",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "llama.cpp",
            "Local AI / LLM Runtimes",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "lm studio",
            "LM Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "lm studio",
            "lm-studio",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "lm studio",
            "Local AI / LLM Runtimes",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "logseq",
            "Logseq",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "logseq",
            "logseq",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "logseq",
            "Personal Collaboration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "loom",
            "Loom",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "loom",
            "loom",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "loom",
            "Screen Recording / Capture",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("malwarebytes", "malwarebytes premium"),
            "Malwarebytes consumer family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("malwarebytes", "malwarebytes premium"),
            "malwarebytes-consumer",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("malwarebytes", "malwarebytes premium"),
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "mcafee total protection",
            "McAfee Total Protection",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mcafee total protection",
            "mcafee-total-protection",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "mcafee total protection",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "megasync",
            "MEGAsync",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "megasync",
            "megasync",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "megasync",
            "Cloud Storage / File Synchronization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "metasploit framework",
            "Metasploit Framework",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "metasploit framework",
            "metasploit-framework",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "metasploit framework",
            "Penetration Testing / Dual-Use Security Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "microsoft defender for endpoint",
            "Microsoft Defender for Endpoint",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "microsoft defender for endpoint",
            "microsoft-defender-endpoint",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "microsoft defender for endpoint",
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "microsoft edge",
            "Microsoft Edge",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "microsoft edge",
            "microsoft-edge",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "microsoft edge",
            "Browsers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "microsoft onedrive",
            "Microsoft OneDrive",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "microsoft onedrive",
            "onedrive",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "microsoft onedrive",
            "Cloud Storage / File Synchronization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("microsoft powertoys", "powertoys"),
            "Microsoft PowerToys",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("microsoft powertoys", "powertoys"),
            "microsoft-powertoys",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("microsoft powertoys", "powertoys"),
            "System Administration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("microsoft teams", "microsoft teams classic"),
            "Microsoft Teams",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("microsoft teams", "microsoft teams classic"),
            "microsoft-teams",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("microsoft teams", "microsoft teams classic"),
            "Communication / Messaging",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "minikube",
            "minikube",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "minikube",
            "minikube",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "minikube",
            "Containers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("mobaxterm", "mobaxterm personal edition", "mobaxterm professional edition"),
            "MobaXterm",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("mobaxterm", "mobaxterm personal edition", "mobaxterm professional edition"),
            "mobaxterm",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("mobaxterm", "mobaxterm personal edition", "mobaxterm professional edition"),
            "Remote Shell / SSH Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "monero gui wallet",
            "Monero GUI Wallet",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "monero gui wallet",
            "monero-gui-wallet",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "monero gui wallet",
            "Crypto / Mining Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("firefox", "mozilla firefox"),
            "Mozilla Firefox",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("firefox", "mozilla firefox"),
            "mozilla-firefox",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("firefox", "mozilla firefox"),
            "Browsers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "msty studio",
            "Msty Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "msty studio",
            "msty-studio",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "msty studio",
            "Local AI / LLM Runtimes",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "mullvad browser",
            "Mullvad Browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mullvad browser",
            "mullvad-browser",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "mullvad browser",
            "Privacy / Anonymization Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "mysql workbench",
            "MySQL Workbench",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mysql workbench",
            "mysql-workbench",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "mysql workbench",
            "Database Clients",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "ngrok",
            "ngrok",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ngrok",
            "ngrok",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "ngrok",
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "nicehash miner",
            "NiceHash Miner",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nicehash miner",
            "nicehash-miner",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "nicehash miner",
            "Crypto / Mining Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "nmap",
            "Nmap",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nmap",
            "nmap",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "nmap",
            "Penetration Testing / Dual-Use Security Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "node.js",
            "Node.js",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "node.js",
            "nodejs",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "node.js",
            "Scripting / Automation Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("norton 360", "norton 360 deluxe"),
            "Norton 360 family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("norton 360", "norton 360 deluxe"),
            "norton-360",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("norton 360", "norton 360 deluxe"),
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "notion",
            "Notion",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "notion",
            "notion",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "notion",
            "Personal Collaboration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "obs studio",
            "OBS Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "obs studio",
            "obs-studio",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "obs studio",
            "Screen Recording / Capture",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "obsidian",
            "Obsidian",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "obsidian",
            "obsidian",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "obsidian",
            "Personal Collaboration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "ollama",
            "Ollama",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ollama",
            "ollama",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "ollama",
            "Local AI / LLM Runtimes",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("openssh", "openssh client", "openssh server"),
            "OpenSSH",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("openssh", "openssh client", "openssh server"),
            "openssh",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("openssh", "openssh client", "openssh server"),
            "Remote Shell / SSH Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "openvpn connect",
            "OpenVPN Connect",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "openvpn connect",
            "openvpn-connect",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "openvpn connect",
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("oracle sql developer", "sql developer"),
            "Oracle SQL Developer",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("oracle sql developer", "sql developer"),
            "oracle-sql-developer",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("oracle sql developer", "sql developer"),
            "Database Clients",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("oracle virtualbox", "oracle vm virtualbox"),
            "Oracle VirtualBox",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("oracle virtualbox", "oracle vm virtualbox"),
            "virtualbox",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("oracle virtualbox", "oracle vm virtualbox"),
            "Virtualization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "orbstack",
            "OrbStack",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "orbstack",
            "orbstack",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "orbstack",
            "Containers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("panda dome", "panda dome free"),
            "Panda Dome family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("panda dome", "panda dome free"),
            "panda-dome",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("panda dome", "panda dome free"),
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "parallels desktop",
            "Parallels Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "parallels desktop",
            "parallels-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "parallels desktop",
            "Virtualization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "pdq deploy",
            "PDQ Deploy",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "pdq deploy",
            "pdq-deploy",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "pdq deploy",
            "System Administration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "pdq inventory",
            "PDQ Inventory",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "pdq inventory",
            "pdq-inventory",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "pdq inventory",
            "System Administration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "peazip",
            "PeaZip",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "peazip",
            "peazip",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "peazip",
            "Other Corporate-Risk / Shadow-IT Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "pgadmin 4",
            "pgAdmin 4",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "pgadmin 4",
            "pgadmin4",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "pgadmin 4",
            "Database Clients",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "podman desktop",
            "Podman Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "podman desktop",
            "podman-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "podman desktop",
            "Containers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "postman",
            "Postman",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "postman",
            "postman",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "postman",
            "Developer Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("powershell", "powershell 7"),
            "PowerShell 7",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("powershell", "powershell 7"),
            "powershell7",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("powershell", "powershell 7"),
            "Scripting / Automation Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "putty",
            "PuTTY",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "putty",
            "putty",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "putty",
            "Remote Shell / SSH Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("pycharm", "pycharm community edition", "pycharm professional edition"),
            "PyCharm",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("pycharm", "pycharm community edition", "pycharm professional edition"),
            "pycharm",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("pycharm", "pycharm community edition", "pycharm professional edition"),
            "Development Tools / IDEs",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "python",
            "Python",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "python",
            "python",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "python",
            "Scripting / Automation Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "qbittorrent",
            "qBittorrent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "qbittorrent",
            "qbittorrent",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "qbittorrent",
            "P2P / Torrent",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "qemu",
            "QEMU",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "qemu",
            "qemu",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "qemu",
            "Virtualization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "rancher desktop",
            "Rancher Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "rancher desktop",
            "rancher-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "rancher desktop",
            "Containers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "rclone",
            "rclone",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "rclone",
            "rclone",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "rclone",
            "File Transfer Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("realvnc connect", "realvnc server", "realvnc viewer"),
            "RealVNC Connect",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("realvnc connect", "realvnc server", "realvnc viewer"),
            "realvnc-connect",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("realvnc connect", "realvnc server", "realvnc viewer"),
            "Remote Access / Remote Administration",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "reddit",
            "Reddit",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "reddit",
            "reddit",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "reddit",
            "Social Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("revo uninstaller", "revo uninstaller pro"),
            "Revo Uninstaller",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("revo uninstaller", "revo uninstaller pro"),
            "revo-uninstaller",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("revo uninstaller", "revo uninstaller pro"),
            "Other Corporate-Risk / Shadow-IT Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "rustdesk",
            "RustDesk",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "rustdesk",
            "rustdesk",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "rustdesk",
            "Remote Access / Remote Administration",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("connectwise control", "screenconnect", "screenconnect client"),
            "ScreenConnect",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("connectwise control", "screenconnect", "screenconnect client"),
            "screenconnect",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("connectwise control", "screenconnect", "screenconnect client"),
            "Remote Access / Remote Administration",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "securecrt",
            "SecureCRT",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "securecrt",
            "securecrt",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "securecrt",
            "Remote Shell / SSH Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "sentinelone agent",
            "SentinelOne Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sentinelone agent",
            "sentinelone-agent",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "sentinelone agent",
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "sharex",
            "ShareX",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sharex",
            "sharex",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "sharex",
            "Screen Recording / Capture",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("signal", "signal desktop"),
            "Signal Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("signal", "signal desktop"),
            "signal-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("signal", "signal desktop"),
            "Communication / Messaging",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "slack",
            "Slack",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "slack",
            "slack",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "slack",
            "Communication / Messaging",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "smartftp",
            "SmartFTP",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "smartftp",
            "smartftp",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "smartftp",
            "File Transfer Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("snagit", "techsmith snagit"),
            "Snagit",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("snagit", "techsmith snagit"),
            "snagit",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("snagit", "techsmith snagit"),
            "Screen Recording / Capture",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "sophos endpoint agent",
            "Sophos Endpoint Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sophos endpoint agent",
            "sophos-endpoint-agent",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "sophos endpoint agent",
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "splashtop streamer",
            "Splashtop Streamer",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "splashtop streamer",
            "splashtop-streamer",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "splashtop streamer",
            "Remote Access / Remote Administration",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "steam",
            "Steam",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "steam",
            "steam",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "steam",
            "Gaming Platforms",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "sublime text",
            "Sublime Text",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sublime text",
            "sublime-text",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "sublime text",
            "Development Tools / IDEs",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "symantec endpoint protection",
            "Symantec Endpoint Protection",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "symantec endpoint protection",
            "symantec-endpoint-protection",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "symantec endpoint protection",
            "EDR / Endpoint Security",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "syncthing",
            "Syncthing",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "syncthing",
            "syncthing",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "syncthing",
            "Cloud Storage / File Synchronization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "sysinternals suite",
            "Sysinternals Suite",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sysinternals suite",
            "sysinternals-suite",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "sysinternals suite",
            "System Administration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "tailscale",
            "Tailscale",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "tailscale",
            "tailscale",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "tailscale",
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("teamviewer", "teamviewer host", "teamviewer quicksupport"),
            "TeamViewer Remote",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("teamviewer", "teamviewer host", "teamviewer quicksupport"),
            "teamviewer",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("teamviewer", "teamviewer host", "teamviewer quicksupport"),
            "Remote Access / Remote Administration",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "telegram desktop",
            "Telegram Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "telegram desktop",
            "telegram-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "telegram desktop",
            "Communication / Messaging",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "nessus",
            "Tenable Nessus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nessus",
            "tenable-nessus",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "nessus",
            "Penetration Testing / Dual-Use Security Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "termius",
            "Termius",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "termius",
            "termius",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "termius",
            "Remote Shell / SSH Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "tiktok",
            "TikTok",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "tiktok",
            "tiktok",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "tiktok",
            "Social Applications",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "tixati",
            "Tixati",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "tixati",
            "tixati",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "tixati",
            "P2P / Torrent",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "tor browser",
            "Tor Browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "tor browser",
            "tor-browser",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "tor browser",
            "Privacy / Anonymization Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "transmission",
            "Transmission",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "transmission",
            "transmission",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "transmission",
            "P2P / Torrent",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "trend micro maximum security",
            "Trend Micro Maximum Security",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "trend micro maximum security",
            "trend-micro-maximum-security",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "trend micro maximum security",
            "Antivirus",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "ubisoft connect",
            "Ubisoft Connect",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ubisoft connect",
            "ubisoft-connect",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "ubisoft connect",
            "Gaming Platforms",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "veracrypt",
            "VeraCrypt",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "veracrypt",
            "veracrypt",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "veracrypt",
            "Privacy / Anonymization Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("microsoft visual studio code", "visual studio code"),
            "Visual Studio Code",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("microsoft visual studio code", "visual studio code"),
            "visual-studio-code",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("microsoft visual studio code", "visual studio code"),
            "Development Tools / IDEs",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "vivaldi",
            "Vivaldi",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "vivaldi",
            "vivaldi",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "vivaldi",
            "Browsers",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "vmware fusion",
            "VMware Fusion",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "vmware fusion",
            "vmware-fusion",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "vmware fusion",
            "Virtualization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("vmware workstation", "vmware workstation pro"),
            "VMware Workstation Pro",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("vmware workstation", "vmware workstation pro"),
            "vmware-workstation",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("vmware workstation", "vmware workstation pro"),
            "Virtualization",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "windows admin center",
            "Windows Admin Center",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "windows admin center",
            "windows-admin-center",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "windows admin center",
            "System Administration Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized in ("devin desktop", "windsurf"),
            "Windsurf / Devin Desktop family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("devin desktop", "windsurf"),
            "windsurf-devin-desktop",
            product_id
        ),
        tool_family = if(
            application_name_normalized in ("devin desktop", "windsurf"),
            "AI Development Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "winscp",
            "WinSCP",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "winscp",
            "winscp",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "winscp",
            "File Transfer Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "wireguard",
            "WireGuard",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "wireguard",
            "wireguard",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "wireguard",
            "VPN / Tunneling / Proxy",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "wireshark",
            "Wireshark",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "wireshark",
            "wireshark",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "wireshark",
            "Network Utilities",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "xmrig",
            "XMRig",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "xmrig",
            "xmrig",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "xmrig",
            "Crypto / Mining Tools",
            tool_family
        )

| alter detected_product = if(
            application_name_normalized = "zoom workplace",
            "Zoom Workplace",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "zoom workplace",
            "zoom-workplace",
            product_id
        ),
        tool_family = if(
            application_name_normalized = "zoom workplace",
            "Communication / Messaging",
            tool_family
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
