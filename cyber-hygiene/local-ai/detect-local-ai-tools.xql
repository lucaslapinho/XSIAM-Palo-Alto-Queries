config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "alpaca",
    "backyard ai",
    "comfy desktop",
    "comfyui",
    "faraday",
    "freechat",
    "gpt4all",
    "llama.cpp",
    "lm studio",
    "msty studio",
    "ollama",
    "pinokio",
    "private llm",
    "recursechat",
    "stability matrix"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Local AI / LLM Runtimes"

| alter detected_product = if(
            application_name_normalized = "alpaca",
            "Alpaca",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "alpaca",
            "alpaca",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("backyard ai", "faraday"),
            "Backyard AI / Faraday legacy desktop family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("backyard ai", "faraday"),
            "backyard-ai-legacy",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("comfy desktop", "comfyui"),
            "ComfyUI / Comfy Desktop family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("comfy desktop", "comfyui"),
            "comfyui-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "freechat",
            "FreeChat",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "freechat",
            "freechat",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "gpt4all",
            "GPT4All",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "gpt4all",
            "gpt4all",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "llama.cpp",
            "llama.cpp",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "llama.cpp",
            "llama-cpp",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "lm studio",
            "LM Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "lm studio",
            "lm-studio",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "msty studio",
            "Msty Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "msty studio",
            "msty-studio",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "ollama",
            "Ollama",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "ollama",
            "ollama",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "pinokio",
            "Pinokio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "pinokio",
            "pinokio",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "private llm",
            "Private LLM",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "private llm",
            "private-llm",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "recursechat",
            "RecurseChat",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "recursechat",
            "recursechat",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "stability matrix",
            "Stability Matrix",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "stability matrix",
            "stability-matrix",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
