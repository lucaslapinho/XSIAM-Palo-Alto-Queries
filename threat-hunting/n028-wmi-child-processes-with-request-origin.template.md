# WMI Child Processes with Request Origin

Reviews verified WmiPrvSE child starts with time-qualified WMI request source, account, namespace, result and management-baseline context. Missing traces remain unassessed.

[Open query](n028-wmi-child-processes-with-request-origin.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N028  
**Category:** Threat Hunting / Execution  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full origin-attribution workflow template; parent names alone do not establish remote execution.

## Data and setup

**Sources:** `xdr_data`, `{{WMI_TRACE_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{WMI_DIRECT_PARENT_IMAGE}}` | STRING scalar expression | Verified direct parent image for the started process |
| `{{WMI_TRACE_DATASET}}` | XQL dataset identifier | Actual read-only source for WMI_TRACE. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{WMI_TRACE_W_HOST}}` | STRING scalar expression | Target endpoint ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_CHILD}}` | STRING scalar expression | Resulting child process instance after verified WMI/process correlation, not PID-only matching Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_TIME}}` | DATETIME scalar expression | WMI operation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_CLIENT}}` | STRING scalar expression | Observed client source host/address Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_ACCOUNT}}` | STRING scalar expression | Authenticated requesting account Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_NAMESPACE}}` | STRING scalar expression | WMI namespace Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_OPERATION}}` | STRING scalar expression | WMI operation/provider activity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_RESULT}}` | STRING scalar expression | Operation result Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_TRACE_W_EXPECTED}}` | BOOLEAN scalar expression | Comparison with a current scoped management baseline; null when baseline is unavailable Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- The WMI trace must expose a verifiable child-instance correlation; client process IDs alone are insufficient.
- A one-to-many trace join may yield multiple rows per child; out-of-window context is nulled rather than used as attribution.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Known WMI child has a matching trace 2 seconds earlier from an unexpected management source | Correlated source/account and REVIEW_BASELINE_DEVIATION. |
| negative | Same numeric PID but different instance/endpoint | No source attribution. |
| null | Missing trace or unavailable expected-management comparison | UNASSESSED; child retained. |
| edge | Trace is 61 seconds before start | Trace fields are null and origin is NO_TRACE_IN_WINDOW. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-003](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-003](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-003](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-003](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-003](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-003](https://learn.microsoft.com/en-us/windows/win32/wmisdk/tracing-wmi-activity)
- [Official source for TH-003](https://attack.mitre.org/techniques/T1047/)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
