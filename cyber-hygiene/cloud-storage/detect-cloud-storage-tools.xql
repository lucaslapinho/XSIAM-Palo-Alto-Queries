config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "dropbox",
    "google drive",
    "google drive for desktop",
    "microsoft onedrive",
    "syncthing"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Cloud Storage / File Synchronization"

| alter detected_product = if(
            application_name_normalized = "dropbox",
            "Dropbox desktop app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "dropbox",
            "dropbox",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("google drive", "google drive for desktop"),
            "Google Drive for desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("google drive", "google drive for desktop"),
            "google-drive-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "microsoft onedrive",
            "Microsoft OneDrive",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "microsoft onedrive",
            "onedrive",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "syncthing",
            "Syncthing",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "syncthing",
            "syncthing",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
