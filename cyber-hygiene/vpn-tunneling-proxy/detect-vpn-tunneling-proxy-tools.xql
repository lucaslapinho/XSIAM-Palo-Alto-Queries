config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "cisco anyconnect secure mobility client",
    "cisco secure client",
    "globalprotect",
    "ngrok",
    "openvpn connect",
    "tailscale",
    "wireguard"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "VPN / Tunneling / Proxy"

| alter detected_product = if(
            application_name_normalized in ("cisco anyconnect secure mobility client", "cisco secure client"),
            "Cisco Secure Client",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("cisco anyconnect secure mobility client", "cisco secure client"),
            "cisco-secure-client",
            product_id
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
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
