# Permanent WMI Subscription Registrations

Reviews permanent WMI filter, consumer and binding registrations/changes and resolves configured query/consumer targets through a validated object-state source.

[Open query](n034-permanent-wmi-subscription-registrations.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N034  
**Category:** Threat Hunting / Persistence  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Explicit permanent-subscription events and references; WMI process starts alone cannot satisfy this template.

## Data and setup

**Sources:** `{{WMI_OBJECT_STATE_DATASET}}`, `{{WMI_SUBSCRIPTIONS_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{WMI_SUBSCRIPTIONS_DATASET}}` | XQL dataset identifier | Actual read-only source for WMI_SUBSCRIPTIONS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{WMI_SUBSCRIPTIONS_EVENT_TIME}}` | DATETIME scalar expression | WMI registration/change event time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_HOST_ID}}` | STRING scalar expression | Stable host identifier Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_EVENT_ID}}` | INTEGER scalar expression | Provider-verified Sysmon WMI event 19, 20 or 21 Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_NAMESPACE}}` | STRING scalar expression | WMI namespace Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_SUBJECT}}` | STRING scalar expression | Registering subject identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_OBJECT_NAME}}` | STRING scalar expression | Created filter/consumer/binding identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_FILTER_REFERENCE}}` | STRING scalar expression | Canonical filter object reference; for filter records its own identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_CONSUMER_REFERENCE}}` | STRING scalar expression | Canonical consumer object reference; for consumer records its own identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_FILTER_QUERY}}` | STRING scalar expression | Observed filter query where present Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_CONSUMER_TARGET}}` | STRING scalar expression | Observed consumer command/script/destination where present Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_SUBSCRIPTIONS_OPERATION}}` | STRING scalar expression | Verified creation/change operation Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_OBJECT_STATE_DATASET}}` | XQL dataset identifier | Actual read-only source for WMI_OBJECT_STATE. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{WMI_OBJECT_STATE_OBJ_HOST}}` | STRING scalar expression | Stable host identifier Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_OBJECT_STATE_OBJ_NAMESPACE}}` | STRING scalar expression | WMI namespace Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_OBJECT_STATE_OBJ_REFERENCE}}` | STRING scalar expression | Canonical object reference; unique nonoverlapping effective state intervals per host/namespace/reference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_OBJECT_STATE_OBJ_QUERY}}` | STRING scalar expression | Filter query for a filter object Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_OBJECT_STATE_OBJ_TARGET}}` | STRING scalar expression | Consumer execution target for a consumer object Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_OBJECT_STATE_OBJ_FROM}}` | DATETIME scalar expression | Effective start of this object-state version, inclusive; do not substitute ingestion time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{WMI_OBJECT_STATE_OBJ_UNTIL}}` | DATETIME scalar expression | Effective end of this object-state version, exclusive; null only for a verified currently open interval Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Object-state intervals must be uniquely keyed and nonoverlapping. Only state effective at the event time enriches a record; grouped value sets collapse invalid-version null join fan-out. Identical event projections can coalesce because no universal event UID is assumed.
- Preexisting objects and deleted consumers can leave unresolved references; retain nulls rather than claim absence.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Sysmon 21 registers a binding referencing a known filter and consumer | BINDING row includes historically applicable resolved query and target sets. |
| negative | Ordinary WMI query/process event without subscription registration | Excluded. |
| null | Binding consumer is absent from available state | Binding remains with unresolved target. |
| edge | Same consumer has one future state version and one valid earlier version; identical name also occurs on another host | Only the version effective at the event time on the same host/namespace contributes. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-009](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-009](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-009](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-009](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-009](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-009](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Official source for TH-009](https://attack.mitre.org/techniques/T1546/003/)
