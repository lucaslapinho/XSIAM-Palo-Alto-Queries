config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "cyberduck",
    "filezilla",
    "filezilla client",
    "rclone",
    "smartftp",
    "winscp"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "File Transfer Tools"

| alter detected_product = if(
            application_name_normalized = "cyberduck",
            "Cyberduck",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cyberduck",
            "cyberduck",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("filezilla", "filezilla client"),
            "FileZilla Client",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("filezilla", "filezilla client"),
            "filezilla-client",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "rclone",
            "rclone",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "rclone",
            "rclone",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "smartftp",
            "SmartFTP",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "smartftp",
            "smartftp",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "winscp",
            "WinSCP",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "winscp",
            "winscp",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
