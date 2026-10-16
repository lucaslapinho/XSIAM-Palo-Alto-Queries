config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "evernote",
    "joplin",
    "notion",
    "obsidian"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Personal Collaboration Tools"

| alter detected_product = if(
            application_name_normalized = "evernote",
            "Evernote",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "evernote",
            "evernote",
            product_id
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
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
