config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "camtasia",
    "loom",
    "obs studio",
    "sharex",
    "snagit",
    "techsmith snagit"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Screen Recording / Capture"

| alter detected_product = if(
            application_name_normalized = "camtasia",
            "Camtasia",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "camtasia",
            "camtasia",
            product_id
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
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
