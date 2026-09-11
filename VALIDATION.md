# Validation and evidence boundaries

| Level | Result | Scope |
|---|---|---|
| Static review | PASS | Independent review of the exact query files, their stated analytic scope and source/binding contracts. |
| Documentation | Partial, scoped evidence | Selected constructs and fields have primary references; no complete-query documentation certification. |
| Tenant compilation | NOT RUN | No exact full-body editor/compiler acceptance. |
| Tenant execution | NOT RUN | No returned-result or detection-effectiveness validation. |

The retained [independent review](qa/independent-static-review.json) covers all 80 artifacts. The [source-package checks](qa/release-checks.json) record the earlier packaging step; their publication field refers to that prepublication snapshot. The latest 74 artifacts include 296 acceptance scenarios that remain plans, not executed tests. Local binding-tool fixtures do not validate XQL runtime behavior.

## First six candidates

The initial six retain their [detailed guide](FIRST-SIX-GUIDE.md), [reference register](FIRST-SIX-REFERENCES.md) and [validation notes](FIRST-SIX-VALIDATION.md). In particular, `action_network_protocol` was observed as ENUM while the official field reference describes INTEGER/IPPROTO. Numeric 6/17 comparisons require target compiler validation.

## Interpretation

Templates are conceptual until every source contract is met and each binding is inspected. Schema visibility alone does not prove field population. Successful compilation does not establish useful results. A hypothesis, a tool name or an ATT&CK label does not prove malicious behavior. Rule-surface promotion and deployment need their own validation.

No Cortex saved queries, rules, integrations or response actions were deployed by this repository publication.
