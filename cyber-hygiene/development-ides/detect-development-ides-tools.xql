config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter (application_name != null) and (application_name != "")
| fields endpoint_name, platform, application_name, version
| alter application_name_normalized = lowercase(application_name)
| filter application_name_normalized in (
    "android studio",
    "intellij idea",
    "intellij idea community edition",
    "intellij idea ultimate edition",
    "microsoft visual studio code",
    "pycharm",
    "pycharm community edition",
    "pycharm professional edition",
    "sublime text",
    "visual studio code"
)

| alter detected_product = "UNMAPPED",
        product_id = "UNMAPPED",
        tool_family = "Development Tools / IDEs"

| alter detected_product = if(
            application_name_normalized = "android studio",
            "Android Studio",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "android studio",
            "android-studio",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("intellij idea", "intellij idea community edition", "intellij idea ultimate edition"),
            "IntelliJ IDEA",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("intellij idea", "intellij idea community edition", "intellij idea ultimate edition"),
            "intellij-idea",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("pycharm", "pycharm community edition", "pycharm professional edition"),
            "PyCharm",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("pycharm", "pycharm community edition", "pycharm professional edition"),
            "pycharm",
            product_id
        )

| alter detected_product = if(
            application_name_normalized = "sublime text",
            "Sublime Text",
            detected_product
        ),
        product_id = if(
            application_name_normalized = "sublime text",
            "sublime-text",
            product_id
        )

| alter detected_product = if(
            application_name_normalized in ("microsoft visual studio code", "visual studio code"),
            "Visual Studio Code",
            detected_product
        ),
        product_id = if(
            application_name_normalized in ("microsoft visual studio code", "visual studio code"),
            "visual-studio-code",
            product_id
        )

| filter product_id != "UNMAPPED"
| fields endpoint_name, platform, application_name, version, detected_product, product_id, tool_family
| limit 1000
