# No-preauthentication Accounts and TGT Request Activity

Correlates successful no-preauthentication TGT requests with time-valid account configuration, source/request baselines and approved service exceptions.

[Open query](n043-no-preauthentication-accounts-and-tgt-request-activity.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N043  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full account-state-plus-activity template; account flags and successful request semantics are independent mandatory evidence.

## Data and setup

**Sources:** `{{ASREP_REQUEST_BASELINE_DATASET}}`, `{{PREAUTH_ACCOUNT_STATE_DATASET}}`, `{{TGT_REQUESTS_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{TGT_REQUESTS_DATASET}}` | XQL dataset identifier | Actual read-only source for TGT_REQUESTS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{TGT_REQUESTS_EVENT_TIME}}` | DATETIME scalar expression | 4768 request time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TGT_REQUESTS_EVENT_ID}}` | INTEGER scalar expression | Provider-verified event ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TGT_REQUESTS_ACCOUNT_SID}}` | STRING scalar expression | Resolved target account SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TGT_REQUESTS_DOMAIN_ID}}` | STRING scalar expression | Authoritative domain identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TGT_REQUESTS_SOURCE_IP}}` | STRING scalar expression | Observed client address Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TGT_REQUESTS_PREAUTH_TYPE}}` | INTEGER scalar expression | Parsed PreAuthType with the event-version meaning Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TGT_REQUESTS_SUCCESS}}` | BOOLEAN scalar expression | Successful TGT issue outcome Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TGT_REQUESTS_ENCRYPTION_TYPE}}` | STRING scalar expression | Original ticket encryption value Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PREAUTH_ACCOUNT_STATE_DATASET}}` | XQL dataset identifier | Actual read-only source for PREAUTH_ACCOUNT_STATE. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{PREAUTH_ACCOUNT_STATE_A_SID}}` | STRING scalar expression | Same account SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PREAUTH_ACCOUNT_STATE_A_DOMAIN}}` | STRING scalar expression | Same domain identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PREAUTH_ACCOUNT_STATE_DOES_NOT_REQUIRE_PREAUTH}}` | BOOLEAN scalar expression | Verified effective DONT_REQ_PREAUTH configuration, not failed-auth inference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PREAUTH_ACCOUNT_STATE_EFFECTIVE_FROM}}` | DATETIME scalar expression | Start of configuration validity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PREAUTH_ACCOUNT_STATE_EFFECTIVE_UNTIL}}` | DATETIME scalar expression | End of configuration validity; use explicit future bound for currently open state Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PREAUTH_ACCOUNT_STATE_APPROVED_EXCEPTION}}` | BOOLEAN scalar expression | Current approved non-preauthentication service exception; null means unassessed Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ASREP_REQUEST_BASELINE_DATASET}}` | XQL dataset identifier | Actual read-only source for ASREP_REQUEST_BASELINE. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{ASREP_REQUEST_BASELINE_B_SID}}` | STRING scalar expression | Same account SID; exactly one frozen baseline row per SID/domain/source key, including explicit zero rows when source absence is established Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ASREP_REQUEST_BASELINE_B_DOMAIN}}` | STRING scalar expression | Same domain identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ASREP_REQUEST_BASELINE_KNOWN_SOURCE}}` | STRING scalar expression | Previously expected source address Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ASREP_REQUEST_BASELINE_PRIOR_REQUESTS}}` | INTEGER scalar expression | Prior covered successful no-preauth requests from this account/source Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ASREP_REQUEST_BASELINE_EXPECTED_DAILY_PEAK}}` | INTEGER scalar expression | Reviewed expected daily request count Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ASREP_REQUEST_BASELINE_BASELINE_COMPLETE}}` | BOOLEAN scalar expression | Prior baseline coverage validated. Freeze a comparable snapshot ending at or before evaluation_time minus 86400 seconds, exclude all rolling-current-window observations, and require one row per SID/domain/source key Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ASREP_DAILY_THRESHOLD}}` | INTEGER literal | Positive daily request triage floor chosen after environment baseline review |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Historical creation flags do not establish current preauthentication state; validity intervals must not overlap for a SID/domain.
- Unusual request activity is not proof that an AS-REP was cracked. Missing baseline yields UNASSESSED.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Account has a valid no-preauth flag and successful PreAuthType 0 requests exceed its covered baseline | Request-burst candidate with configuration evidence. |
| negative | Only 4771 failures, preauth-enabled account or PreAuthType not zero | Excluded. |
| null | Account flag or SID unavailable | No fabricated exposure correlation; record the coverage gap. |
| edge | Flag was disabled after the request or two account-state intervals overlap | Only the historically applicable unique interval is allowed; overlapping input fails acceptance. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-018](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-018](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-018](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-018](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-018](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-018](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4768)
- [Official source for TH-018](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/useraccountcontrol-manipulate-account-properties)
- [Official source for TH-018](https://attack.mitre.org/techniques/T1558/004/)
