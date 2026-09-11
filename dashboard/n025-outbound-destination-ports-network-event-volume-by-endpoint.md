# Outbound Destination Ports - Network Event Volume by Endpoint

Ranks outgoing endpoint-associated TCP and UDP network event rows by stable endpoint ID, IP protocol, remote port and operation subtype over one day. Keeps hostnames as context and excludes unknown direction or invalid ports; counts are event volume, not unique connections or identified applications.

[Open query](n025-outbound-destination-ports-network-event-volume-by-endpoint.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N025  
**Category:** Dashboard / Network Activity  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One group per agent_id, IP protocol, remote port and operation subtype; metric is count of admitted rows.

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

- This proposal is implemented as destination-port visibility; App-ID ranking requires separately verified application telemetry.
- For outgoing rows the remote port is the destination port; incoming rows are deliberately excluded.
- Hostname changes do not split stable endpoint groups; values preserves distinct observed labels.
- No connection-ID uniqueness or session-start subtype is assumed.
- Selected data and fields are accessible under the analyst role and retained in the one-day window.
- No full-query compilation, returned results or deployment is claimed.
- Missing fields, collection, access or retention can produce incomplete or empty results.
- Endpoint association does not prove exclusive agent-source provenance.
- A result is investigation context and not a maliciousness verdict.

**Benign matches:** Frequent authorized traffic and collection/statistics cadence can dominate the ranking.

**Possible misses:** Excludes incoming/unknown direction, absent agent IDs, invalid/null ports, non-TCP/UDP protocols and groups outside the top 100.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

## Investigation pivots

- Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample.
- Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results.
- Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.
