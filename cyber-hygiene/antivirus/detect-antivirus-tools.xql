config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "avast free antivirus",
    "avg antivirus free",
    "clamav",
    "eset nod32 antivirus"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Antivirus"

| alter detected_product = if(
            application_name_normalized = "avast free antivirus",
            "Avast Free Antivirus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avast free antivirus",
            "avast-free-antivirus",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "avg antivirus free",
            "AVG AntiVirus FREE",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avg antivirus free",
            "avg-antivirus-free",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "clamav",
            "ClamAV",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "clamav",
            "clamav",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "eset nod32 antivirus",
            "ESET NOD32 Antivirus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "eset nod32 antivirus",
            "eset-nod32",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
