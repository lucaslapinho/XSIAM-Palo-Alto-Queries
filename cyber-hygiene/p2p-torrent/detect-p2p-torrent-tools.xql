config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "bittorrent classic",
    "deluge",
    "qbittorrent",
    "transmission"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "P2P / Torrent"

| alter detected_product = if(
            application_name_normalized = "bittorrent classic",
            "BitTorrent Classic",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bittorrent classic",
            "bittorrent-classic",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "deluge",
            "Deluge",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "deluge",
            "deluge",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "qbittorrent",
            "qBittorrent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "qbittorrent",
            "qbittorrent",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "transmission",
            "Transmission",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "transmission",
            "transmission",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
