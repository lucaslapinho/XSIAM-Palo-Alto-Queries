# Latest Local Administrators Membership Snapshot

Lists direct members of the built-in local Administrators group from the latest complete membership snapshot per endpoint. Preserves explicit empty snapshots and excludes domain controllers; nested effective membership requires a separate directory expansion.

[Open query](n087-latest-local-administrators-membership-snapshot.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N087  
**Category:** Asset Visibility / Local Privileges  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{LOCAL_MEMBERSHIP_SNAPSHOTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{LOCAL_MEMBERSHIP_SNAPSHOTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{MEMBERSHIP_ENDPOINT_ID}}` | STRING | STRING: stable endpoint ID; exclude domain controllers for workstation/member-server local membership scope. |
| `{{MEMBERSHIP_SNAPSHOT_TIME}}` | DATETIME | DATETIME: time of a complete snapshot; all member rows share this value. |
| `{{MEMBERSHIP_SNAPSHOT_COMPLETE}}` | BOOLEAN | BOOLEAN: true only when the complete local-group snapshot was collected, including explicit empty groups. |
| `{{MEMBERSHIP_ENDPOINT_ROLE}}` | STRING | STRING: normalized workstation/member_server/domain_controller role, time-valid at snapshot. |
| `{{LOCAL_GROUP_SID}}` | STRING | STRING: local group SID; preserve canonical SID spelling. |
| `{{LOCAL_MEMBER_SID}}` | STRING nullable | STRING nullable: direct member SID; null represents a deliberately empty group snapshot, not missing telemetry. |
| `{{LOCAL_MEMBER_NAME}}` | STRING nullable | STRING nullable: resolved display name. |
| `{{LOCAL_MEMBER_KIND}}` | STRING | STRING: user/group; nested expansion is not performed by this query. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Only complete snapshots in the seven-day window are eligible; no eligible snapshot means unknown, not an empty group.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: latest complete group snapshot contains a user and group; return both. | See scenario |
| Planned test | Negative: a removed member appears only in an older snapshot; exclude it. | See scenario |
| Planned test | Null: explicit empty newest snapshot must not resurrect an old member. | See scenario |
| Planned test | Edge: exclude a domain controller even though its Builtin Administrators SID matches. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Well-known built-in group SID semantics](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab)
- [Latest complete snapshot selection without collapsing member rows](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/windowcomp)
