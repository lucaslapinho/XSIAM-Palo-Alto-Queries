config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "bluestacks",
    "bluestacks app player",
    "ccleaner",
    "internet download manager",
    "peazip",
    "revo uninstaller",
    "revo uninstaller pro"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Other Corporate-Risk / Shadow-IT Applications"

| alter detected_product = if(
            application_name_normalized in ("bluestacks", "bluestacks app player"),
            "BlueStacks",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("bluestacks", "bluestacks app player"),
            "bluestacks",
            product_id
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
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
