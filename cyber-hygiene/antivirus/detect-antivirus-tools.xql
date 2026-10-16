config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "avast free antivirus",
    "avg antivirus free",
    "avira security",
    "bitdefender antivirus plus",
    "bitdefender total security",
    "clamav",
    "emsisoft anti-malware home",
    "eset endpoint antivirus",
    "eset endpoint security",
    "eset nod32 antivirus",
    "f-secure total",
    "kaspersky endpoint security for windows",
    "malwarebytes",
    "malwarebytes premium",
    "mcafee total protection",
    "norton 360",
    "norton 360 deluxe",
    "panda dome",
    "panda dome free",
    "trend micro maximum security"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Antivirus"

| alter detected_product = if(
            application_name_normalized = "avast free antivirus",
            "Avast Free Antivirus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avast free antivirus",
            "avast-free-antivirus",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "avg antivirus free",
            "AVG AntiVirus FREE",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avg antivirus free",
            "avg-antivirus-free",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "avira security",
            "Avira Security",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "avira security",
            "avira-security",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("bitdefender antivirus plus", "bitdefender total security"),
            "Bitdefender consumer security family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("bitdefender antivirus plus", "bitdefender total security"),
            "bitdefender-consumer",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "clamav",
            "ClamAV",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "clamav",
            "clamav",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "emsisoft anti-malware home",
            "Emsisoft Anti-Malware Home",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "emsisoft anti-malware home",
            "emsisoft-anti-malware",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("eset endpoint antivirus", "eset endpoint security"),
            "ESET endpoint protection family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("eset endpoint antivirus", "eset endpoint security"),
            "eset-endpoint-protection",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "eset nod32 antivirus",
            "ESET NOD32 Antivirus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "eset nod32 antivirus",
            "eset-nod32",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "f-secure total",
            "F-Secure Total",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "f-secure total",
            "f-secure-total",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "kaspersky endpoint security for windows",
            "Kaspersky Endpoint Security for Windows",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "kaspersky endpoint security for windows",
            "kaspersky-endpoint-windows",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("malwarebytes", "malwarebytes premium"),
            "Malwarebytes consumer family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("malwarebytes", "malwarebytes premium"),
            "malwarebytes-consumer",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "mcafee total protection",
            "McAfee Total Protection",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mcafee total protection",
            "mcafee-total-protection",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("norton 360", "norton 360 deluxe"),
            "Norton 360 family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("norton 360", "norton 360 deluxe"),
            "norton-360",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("panda dome", "panda dome free"),
            "Panda Dome family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("panda dome", "panda dome free"),
            "panda-dome",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "trend micro maximum security",
            "Trend Micro Maximum Security",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "trend micro maximum security",
            "trend-micro-maximum-security",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
