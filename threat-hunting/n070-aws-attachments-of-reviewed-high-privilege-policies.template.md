# AWS Attachments of Reviewed High-Privilege Policies

Finds AWS IAM managed-policy attachments without a logged API error and joins them to policy assessments valid for the account and event time. Preserves actor and beneficiary separately; policy attachment does not prove unrestricted effective permissions or malicious privilege escalation.

[Open query](n070-aws-attachments-of-reviewed-high-privilege-policies.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N070  
**Category:** Threat Hunting / Cloud Privileges  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{AWS_AUDIT_DATASET}}`, `{{REVIEWED_HIGH_PRIVILEGE_POLICY_HISTORY}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{AWS_AUDIT_DATASET}}` | Dataset identifier | Dataset identifier: verified AWS CloudTrail source; one CloudTrail event per row. Management/data-event selection and account/region scope must be established. |
| `{{AWS_EVENT_TIME}}` | DATETIME expression | DATETIME expression: correctly parsed CloudTrail eventTime, not a guessed timestamp unit. |
| `{{AWS_EVENT_JSON}}` | STRING expression | STRING expression: one original CloudTrail JSON event object. Do not bind an outer Records array or double-encode a JSON string. |
| `{{REVIEWED_HIGH_PRIVILEGE_POLICY_HISTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{PRIVILEGED_POLICY_ARN}}` | STRING | STRING: exact managed policy ARN reviewed as high privilege at event time. |
| `{{PRIVILEGED_POLICY_ACCOUNT}}` | STRING | STRING: affected account for which the policy assessment applies. |
| `{{PRIVILEGED_POLICY_FROM}}` | DATETIME | DATETIME: reviewed policy version applicability start. |
| `{{PRIVILEGED_POLICY_UNTIL}}` | DATETIME | DATETIME: applicability end exclusive. |
| `{{PRIVILEGED_POLICY_REASON}}` | STRING | STRING: reviewed permissions/rationale and policy version; account SCP/boundary limitations must be described. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Inline policies, Entra role assignments, trust changes and effective permissions under SCPs/boundaries need separate reviewed branches. No errorCode is an API-log outcome convention, not proof of downstream effect.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: reviewed policy attached in its valid account/version interval matches. | See scenario |
| Planned test | Negative: denied attachment or unreviewed policy is excluded. | See scenario |
| Planned test | Null: missing policy ARN cannot join. | See scenario |
| Planned test | Edge: the actor assuming a role is not the beneficiary receiving the attachment. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [CloudTrail event and error conventions](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-event-reference-record-contents.html)
- [IAM audit actor and operation context](https://docs.aws.amazon.com/IAM/latest/UserGuide/cloudtrail-integration.html)
- [Managed policy attachment request semantics](https://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachRolePolicy.html)
- [Typed scalar extraction from a JSON string](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/json_extract_scalar)
