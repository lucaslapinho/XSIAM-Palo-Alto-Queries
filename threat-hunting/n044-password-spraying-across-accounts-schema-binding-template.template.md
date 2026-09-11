# Password Spraying Across Accounts - Schema Binding Template

Ranks source-specific bad-secret failures spread across accounts within 15-minute bins. Retains original reasons and separates source systems; thresholds identify spray-shaped behavior for review.

[Open query](n044-password-spraying-across-accounts-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N044  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One source-system/client/time-bin with many target accounts and low average retries. Slow and distributed spraying needs a separate longer-window baseline.

## Data and setup

**Sources:** `{{AUTH_FAILURE_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{AUTH_FAILURE_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{FAIL_TIME}}` | DATETIME |  |
| `{{FAIL_EVENT_UID}}` | STRING |  |
| `{{FAIL_SOURCE_SYSTEM}}` | STRING |  |
| `{{FAIL_SOURCE_IP}}` | STRING |  |
| `{{FAIL_ACCOUNT_KEY}}` | STRING |  |
| `{{FAIL_OUTCOME}}` | STRING |  |
| `{{FAIL_REASON_CLASS}}` | STRING |  |
| `{{FAIL_REASON_RAW}}` | STRING |  |
| `{{MIN_ACCOUNTS}}` | INTEGER_LITERAL |  |
| `{{MAX_FAILURES_PER_ACCOUNT}}` | NUMBER_LITERAL |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- NAT, shared gateways and stale service secrets can create legitimate fan-out. A count cannot establish that one password was reused.
- Account identity and failure-code normalization must be validated separately for 4625, 4771 and other providers.
- All bindings are explicit contracts, not claims that a source or field exists. Bind field/expression placeholders to typed tenant fields or tested extraction expressions; never substitute a made-up name.
- One-day telemetry lookback unless stated otherwise. Source-clock, retention, collection and permission gaps can remove evidence; _time filtering must cover each source event time.
- All canonical normalized words in expressions are local mapping contracts, not undocumented Cortex enum values.
- Result limits apply after analysis and do not cap scanned data or join fan-out. No tenant compile, execution, performance or deployment claim.
- ATT&CK, where present, is an analytical interpretation requiring context, not proof of compromise.
- Inventory/coverage/snapshot source bindings must return every relevant validity record under the configured query timeframe; if their storage timestamps differ, establish and test an explicit inner timeframe before use. A missing lookup row is never automatically benign.
- Comparisons are case-sensitive. Binding owners must canonicalize values only in source namespaces proven case-insensitive (such as reviewed Windows service/path/account keys and DNS A-label names), identically on both join sides. Preserve Unix paths, case-sensitive identities, ARN resource components, and source evidence text. All normalized operation/result labels must match the documented local contract spelling exactly.
- Time-difference bounds are expressed at second resolution. Validate subsecond boundary behavior using source fixtures; direct timestamp comparisons enforce before/after ordering where required.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Ten accounts receive one bad-secret failure from source A in one bin; thresholds 10 and 3. | One group with account_count 10 and failure_events 10. |
| negative | One account receives 30 failures, or ten lockout-only failures occur. | No qualifying group. |
| null | Source IP or target account is missing. | Excluded from grouping; record the resulting coverage gap. |
| edge | The same event is delivered twice and another provider reports its own failure. | Repeated delivery is deduplicated per source; different providers remain separate. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Microsoft event 4625](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4625)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
- [MITRE Password Spraying](https://attack.mitre.org/techniques/T1110/003/)
