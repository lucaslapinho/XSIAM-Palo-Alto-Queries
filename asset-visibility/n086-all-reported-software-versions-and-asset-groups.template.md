# All Reported Software Versions and Asset Groups

Lists all reported applications, vendors and versions from each endpoint's authoritative latest nonempty application snapshot and enriches actual asset-group membership. Explicitly empty latest reports do not revive older applications.

[Open query](n086-all-reported-software-versions-and-asset-groups.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N086  
**Category:** Asset Visibility / Software Inventory  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

General all-software inventory, not the earlier mapped-tool subset. Exact latest snapshot state including empty reports and group membership remain required bindings.

## Data and setup

**Sources:** `host_inventory_applications`, `{{APPLICATION_SNAPSHOT_STATE_DATASET}}`, `{{ENDPOINT_GROUP_MEMBERSHIP_DATASET}}`.

**Lookback:** `30d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{APPLICATION_SNAPSHOT_STATE_DATASET}}` | XQL dataset identifier | Actual read-only source for APPLICATION_SNAPSHOT_STATE. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{APPLICATION_SNAPSHOT_STATE_SNAPSHOT_ENDPOINT}}` | STRING scalar expression | Endpoint identity matching host_inventory_applications.endpoint_id Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{APPLICATION_SNAPSHOT_STATE_SNAPSHOT_TIME}}` | DATETIME scalar expression | Actual latest application snapshot timestamp including empty reports; one current row per endpoint Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{APPLICATION_SNAPSHOT_STATE_SNAPSHOT_EMPTY}}` | BOOLEAN scalar expression | True only when the actual latest report explicitly contains zero applications Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ENDPOINT_GROUP_MEMBERSHIP_DATASET}}` | XQL dataset identifier | Actual read-only source for ENDPOINT_GROUP_MEMBERSHIP. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{ENDPOINT_GROUP_MEMBERSHIP_GROUP_ENDPOINT}}` | STRING scalar expression | Same endpoint identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ENDPOINT_GROUP_MEMBERSHIP_GROUP_NAME}}` | STRING scalar expression | Actual human-readable asset group name; one row per membership Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ENDPOINT_GROUP_MEMBERSHIP_GROUP_ID}}` | STRING scalar expression | Actual asset group ID normalized without identity collisions Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Endpoints with an empty latest snapshot have zero application rows by design; use the supplied snapshot-state inventory to distinguish empty from absent collection.
- One software row can expand across multiple group memberships. Snapshot/group applicability and identity joins must be validated; installed reports do not prove execution.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Latest snapshot has unlisted ordinary software with a vendor/version and two groups | Software appears in both group contexts even though not in a tool taxonomy. |
| negative | Older report contains software removed in a newer nonempty report | Older software rows excluded. |
| null | Latest nonempty software row has no vendor or group membership | Application remains with null enrichment. |
| edge | Latest application snapshot is explicitly empty, while a prior report had software | No stale application rows are returned. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for OP-016](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for OP-016](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for OP-016](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for OP-016](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for OP-016](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for OP-016](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
