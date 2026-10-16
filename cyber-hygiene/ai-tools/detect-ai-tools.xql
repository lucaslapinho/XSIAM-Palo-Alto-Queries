config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "anythingllm",
    "anythingllm desktop",
    "chatgpt",
    "claude",
    "jan"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Artificial Intelligence Tools"

| alter detected_product = if(
            application_name_normalized in ("anythingllm", "anythingllm desktop"),
            "AnythingLLM Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("anythingllm", "anythingllm desktop"),
            "anythingllm",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "chatgpt",
            "ChatGPT desktop app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "chatgpt",
            "chatgpt-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "claude",
            "Claude desktop app",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "claude",
            "claude-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "jan",
            "Jan",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "jan",
            "jan",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
