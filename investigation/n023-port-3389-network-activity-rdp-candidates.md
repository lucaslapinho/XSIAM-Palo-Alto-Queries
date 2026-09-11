# Port 3389 Network Activity - RDP Candidates

Returns endpoint-associated TCP or UDP network records with local or remote port 3389 over one day, including direction, protocol and initiating-process context. The port identifies RDP candidates only; records do not establish an authenticated session, application identity or unauthorized access.

[Open query](n023-port-3389-network-activity-rdp-candidates.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N023  
**Category:** Investigation / Network Activity  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One network event row with a port-3389 tuple; no session reconstruction.

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

- Local and remote tuples retain their native endpoint perspective.
- Network success does not mean successful sign-in.
- An agent ID establishes endpoint association, not exclusive EDR provenance.
- Selected data and fields are accessible under the analyst role and retained in the one-day window.
- No full-query compilation, returned results or deployment is claimed.
- Missing fields, collection, access or retention can produce incomplete or empty results.
- Endpoint association does not prove exclusive agent-source provenance.
- A result is investigation context and not a maliciousness verdict.

**Benign matches:** Approved RDP, unrelated software on port 3389 and repeated network-operation records can appear.

**Possible misses:** Misses RDP on alternative ports, tunnel/gateway traffic without this tuple, missing agent association and incomplete network telemetry.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

## Investigation pivots

- Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample.
- Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results.
- Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.
