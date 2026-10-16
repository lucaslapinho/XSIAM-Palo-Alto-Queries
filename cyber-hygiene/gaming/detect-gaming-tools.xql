config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "battle.net",
    "blizzard battle.net",
    "ea app",
    "epic games launcher",
    "gog galaxy",
    "steam",
    "ubisoft connect"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Gaming Platforms"

| alter detected_product = if(
            application_name_normalized in ("battle.net", "blizzard battle.net"),
            "Battle.net",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("battle.net", "blizzard battle.net"),
            "battle-net",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "ea app",
            "EA app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ea app",
            "ea-app",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "epic games launcher",
            "Epic Games Launcher",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "epic games launcher",
            "epic-games-launcher",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "gog galaxy",
            "GOG GALAXY",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "gog galaxy",
            "gog-galaxy",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "steam",
            "Steam",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "steam",
            "steam",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "ubisoft connect",
            "Ubisoft Connect",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ubisoft connect",
            "ubisoft-connect",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
