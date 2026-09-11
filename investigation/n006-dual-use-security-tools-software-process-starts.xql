// Validation: NEEDS_ENVIRONMENT_VALIDATION; Cortex XSIAM XQL Search.
// Full-query compilation and execution: NOT RUN.
// Product-name matches are visibility leads, not maliciousness or approval verdicts.

config case_sensitive = false timeframe = 30d
| dataset = xdr_data

// Process-start rows only; executable matching does not prove a session or abuse.
| filter event_type = PROCESS and event_sub_type = PROCESS_START
// Stable endpoint identity is required by the shared prevalence and host views.
| filter agent_id != null and agent_id != ""
| alter process_name = lowercase(action_process_image_name)
| filter process_name in ("dumpcap.exe", "hashcat.exe", "john.exe", "mimikatz.exe", "ncat.exe", "nmap.exe", "procdump.exe", "procdump64.exe", "sharphound.exe", "tshark.exe", "wireshark.exe")

// Product and family are inferred from documented basenames, not authenticated identity.
| alter detected_product = "UNMAPPED", tool_family = "UNMAPPED", product_vendor = "UNMAPPED"
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("pangpa.exe", "pangps.exe"), "GlobalProtect", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("vpncli.exe", "vpnui.exe"), "Cisco Secure Client", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("forticlient.exe", "fortisslvpndaemon.exe"), "FortiClient", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("openvpn-gui.exe", "openvpn.exe"), "OpenVPN Engine / GUI", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("wireguard.exe"), "WireGuard for Windows", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("tailscale-ipn.exe", "tailscale.exe", "tailscaled.exe"), "Tailscale", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("twingate.exe", "twingate.service.exe", "twingateupdater.exe"), "Twingate", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("cloudflare warp.exe", "warp-svc.exe"), "Cloudflare WARP / Cloudflare One Client", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("nordvpn.exe"), "NordVPN", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("protonvpn.client.exe", "protonvpn.launcher.exe", "protonvpn.wireguardservice.exe", "protonvpnservice.exe"), "Proton VPN", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("mullvad-daemon.exe"), "Mullvad VPN", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("aws vpn client.exe", "aws-client-vpn-daemon.exe", "aws-vpn-client.exe"), "AWS VPN Client", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("teamviewer.exe", "teamviewer_desktop.exe", "teamviewer_service.exe"), "TeamViewer", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("anydesk.exe"), "AnyDesk", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("rustdesk.exe"), "RustDesk", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("tvnserver.exe", "tvnviewer.exe"), "TightVNC", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("mstsc.exe"), "Remote Desktop Connection", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("psexec.exe", "psexec64.exe"), "PsExec", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("plink.exe", "pscp.exe", "psftp.exe", "putty.exe"), "PuTTY", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("meshagent.exe"), "MeshCentral Agent", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("srfeature.exe", "srmanager.exe"), "Splashtop", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("nmap.exe"), "Nmap", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("ncat.exe"), "Ncat", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("dumpcap.exe", "tshark.exe", "wireshark.exe"), "Wireshark / TShark", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("hashcat.exe"), "hashcat", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("john.exe"), "John the Ripper", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("mimikatz.exe"), "Mimikatz", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("sharphound.exe"), "SharpHound Community Edition", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and process_name in ("procdump.exe", "procdump64.exe"), "ProcDump", detected_product)
| alter tool_family = if(detected_product = "GlobalProtect", "VPN", tool_family), product_vendor = if(detected_product = "GlobalProtect", "Palo Alto Networks", product_vendor)
| alter tool_family = if(detected_product = "Cisco Secure Client", "VPN", tool_family), product_vendor = if(detected_product = "Cisco Secure Client", "Cisco", product_vendor)
| alter tool_family = if(detected_product = "FortiClient", "VPN", tool_family), product_vendor = if(detected_product = "FortiClient", "Fortinet", product_vendor)
| alter tool_family = if(detected_product = "OpenVPN Engine / GUI", "VPN", tool_family), product_vendor = if(detected_product = "OpenVPN Engine / GUI", "OpenVPN project", product_vendor)
| alter tool_family = if(detected_product = "WireGuard for Windows", "VPN", tool_family), product_vendor = if(detected_product = "WireGuard for Windows", "WireGuard project", product_vendor)
| alter tool_family = if(detected_product = "Tailscale", "VPN", tool_family), product_vendor = if(detected_product = "Tailscale", "Tailscale", product_vendor)
| alter tool_family = if(detected_product = "Twingate", "VPN", tool_family), product_vendor = if(detected_product = "Twingate", "Twingate", product_vendor)
| alter tool_family = if(detected_product = "Cloudflare WARP / Cloudflare One Client", "VPN", tool_family), product_vendor = if(detected_product = "Cloudflare WARP / Cloudflare One Client", "Cloudflare", product_vendor)
| alter tool_family = if(detected_product = "NordVPN", "VPN", tool_family), product_vendor = if(detected_product = "NordVPN", "NordVPN", product_vendor)
| alter tool_family = if(detected_product = "Proton VPN", "VPN", tool_family), product_vendor = if(detected_product = "Proton VPN", "Proton AG", product_vendor)
| alter tool_family = if(detected_product = "Mullvad VPN", "VPN", tool_family), product_vendor = if(detected_product = "Mullvad VPN", "Mullvad", product_vendor)
| alter tool_family = if(detected_product = "AWS VPN Client", "VPN", tool_family), product_vendor = if(detected_product = "AWS VPN Client", "Amazon Web Services", product_vendor)
| alter tool_family = if(detected_product = "TeamViewer", "Remote Access", tool_family), product_vendor = if(detected_product = "TeamViewer", "TeamViewer", product_vendor)
| alter tool_family = if(detected_product = "AnyDesk", "Remote Access", tool_family), product_vendor = if(detected_product = "AnyDesk", "AnyDesk", product_vendor)
| alter tool_family = if(detected_product = "RustDesk", "Remote Access", tool_family), product_vendor = if(detected_product = "RustDesk", "RustDesk project", product_vendor)
| alter tool_family = if(detected_product = "TightVNC", "Remote Access", tool_family), product_vendor = if(detected_product = "TightVNC", "GlavSoft", product_vendor)
| alter tool_family = if(detected_product = "Remote Desktop Connection", "Remote Access", tool_family), product_vendor = if(detected_product = "Remote Desktop Connection", "Microsoft", product_vendor)
| alter tool_family = if(detected_product = "PsExec", "Remote Access", tool_family), product_vendor = if(detected_product = "PsExec", "Microsoft Sysinternals", product_vendor)
| alter tool_family = if(detected_product = "PuTTY", "Remote Access", tool_family), product_vendor = if(detected_product = "PuTTY", "Simon Tatham and PuTTY contributors", product_vendor)
| alter tool_family = if(detected_product = "MeshCentral Agent", "Remote Access", tool_family), product_vendor = if(detected_product = "MeshCentral Agent", "MeshCentral project", product_vendor)
| alter tool_family = if(detected_product = "Splashtop", "Remote Access", tool_family), product_vendor = if(detected_product = "Splashtop", "Splashtop", product_vendor)
| alter tool_family = if(detected_product = "Nmap", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Nmap", "Nmap Project", product_vendor)
| alter tool_family = if(detected_product = "Ncat", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Ncat", "Nmap Project", product_vendor)
| alter tool_family = if(detected_product = "Wireshark / TShark", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Wireshark / TShark", "Wireshark Foundation", product_vendor)
| alter tool_family = if(detected_product = "hashcat", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "hashcat", "hashcat project", product_vendor)
| alter tool_family = if(detected_product = "John the Ripper", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "John the Ripper", "Openwall project", product_vendor)
| alter tool_family = if(detected_product = "Mimikatz", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Mimikatz", "Benjamin Delpy / gentilkiwi", product_vendor)
| alter tool_family = if(detected_product = "SharpHound Community Edition", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "SharpHound Community Edition", "SpecterOps", product_vendor)
| alter tool_family = if(detected_product = "ProcDump", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "ProcDump", "Microsoft Sysinternals", product_vendor)
| filter detected_product != "UNMAPPED"
| filter tool_family = "Dual-Use Security Tools"

// Event-level investigation context.
| fields
    _time,
    agent_id,
    agent_hostname,
    action_process_username as process_user,
    actor_effective_username as initiating_user,
    tool_family,
    detected_product,
    product_vendor,
    action_process_image_name,
    action_process_image_path,
    action_process_image_command_line,
    actor_process_image_name as initiating_process,
    actor_process_command_line as initiating_command_line,
    action_process_signature_vendor,
    action_process_signature_status,
    action_process_image_sha256
| sort desc _time
| limit 1000
