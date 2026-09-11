# Configured SSH Authorized Keys File Changes

Correlates successful mutations of configured SSH authorized-key files with owning accounts, writer/process identity and approved key-change windows. Paths remain case-sensitive.

[Open query](n037-configured-ssh-authorized-keys-file-changes.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N037  
**Category:** Threat Hunting / Persistence  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Complete account/writer/change-window template including configured nondefault paths and atomic replacement; does not infer changes from accepted public-key logons.

## Data and setup

**Sources:** `{{AUTHORIZED_KEYS_CONFIGURATION_DATASET}}`, `{{KEY_CHANGE_WINDOWS_DATASET}}`, `{{SSH_KEY_FILE_CHANGES_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SSH_KEY_FILE_CHANGES_DATASET}}` | XQL dataset identifier | Actual read-only source for SSH_KEY_FILE_CHANGES. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{SSH_KEY_FILE_CHANGES_EVENT_TIME}}` | DATETIME scalar expression | Linux file mutation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SSH_KEY_FILE_CHANGES_HOST_ID}}` | STRING scalar expression | Stable Linux endpoint identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SSH_KEY_FILE_CHANGES_RECORD_ID}}` | STRING scalar expression | Unique mutation record key Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SSH_KEY_FILE_CHANGES_FILE_PATH}}` | STRING scalar expression | Case-preserving resolved canonical file path, including rename destination Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SSH_KEY_FILE_CHANGES_OPERATION}}` | STRING scalar expression | CREATE, WRITE, RENAME or DELETE; never map reads to changes Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SSH_KEY_FILE_CHANGES_SUCCESSFUL}}` | BOOLEAN scalar expression | Actual mutation success Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SSH_KEY_FILE_CHANGES_WRITER_ID}}` | STRING scalar expression | Writer account identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SSH_KEY_FILE_CHANGES_WRITER_PROCESS}}` | STRING scalar expression | Writer process instance Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{AUTHORIZED_KEYS_CONFIGURATION_DATASET}}` | XQL dataset identifier | Actual read-only source for AUTHORIZED_KEYS_CONFIGURATION. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{AUTHORIZED_KEYS_CONFIGURATION_KEY_HOST}}` | STRING scalar expression | Stable endpoint identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{AUTHORIZED_KEYS_CONFIGURATION_KEY_PATH}}` | STRING scalar expression | Actual configured AuthorizedKeysFile path after token/user/symlink resolution; case-preserving Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{AUTHORIZED_KEYS_CONFIGURATION_ACCOUNT_ID}}` | STRING scalar expression | Account for which this key file is configured Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{AUTHORIZED_KEYS_CONFIGURATION_CONFIGURATION_FROM}}` | DATETIME scalar expression | Verified effective configuration start inclusive, not ingestion time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{AUTHORIZED_KEYS_CONFIGURATION_CONFIGURATION_UNTIL}}` | DATETIME scalar expression | Verified effective configuration end exclusive; null only for a currently open interval. Intervals per host/path/account must not overlap Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{KEY_CHANGE_WINDOWS_DATASET}}` | XQL dataset identifier | Actual read-only source for KEY_CHANGE_WINDOWS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{KEY_CHANGE_WINDOWS_W_HOST}}` | STRING scalar expression | Stable endpoint identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{KEY_CHANGE_WINDOWS_W_ACCOUNT}}` | STRING scalar expression | Owner/account identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{KEY_CHANGE_WINDOWS_WINDOW_START}}` | DATETIME scalar expression | Approved provisioning/rotation window start Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{KEY_CHANGE_WINDOWS_WINDOW_END}}` | DATETIME scalar expression | Approved window end Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{KEY_CHANGE_WINDOWS_CHANGE_ID}}` | STRING scalar expression | Actual change reference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- The path inventory must resolve actual AuthorizedKeysFile settings and symlink/rename behavior at event time.
- Window overlap is not proof that a particular writer or key was approved. No key contents or secrets are required in this output.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Successful atomic rename replaces the configured key file during an approved account rotation window | Mutation, account, writer and overlapping change reference appear. |
| negative | Read-only access or similarly named unconfigured file | Excluded. |
| null | No approved window exists | Mutation retained with NO_APPROVED_WINDOW_MATCH. |
| edge | Two Linux paths differ only in letter case | Only the exact configured path matches. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-012](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-012](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-012](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-012](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-012](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-012](https://man.openbsd.org/sshd_config.5)
- [Official source for TH-012](https://attack.mitre.org/techniques/T1098/004/)
