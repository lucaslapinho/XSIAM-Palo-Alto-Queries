config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "arc",
    "brave",
    "brave browser",
    "chromium",
    "comet",
    "dia",
    "duckduckgo",
    "firefox",
    "floorp",
    "google chrome",
    "librewolf",
    "microsoft edge",
    "mozilla firefox",
    "opera",
    "opera gx",
    "safari",
    "vivaldi",
    "waterfox",
    "zen browser"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Browsers"

| alter detected_product = if(
            application_name_normalized = "arc",
            "Arc browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "arc",
            "arc-browser",
            product_id
        )

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
            application_name_normalized = "chromium",
            "Chromium",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "chromium",
            "chromium",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "comet",
            "Comet browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "comet",
            "comet-browser",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "dia",
            "Dia browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "dia",
            "dia-browser",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "duckduckgo",
            "DuckDuckGo browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "duckduckgo",
            "duckduckgo-browser",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "floorp",
            "Floorp",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "floorp",
            "floorp",
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
            application_name_normalized = "librewolf",
            "LibreWolf",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "librewolf",
            "librewolf",
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
            application_name_normalized in ("opera", "opera gx"),
            "Opera browser family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("opera", "opera gx"),
            "opera-browser",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "safari",
            "Safari",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "safari",
            "apple-safari",
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

| alter detected_product = if(
            application_name_normalized = "waterfox",
            "Waterfox",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "waterfox",
            "waterfox",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "zen browser",
            "Zen Browser",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "zen browser",
            "zen-browser",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
