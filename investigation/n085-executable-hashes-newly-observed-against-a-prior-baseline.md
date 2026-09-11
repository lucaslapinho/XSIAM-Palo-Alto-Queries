# Executable Hashes Newly Observed Against a Prior Baseline

Finds executable hashes observed in process starts during the last 24 hours but absent from process starts in the preceding 29 days, with current host/path/user context.

[Open query](n085-executable-hashes-newly-observed-against-a-prior-baseline.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N085  
**Category:** Investigation / Executable Baselines  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

A concrete disjoint 29-day baseline versus 24-hour current comparison by SHA-256. This is newly observed in retained scope, not newly created or first-ever executable presence.

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

- Thirty-day comparable telemetry coverage is a required interpretation prerequisite; collection gaps and new endpoints create false novelty.
- A current-time relative baseline is intended for a live investigation, not a historical replay without a fixed evaluation anchor.
- Legitimate versions, staged deployments, portable tools and hash changes can be new; approval/rollout context must be investigated.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Hash H has starts 2 hours ago and none from 24 hours to 30 days ago | H is returned with current context. |
| negative | Same hash has any prior-window start, even on another host | H is excluded from global observed novelty. |
| null | Null/malformed hash or missing stable endpoint | Excluded without inventing identity. |
| edge | Start exactly 86400 seconds old versus one second younger | The exact boundary belongs only to prior; younger belongs only to current. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for OP-015](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for OP-015](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for OP-015](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for OP-015](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
- [XQL filter Example 22: ordinary double-quoted strings](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-22-String-manipulation-single-quotes?contentId=lwRG5fwKl6gNfg7ngRAAMA)
- [RE2 syntax reference](https://github.com/google/re2/wiki/syntax)
