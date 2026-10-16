config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "aider",
    "claude code",
    "continue",
    "cursor",
    "devin desktop",
    "windsurf"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "AI Development Tools"

| alter detected_product = if(
            application_name_normalized = "aider",
            "Aider",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "aider",
            "aider",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "claude code",
            "Claude Code",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "claude code",
            "claude-code",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "continue",
            "Continue",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "continue",
            "continue",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "cursor",
            "Cursor",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cursor",
            "cursor",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("devin desktop", "windsurf"),
            "Windsurf / Devin Desktop family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("devin desktop", "windsurf"),
            "windsurf-devin-desktop",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
