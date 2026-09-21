# Architecture

## Decision

This release implements only the **Cyber Hygiene** module. It is an open-source, read-only query library for Cortex XSIAM/XDR Query Center. Threat Hunting, Detection Engineering, Incident Investigation, Identity, Cloud, Network, Endpoint, Persistence, Credential Access, Lateral Movement, and Exfiltration remain future modules.

The library is documentation-grounded but **tenant-unverified**. It does not claim that a query compiles, executes, returns complete fleet inventory, or proves software use. The current decision is `PROCEED TO STATIC IMPLEMENTATION AND TENANT VALIDATION`, not production deployment.

## Component model

```text
catalog/software-catalog.yaml
        |
        | reviewed exact-name candidates
        v
tools/generate_query_library.py
        |
        +--> cyber-hygiene/<category>/detect-*.xql
        +--> cyber-hygiene/<category>/README.md
        +--> cyber-hygiene/<category>/query-metadata.yaml
        +--> cyber-hygiene/all-detected-tools.xql
        +--> cyber-hygiene/all-detected-tools.md
        +--> cyber-hygiene/all-detected-tools.metadata.yaml

tools/generate_support_docs.py
        |
        +--> correlations/cyber-hygiene/*.md
        +--> docs/query-validation-matrix.md

tests/validate_library.py
        |
        +--> catalog integrity
        +--> generated-artifact drift
        +--> query/guide/metadata completeness
        +--> forbidden unverified source-field checks
```

The catalog is the single maintained source for product identity candidates, vendor labels, categories, subcategories, and policy-neutral context. Generated query artifacts remain standalone for easy copy/paste, while generation prevents 31 manually diverging classifiers.

## Query source and evidence ceiling

Current official XSIAM and XDR documentation lists `host_inventory_applications` as a preset. A historical first-party **Cortex XDR** example supplies candidate fields `application_name`, `version`, `endpoint_name`, `ip_address`, and `platform`. No complete current preset schema was found. Therefore v1 uses only `application_name`, `version`, `endpoint_name`, and `platform` from that XDR example plus derived fields. The generated query text is an XDR documentation-example candidate; XSIAM use requires a separate field-binding record before compilation.

The following requested fields are intentionally absent from executable-looking v1 queries because their preset availability or semantics were not established: `endpoint_id`, `report_timestamp`, `vendor`, `install_date`, and a stable product-publisher field. `reported_vendor`, freshness, current-snapshot, and install-age claims are therefore not emitted.

Every query has this evidence ceiling:

- Canonical class: `VERSION-DEPENDENT`
- Qualifiers: `OFFICIAL-EXAMPLE`, `TENANT-UNVERIFIED`
- S: `NOT RUN` unless the independent QA artifact records a bounded static check
- D: `NOT RUN` for each complete generated query; individual language/source claims can have separate claim-level `PASS` records
- C: `NOT RUN`
- E: `NOT RUN`

## Row grain and semantics

The v1 row grain is **one application-inventory row admitted by the selected 30-day query window and matched to a catalog candidate**. It is not guaranteed to be the latest complete software snapshot per endpoint.

A positive row supports only: “the visible application inventory reported a matching label in the admitted window.” It does not prove execution, session use, approval status, maliciousness, current installation, protection health, or completeness. Zero rows do not prove absence.

The proposed `windowcomp max(report_timestamp) by endpoint_id` wrapper is withheld until the tenant verifies:

- literal field names and types;
- report time semantics;
- full-snapshot versus delta behavior;
- empty newest reports;
- ties, duplicates, delayed reports, and reinstalled agents;
- stable endpoint identity and coverage.

## Classification contract

Queries normalize `application_name` with `lowercase()` and compare complete lowercased strings to catalog literals. Substring matching is not generated. Null and empty names are excluded before normalization. Raw `application_name` is preserved.

The generated classifier produces:

- `detected_product` — catalog canonical name;
- `product_id` — stable catalog ID;
- `tool_family` — primary category name;
- `tool_subcategory` — catalog subcategory;
- `expected_product_vendor` — curated vendor/project label, not a tenant publisher assertion;
- `corporate_relevance` — policy-neutral review context;
- `review_priority` — always `POLICY_DEPENDENT_UNASSIGNED` in the public library.

Exact literals are unique across product records. Static validation fails on a collision, unresolved product, generic one-token pattern prohibited by policy, or a mismatch between catalog and generated classifiers.

## Query organization

There is one category query for each of the 30 taxonomy categories and one master query. Secondary-category membership is documented in the catalog but v1 category queries use primary ownership only. This avoids one source of cross-category repetition; it does **not** prevent duplicate inventory rows, versions, reports, components, endpoints, or fleet counts. Organizations must define endpoint identity, snapshot, and deduplication semantics before counting installations or assets.

Each query has:

- an `.xql` artifact;
- an adjacent README with objective, data source, logic, products, output, false positives, limitations, tuning, validation, and references;
- YAML metadata with the requested fields and explicit S/D/C/E status.

## Allowlist boundary

The public queries classify inventory observations; they do not decide approval. Future organization-specific comparison requires a separately governed allowlist with product ID, product/version scope, asset/user/business-unit scope, owner, justification, effective dates, expiry, and exception evidence.

No placeholder such as `APPROVED_PRODUCTS_HERE` is emitted into an executable query because an unbound sentinel can be misinterpreted. The allowlist schema is documented in `docs/allowlisting.md`.

## Correlation boundary

`correlations/` contains conceptual designs only. An inventory match is not automatically a Case/Issue or incident. Direct BIOC and real-time correlation conversion of the inventory aggregation design is unsupported by reviewed restrictions; scheduled rules need separate timeframe, schema, grouping, hit-volume, severity, exception, and tenant tests.

## Scalability roadmap

| Catalog size | Strategy |
|---:|---|
| Up to 50 products | Generated standalone exact-match chains are reviewable and portable. |
| 51–100 | Keep generation mandatory; split by category and enforce collision/drift tests. |
| 101–500 | Keep category artifacts; master query remains generated but should be measured for compiler size and runtime before tenant use. |
| 501–1,000 | Prefer a tenant-managed lookup/dataset and a documented join only after target support, schema, permissions, cardinality, update ownership, and rollback are verified. |
| Above 1,000 | Treat classification as a governed data product with versioned ingestion, quality metrics, staged rollout, and consumer contracts. |

The repository does not create or overwrite lookup datasets. XQL `target` is state-changing and is outside v1.

## Future module expansion

Future modules live beside `cyber-hygiene/`, keep independent catalogs and telemetry contracts, and may reference Cyber Hygiene product IDs without changing inventory observations into behavioral evidence. Cross-module correlations require explicit entity/time alignment and separate validation.

## Ownership and gates

| Gate | Owner | Acceptance evidence |
|---|---|---|
| G0 scope | Lead architect + risk owner | Cyber Hygiene-only scope and non-goals accepted |
| G1 source/schema | Cortex platform/data owner | Preset, fields, types, retention, coverage, RBAC/SBAC observed |
| G2 query | XQL engineer | Exact query compiles and bounded fixtures execute in the named tenant |
| G3 policy | Software governance owner | Allowlist and review-priority contract approved |
| G4 correlation | Detection owner | Rule-specific tests, issue quality, safeguards, monitoring, rollback |
| G5 publication | Maintainer | Static checks pass; evidence claims and references reviewed |

No gate in this repository authorizes containment, blocking, uninstall, isolation, or another response action.
