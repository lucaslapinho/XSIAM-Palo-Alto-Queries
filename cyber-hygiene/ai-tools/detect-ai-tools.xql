config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "anythingllm",
    "anythingllm desktop",
    "boltai",
    "chatall",
    "chatbox",
    "chatbox ai",
    "chatgpt",
    "chatwise",
    "cherry studio",
    "claude",
    "jan",
    "microsoft 365 copilot",
    "microsoft copilot",
    "mindmac",
    "perplexity",
    "poe"
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
            application_name_normalized = "boltai",
            "BoltAI",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "boltai",
            "boltai",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "chatall",
            "ChatALL",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "chatall",
            "chatall",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("chatbox", "chatbox ai"),
            "Chatbox AI",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("chatbox", "chatbox ai"),
            "chatbox",
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
            application_name_normalized = "chatwise",
            "ChatWise",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "chatwise",
            "chatwise",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "cherry studio",
            "Cherry Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "cherry studio",
            "cherry-studio",
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

| alter detected_product = if(
            application_name_normalized in ("microsoft 365 copilot", "microsoft copilot"),
            "Microsoft Copilot app family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("microsoft 365 copilot", "microsoft copilot"),
            "microsoft-copilot-app",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "mindmac",
            "MindMac",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mindmac",
            "mindmac",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "perplexity",
            "Perplexity desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "perplexity",
            "perplexity-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "poe",
            "Poe desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "poe",
            "poe",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
