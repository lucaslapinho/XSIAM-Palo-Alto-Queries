# Successful Uploads to Externally Owned Cloud Storage

Selects successful object-upload/write events with measured outbound volume and confirmed external destination ownership. Requires upload-capable proxy, CASB or storage data-event telemetry; an observed storage domain or TLS connection is insufficient.

[Open query](n065-successful-uploads-to-externally-owned-cloud-storage.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N065  
**Category:** Threat Hunting / Cloud Transfers  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{CLOUD_STORAGE_UPLOAD_EVENTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MIN_UPLOAD_BYTES}}` | Positive INTEGER literal | Positive INTEGER literal: reviewed minimum outbound object/request byte volume. |
| `{{CLOUD_STORAGE_UPLOAD_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{UPLOAD_TIME}}` | DATETIME | DATETIME: source upload/write event time. |
| `{{UPLOAD_PRINCIPAL}}` | STRING | STRING: stable uploading principal. |
| `{{UPLOAD_ENDPOINT}}` | STRING nullable | STRING nullable: attributed endpoint. |
| `{{UPLOAD_SERVICE}}` | STRING | STRING: identified storage service, not domain suffix alone. |
| `{{UPLOAD_DESTINATION_ACCOUNT}}` | STRING | STRING: actual destination tenant/account/bucket owner. |
| `{{UPLOAD_DESTINATION_OWNED}}` | BOOLEAN | BOOLEAN: false only when authoritative ownership data confirms an external account; unknown must remain null. |
| `{{UPLOAD_OPERATION}}` | STRING | STRING: normalized object_upload/object_write from real request semantics. |
| `{{UPLOAD_SUCCESS}}` | BOOLEAN | BOOLEAN: successful write outcome. |
| `{{UPLOAD_OBJECT_ID}}` | STRING | STRING: non-secret object/resource identifier. |
| `{{UPLOAD_OUTBOUND_BYTES}}` | INTEGER | INTEGER: actual uploaded/request bytes, not response/download bytes. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Multipart parts and final object events must have documented counting semantics. Unknown destination ownership is excluded for separate review.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: successful measured upload to confirmed external account meets threshold. | See scenario |
| Planned test | Negative: a download or failed upload is excluded. | See scenario |
| Planned test | Null: unknown ownership does not become external. | See scenario |
| Planned test | Edge: do not count both part-level and object-total bytes as independent transfer volume. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [S3 data-operation logging and collection boundaries](https://docs.aws.amazon.com/AmazonS3/latest/userguide/cloudtrail-logging-s3-info.html)
