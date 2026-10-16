config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "acunetix",
    "bloodhound community edition",
    "burp suite community edition",
    "burp suite professional",
    "hashcat",
    "invicti standard",
    "invicti web + api",
    "maltego",
    "metasploit framework",
    "mitmproxy",
    "nessus",
    "netsparker standard",
    "nikto",
    "nmap",
    "sqlmap",
    "zap",
    "zed attack proxy"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Penetration Testing / Dual-Use Security Tools"

| alter detected_product = if(
            application_name_normalized in ("acunetix", "invicti web + api"),
            "Acunetix / Invicti Web + API family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("acunetix", "invicti web + api"),
            "acunetix-invicti-web",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "bloodhound community edition",
            "BloodHound Community Edition",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "bloodhound community edition",
            "bloodhound-community",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("burp suite community edition", "burp suite professional"),
            "Burp Suite",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("burp suite community edition", "burp suite professional"),
            "burp-suite",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "hashcat",
            "hashcat",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "hashcat",
            "hashcat",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("invicti standard", "netsparker standard"),
            "Invicti Standard / Netsparker Standard family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("invicti standard", "netsparker standard"),
            "invicti-standard",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "maltego",
            "Maltego",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "maltego",
            "maltego",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "metasploit framework",
            "Metasploit Framework",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "metasploit framework",
            "metasploit-framework",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "mitmproxy",
            "mitmproxy",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mitmproxy",
            "mitmproxy",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "nikto",
            "Nikto",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nikto",
            "nikto",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "nmap",
            "Nmap",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nmap",
            "nmap",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "sqlmap",
            "sqlmap",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sqlmap",
            "sqlmap",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "nessus",
            "Tenable Nessus",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "nessus",
            "tenable-nessus",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("zap", "zed attack proxy"),
            "ZAP / Zed Attack Proxy family",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("zap", "zed attack proxy"),
            "zap",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
