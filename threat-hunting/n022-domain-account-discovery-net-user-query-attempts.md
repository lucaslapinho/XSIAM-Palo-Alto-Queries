# Domain Account Discovery - Net User Query Attempts

Finds net.exe or net1.exe process starts requesting primary-domain user listings or a single user detail view with an explicit /domain switch. Restricts command shapes to exclude account-changing arguments; results show query attempts and require administrative context and outcome verification.

[Open query](n022-domain-account-discovery-net-user-query-attempts.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N022  
**Category:** Threat Hunting / Account Discovery  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One process-start telemetry row; net/net1 can generate related observations and no unique discovery count is claimed.

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

- An optional single ordinary ASCII username is allowed; a single lookup is not bulk enumeration.
- The command shape excludes extra passwords, /add, /delete and property switches.
- dsquery and Get-ADUser are outside this deliberately constrained implementation.
- Selected data and fields are accessible under the analyst role and retained in the one-day window.
- No full-query compilation, returned results or deployment is claimed.
- Missing fields, collection, access or retention can produce incomplete or empty results.
- Endpoint association does not prove exclusive agent-source provenance.
- A result is investigation context and not a maliciousness verdict.

**Benign matches:** Help desk, identity administration, inventory scripts and authorized assessments can request the same information.

**Possible misses:** Misses other directory tools/APIs, reversed argument order, abbreviated domain switches, exotic usernames, unsupported quoting, renamed tools and missing command lines.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

## Investigation pivots

- Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample.
- Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results.
- Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.
