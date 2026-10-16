config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "dbeaver",
    "dbeaver community",
    "heidisql",
    "mysql workbench",
    "oracle sql developer",
    "pgadmin 4",
    "sql developer"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Database Clients"

| alter detected_product = if(
            application_name_normalized in ("dbeaver", "dbeaver community"),
            "DBeaver Community",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("dbeaver", "dbeaver community"),
            "dbeaver-community",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "heidisql",
            "HeidiSQL",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "heidisql",
            "heidisql",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "mysql workbench",
            "MySQL Workbench",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "mysql workbench",
            "mysql-workbench",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("oracle sql developer", "sql developer"),
            "Oracle SQL Developer",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("oracle sql developer", "sql developer"),
            "oracle-sql-developer",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "pgadmin 4",
            "pgAdmin 4",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "pgadmin 4",
            "pgadmin4",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
