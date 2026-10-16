config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "facebook",
    "instagram",
    "reddit",
    "tiktok"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Social Applications"

| alter detected_product = if(
            application_name_normalized = "facebook",
            "Facebook",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "facebook",
            "facebook",
            product_id
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
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
