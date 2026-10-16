config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "anydesk",
    "connectwise control",
    "dwagent",
    "goto resolve",
    "hoptodesk",
    "logmein resolve",
    "meshagent",
    "meshcentral agent",
    "mremoteng",
    "nomachine",
    "parsec",
    "realvnc connect",
    "realvnc server",
    "realvnc viewer",
    "remote utilities host",
    "remote utilities viewer",
    "rustdesk",
    "screenconnect",
    "screenconnect client",
    "splashtop streamer",
    "teamviewer",
    "teamviewer host",
    "teamviewer quicksupport",
    "tightvnc",
    "ultravnc",
    "veyon",
    "zoho assist"
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
            application_name_normalized = "dwagent",
            "DWAgent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "dwagent",
            "dwagent",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "hoptodesk",
            "HopToDesk",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "hoptodesk",
            "hoptodesk",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("goto resolve", "logmein resolve"),
            "LogMeIn Resolve / GoTo Resolve family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("goto resolve", "logmein resolve"),
            "logmein-resolve",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("meshagent", "meshcentral agent"),
            "MeshCentral Agent family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("meshagent", "meshcentral agent"),
            "meshcentral-agent",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "mremoteng",
            "mRemoteNG",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mremoteng",
            "mremoteng",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "nomachine",
            "NoMachine",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nomachine",
            "nomachine",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "parsec",
            "Parsec",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "parsec",
            "parsec",
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
            application_name_normalized in ("remote utilities host", "remote utilities viewer"),
            "Remote Utilities Host / Viewer family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("remote utilities host", "remote utilities viewer"),
            "remote-utilities",
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

| alter detected_product = if(
            application_name_normalized = "tightvnc",
            "TightVNC",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "tightvnc",
            "tightvnc",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "ultravnc",
            "UltraVNC",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ultravnc",
            "ultravnc",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "veyon",
            "Veyon",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "veyon",
            "veyon",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "zoho assist",
            "Zoho Assist",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "zoho assist",
            "zoho-assist",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
