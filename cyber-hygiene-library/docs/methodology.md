# Methodology

## Objective and scope

The library helps analysts review application-inventory observations that may be relevant to corporate Cyber Hygiene. It is intentionally policy-neutral and does not identify malware, prove execution, or replace endpoint-management inventory.

## Evidence order

1. Current official Palo Alto Networks documentation for the named product and surface.
2. Current or pinned first-party examples.
3. Direct tenant schema, compiler, and execution evidence.
4. Local project artifacts for their own structure only.
5. Secondary sources as leads, never as the sole runtime contract.

Claims use `VERIFIED`, `VERSION-DEPENDENT`, `INFERRED`, `CONCEPTUAL`, `UNSUPPORTED`, `DEPRECATED`, or `UNVERIFIED`, with provenance qualifiers. Validation uses independent S/D/C/E results: `PASS`, `FAIL`, `NOT RUN`, or `N/A`.

## Research-to-query workflow

1. Verify the source exists in current product documentation.
2. Record every source field and its evidence boundary.
3. Build the product taxonomy separately from XQL syntax.
4. Prefer full-string, case-insensitive candidate labels over broad substrings.
5. Preserve the raw inventory name and map only reviewed literals.
6. Generate category and master artifacts from one catalog.
7. Run independent static QA and resolve BLOCKER/HIGH findings.
8. Validate schema, compile, and execute with bounded fixtures in a named non-production tenant.
9. Tune organization policy through governed allowlists, not public risk labels.

## Product research rules

A vendor/project page can support product existence and general function. It cannot verify a Cortex display name. Every catalog pattern remains a candidate until a tenant record with sanitized raw label, publisher/package corroboration, product/version, platform, collection time, and positive/negative fixtures is retained.

Alternate names are descriptive and are not enabled patterns. New patterns require lookalike negatives. A product with multiple roles has one primary category and optional secondary categories; this prevents double-counting in the default query set.

## Query design rules

- Use a bounded timeframe and explicit result limit.
- Filter null/empty application names before string functions.
- Preserve raw source fields alongside derived labels.
- Use explicit parentheses around mixed boolean logic.
- Apply exact-name classification; avoid `contains "ai"`, `contains "vpn"`, `contains "remote"`, and similar generic predicates.
- Explain cardinality changes and truncation.
- Do not use latest-report logic until snapshot semantics and fields are tenant-verified.
- Do not claim performance gains without measurements.
- Keep rule/correlation conversion separate from Query Center validity.

## Interpretation rules

Inventory can answer “Which visible rows reported a matching application label?” It cannot answer “Was this product executed?” or “Was it used for remote access?” without behavioral telemetry.

Approval is also separate from identity. A correct match to an approved corporate tool is not a false identity match; it is a policy-allowed observation. Absence of an allowlist entry is Unknown until policy ownership and scope are bound.

## Validation fixtures

Each product or category validation should include:

- known positive raw labels;
- known benign approved installations;
- negative lookalikes/components;
- null and empty application names;
- version/locale/architecture suffixes;
- duplicate rows and multiple versions;
- boundary-time rows;
- restricted-identity visibility;
- stale/offline endpoint cases;
- newest empty report and removed-application cases before enabling snapshot logic.

## Change control

Catalog changes require stable IDs, source/date, exact proposed labels, negative examples, category rationale, impacted queries, and evidence status. Generated files must be regenerated and static drift checks must pass. Tenant-specific observations and allowlists must not be committed to the public catalog.
