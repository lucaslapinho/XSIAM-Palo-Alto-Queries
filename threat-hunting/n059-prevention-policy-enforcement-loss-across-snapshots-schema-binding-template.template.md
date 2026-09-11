# Prevention Policy Enforcement Loss Across Snapshots - Schema Binding Template

Compares controlled before/after effective-policy snapshots for each endpoint and protection scope, selecting enforced-to-unenforced transitions tied to successful policy changes.

[Open query](n059-prevention-policy-enforcement-loss-across-snapshots-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N059  
**Category:** Threat Hunting / Defense Impairment  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One policy change/endpoint/atomic-control transition; snapshot uniqueness and completeness are binding prerequisites.

## Data and setup

**Sources:** `{{PREVENTION_CHANGE_DATASET}}`, `{{EFFECTIVE_PREVENTION_SNAPSHOTS}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{PREVENTION_CHANGE_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{POLICY_CHANGE_TIME}}` | DATETIME |  |
| `{{POLICY_CHANGE_UID}}` | STRING |  |
| `{{POLICY_OBJECT_ID}}` | STRING |  |
| `{{POLICY_CHANGE_ACTOR}}` | STRING |  |
| `{{POLICY_CHANGE_RESULT}}` | STRING |  |
| `{{POLICY_BEFORE_SNAPSHOT}}` | STRING |  |
| `{{POLICY_AFTER_SNAPSHOT}}` | STRING |  |
| `{{EFFECTIVE_PREVENTION_SNAPSHOTS}}` | DATASET_IDENTIFIER |  |
| `{{EFFECTIVE_SNAPSHOT_ID}}` | STRING |  |
| `{{EFFECTIVE_ENDPOINT}}` | STRING |  |
| `{{EFFECTIVE_CONTROL_KEY}}` | STRING |  |
| `{{EFFECTIVE_ENFORCED}}` | BOOLEAN |  |
| `{{EFFECTIVE_RAW_MODE}}` | STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Generic edits, policy creation and exception counts cannot establish weakening.
- The snapshot mapping must resolve assignment precedence and exact exclusion scope; arbitrary ordinal strength scores are forbidden.
- An effective control-plane transition is not proof the endpoint applied the configuration; endpoint state confirmation remains a next pivot.
- Missing old/new scope items are unknown rather than false; both explicit Boolean states are required.
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
| positive | Same endpoint/control is enforced in the referenced before snapshot and explicitly excluded in the after snapshot. | One weakening transition. |
| negative | A descriptive edit occurs, or enforcement remains true, or false becomes true. | Excluded. |
| null | Either effective state is unknown or an endpoint/control is missing in either snapshot. | Excluded; no assumed weakening. |
| edge | Two policies conflict but precedence still leaves the effective control enforced. | No transition despite a weaker individual policy. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [MITRE Disable or Modify Tools](https://attack.mitre.org/techniques/T1685/)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
