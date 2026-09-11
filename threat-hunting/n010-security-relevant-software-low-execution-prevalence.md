# Security-Relevant Software - Low Execution Prevalence

Finds matched Windows tool products with process-start telemetry on at most three endpoint IDs in xdr_data over 30 days. Provides first/last observations and host context for peer-group review; rarity alone is not evidence of compromise.

[Open query](n010-security-relevant-software-low-execution-prevalence.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N010  
**Category:** Threat Hunting / Software Prevalence  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Finds matched Windows tool products with process-start telemetry on at most three endpoint IDs in xdr_data over 30 days. Provides first/last observations and host context for peer-group review; rarity alone is not evidence of compromise.

## Data and setup

**Sources:** `xdr_data`.

**Lookback:** `30d`. Adjust the configured window for your investigation and data retention.

Check that the listed sources and fields are available to your analyst account. Review image-name lists, filters and the lookback against your environment.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Names can be spoofed or changed; mapping is non-exhaustive.
- A terminal limit bounds returned rows, not scan cost.
- Windows basename evidence bounds execution coverage; this is not cross-platform completeness.
- Counts describe admitted telemetry rows; they are not necessarily unique process launches.
- First/last timestamps are observations within the selected 30-day window.
- Rows without a stable agent ID are excluded from the shared endpoint population.

**Benign matches:** Approved administration, support, development, testing and service activity can satisfy the query.

**Possible misses:** Renamed tools, unsupported platforms, unlisted versions, missing telemetry, stale inventory, null fields and retention gaps can be missed.

**Performance:** A 30-day multi-product scan and aggregation can be expensive; tune population and lookback before execution.

## Investigation pivots

- Verify software identity using path, signer, hash and deployment records.
- Check approved product, host, user, version and change window.
- For concerning activity, inspect process ancestry, command lines and associated network/authentication events.
