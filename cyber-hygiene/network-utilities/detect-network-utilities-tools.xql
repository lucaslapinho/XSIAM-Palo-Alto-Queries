config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "advanced ip scanner",
    "angry ip scanner",
    "fiddler everywhere",
    "iperf3",
    "wireshark"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Network Utilities"

| alter detected_product = if(
            application_name_normalized = "advanced ip scanner",
            "Advanced IP Scanner",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "advanced ip scanner",
            "advanced-ip-scanner",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "angry ip scanner",
            "Angry IP Scanner",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "angry ip scanner",
            "angry-ip-scanner",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "fiddler everywhere",
            "Fiddler Everywhere",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "fiddler everywhere",
            "fiddler-everywhere",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "iperf3",
            "iperf3",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "iperf3",
            "iperf3",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "wireshark",
            "Wireshark",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "wireshark",
            "wireshark",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
