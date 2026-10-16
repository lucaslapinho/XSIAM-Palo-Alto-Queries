config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "brave",
    "brave browser",
    "firefox",
    "google chrome",
    "microsoft edge",
    "mozilla firefox",
    "vivaldi"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Browsers"

| alter detected_product = if(
            application_name_normalized in ("brave", "brave browser"),
            "Brave Browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("brave", "brave browser"),
            "brave-browser",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "google chrome",
            "Google Chrome",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "google chrome",
            "google-chrome",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "microsoft edge",
            "Microsoft Edge",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "microsoft edge",
            "microsoft-edge",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("firefox", "mozilla firefox"),
            "Mozilla Firefox",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("firefox", "mozilla firefox"),
            "mozilla-firefox",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "vivaldi",
            "Vivaldi",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "vivaldi",
            "vivaldi",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
