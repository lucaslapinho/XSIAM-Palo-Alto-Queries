# Unexpected Replication Rights Use with Source Context

Reviews successful Get-Changes-All control-access usage by non-baselined/unassessed principals, resolves the authenticated source, and attaches time-qualified actual DRS operation evidence.

[Open query](n041-unexpected-replication-rights-use-with-source-context.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N041  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full rights/origin/replication workflow for the Get-Changes-All signal; generic RPC ports cannot satisfy DRS_OPERATIONS. Other replication-right variants are an explicit coverage extension.

## Data and setup

**Sources:** `{{DRS_OPERATIONS_DATASET}}`, `{{REPLICATION_ORIGIN_DATASET}}`, `{{REPLICATION_RIGHTS_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{REPLICATION_RIGHTS_DATASET}}` | XQL dataset identifier | Actual read-only source for REPLICATION_RIGHTS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{REPLICATION_RIGHTS_EVENT_TIME}}` | DATETIME scalar expression | Audited directory-object operation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_DC_ID}}` | STRING scalar expression | Target DC identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_EVENT_ID}}` | INTEGER scalar expression | Provider-verified Security event ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_SUCCESS}}` | BOOLEAN scalar expression | Successful directory-object access outcome Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_SUBJECT_SID}}` | STRING scalar expression | Acting principal SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_LOGON_KEY}}` | STRING scalar expression | Host/logon-session-scoped correlation identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_PROPERTIES}}` | STRING scalar expression | Actual control-access property GUIDs from 4662 Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_ACCESS_IS_CONTROL}}` | BOOLEAN scalar expression | Verified control-access operation flag Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_RIGHTS_EXPECTED_PRINCIPAL}}` | BOOLEAN scalar expression | Current scoped DC/approved-sync principal baseline; null when unknown Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_ORIGIN_DATASET}}` | XQL dataset identifier | Actual read-only source for REPLICATION_ORIGIN. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{REPLICATION_ORIGIN_O_DC}}` | STRING scalar expression | Same target DC identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_ORIGIN_O_LOGON}}` | STRING scalar expression | Verified DC/logon-session key matching the rights event Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_ORIGIN_O_SID}}` | STRING scalar expression | Same authenticated principal SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_ORIGIN_SOURCE_HOST}}` | STRING scalar expression | Source endpoint identity from correlated successful authentication Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_ORIGIN_SOURCE_IP}}` | STRING scalar expression | Observed source address with NAT/ownership context Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_ORIGIN_SOURCE_IS_DC}}` | BOOLEAN scalar expression | Time-valid authoritative DC inventory match; null unknown Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{REPLICATION_ORIGIN_AUTH_TIME}}` | DATETIME scalar expression | Authentication time that established this session Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DRS_OPERATIONS_DATASET}}` | XQL dataset identifier | Actual read-only source for DRS_OPERATIONS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{DRS_OPERATIONS_D_DC}}` | STRING scalar expression | Target DC identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DRS_OPERATIONS_D_SOURCE}}` | STRING scalar expression | Source identity in the origin namespace Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DRS_OPERATIONS_D_TIME}}` | DATETIME scalar expression | Observed replication operation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DRS_OPERATIONS_D_OPERATION}}` | STRING scalar expression | Validated DRS/RPC replication operation, not a port classification Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DRS_OPERATIONS_D_RESULT}}` | STRING scalar expression | Actual operation outcome Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Suitable 4662 auditing/SACLs are required. Rights usage is not proof of completed credential replication.
- One session/source may have many DRS records; unknown source/DC status remains unknown, and expected-principal exclusions require a complete approved baseline.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Unapproved SID exercises the specified right; the correlated source is non-DC and a DRS operation occurs +2 seconds | NON_DC_SOURCE and corroborated operation. |
| negative | Generic TCP/135 traffic without a rights event, or properties lack the replication right | No rights-use finding. |
| null | Valid rights event lacks source authentication | Rights lead retained with UNKNOWN origin and no false DRS match. |
| edge | A source IP was reassigned or matching DRS occurs >5 minutes away | Do not corroborate without stable time-valid identity and interval match. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-016](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-016](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-016](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-016](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-016](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-016](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4662)
- [Official source for TH-016](https://learn.microsoft.com/en-us/windows/win32/adschema/r-ds-replication-get-changes-all)
- [Official source for TH-016](https://attack.mitre.org/techniques/T1003/006/)
