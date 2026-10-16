config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "bitcoin core",
    "electrum",
    "monero gui wallet",
    "nicehash miner",
    "xmrig"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Crypto / Mining Tools"

| alter detected_product = if(
            application_name_normalized = "bitcoin core",
            "Bitcoin Core",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bitcoin core",
            "bitcoin-core",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "electrum",
            "Electrum",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "electrum",
            "electrum",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "monero gui wallet",
            "Monero GUI Wallet",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "monero gui wallet",
            "monero-gui-wallet",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "nicehash miner",
            "NiceHash Miner",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nicehash miner",
            "nicehash-miner",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "xmrig",
            "XMRig",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "xmrig",
            "xmrig",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
