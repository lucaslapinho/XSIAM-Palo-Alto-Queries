// Validation: NEEDS_ENVIRONMENT_VALIDATION; Cortex XSIAM XQL Search.
// Full-query compilation and execution: NOT RUN.
// Product-name matches are visibility leads, not maliciousness or approval verdicts.

config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications

// Select the latest nonempty application report available per endpoint in this window.
// Empty reports are absent from this preset; do not interpret this as current presence.
// max(report_timestamp) datetime compatibility still requires exact-query compilation.
| filter endpoint_id != null and endpoint_id != "" and report_timestamp != null
| windowcomp max(report_timestamp) by endpoint_id as latest_application_report
| filter report_timestamp = latest_application_report
| alter application_label = lowercase(application_name)

// Inventory labels are candidate product-name patterns; validate actual tenant naming.
| alter detected_product = "UNMAPPED", tool_family = "UNMAPPED", product_vendor = "UNMAPPED"
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "globalprotect"), "GlobalProtect", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "cisco secure client"), "Cisco Secure Client", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "forticlient"), "FortiClient", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "openvpn"), "OpenVPN Product Family", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "wireguard"), "WireGuard", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "tailscale"), "Tailscale", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "twingate"), "Twingate", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "cloudflare warp" or application_label contains "cloudflare one client"), "Cloudflare WARP / Cloudflare One Client", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "nordvpn"), "NordVPN", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "proton vpn"), "Proton VPN", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "mullvad vpn"), "Mullvad VPN", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "aws vpn client"), "AWS VPN Client", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "teamviewer"), "TeamViewer", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "anydesk"), "AnyDesk", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "rustdesk"), "RustDesk", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "realvnc server" or application_label contains "realvnc viewer" or application_label contains "realvnc connect"), "RealVNC Connect", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "tightvnc"), "TightVNC", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "chrome remote desktop"), "Chrome Remote Desktop", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "remote desktop connection"), "Remote Desktop Connection", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "psexec"), "PsExec", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "putty"), "PuTTY", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "openssh client" or application_label contains "openssh server" or application_label contains "openssh for windows"), "OpenSSH", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "meshcentral agent" or application_label contains "mesh agent"), "MeshCentral Agent Candidate", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "splashtop"), "Splashtop", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "dwagent"), "DWService / DWAgent", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "nmap"), "Nmap", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "ncat"), "Ncat", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "wireshark"), "Wireshark / TShark", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "tcpdump"), "tcpdump", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "hashcat"), "hashcat", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "john the ripper"), "John the Ripper", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "mimikatz"), "Mimikatz", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "sharphound"), "SharpHound", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "impacket"), "Impacket", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "metasploit framework"), "Metasploit Framework", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "chisel"), "Chisel", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "ligolo-ng"), "Ligolo-ng", detected_product)
| alter detected_product = if(detected_product = "UNMAPPED" and (application_label contains "procdump"), "ProcDump", detected_product)
| alter tool_family = if(detected_product = "GlobalProtect", "VPN", tool_family), product_vendor = if(detected_product = "GlobalProtect", "Palo Alto Networks", product_vendor)
| alter tool_family = if(detected_product = "Cisco Secure Client", "VPN", tool_family), product_vendor = if(detected_product = "Cisco Secure Client", "Cisco", product_vendor)
| alter tool_family = if(detected_product = "FortiClient", "VPN", tool_family), product_vendor = if(detected_product = "FortiClient", "Fortinet", product_vendor)
| alter tool_family = if(detected_product = "OpenVPN Product Family", "VPN", tool_family), product_vendor = if(detected_product = "OpenVPN Product Family", "OpenVPN project", product_vendor)
| alter tool_family = if(detected_product = "WireGuard", "VPN", tool_family), product_vendor = if(detected_product = "WireGuard", "WireGuard project", product_vendor)
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
| alter tool_family = if(detected_product = "RealVNC Connect", "Remote Access", tool_family), product_vendor = if(detected_product = "RealVNC Connect", "RealVNC", product_vendor)
| alter tool_family = if(detected_product = "TightVNC", "Remote Access", tool_family), product_vendor = if(detected_product = "TightVNC", "GlavSoft", product_vendor)
| alter tool_family = if(detected_product = "Chrome Remote Desktop", "Remote Access", tool_family), product_vendor = if(detected_product = "Chrome Remote Desktop", "Google / Chromium project", product_vendor)
| alter tool_family = if(detected_product = "Remote Desktop Connection", "Remote Access", tool_family), product_vendor = if(detected_product = "Remote Desktop Connection", "Microsoft", product_vendor)
| alter tool_family = if(detected_product = "PsExec", "Remote Access", tool_family), product_vendor = if(detected_product = "PsExec", "Microsoft Sysinternals", product_vendor)
| alter tool_family = if(detected_product = "PuTTY", "Remote Access", tool_family), product_vendor = if(detected_product = "PuTTY", "Simon Tatham and PuTTY contributors", product_vendor)
| alter tool_family = if(detected_product = "OpenSSH", "Remote Access", tool_family), product_vendor = if(detected_product = "OpenSSH", "Microsoft / OpenSSH project", product_vendor)
| alter tool_family = if(detected_product = "MeshCentral Agent Candidate", "Remote Access", tool_family), product_vendor = if(detected_product = "MeshCentral Agent Candidate", "MeshCentral project", product_vendor)
| alter tool_family = if(detected_product = "Splashtop", "Remote Access", tool_family), product_vendor = if(detected_product = "Splashtop", "Splashtop", product_vendor)
| alter tool_family = if(detected_product = "DWService / DWAgent", "Remote Access", tool_family), product_vendor = if(detected_product = "DWService / DWAgent", "DWService project", product_vendor)
| alter tool_family = if(detected_product = "Nmap", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Nmap", "Nmap Project", product_vendor)
| alter tool_family = if(detected_product = "Ncat", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Ncat", "Nmap Project", product_vendor)
| alter tool_family = if(detected_product = "Wireshark / TShark", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Wireshark / TShark", "Wireshark Foundation", product_vendor)
| alter tool_family = if(detected_product = "tcpdump", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "tcpdump", "The Tcpdump Group", product_vendor)
| alter tool_family = if(detected_product = "hashcat", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "hashcat", "hashcat project", product_vendor)
| alter tool_family = if(detected_product = "John the Ripper", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "John the Ripper", "Openwall project", product_vendor)
| alter tool_family = if(detected_product = "Mimikatz", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Mimikatz", "Benjamin Delpy / gentilkiwi", product_vendor)
| alter tool_family = if(detected_product = "SharpHound", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "SharpHound", "SpecterOps", product_vendor)
| alter tool_family = if(detected_product = "Impacket", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Impacket", "Fortra / Core Security", product_vendor)
| alter tool_family = if(detected_product = "Metasploit Framework", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Metasploit Framework", "Rapid7 and contributors", product_vendor)
| alter tool_family = if(detected_product = "Chisel", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Chisel", "jpillora / Chisel contributors", product_vendor)
| alter tool_family = if(detected_product = "Ligolo-ng", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "Ligolo-ng", "Nicolas Chatelain / Ligolo-ng contributors", product_vendor)
| alter tool_family = if(detected_product = "ProcDump", "Dual-Use Security Tools", tool_family), product_vendor = if(detected_product = "ProcDump", "Microsoft Sysinternals", product_vendor)
| filter detected_product != "UNMAPPED"

// REQUIRED: replace the sentinel with approved detected_product values for this scope.
// Approval also depends on host, user, version, purpose and time; product alone is insufficient.
| filter detected_product not in ("REPLACE_WITH_APPROVED_PRODUCT")
| fields
    endpoint_id,
    endpoint_name,
    platform,
    tool_family,
    detected_product,
    application_name,
    vendor as reported_vendor,
    product_vendor as expected_product_vendor,
    version,
    report_timestamp,
    install_date
| sort desc report_timestamp
| limit 1000
