# SSH Accepted Access and Session Command Review - Schema Binding Template

Preserves accepted SSH authentications and attaches audited exec events through a validated server-session key, showing missing command evidence explicitly.

[Open query](n055-ssh-accepted-access-and-session-command-review-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N055  
**Category:** Threat Hunting / Lateral Movement  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One authentication/linked-exec pair, or one authentication with no linked exec within one hour; left join keeps unmatched authentications.

## Data and setup

**Sources:** `{{SSH_AUTH_DATASET}}`, `{{SSH_COMMAND_AUDIT_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SSH_AUTH_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{SSH_AUTH_TIME}}` | DATETIME |  |
| `{{SSH_TARGET_ENDPOINT}}` | STRING |  |
| `{{SSH_CLIENT_IP}}` | STRING |  |
| `{{SSH_AUTH_ACCOUNT}}` | STRING |  |
| `{{SSH_AUTH_METHOD}}` | STRING |  |
| `{{SSH_SESSION_KEY}}` | STRING |  |
| `{{SSH_AUTH_RESULT}}` | STRING |  |
| `{{SSH_COMMAND_AUDIT_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{SSH_COMMAND_TIME}}` | DATETIME |  |
| `{{SSH_COMMAND_ENDPOINT}}` | STRING |  |
| `{{SSH_COMMAND_SESSION}}` | STRING |  |
| `{{SSH_COMMAND_UID}}` | STRING |  |
| `{{SSH_EFFECTIVE_USER}}` | STRING |  |
| `{{SSH_COMMAND_LINE}}` | STRING |  |
| `{{SSH_COMMAND_OPERATION}}` | STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- No linked command does not mean no command ran; audit coverage and session mapping may be incomplete.
- Bastion/service accounts need explicit policy context; no blanket private-address or account exclusion.
- Authentication principal and effective command user may differ legitimately through elevation.
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
| positive | Accepted public-key authentication has an audited exec on the same server/session ten minutes later. | SESSION_LINKED_EXEC returned with authenticated and effective users. |
| negative | Another session executes on the same server at the same time. | Not attached to this authentication. |
| null | Authentication has valid session but no command audit. | Authentication remains with NO_LINKED_EXEC_IN_WINDOW. |
| edge | sshd PID is reused after reboot. | Boot-scoped key prevents cross-boot attachment. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [OpenSSH manuals](https://www.openssh.org/manual.html)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
