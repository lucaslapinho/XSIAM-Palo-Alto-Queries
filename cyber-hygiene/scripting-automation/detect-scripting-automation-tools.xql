config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "autohotkey",
    "node.js",
    "powershell",
    "powershell 7",
    "python"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Scripting / Automation Tools"

| alter detected_product = if(
            application_name_normalized = "autohotkey",
            "AutoHotkey",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "autohotkey",
            "autohotkey",
            product_id
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
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
