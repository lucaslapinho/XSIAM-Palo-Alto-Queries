config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "1password",
    "bitwarden",
    "keepass password safe",
    "keepass password safe 2",
    "keepassxc"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Password Managers"

| alter detected_product = if(
            application_name_normalized = "1password",
            "1Password",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "1password",
            "1password",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "bitwarden",
            "Bitwarden",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bitwarden",
            "bitwarden",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("keepass password safe", "keepass password safe 2"),
            "KeePass Password Safe",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("keepass password safe", "keepass password safe 2"),
            "keepass",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "keepassxc",
            "KeePassXC",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "keepassxc",
            "keepassxc",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
