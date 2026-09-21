# Reference repository analysis — Phase 2

Reviewed **2026-09-20**, after completion of [Phase 1 official research](palo-alto-xql-research.md). This phase analyzes architecture and existing authored logic only. It creates no queries, taxonomy, tenant bindings, or detection rules.

## Evidence boundary and retrieval

Reference: [lucaslapinho/XSIAM-Palo-Alto-Queries](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/tree/main). The current main revision resolved to **78cf3d3d8179dfbb00bea10b6745c06fef4a23b9**, committed 2026-09-11 18:46:06 UTC. All file reads were pinned to that revision. The recursive GitHub tree returned `truncated: false`; all **207 text files** were retrieved: 100 XQL files, 100 companion guides, and seven READMEs. Structural counts and duplicate comparisons cover all files; detailed semantic findings below identify the particular files inspected. This is not an exhaustive proof of every query's correctness.

The normal web fetch returned a cache error and local HTTPS requests failed at Windows TLS credential initialization. The connected GitHub read API successfully supplied the current tree and pinned files; local publication copies were not substituted as current evidence.

Repository facts are **VERIFIED / PROJECT-ASSERTED** only in the narrow sense that the pinned files contain the described structure/text. Runtime assertions remain **UNVERIFIED / PROJECT-ASSERTED / TENANT-UNVERIFIED** unless separately supported by Phase 1. Design recommendations are **INFERRED**. The repository is an architectural reference, never a syntax or schema authority.

| Validation level | Result |
|---|---|
| S — independent controlled evaluation | NOT RUN; structural comparisons are not independent runtime/behavioral validation |
| D — official documentation | Phase 1 supports only its explicitly cited claims; full-reference-library language validation NOT RUN |
| C — tenant schema/compiler | NOT RUN |
| E — tenant execution | NOT RUN |

## Current tree and organization

```text
README.md
asset-visibility/      README.md + 4 query/guide pairs
cyber-hygiene/         README.md + 10 query/guide pairs
dashboard/            README.md + 2 query/guide pairs
investigation/        README.md + 24 query/guide pairs
security-operations/  README.md + 6 query/guide pairs
threat-hunting/        README.md + 54 query/guide pairs
```

| Category | Candidates | Schema templates | Total |
|---|---:|---:|---:|
| Asset Visibility | 1 | 3 | 4 |
| Cyber Hygiene | 8 | 2 | 10 |
| Dashboard | 2 | 0 | 2 |
| Investigation | 10 | 14 | 24 |
| Security Operations | 3 | 3 | 6 |
| Threat Hunting | 7 | 47 | 54 |
| **Total** | **31** | **69** | **100** |

Naming is lowercase kebab-case with stable `nNNN-` identifiers covering N001–N100. Each candidate uses `nNNN-description.xql` and a matching `.md`; templates use `.template.xql` and `.template.md`. Every XQL file has its corresponding guide. IDs cross category boundaries and are not a category hierarchy.

The root README is concise: purpose, category counts/links, usage, 31-candidate/69-template distinction, validation disclaimer, and file layout. Category indexes expose ID, guide, topic, query link, and status. Folders are shallow and organized by analyst purpose, not dataset or attack technique. “Cyber Hygiene” also contains executed-software and collection-coverage queries, while software inventory distribution is in Asset Visibility. Thus categories are navigation choices, not exclusive semantic types.

The pinned tree has no LICENSE, CONTRIBUTING, automated test suite, CI workflow, machine-readable catalog, binding manifest, or shared classifier source. This is an observation about current files, not their entire history. The pinned commit message explicitly describes removal of publication scaffolding and machine-readable catalogs in favor of the six-category layout. A future contribution design should respect this simplicity while documenting any additional maintenance artifacts it introduces.

Source: [pinned root README](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/README.md), [pinned tree](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/tree/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9), [revision](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/commit/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9).

## XQL and documentation style

All 100 XQL files contain `//` comments. Typical ordering is validation/scope comments, explicit `config`, source, filters, transformations, aggregation/enrichment where required, explicit projection, final sort, and result cap. Case-insensitive software candidates commonly use 30 days; many binding templates use case-sensitive one-day windows. These are authored choices, not universal defaults or compatible rule configurations.

Inventory candidates first exclude unusable endpoint IDs/report timestamps, compute maximum report time per endpoint, retain matching report rows, normalize the application label, classify products, then apply family-specific selection. This order appropriately avoids selecting an old matching application before determining the latest admitted report. It retains all matching rows rather than one arbitrary application per endpoint. The semantics still depend on unknown report completeness, empty-report handling, and timestamp types.

Product classifiers initialize UNMAPPED values, then use sequential conditional assignments and first-match precedence. Inventory classification uses name substrings; process classification uses basename lists, predominantly Windows executables. Derived family/vendor fields are separated from original source values in inventory detail output. All-software inventory and classified security-tool inventory are separate use cases.

Guides typically contain purpose, navigation, ID/category/status/product/surface, explicit tenant validation status, data/setup, usage, interpretation, and limits. **74 of 100** companion guides have both References and unexecuted Validation examples sections; the other 26 do not have these sections. The richer guides include typed binding tables and positive/negative/null/edge examples. Some older guides duplicate the opening paragraph in “What it returns.”

Comments explain semantic limitations, such as process starts versus sessions, report time versus install time, port versus protocol identity, and result limit versus scan cost. Preserve these distinctions in prose. Their presence is not proof that comment syntax is portable to all editors/import surfaces; Phase 1 did not verify comments.

## Preserve, improve, or replace

| Pattern | Decision | Reason and future design consequence |
|---|---|---|
| Stable IDs, descriptive filenames, adjacent guides | **PRESERVE** | Simple navigation and durable references; retain provenance if later relocated |
| Root/category indexes with counts and status | **PRESERVE** | Readers can distinguish candidates from templates before opening files |
| Explicit unexecuted/tenant-pending labels | **PRESERVE** | Honest boundary; add canonical claim status and S/D/C/E without implying a tenant test |
| Reported installed versus process starts versus policy review | **PRESERVE** | Different evidence classes; do not merge them into a malicious-software verdict |
| Latest-report selection before product filtering | **PRESERVE conditionally** | Sound conceptual ordering; implement only after snapshot/field validation |
| Originals plus derived labels and explicit output grain | **PRESERVE / IMPROVE** | Keep raw evidence; make grain, normalization, tie/null handling and truncation explicit in every guide |
| Shallow analyst-purpose categories | **IMPROVE** | Retain simple browsing; supplement cross-cutting software families and sources through indexes rather than duplicating query ownership |
| Long first-match product condition chains | **REPLACE as maintenance model** | Twenty files repeat classifiers; a reviewed shared source or generation/check process can keep standalone deliverables consistent |
| Plain candidate status despite unverified inventory fields | **REPLACE evidence treatment** | Field assumptions need a binding contract or visibly conceptual template; a compilation disclaimer does not establish schema |
| Comment-heavy executable files | **IMPROVE** | Verify named surface compatibility; otherwise move commentary into guides and provide clean query artifacts |
| Loose name-only product identity | **IMPROVE** | Define positive/negative label examples, match boundaries, aliases, precedence, vendor corroboration and platform scope |
| Generic fixed rarity/multiplicity thresholds | **REPLACE as detection defaults** | Keep exploratory views; thresholds need fleet coverage and an owner-reviewed baseline |
| Product-only approval list/sentinel | **REPLACE for policy enforcement** | Approval requires scope/version/identity/time; required-input checks should prevent accidental unbound execution |
| Typed schema templates and unexecuted fixtures | **PRESERVE / IMPROVE** | Strong contracts; map every material source/field, including hardcoded sides of joins |
| Generic copied reference lists and correlation prose | **REPLACE** | Tie each source and cardinality explanation to actual constructs in that query |
| No visible static/maintenance checks | **IMPROVE** | Future checks should detect mismatched IDs, broken guide links, unresolved inputs, mapping drift and stale evidence |
| Public repository without a current LICENSE file | **IMPROVE** | Record licensing/attribution before republishing copied content; public accessibility alone is not a license |

These are recommendations for subsequent phases, not implemented changes.

## Duplicate, fragile, and generic signals

### Duplication is primarily shared implementation

No query pair had the same Git blob SHA. No pair became identical after stripping full-line comments and collapsing whitespace. This rules out those two forms of exact duplication, not semantic equivalence.

However, **N001, N003, and N005 are byte-identical after removing their single family-filter line**. They are useful VPN, Remote Access, and Dual-Use views of the same classifier, not three independent detection methods. Keep their user-facing purpose if needed, but maintain shared logic once.

Twenty queries initialize the shared detected-product/family/vendor classifier: N001–N020. Their outputs differ (details, prevalence, first-seen, signature, path, co-occurrence), so wholesale deletion as “duplicates” would lose legitimate views. The maintenance risk is repeated naming lists and derived labels without a visible shared source.

Inventory and execution labels also differ: OpenVPN Product Family versus OpenVPN Engine / GUI, WireGuard versus WireGuard for Windows, and SharpHound versus SharpHound Community Edition. These may reflect legitimate granularity, but literal-label joins or combined counts would split related observations. Use a reviewed identity relationship, not string equivalence.

Sources: [N001](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/cyber-hygiene/n001-vpn-software-reported-installed.xql), [N003](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/cyber-hygiene/n003-remote-access-software-reported-installed.xql), [N005](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/cyber-hygiene/n005-dual-use-security-tools-software-reported-installed.xql).

### Concrete fragility and interpretation limits

| Items | Observed logic / fragility | Treatment |
|---|---|---|
| N001/N003/N005 and related inventory views | Concrete endpoint_id, report_timestamp, vendor and sometimes install_date, despite Phase 1 gaps; comments assert empty reports are absent | Reclassify field/snapshot assumptions as UNVERIFIED; do not promote the empty-report assertion to a vendor fact |
| N001/N003/N005 | Broad contains matching and order-dependent first match; nmap/chisel and other label matches do not authenticate a product | Maintain negative fixtures for similarly named packages and variants; preserve raw labels |
| N009/N010 | Distinct endpoint count <= 3 is a fixed rarity proxy | Exploratory prevalence, not maliciousness; small/partial fleets and SBAC materially affect rarity |
| N012/N013 | At least two products in one family | Legitimate coexistence is common; classify as review, not conflict or compromise |
| N014/N015 | Sentinel product approval list returns all mapped products when unchanged | Guides correctly disclose this. Add an input gate; avoid interpreting the result as “unauthorized” |
| N011 | First admitted observation in 30 days, then a 24-hour recency filter | Not first-ever installation or use; retention/coverage/window boundary can create apparent novelty |
| N017 | Name-selected Remote Access plus unsigned state | Useful enrichment, not identity proof; preserve distinction from unknown/missing signature |
| N018 | AppData, Downloads, or Temp path substrings | Candidate path location, not proof that the executing identity has write permission or that behavior is malicious |
| N019 | Product/initiating-image pair present on <= 2 endpoints | Name-based rarity depends on coverage; initiating process semantics must not be overstated as complete ancestry |
| N020 | Same-host Remote Access and script-interpreter aggregates within one day | Co-occurrence only; no session, ancestry, sequence, or causal link |
| N023 | Port 3389 network candidates | Port alone does not prove RDP or a successful session; title appropriately says candidates |
| N021/N022 | Carefully anchored but narrow command grammars | Preserve bounded claims; other valid spellings, arguments, launch styles and platforms require separate coverage fixtures |
| N060/N061 | DNS cardinality/length and web interval regularity | Generic candidate signals; benign automation and measurement/collection effects need baselines, not automatic compromise labels |
| N086 | Latest snapshot and group sources are placeholders, while the application-preset fields are concrete | Binding only the new sources does not validate the concrete preset side or prevent join multiplication |

Most of these limitations are partly disclosed in existing guides. They are reasons to improve reuse contracts, not claims that the author represented the library as production detections.

Additional evidence: [N014 guide](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/cyber-hygiene/n014-tool-approval-baseline-inventory-review-candidates.md), [N011](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/threat-hunting/n011-security-relevant-software-recently-first-observed.xql), [N020](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/investigation/n020-remote-access-tools-and-script-interpreters-host-co-occurrence.xql), [N060](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/threat-hunting/n060-high-cardinality-dns-name-candidates.template.xql), [N061](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/threat-hunting/n061-periodic-identified-web-connection-candidates.template.xql).

### Documentation inconsistencies

N086's guide describes union anchor rows in its correlation-semantics boilerplate, but its XQL contains an inner snapshot join and left group join, with no union. Its reference list includes XDR actor/action-actor pages and timestamp_diff even though this query uses application inventory and no timestamp_diff. Those links cannot establish its inventory schema. Replace this prose with the actual application-by-group grain, inner-join exclusion behavior and multiplicity contract.

N001's purpose promises inventory-age context; the query returns report_timestamp, not a calculated age field. The timestamp can support age interpretation, but the guide should distinguish raw report time from derived freshness. The guide also calls install_date an unparsed string without Phase 1 evidence for that field/type.

Candidate/template is not a complete evidence ladder. Some candidates contain sentinel inputs; some templates contain unverified concrete fields alongside tokens. Documentation needs field-by-field evidence and required-input status, rather than equating a suffix with validity.

Sources: [N086 query](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/asset-visibility/n086-all-reported-software-versions-and-asset-groups.template.xql), [N086 guide](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/asset-visibility/n086-all-reported-software-versions-and-asset-groups.template.md), [N001 guide](https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/blob/78cf3d3d8179dfbb00bea10b6745c06fef4a23b9/cyber-hygiene/n001-vpn-software-reported-installed.md).

## Reconciliation with official research

| Reference pattern | Phase 1 comparison | Decision |
|---|---|---|
| Application preset selection | S01/S02 confirm host_inventory_applications is a preset; historical S20 supports example selection | Preserve source kind; never relabel it a dataset |
| Combined 30-day insensitive config | S05 supports individual controls; S21 is a historical combined example | Keep product/surface/version and exact compile boundary |
| Partitioned max then timestamp equality | S06 supports general window syntax and row preservation | Preserve concept; endpoint_id/report_timestamp schema and complete-report semantics remain UNVERIFIED |
| Normalized name matching | S10/S11 support lowercase in the recorded scope | Normalization is not identity, approval, or complete inventory coverage |
| Projected vendor/install_date | Phase 1 found no authoritative complete current preset contract | Bind or omit; repository usage cannot fill the evidence gap |
| Shared report rows and empty report behavior | Phase 1 explicitly calls these unknown | Replace factual wording with conditional semantics and required fixtures |
| Aggregations/joins and output cap | S06/S09/S22 explain grain, sorting and limits | Record multiplicity; result cap does not bound scans or guarantee fleet completeness |
| Interactive XQL Search target | Repository consistently names the interactive surface | Preserve. S15/S16 prohibit assuming direct BIOC/real-time compatibility; 30-day flow is not an unchanged scheduled rule |
| Inline comments | Not verified in Phase 1 | Compatibility UNVERIFIED; do not infer portability from the files |

## Handoff to later phases

Reuse navigation, paired documentation, stable references, explicit evidence limits, and the distinction between observed inventory, execution and policy assessment. Improve maintenance around product identity and shared matching without transplanting this library's current mapping as authoritative taxonomy. Keep software scope, platform coverage, matching precedence, output grain, null behavior, freshness and evidence provenance explicit.

Before implementing the inventory flow, obtain or visibly defer the exact preset schema and full-versus-delta/empty snapshot semantics listed in Phase 1. A fallback must be a clearly conceptual binding contract; renaming a candidate to a template alone does not settle its concrete field dependencies. No phase may infer tenant compilation, execution, deployment, detection quality, or measured performance from this repository analysis.
