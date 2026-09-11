# Validation and operational limits

| Level | Result | Scope |
|---|---|---|
| S | PASS | Two independent static reviews of all six files and structural checks; N021/N022 additionally reviewed with controlled command-line fixtures using a Python regex proxy. |
| D | NOT RUN | No full-query documentation certification. Selected fields, event categories, functions, operators and CLI forms have official evidence in FIRST-SIX-REFERENCES.md. |
| C | NOT RUN | No exact full-body compiler acceptance. Selected field/type Schema observations do not certify an entire query. |
| E | NOT RUN | No query execution, returned-result validation or performance measurement. |

The documented constructs are evidence-backed; overall tenant compatibility remains unverified. Target product version, permissions, field population and result usefulness must be established before operational use. Python regex checks are not the XQL/RE2 parser and do not establish XQL string-literal handling. The 53 applicable command fixtures passed this proxy check.

The inspected Schema exposes `action_network_protocol` as enum, whereas the official field reference describes integer IPPROTO values. Numeric comparisons to 6 and 17 follow the documented protocol representation; their exact acceptance in the target query remains unverified. Remote IP string and remote port integer were observed separately. This distinction is retained rather than treated as compiler acceptance.

## Required acceptance checks

1. Paste only the body after `:Query:` and verify dataset, projected fields/types, process enum/subtype and exact regex literal acceptance in the target XQL editor.
2. Replace the required endpoint sentinels, retain a bounded timeframe, and compare known positive, benign, negative and null cases with source telemetry.
3. For N021, check the supported launch switches and reject inline `-Command`/`-File` mentions, `-ExecutionPolicy` alone and `-EncodedArguments`. Confirm explicit coverage exclusions in FIRST-SIX-GUIDE.md.
4. For N022, check domain listing and a single account lookup; reject local/group queries, password changes, `/add`, `/delete` and unexpected arguments. A request is not proof of its success.
5. For N023/N024, inspect both incoming and outgoing tuples plus unknown direction. Do not infer login outcome from network success.
6. For N025, verify outgoing TCP/UDP rows, invalid/null-port exclusions, per-subtype groups, hostname changes and repeated records. Repeated records must increase event count; do not infer unique sessions.
7. For N026, confirm process starts are admitted and unrelated subtypes excluded. Check timestamp ties, missing fields and the output cap.
8. Review row volume, runtime and collection/retention coverage. Empty results are not proof of absence. Validate other rule/import surfaces separately before any promotion.
