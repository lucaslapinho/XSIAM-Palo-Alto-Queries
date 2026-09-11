# Data Source Freshness and Interval Volume

Shows per-source ingestion volume, delay metrics and last-log age from metrics_view over one day. Keeps source identity dimensions and zero intervals supplied by the preset; freshness and volume require comparison with each source collection schedule.

[Open query](n098-data-source-freshness-and-interval-volume.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N098  
**Category:** Security Operations / Ingestion Health  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `preset:metrics_view`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Check that the listed sources and fields are available to your analyst account. Review image-name lists, filters and the lookback against your environment.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- metrics_view synthesizes zero metrics for eligible sources; it does not establish the existence of a source never configured or observed. Delay buckets are approximate, and the result cap can omit intervals.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: populated source interval exposes count, bytes and freshness. | See scenario |
| Planned test | Negative: no claim of failure is made solely from a low-volume interval. | See scenario |
| Planned test | Null: last_seen absent leaves age unknown. | See scenario |
| Planned test | Edge: zero interval is retained; identical product names with different collector IDs remain separate. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official XSIAM metrics_view schema, zero interval behavior and units](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/configure-cortex-xsiam/cortex-xsiam-data-sources/administration-and-troubleshooting/overview-of-data-ingestion-metrics)
