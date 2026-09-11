# AWS Access Key Creation and First Observed Use

Tracks AWS IAM access-key creation and the first matching use visible within the bounded window using only non-secret credential identifiers in the explicit projection. Keeps unmatched creations for review and distinguishes legitimate rotation from suspicious additional credentials.

[Open query](n071-aws-access-key-creation-and-first-observed-use.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N071  
**Category:** Threat Hunting / Cloud Credentials  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{AWS_ACCESS_KEY_USE_EVENTS}}`, `{{AWS_AUDIT_DATASET}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{AWS_AUDIT_DATASET}}` | Dataset identifier | Dataset identifier: verified AWS CloudTrail source; one CloudTrail event per row. Management/data-event selection and account/region scope must be established. |
| `{{AWS_EVENT_TIME}}` | DATETIME expression | DATETIME expression: correctly parsed CloudTrail eventTime, not a guessed timestamp unit. |
| `{{AWS_EVENT_JSON}}` | STRING expression | STRING expression: one original CloudTrail JSON event object. Do not bind an outer Records array or double-encode a JSON string. |
| `{{AWS_ACCESS_KEY_USE_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{AWS_KEY_USE_TIME}}` | DATETIME | DATETIME: attributed AWS API use time. |
| `{{AWS_USED_KEY_ID}}` | STRING | STRING: userIdentity.accessKeyId of the caller; non-secret identifier. |
| `{{AWS_KEY_USE_ACCOUNT}}` | STRING | STRING: owning identity account, compatible with the creation account; do not substitute recipient resource account for cross-account use. |
| `{{AWS_KEY_USE_EVENT}}` | STRING | STRING: observed API event name. |
| `{{AWS_KEY_USE_SOURCE}}` | STRING nullable | STRING nullable: caller address or AWS service context. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Other credential types/providers require separate lifecycle mappings. Generated raw/system columns may remain available in the query UI; inspect exports before distributing results. No secret access key is explicitly extracted.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: matching non-secret key ID and owning account link creation to later use. | See scenario |
| Planned test | Negative: use before creation or under a different owning account does not match. | See scenario |
| Planned test | Null: created key without visible use remains with zero matched rows. | See scenario |
| Planned test | Edge: a cross-account resource call must be matched by credential owner, not recipient resource account. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [CloudTrail record conventions](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-event-reference-record-contents.html)
- [IAM access key creation response and secret/non-secret metadata boundary](https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateAccessKey.html)
