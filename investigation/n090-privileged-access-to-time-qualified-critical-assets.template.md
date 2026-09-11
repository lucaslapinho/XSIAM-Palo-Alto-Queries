# Privileged Access to Time-Qualified Critical Assets

Correlates successful asset-access records with effective privileged entitlements and critical-asset classification valid at the event time. Requires explicit identity and asset contracts and returns entitlement context without assuming that every privileged access is inappropriate.

[Open query](n090-privileged-access-to-time-qualified-critical-assets.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N090  
**Category:** Investigation / Privileged Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{ASSET_ACCESS_EVENTS}}`, `{{CRITICAL_ASSET_HISTORY}}`, `{{PRIVILEGED_ENTITLEMENT_HISTORY}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{ASSET_ACCESS_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{ACCESS_TIME}}` | DATETIME | DATETIME: actual asset/service access timestamp. |
| `{{ACCESS_EVENT_KEY}}` | STRING | STRING: stable access-record identity. |
| `{{ACCESS_PRINCIPAL_ID}}` | STRING | STRING: stable authority-qualified principal. |
| `{{ACCESS_ASSET_ID}}` | STRING | STRING: stable asset identity, not a hostname-only guess. |
| `{{ACCESS_ACTION}}` | STRING | STRING: original authenticated access operation. |
| `{{ACCESS_SUCCESS}}` | BOOLEAN | BOOLEAN: verified successful access outcome; null remains unknown. |
| `{{PRIVILEGED_ENTITLEMENT_HISTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{PRIVILEGED_PRINCIPAL_ID}}` | STRING | STRING: same authority-qualified principal namespace as access. |
| `{{PRIVILEGED_ASSET_ID}}` | STRING | STRING: entitlement scope resolved to a specific asset. |
| `{{PRIVILEGE_VALID_FROM}}` | DATETIME | DATETIME: entitlement validity start inclusive. |
| `{{PRIVILEGE_VALID_UNTIL}}` | DATETIME | DATETIME: entitlement validity end exclusive; bind an explicit future bound for open intervals. |
| `{{PRIVILEGE_ROLE}}` | STRING | STRING: reviewed effective privileged entitlement. |
| `{{CRITICAL_ASSET_HISTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{CRITICAL_ASSET_ID}}` | STRING | STRING: same stable asset namespace. |
| `{{CRITICAL_VALID_FROM}}` | DATETIME | DATETIME: criticality validity start inclusive. |
| `{{CRITICAL_VALID_UNTIL}}` | DATETIME | DATETIME: criticality validity end exclusive. |
| `{{CRITICAL_OWNER}}` | STRING | STRING: accountable asset owner. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Inventory history must be unique per entitlement interval; do not apply current privileges retrospectively.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: access during both privilege and criticality validity intervals matches. | See scenario |
| Planned test | Negative: failed access or expired privilege is excluded. | See scenario |
| Planned test | Null: missing principal or asset identity cannot match. | See scenario |
| Planned test | Edge: current privilege granted after the event must not reclassify that event. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
