config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "docker desktop",
    "minikube",
    "podman desktop",
    "rancher desktop"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Containers"

| alter detected_product = if(
            application_name_normalized = "docker desktop",
            "Docker Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "docker desktop",
            "docker-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "minikube",
            "minikube",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "minikube",
            "minikube",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "podman desktop",
            "Podman Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "podman desktop",
            "podman-desktop",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "rancher desktop",
            "Rancher Desktop",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "rancher desktop",
            "rancher-desktop",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
