config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "bitdefender endpoint security tools",
    "cortex xdr",
    "cortex xdr agent",
    "crowdstrike falcon sensor",
    "elastic agent",
    "microsoft defender for endpoint",
    "sentinelone agent",
    "sophos endpoint agent",
    "symantec endpoint protection"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "EDR / Endpoint Security"

| alter detected_product = if(
            application_name_normalized = "bitdefender endpoint security tools",
            "Bitdefender Endpoint Security Tools",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bitdefender endpoint security tools",
            "bitdefender-best",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("cortex xdr", "cortex xdr agent"),
            "Cortex XDR Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("cortex xdr", "cortex xdr agent"),
            "cortex-xdr-agent",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "crowdstrike falcon sensor",
            "CrowdStrike Falcon Sensor",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "crowdstrike falcon sensor",
            "crowdstrike-falcon-sensor",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "elastic agent",
            "Elastic Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "elastic agent",
            "elastic-agent",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "microsoft defender for endpoint",
            "Microsoft Defender for Endpoint",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "microsoft defender for endpoint",
            "microsoft-defender-endpoint",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "sentinelone agent",
            "SentinelOne Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sentinelone agent",
            "sentinelone-agent",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "sophos endpoint agent",
            "Sophos Endpoint Agent",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sophos endpoint agent",
            "sophos-endpoint-agent",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "symantec endpoint protection",
            "Symantec Endpoint Protection",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "symantec endpoint protection",
            "symantec-endpoint-protection",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
