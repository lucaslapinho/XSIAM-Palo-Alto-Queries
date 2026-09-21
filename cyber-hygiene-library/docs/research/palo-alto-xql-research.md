# Palo Alto XQL documentation research — Phase 1

Research cut: **2026-09-20**. Scope: documentation research for a proposed open-source Cyber Hygiene query library. No tenant, compiler, API, endpoint, saved query, or detection rule was accessed. This report implements no library queries.

## Findings that govern implementation

1. `host_inventory_applications` is explicitly listed as a **preset**, separately from the `host_inventory` dataset, in current Cortex XSIAM and Cortex XDR 5 documentation. Its documented existence is VERIFIED; tenant availability is not. [S01, S02]
2. The requested complete canonical flow cannot yet receive a documentation-complete or tenant-tested label. The exact preset schema, especially `endpoint_id`, `report_timestamp`, their types, and snapshot meaning, was not established by the official sources retrieved in this review.
3. The combined configuration `config case_sensitive = false timeframe = 30d` occurs in a Palo Alto Unit 42 example. Current command documentation independently describes both settings and compact duration syntax. This is meaningful first-party syntax evidence, but does not prove every product/version/surface accepts the complete proposed inventory pipeline. [S05, S21]
4. `windowcomp` documents partitioned `max`, row preservation, and an optional result alias. Computing a maximum does not itself select the latest rows. Inventory snapshot interpretation remains a separate schema/data question. [S06]
5. XSIAM BIOCs and real-time correlations cannot directly accept this window-aggregation flow under the documented stage restrictions. A scheduled correlation also has a documented query window of at most seven days; a 30-day reporting query cannot simply be promoted unchanged. [S15, S16]

## Evidence and scope contract

Use `VERIFIED`, `VERSION-DEPENDENT`, `INFERRED`, `CONCEPTUAL`, `UNSUPPORTED`, or `UNVERIFIED` as claim status. `OFFICIAL-CURRENT`, `OFFICIAL-EXAMPLE`, and `TENANT-UNVERIFIED` describe provenance/validation boundaries. A dated official example is not a schema contract.

Every source below was reviewed or retrieval-attempted on **2026-09-20**. “Current page” means the substantive destination was retrieved that day; it does not mean a tenant build was verified. Several legacy URLs redirect to the documentation homepage, and several migrated command pages returned retrieval errors. Those failures are recorded, not treated as proof that a feature is absent. Search-index evidence is explicitly distinguished from a successfully retrieved page.

| Dimension | Result |
|---|---|
| S — independent controlled static/behavioral evaluation | NOT RUN; this research is not its own independent test |
| D — official documentation | PASS only for the individual supported claims identified below; NOT RUN for a complete canonical inventory query because material schema evidence is missing |
| C — tenant schema/compiler acceptance | NOT RUN; no named tenant evidence |
| E — tenant execution/results | NOT RUN; no queries executed |

Products considered: XSIAM current migrated documentation and XDR 5, separately. XDR 3 references and historical Unit 42 examples retain their narrower version boundary. Intended initial consumer: interactive investigation/reporting, as a design assumption. Exact deployed builds, licenses, identity scope, collection settings, retention, and output bounds remain Unknown.

## Source and inventory boundaries

The XSIAM and XDR 5 source lists name `host_inventory`, `va_cves`, and `va_endpoints` as datasets, and include `host_inventory_applications` and `host_inventory_endpoints` among inventory presets. Do not silently turn a preset into a dataset or assume that an endpoint-management API object is a query dataset. The same pages describe `xdr_data` as a built-in event source and warn that dataset availability depends on integrations. [S01, S02]

The general preset text describes field groupings and a randomly ordered first-million-result boundary. It is not a complete, inventory-specific retention or snapshot contract. In particular, do not use its broad discussion of `xdr_data` presets to assume every inventory field can be substituted into `dataset = xdr_data`. Confirm the actual source and row population in the target tenant. Dataset names are treated as lowercase in queries; schema/autocomplete updates may lag. [S01]

Both Host Inventory pages document a 24-hour endpoint scan cadence, display of information from the previous 30 days, initial collection taking up to six hours, and an option to rescan. Applications are supported on Windows, Mac, and Linux. Host Inventory Data Collection must be enabled. The XDR 5 page lists a **Cortex XDR Pro per Endpoint** prerequisite; older community claims of a mandatory separate Host Insights add-on must not override that current product-specific page. XSIAM's retrieved prerequisites do not establish an identical license contract. [S03, S04]

Implementation impact: “installed software observed in inventory” is an inventory observation. It does not establish execution, service state, exploitability, organization approval, complete software discovery, or current installation state at query time. A 30-day UI display statement is not proof that a custom query contains all endpoints or every historical snapshot. Those are INFERRED interpretation boundaries, requiring tenant evidence.

### Observable field evidence

“Observable” below means present in the cited source, not observed in a tenant. No complete current official schema for the application preset was located in this review.

| Field or group | Evidence actually found | Status and implementation decision |
|---|---|---|
| `application_name`, `version`, `endpoint_name`, `ip_address`, `platform` | Unit 42 OpenSSL article uses these with the application preset; article explicitly updated 2022-11-04 [S20] | VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED. Candidate fields; types, population, and current product compatibility require validation |
| `vendor`, `manager_name` | LIVEcommunity accepted answer dated 2022-12-09 shows them [C01] | UNVERIFIED for current official schema. Community lead only; not an executable contract |
| `report_timestamp`, `endpoint_type` | LIVEcommunity question dated 2022-12-13 includes them [C02] | UNVERIFIED. A user's query is not proof of type, availability, or timestamp semantics |
| `endpoint_id` within `host_inventory_applications` | No authoritative preset schema or relevant current official example found | UNVERIFIED. Do not substitute `agent_id`, hostname, or a UI column without proof |
| Arbitrary installed path, uninstall command, username, install date, architecture, status, last-seen field | No complete official preset contract retrieved | UNVERIFIED. Request exact schema; do not guess near-synonyms |
| `agent_id`, `agent_hostname`, `agent_version`, `agent_os_sub_type` in `xdr_data` | Current XDR_DATA schema identifies these as strings; `agent_id` identifies an agent [S13] | VERIFIED / OFFICIAL-CURRENT / TENANT-UNVERIFIED for this source only |
| `_time`, `_insert_time` in `xdr_data` | Current schema identifies integer system timestamps [S13] | VERIFIED for this source; do not transfer the same type to `report_timestamp` |

## Requested canonical-flow assessment

| Requested component | Assessment | Minimal next evidence |
|---|---|---|
| `preset = host_inventory_applications` | VERIFIED as a documented source; exact selection form corroborated by historical official example [S01, S02, S20] | Target preset discovery and bounded result |
| `config case_sensitive = false timeframe = 30d` | VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED for the combined form [S21]; individual controls VERIFIED [S05] | Compile the exact first line in the named product/surface |
| `windowcomp max(report_timestamp) by endpoint_id` | General stage structure VERIFIED [S06]; this concrete field-dependent expression UNVERIFIED | Types, nullability, preset schema, timestamp meaning, and compiler acceptance |
| “Latest complete report” semantics | UNVERIFIED | Prove shared report identity/time across all application rows, full versus delta reporting, empty reports, deletions, duplicates, and delayed ingestion behavior |
| `lowercase()` normalization | VERIFIED in XDR 3 function documentation; general current examples also show use [S10, S11]. Cross-product exact query remains TENANT-UNVERIFIED | Confirm input is a string and how nulls should be represented |
| Final output fields | Partial historical example evidence only | Explicit current output schema and field/type evidence for every column |

General language fragment, shown solely to document the stage grammar, not as an inventory query:

```text
windowcomp max(<documented comparable field>) by <documented partition field> as <new result field>
```

This is **CONCEPTUAL** because the operands are placeholders. With neither `sort` nor a frame clause, the documented window is the whole partition. Adding `sort` without a frame changes the default to a running window ending at the current row. An explicit alias avoids reliance on generated output names. [S06]

Conceptual application design, conditional on the missing schema contract:

```text
admit inventory reports in the intended time window
→ exclude or separately report unusable endpoint keys/timestamps
→ compute each endpoint's greatest admitted report value
→ keep all application rows belonging to that report
→ normalize separate matching fields
→ apply software-family predicates
→ project evidence and report freshness
```

The following are **INFERRED semantic risks**, not claims about an observed tenant:

- Filtering for a software name before selecting the endpoint's newest report can retain an older matching installation even when a newer report no longer contains it.
- Choosing one row per endpoint would lose other applications from the same report. Timestamp ties can legitimately contain multiple application rows.
- If the source is incremental rather than full snapshots, maximum-timestamp equality is not a reconstruction of current inventory.
- If an empty newest snapshot creates no application row, the application preset alone may be unable to distinguish that report from a missing report.
- A maximum within the admitted window is only the maximum within that window. It does not prove globally newest data or freshness.
- A missing application result cannot distinguish absence from disabled collection, stale endpoints, filtering, permissions, retention, or truncation without additional evidence.

The intended output contract should therefore retain source evidence: validated endpoint key/name, original application name, original version/vendor where available, report timestamp, and an explicitly derived family label when used. These are semantic requirements, not assertions that any particular field spelling is available. Preserve originals alongside normalized fields; do not silently alter evidence values.

## Language findings and implementation implications

| Concept | Documented basis | Implementation impact and status |
|---|---|---|
| `config` | Must be first; default case sensitivity is false; relative durations and absolute ranges are documented [S05] | VERIFIED. Record timezone and admitted window; do not infer timestamp-field equivalence |
| `filter` | Retains rows satisfying a boolean expression; comparisons, boolean operators, set/string/regex operators, parentheses, and null checks are described [S07] | VERIFIED. Parenthesize mixed predicates; keep null and empty-string cases distinct |
| `fields` | Selects/aliases columns, does not create values or accept functions; later stages use the alias [S08] | VERIFIED. Retain keys and report fields until their final use. Some system columns remain if present |
| `alter` | Current `fields` documentation directs value creation to `alter`; current/dated official examples show assignments and transformations [S08, S11] | VERIFIED for basic field creation. Full standalone command page could not be freshly retrieved; avoid claiming an exhaustive refreshed grammar |
| `comp` | Current `windowcomp` page explicitly contrasts grouped aggregation with row-preserving windows; official indexed `comp` page describes grouping [S06, S12] | VERIFIED for aggregation concept. Complete refreshed grammar/output contract not retrieved; no inventory implementation approved from this alone |
| `windowcomp` | Aggregate function over partitions, adds result to retained rows [S06] | VERIFIED. Snapshot correctness is a separate condition; avoid unnecessary sorting |
| `join` | Inner/left/right types; inner default; conflict strategy right default; subquery aliases; sort order not preserved [S09] | VERIFIED. Define join grain, key mapping, temporal scope, unmatched rows, and multiplicity. Field conflict policy is separate from join type |
| `lowercase` | Converts a string to lowercase [S10, S11] | VERIFIED within cited scope. It standardizes representation; it is not software-family identity or version parsing |
| `arrayexpand` | Creates rows for array elements and repeats the other fields; order unspecified [S17] | VERIFIED. Account for row multiplication and truncation if an expansion limit is used |
| `arrayfilter` | Array plus condition produces a filtered array; XDR 3 documents `@element` [S18] | VERSION-DEPENDENT. Do not pass a scalar or assume current inventory stores applications in that representation |
| `array_length` | Counts array elements; XDR 3 notes NULL for an empty field [S19] | VERSION-DEPENDENT. Test missing, null, empty-array, and malformed input separately |
| JSON and other string functions | Official function index lists scalar/array JSON extraction, `split`, `arraymap`, `arraystring`, `replace`, and related functions [S23] | Existence is documented; exact signatures/return types must be verified before implementing each one |

Case handling needs two independent decisions: comparison policy and normalized display/grouping values. An insensitive filter does not by itself define a canonical application name. Avoid folding platform-specific product names, paths, or versions into a single family without a reviewed matching contract. This is library design guidance, not a vendor rule.

### Time and freshness

The XDR schema defines `_time` as the record timestamp, with insertion time as fallback if unknown; `_insert_time` is when the record entered the system. Neither establishes `report_timestamp` semantics. [S13]

`timestamp_diff` accepts two timestamps and a unit, calculating the first minus the second. Supported units include DAY through MICROSECOND as enumerated by the reference. Do not feed an unverified epoch/string field into this function without a documented conversion contract. [S14]

A future validation record should distinguish query execution time, source report time, ingestion time, and any freshness threshold. Persist UTC bounds plus the intended display timezone. Assess offline endpoints and delayed arrival separately; no freshness threshold is prescribed by this research.

### Performance and result completeness

XSIAM guidance recommends smaller timeframes, selective filters, necessary columns, and explicit result limits. It documents a 1,000-row default for basic dataset/XDM queries with no stages beyond `fields`, while widgets, correlations, APIs, saved queries, and scheduled queries have different limits; legacy templates also differ. A UI or transport cap is not a bound on upstream processing. [S22]

For joins, filter and project both sides while preserving required keys; perform final sorting after the join. [S09] For inventory, do not apply software filters early if doing so changes which report is considered latest. Document that exception to the general “filter early” advice. An explicit result cap must be reported as possible truncation, never as complete fleet coverage. No speedup, resource consumption, or safe fleet size was measured.

## Restricted execution surfaces

| Surface | Verified restriction and consequence |
|---|---|
| XSIAM BIOC | Minimum `event_type` filter; sources limited to `xdr_data`, `cloud_audit_log`, and their presets; `filter`, `alter`, and non-aggregate functions supported. Proposed inventory/window flow is UNSUPPORTED as a direct BIOC conversion [S15] |
| XSIAM real-time correlation | Stage set is `dataset`, `datamodel`, `filter`, `alter`, `fields`, `config case_sensitive`; `filter` required; dataset views unsupported. Proposed window aggregation is UNSUPPORTED [S16] |
| XSIAM scheduled correlation | No `call`, `top`, dataset wildcard, or `tag`; documented minimum frequency ten minutes and query window up to seven days. Thirty-day inventory reporting is not an unchanged rule definition [S16] |
| API, saved query, widget, XDR rules | Compatibility of the complete inventory flow UNVERIFIED; each needs its own product/version/schema/result contract |
| XQLp | Separate parsing language; a Query Center inventory query is not a parsing rule. No XQLp implementation is proposed |

## Tenant evidence needed before implementation approval

1. Identify exact product/build, tenant alias, interactive surface, license, identity, RBAC, dataset access, and SBAC scope. Saved-object sharing is a separate access check.
2. Capture the preset's actual field names/types and a small sanitized sample including original application fields, endpoint key, report marker/time, and available system timestamps.
3. Establish collection coverage and report behavior: complete snapshots versus deltas; latest empty report; removed application; multiple versions; null keys/times; duplicates; delayed reports; reinstalled agents and reused hostnames.
4. Compare the proposed latest-report result to a known Host Inventory view for controlled positive and negative endpoints. A UI TSV export alone does not map UI headers to XQL field names.
5. Compile one transformation at a time, then record bounded execution, row counts, null rates, ties, freshness, result truncation, and source scope. Preserve sanitized errors and outcomes.
6. Only then approve a concrete query and its output contract; record S/D/C/E separately. Rules require an additional surface-specific review.

Read-only research needs no configuration rollback (N/A). A later bounded validation should stop on unexpected volume or source mismatch, retain only sanitized evidence, and use the tenant's supported cancellation flow once documented. Endpoint/source owner verifies a controlled software inventory marker; platform owner verifies collection and report arrival; data owner verifies schema/time/retention; identity owner verifies visibility; library maintainer verifies semantics. Actual owner names and tenant trust boundaries remain Unknown.

## Official source register

All rows reviewed **2026-09-20**. Unless explicitly stated, publication/update date is not exposed in the retrieved page. Every documentation-supported runtime claim remains **TENANT-UNVERIFIED**.

| ID | Direct official source/title | Evidence class / publication boundary | Concept and implementation impact |
|---|---|---|---|
| S01 | [Datasets and presets — Cortex XSIAM](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets) | VERIFIED / OFFICIAL-CURRENT; substantive page retrieved | Source inventory and preset distinction; no complete application schema |
| S02 | [Datasets and presets — Cortex XDR 5](https://cortex-docs.paloaltonetworks.com/cortex-xdr-5.x/reference-and-developer-docs/cortex-xdr-xql/get-started-with-xql/datasets-and-presets) | VERIFIED / OFFICIAL-CURRENT | Independently confirms inventory sources for XDR 5 |
| S03 | [Host Inventory — Cortex XSIAM](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/protect-your-endpoints/endpoint-security/install-and-manage-endpoints/harden-endpoint-security/host-inventory) | VERSION-DEPENDENT / OFFICIAL-CURRENT | Collection cadence, platform coverage, collection enablement |
| S04 | [Host Inventory — Cortex XDR 5](https://cortex-docs.paloaltonetworks.com/cortex-xdr-5.x/protect-your-endpoints/install-and-manage-endpoints/harden-endpoint-security/host-inventory) | VERSION-DEPENDENT / OFFICIAL-CURRENT | XDR Pro per Endpoint prerequisite; exported views not XQL schema |
| S05 | [config](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/config) | VERIFIED / OFFICIAL-CURRENT | First-stage requirement, case controls, relative and absolute time |
| S06 | [windowcomp](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/windowcomp) | VERIFIED / OFFICIAL-CURRENT | Window grammar, partition/frame behavior, alias and row preservation |
| S07 | [filter](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter.md) | VERIFIED / OFFICIAL-CURRENT | Boolean selection, operators, null handling |
| S08 | [fields](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/fields) | VERIFIED / OFFICIAL-CURRENT | Projection versus transformation; downstream aliases |
| S09 | [join](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join.md) | VERIFIED / OFFICIAL-CURRENT | Join types, conflicts, aliases, lost sorting, performance |
| S10 | [lowercase — XDR 3](https://cortex-docs.paloaltonetworks.com/cortex-xdr-3.x/cortex-xdr-3.x-documentation/cortex-xdr-xql/functions/lowercase) | VERSION-DEPENDENT / OFFICIAL-CURRENT; legacy version scope | Exact string function; no inventory schema guarantee |
| S11 | [Example 2: Lowercasing a literal string](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Lowercasing-a-literal-string?contentId=NcAsuVD5jrBpE0EZmIwXLA) | VERSION-DEPENDENT / OFFICIAL-EXAMPLE; official indexed content retrieved, current destination not established | Corroborates lowercase assignment through alter |
| S12 | [comp](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/comp?contentId=~GPg2p5DWpoOafS5~ZDO6Q) | VERSION-DEPENDENT / OFFICIAL-EXAMPLE; indexed prose only, open redirects home | Aggregation concept; exhaustive refreshed syntax remains UNVERIFIED |
| S13 | [XDR_DATA Fields](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields) | VERIFIED / OFFICIAL-CURRENT | Typed event schema and time provenance; not application-preset schema |
| S14 | [timestamp_diff](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff) | VERIFIED / OFFICIAL-CURRENT | Timestamp arithmetic requires appropriate inputs |
| S15 | [Create a BIOC rule — XSIAM](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/detect-investigate-and-respond-to-threats/threat-management/detection-rules/what-are-detection-rules/whats-a-bioc/create-a-bioc-rule) | VERSION-DEPENDENT / OFFICIAL-CURRENT | Source/stage boundaries prohibit direct window-flow promotion |
| S16 | [Create a correlation rule — XSIAM](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/detect-investigate-and-respond-to-threats/threat-management/detection-rules/what-are-detection-rules/whats-a-correlation-rule/create-a-correlation-rule) | VERSION-DEPENDENT / OFFICIAL-CURRENT | Real-time subset and scheduled timing constraints |
| S17 | [arrayexpand](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/arrayexpand) | VERIFIED / OFFICIAL-CURRENT | Array expansion changes row count; requires actual array schema |
| S18 | [arrayfilter — XDR 3](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/arrayfilter) | VERSION-DEPENDENT; official indexed document published 2026-06-27 | Array filtering signature; refresh target before use |
| S19 | [array_length — XDR 3](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/array_length) | VERSION-DEPENDENT; official indexed document | Array size/null distinction; no invented array field |
| S20 | [OpenSSL Vulnerabilities Threat Brief](https://unit42.paloaltonetworks.com/openssl-vulnerabilities/) | VERSION-DEPENDENT / OFFICIAL-EXAMPLE; page update 2022-11-04 | Five preset field names and preset selection example; not current schema |
| S21 | [Hunting for Unsigned DLLs to Find APTs](https://unit42.paloaltonetworks.com/unsigned-dlls/) | VERSION-DEPENDENT / OFFICIAL-EXAMPLE; historical article (2022), exact publication day not established in this review | Exact combined config form; no validation of inventory flow |
| S22 | [XQL Query best practices — XSIAM](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/detect-investigate-and-respond-to-threats/investigation-and-response/build-xql-queries/how-to-build-xql-queries/xql-query-best-practices) | VERSION-DEPENDENT / OFFICIAL-CURRENT | Context-dependent limits and query-size guidance |
| S23 | [Functions List](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Functions-List) | VERSION-DEPENDENT; official indexed content | Function discovery only; not signature or target-context acceptance |

### Secondary leads, not validation authorities

| ID | Source | Evidence treatment |
|---|---|---|
| C01 | [LIVEcommunity — XQL Query Help](https://live.paloaltonetworks.com/t5/cortex-xdr-discussions/xql-query-help/td-p/523651) | Accepted answer 2022-12-09; suggests vendor/manager fields and pre-parsed application preset; current schema UNVERIFIED |
| C02 | [LIVEcommunity — XQL Query help is required to narrow down our requirement](https://live.paloaltonetworks.com/t5/cortex-xdr-discussions/xql-query-help-is-required-to-narrow-down-our-requirement/td-p/524037) | Question 2022-12-13 uses report_timestamp/endpoint_type; not authoritative schema or working-query evidence |

### Retrieval gaps and source-quality cautions

- Fresh standalone retrieval failed for general `preset`, `alter`, `comp`, `lowercase`, `limit`, `arrayfilter`, `array_length`, and JSON-function-reference pages during this review. Legacy command links often resolved to a generic homepage. Alternate official pages support only the narrower claims explicitly recorded above.
- The retrieved `config` examples contain timestamp/output inconsistencies, including an output row later than the stated exact end time. Use normative syntax/parameter descriptions; do not derive boundary inclusivity or clock semantics from those sample tables.
- The `windowcomp` page's counting example includes sorting but describes an all-partition count, conflicting with its stated running-frame default. Follow the normative frame description; add a target fixture before relying on ordering/frame semantics.
- The separate current-general versus XDR 3 `regextract` return-shape conflict is recorded in the local skill snapshot but was not refreshed here. Any future dependency on `regextract` remains VERSION-DEPENDENT and requires direct target documentation plus type verification; it is not needed for this Phase 1 report.

No missing official-schema result is asserted to prove nonexistence. The actionable blocker is sufficient evidence to bind each proposed field and snapshot rule to the intended product/surface.
