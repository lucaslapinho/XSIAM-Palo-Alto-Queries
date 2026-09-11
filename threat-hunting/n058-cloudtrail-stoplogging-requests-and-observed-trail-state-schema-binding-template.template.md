# CloudTrail StopLogging Requests and Observed Trail State - Schema Binding Template

Reviews AWS StopLogging requests and attaches trail-state observations within 15 minutes, preserving API errors and unknown state rather than assuming a successful logging shutdown.

[Open query](n058-cloudtrail-stoplogging-requests-and-observed-trail-state-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N058  
**Category:** Threat Hunting / Defense Impairment  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One StopLogging request and each matching post-request status observation, or an unmatched request; AWS-specific slice of cloud logging disablement.

## Data and setup

**Sources:** `{{AWS_CLOUDTRAIL_DATASET}}`, `{{TRAIL_STATUS_SNAPSHOTS}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{AWS_CLOUDTRAIL_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{CT_EVENT_TIME}}` | DATETIME |  |
| `{{CT_EVENT_UID}}` | STRING |  |
| `{{CT_ACCOUNT}}` | STRING |  |
| `{{CT_REGION}}` | STRING |  |
| `{{CT_EVENT_SOURCE}}` | STRING |  |
| `{{CT_EVENT_NAME}}` | STRING |  |
| `{{CT_TRAIL_ARN}}` | STRING |  |
| `{{CT_ACTOR_SESSION}}` | STRING |  |
| `{{CT_SOURCE_ADDRESS}}` | STRING |  |
| `{{CT_ERROR_CODE}}` | STRING |  |
| `{{TRAIL_STATUS_SNAPSHOTS}}` | DATASET_IDENTIFIER |  |
| `{{TRAIL_STATUS_TIME}}` | DATETIME |  |
| `{{TRAIL_STATUS_ARN}}` | STRING |  |
| `{{TRAIL_STATUS_ACCOUNT}}` | STRING |  |
| `{{TRAIL_IS_LOGGING}}` | BOOLEAN |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- No-error API metadata alone is not complete operational proof. Concurrent changes can alter later snapshots.
- One stopped trail does not establish loss of account/region logging coverage; other trails, event data stores and selectors require separate coverage evaluation.
- Other AWS logging-reduction operations and other cloud providers require separately verified operation semantics; not covered by this StopLogging scope.
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
| positive | StopLogging for trail A has a same-account status snapshot five minutes later with IsLogging false. | Request shows OBSERVED_NOT_LOGGING. |
| negative | A DescribeTrails API operation occurs, or status belongs to another trail/account. | Operation excluded; unrelated state never attaches. |
| null | Trail ARN cannot be resolved or no status snapshot exists. | Request retained with UNKNOWN state. |
| edge | API returns AccessDenied while a concurrent administrator later stops the trail. | Error is preserved; later observed state is not attributed as success of the failed request. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [AWS StopLogging](https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_StopLogging.html)
- [CloudTrail record contents](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-event-reference-record-contents.html)
- [MITRE Disable or Modify Tools](https://attack.mitre.org/techniques/T1685/)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
