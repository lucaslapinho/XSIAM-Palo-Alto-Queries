# Remote Access Tools and Script Interpreters - Host Co-Occurrence

Finds endpoints with both a matched remote-access tool and PowerShell, Windows Script Host or Python process-start rows in a one-day xdr_data window. Host-level co-occurrence is a pivot lead only: it establishes neither process ancestry nor temporal order and is common on administration endpoints.

[Open query](n020-remote-access-tools-and-script-interpreters-host-co-occurrence.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N020  
**Category:** Investigation / Remote Access and Scripting  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Finds endpoints with both a matched remote-access tool and PowerShell, Windows Script Host or Python process-start rows in a one-day xdr_data window. Host-level co-occurrence is a pivot lead only: it establishes neither process ancestry nor temporal order and is common on administration endpoints.

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

- Both sides are aggregated to one row per stable agent key before joining; inner join intentionally excludes unmatched endpoints.
- One-day windows aligned on both branches; host co-occurrence only.
- Names can be spoofed or changed; mapping is non-exhaustive.
- A terminal limit bounds returned rows, not scan cost.
- Windows basename evidence bounds execution coverage; this is not cross-platform completeness.
- Counts describe admitted telemetry rows; they are not necessarily unique process launches.
- First/last timestamps are observations within the selected one-day window.
- Rows without a stable agent ID are excluded from the shared endpoint population.

**Benign matches:** Approved administration, support, development, testing and service activity can satisfy the query.

**Possible misses:** Renamed tools, unsupported platforms, unlisted versions, missing telemetry, stale inventory, null fields and retention gaps can be missed.

**Performance:** One-day process scans with explicit per-agent aggregation on both join branches; cost remains dependent on volume.

## Investigation pivots

- Verify software identity using path, signer, hash and deployment records.
- Check approved product, host, user, version and change window.
- For concerning activity, inspect process ancestry, command lines and associated network/authentication events.
