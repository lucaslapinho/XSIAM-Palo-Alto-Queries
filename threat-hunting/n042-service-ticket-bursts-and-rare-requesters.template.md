# Service-ticket Bursts and Rare Requesters

Compares successful service-ticket activity in fixed ten-minute windows with a covered prior requester/peer baseline, retaining all encryption types as context.

[Open query](n042-service-ticket-bursts-and-rare-requesters.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N042  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Complete burst/rare-requester baseline template. Service targets are the actual available target identifier, not invented SPNs; ticket requests do not prove cracking.

## Data and setup

**Sources:** `{{SERVICE_TICKETS_DATASET}}`, `{{TICKET_REQUESTER_BASELINE_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SERVICE_TICKETS_DATASET}}` | XQL dataset identifier | Actual read-only source for SERVICE_TICKETS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{SERVICE_TICKETS_TICKET_TIME}}` | DATETIME scalar expression | Original 4769 event time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_TICKETS_REQUESTER}}` | STRING scalar expression | Normalized domain-qualified requester identity; event name is not assumed an authoritative UPN Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_TICKETS_SOURCE_IP}}` | STRING scalar expression | Observed IPv4/IPv6 client address Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_TICKETS_SERVICE_TARGET}}` | STRING scalar expression | Service account/SID or verified SPN target; do not label an account name as a full SPN Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_TICKETS_ENCRYPTION_TYPE}}` | STRING scalar expression | Original ticket encryption representation including AES/RC4 Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_TICKETS_EVENT_ID}}` | INTEGER scalar expression | Provider-verified event ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_TICKETS_SUCCESS}}` | BOOLEAN scalar expression | Success mapped from the actual event-version Status value Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TICKET_REQUESTER_BASELINE_DATASET}}` | XQL dataset identifier | Actual read-only source for TICKET_REQUESTER_BASELINE. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{TICKET_REQUESTER_BASELINE_B_REQUESTER}}` | STRING scalar expression | Same normalized requester key; exactly one baseline row per key, with an explicit zero row required to establish rarity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TICKET_REQUESTER_BASELINE_BASELINE_DAYS}}` | INTEGER scalar expression | Covered prior days strictly before the rolling current window [evaluation_time minus 86400 seconds, evaluation_time); freeze one comparable baseline snapshot ending at or before that boundary, not an overlapping calendar day Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TICKET_REQUESTER_BASELINE_PRIOR_REQUEST_ROWS}}` | INTEGER scalar expression | Requester successful request volume over the prior baseline Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TICKET_REQUESTER_BASELINE_EXPECTED_PEAK_TARGETS}}` | INTEGER scalar expression | Reviewed expected peak distinct service targets in comparable ten-minute windows entirely before the rolling current interval; nonnegative and sourced from the same frozen baseline snapshot Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TICKET_REQUESTER_BASELINE_BASELINE_COMPLETE}}` | BOOLEAN scalar expression | Collection and peer comparability validated for the intended baseline Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{MIN_DISTINCT_SERVICES}}` | INTEGER literal | Positive triage floor, for example 10 distinct service targets per fixed ten-minute window; tune against actual benign workloads |
| `{{BURST_MULTIPLIER}}` | NUMBER literal | Positive multiplier over reviewed expected peak, for example 3; not a detection-quality guarantee |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Use disjoint baseline/current intervals and version-aware 4769 field maps. AES is retained; RC4 is not a required condition.
- Fixed bins split boundary-spanning bursts. Null/incomplete baselines yield BASELINE_UNASSESSED, not automatic rarity.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Requester hits 30 distinct targets when expected peak is 4, threshold 10 and multiplier 3 | Burst candidate regardless of AES or RC4. |
| negative | Known high-volume service stays within its reviewed peak | Not flagged as a burst. |
| null | No complete prior baseline | Explicit BASELINE_UNASSESSED rather than rare. |
| edge | Requests straddle two ten-minute bins | Counts remain per fixed bin; boundary limitation is documented. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-017](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-017](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-017](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-017](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-017](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-017](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4769)
- [Official source for TH-017](https://attack.mitre.org/techniques/T1558/003/)
