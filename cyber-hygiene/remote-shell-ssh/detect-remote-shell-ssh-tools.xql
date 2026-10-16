config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "mobaxterm",
    "mobaxterm personal edition",
    "mobaxterm professional edition",
    "openssh",
    "openssh client",
    "openssh server",
    "putty",
    "securecrt",
    "termius"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Remote Shell / SSH Tools"

| alter detected_product = if(
            application_name_normalized in ("mobaxterm", "mobaxterm personal edition", "mobaxterm professional edition"),
            "MobaXterm",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("mobaxterm", "mobaxterm personal edition", "mobaxterm professional edition"),
            "mobaxterm",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("openssh", "openssh client", "openssh server"),
            "OpenSSH",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("openssh", "openssh client", "openssh server"),
            "openssh",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "putty",
            "PuTTY",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "putty",
            "putty",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "securecrt",
            "SecureCRT",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "securecrt",
            "securecrt",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "termius",
            "Termius",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "termius",
            "termius",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
