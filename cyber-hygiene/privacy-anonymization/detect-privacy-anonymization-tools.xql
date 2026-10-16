config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "cryptomator",
    "i2p",
    "tor browser",
    "veracrypt"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Privacy / Anonymization Tools"

| alter detected_product = if(
            application_name_normalized = "cryptomator",
            "Cryptomator",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cryptomator",
            "cryptomator",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "i2p",
            "I2P",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "i2p",
            "i2p",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "tor browser",
            "Tor Browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "tor browser",
            "tor-browser",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "veracrypt",
            "VeraCrypt",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "veracrypt",
            "veracrypt",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
