# PowerShell Encoded Command Launch Candidates

Finds process-start records for Windows PowerShell or pwsh with selected encoded-command launch switches and a Base64-shaped argument. Returns image, user, initiating-process and signature context; matching does not validate the payload or prove successful or malicious execution.

[Open query](n021-powershell-encoded-command-launch-candidates.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N021  
**Category:** Threat Hunting / PowerShell  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained process-start telemetry row; no decoded payload or execution-success assertion.

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

- Windows PowerShell: EncodedCommand/enc; Windows pwsh: EncodedCommand/e/ec/enc.
- The allowlisted prefix grammar admits full NoProfile, NonInteractive, NoLogo, NoExit, STA, MTA, ExecutionPolicy plus selected values, and WindowStyle plus selected values.
- The payload is only nonempty Base64-character-shaped text, not validated or decoded content.
- Selected data and fields are accessible under the analyst role and retained in the one-day window.
- No full-query compilation, returned results or deployment is claimed.
- Missing fields, collection, access or retention can produce incomplete or empty results.
- Endpoint association does not prove exclusive agent-source provenance.
- A result is investigation context and not a maliciousness verdict.

**Benign matches:** Legitimate deployment, administration and automation can use encoded commands.

**Possible misses:** Intentionally misses unlisted abbreviations (including Windows -nop/-e), renamed executables, omitted argv0, unsupported quoting, arguments after the payload, missing telemetry and non-Windows hosts.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

## Investigation pivots

- Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample.
- Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results.
- Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.
