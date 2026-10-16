config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "git",
    "git for windows",
    "github desktop",
    "insomnia",
    "postman"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Developer Utilities"

| alter detected_product = if(
            application_name_normalized in ("git", "git for windows"),
            "Git for Windows",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("git", "git for windows"),
            "git-for-windows",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "github desktop",
            "GitHub Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "github desktop",
            "github-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "insomnia",
            "Insomnia",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "insomnia",
            "insomnia",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "postman",
            "Postman",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "postman",
            "postman",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
