# Selected Endpoint Network Event Timeline

Returns the newest 1000 network records within one day for a required stable endpoint ID, preserving local and remote tuples, operation subtype, direction, success flag and initiating-process context. This is an observation timeline rather than a reconstruction of unique sessions or firewall decisions.

[Open query](n024-selected-endpoint-network-event-timeline.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N024  
**Category:** Investigation / Network Activity  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One network event row ordered by its observed _time; timestamp ties have no guaranteed order.

## Data and setup

**Sources:** `xdr_data`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Check that the listed sources and fields are available to your analyst account. Review image-name lists, filters and the lookback against your environment.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- REQUIRED parameter: replace AGENT_ID_TO_REVIEW with the intended stable endpoint ID.
- Connection ID uniqueness and lifetime have not been established; no deduplication is applied.
- Network success is not a firewall allow/deny action or authenticated session result.
- Selected data and fields are accessible under the analyst role and retained in the one-day window.
- No full-query compilation, returned results or deployment is claimed.
- Missing fields, collection, access or retention can produce incomplete or empty results.
- Endpoint association does not prove exclusive agent-source provenance.
- A result is investigation context and not a maliciousness verdict.

**Benign matches:** Expected background services and routine traffic remain in this broad investigative timeline.

**Possible misses:** Rows outside the selected endpoint/day, beyond the newest 1000 results, or absent from accessible telemetry are not shown.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

## Investigation pivots

- Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample.
- Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results.
- Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.
