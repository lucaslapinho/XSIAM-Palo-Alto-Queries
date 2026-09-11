# Domain Controller Operational Event Timeline

Returns an approved set of replication, DNS, time and service events on hosts confirmed as domain controllers at event time. Joins exact provider/channel/event selections to prevent cross-provider event-ID collisions.

[Open query](n093-domain-controller-operational-event-timeline.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N093  
**Category:** Security Operations / Domain Controllers  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{APPROVED_DC_EVENT_SELECTION}}`, `{{DC_OPERATIONAL_EVENTS}}`, `{{DOMAIN_CONTROLLER_HISTORY}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{DC_OPERATIONAL_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{DC_EVENT_TIME}}` | DATETIME | DATETIME: original event time. |
| `{{DC_EVENT_ENDPOINT}}` | STRING | STRING: stable host identity. |
| `{{DC_EVENT_PROVIDER}}` | STRING | STRING: exact provider. |
| `{{DC_EVENT_CHANNEL}}` | STRING | STRING: exact Windows event channel. |
| `{{DC_EVENT_ID}}` | INTEGER | INTEGER: provider-specific event ID. |
| `{{DC_EVENT_LEVEL}}` | STRING | STRING: original level/importance. |
| `{{DC_EVENT_MESSAGE}}` | STRING | STRING: operational event detail. |
| `{{DOMAIN_CONTROLLER_HISTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{DC_INVENTORY_ENDPOINT}}` | STRING | STRING: verified DC endpoint key. |
| `{{DC_ROLE_VALID_FROM}}` | DATETIME | DATETIME: DC role validity start. |
| `{{DC_ROLE_VALID_UNTIL}}` | DATETIME | DATETIME: DC role validity end exclusive. |
| `{{APPROVED_DC_EVENT_SELECTION}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{SELECTED_PROVIDER}}` | STRING | STRING: approved provider for replication/DNS/time/service review. |
| `{{SELECTED_CHANNEL}}` | STRING | STRING: approved channel. |
| `{{SELECTED_EVENT_ID}}` | INTEGER | INTEGER: approved event ID for the provider/channel. |
| `{{SELECTED_PURPOSE}}` | STRING | STRING: operational interpretation, verified for applicable OS version. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- The event-selection inventory must be unique by provider/channel/event. No universal DC fault list or collection guarantee is assumed.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: selected event on a time-valid DC matches. | See scenario |
| Planned test | Negative: identical ID from a different provider or channel is excluded. | See scenario |
| Planned test | Null: unresolved host role is excluded rather than guessed. | See scenario |
| Planned test | Edge: a former DC event after demotion does not match the expired role. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
