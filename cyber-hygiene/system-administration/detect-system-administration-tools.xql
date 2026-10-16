config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "microsoft powertoys",
    "pdq deploy",
    "pdq inventory",
    "powertoys",
    "sysinternals suite",
    "windows admin center"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "System Administration Tools"

| alter detected_product = if(
            application_name_normalized in ("microsoft powertoys", "powertoys"),
            "Microsoft PowerToys",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("microsoft powertoys", "powertoys"),
            "microsoft-powertoys",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "pdq deploy",
            "PDQ Deploy",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "pdq deploy",
            "pdq-deploy",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "pdq inventory",
            "PDQ Inventory",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "pdq inventory",
            "pdq-inventory",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "sysinternals suite",
            "Sysinternals Suite",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sysinternals suite",
            "sysinternals-suite",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "windows admin center",
            "Windows Admin Center",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "windows admin center",
            "windows-admin-center",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
