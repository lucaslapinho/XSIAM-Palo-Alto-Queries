# Dual-Use Security Tools Software - Reported Installed

Identifies candidate dual-use security tools products in the latest nonempty application report per endpoint available through host_inventory_applications during the selected window. Returns product, reported vendor, version and inventory age context for software-policy review; a report is not proof of current presence or execution.

[Open query](n005-dual-use-security-tools-software-reported-installed.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N005  
**Category:** Cyber Hygiene / Dual-Use Security Tools  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Identifies candidate dual-use security tools products in the latest nonempty application report per endpoint available through host_inventory_applications during the selected window. Returns product, reported vendor, version and inventory age context for software-policy review; a report is not proof of current presence or execution.

## Data and setup

**Sources:** `host_inventory_applications`.

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
- Inventory product-label patterns are INFERRED and NEEDS_VALIDATION.
- Latest nonempty report does not prove current installation; empty reports, stale agents and missing inventory limit conclusions.
- Report timestamps are not installation timestamps; install_date is an unparsed string.
- Grouping max over report_timestamp requires full-query tenant compilation.

**Benign matches:** Approved administration, support, development, testing and service activity can satisfy the query.

**Possible misses:** Renamed tools, unsupported platforms, unlisted versions, missing telemetry, stale inventory, null fields and retention gaps can be missed.

**Performance:** A 30-day multi-product scan and aggregation can be expensive; tune population and lookback before execution.

## Investigation pivots

- Verify software identity using path, signer, hash and deployment records.
- Check approved product, host, user, version and change window.
- For concerning activity, inspect process ancestry, command lines and associated network/authentication events.
