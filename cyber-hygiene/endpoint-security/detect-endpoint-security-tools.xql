config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "cortex xdr",
    "cortex xdr agent",
    "crowdstrike falcon sensor",
    "microsoft defender for endpoint",
    "sentinelone agent"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "EDR / Endpoint Security"

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

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
