config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "anydesk",
    "connectwise control",
    "realvnc connect",
    "realvnc server",
    "realvnc viewer",
    "rustdesk",
    "screenconnect",
    "screenconnect client",
    "splashtop streamer",
    "teamviewer",
    "teamviewer host",
    "teamviewer quicksupport"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Remote Access / Remote Administration"

| alter detected_product = if(
            application_name_normalized = "anydesk",
            "AnyDesk",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "anydesk",
            "anydesk",
            product_id
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
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
