config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "oracle virtualbox",
    "oracle vm virtualbox",
    "parallels desktop",
    "qemu",
    "vmware workstation",
    "vmware workstation pro"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Virtualization"

| alter detected_product = if(
            application_name_normalized in ("oracle virtualbox", "oracle vm virtualbox"),
            "Oracle VirtualBox",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("oracle virtualbox", "oracle vm virtualbox"),
            "virtualbox",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "parallels desktop",
            "Parallels Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "parallels desktop",
            "parallels-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "qemu",
            "QEMU",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "qemu",
            "qemu",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("vmware workstation", "vmware workstation pro"),
            "VMware Workstation Pro",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("vmware workstation", "vmware workstation pro"),
            "vmware-workstation",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
