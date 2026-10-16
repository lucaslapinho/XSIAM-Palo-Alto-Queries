config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "core ftp le",
    "core ftp pro",
    "cuteftp",
    "cyberduck",
    "filezilla",
    "filezilla client",
    "filezilla server",
    "forklift",
    "freefilesync",
    "mountain duck",
    "rclone",
    "securefx",
    "smartftp",
    "transmit",
    "winscp"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "File Transfer Tools"

| alter detected_product = if(
            application_name_normalized in ("core ftp le", "core ftp pro"),
            "Core FTP client family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("core ftp le", "core ftp pro"),
            "core-ftp-client",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "cuteftp",
            "CuteFTP",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cuteftp",
            "cuteftp",
            product_id
        )

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
            application_name_normalized = "filezilla server",
            "FileZilla Server",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "filezilla server",
            "filezilla-server",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "forklift",
            "ForkLift",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "forklift",
            "forklift",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "freefilesync",
            "FreeFileSync",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "freefilesync",
            "freefilesync",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "mountain duck",
            "Mountain Duck",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mountain duck",
            "mountain-duck",
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
            application_name_normalized = "securefx",
            "SecureFX",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "securefx",
            "securefx",
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
            application_name_normalized = "transmit",
            "Transmit",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "transmit",
            "transmit",
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
