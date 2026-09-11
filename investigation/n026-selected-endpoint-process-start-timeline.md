# Selected Endpoint Process Start Timeline

Returns the newest 1000 process-start records within one day for a required stable endpoint ID, with started-process command line, user, hash, signature and initiating-process context. Ordering describes observed timestamps and does not reconstruct ancestry, process lifetime or current running state.

[Open query](n026-selected-endpoint-process-start-timeline.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N026  
**Category:** Investigation / Process Activity  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One process-start telemetry row ordered newest first; not a process tree or a current-process inventory.

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
- Actor fields represent the initiating process; a direct-parent relationship is not asserted.
- Timestamp ties are not ordered and _time may include insertion-time fallback.
- Selected data and fields are accessible under the analyst role and retained in the one-day window.
- No full-query compilation, returned results or deployment is claimed.
- Missing fields, collection, access or retention can produce incomplete or empty results.
- Endpoint association does not prove exclusive agent-source provenance.
- A result is investigation context and not a maliciousness verdict.

**Benign matches:** Routine service, user and administrative process starts remain visible by design.

**Possible misses:** Misses starts outside the selected day, older rows beyond the result cap, missing collection and inaccessible endpoint telemetry.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

## Investigation pivots

- Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample.
- Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results.
- Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.
