#!/usr/bin/env python3
"""Generate read-only XDR inventory candidates from the reviewed YAML catalog.

Requires Python 3 and PyYAML. --check verifies drift without writing files.
The structural checks here are author maintenance checks, not XQL compilation,
behavioral evaluation, complete-query documentation validation or tenant tests.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from collections import Counter
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "catalog/software-catalog.yaml"
SOURCE_FIELDS = ["endpoint_name", "platform", "application_name", "version"]
DERIVED_FIELDS = [
    "detected_product", "product_id", "tool_family", "tool_subcategory",
    "expected_product_vendor", "corporate_relevance", "review_priority",
]
OUTPUT_FIELDS = SOURCE_FIELDS + ["application_name_normalized"] + DERIVED_FIELDS
REFERENCES = [
    ("R1", "XDR 5 datasets and presets", "https://cortex-docs.paloaltonetworks.com/cortex-xdr-5.x/reference-and-developer-docs/cortex-xdr-xql/get-started-with-xql/datasets-and-presets", "Current source listing, retained in Phase 1 research; not complete application schema."),
    ("R2", "Unit 42 OpenSSL threat brief", "https://unit42.paloaltonetworks.com/openssl-vulnerabilities/", "Historical Cortex XDR preset and source-field example, updated 2022-11-04."),
    ("R3", "config", "https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/config", "Current individual case/time controls and first-stage ordering."),
    ("R4", "filter", "https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter.md", "Phase 1 retrieval and official indexed examples support boolean/null/in comparison."),
    ("R5", "fields", "https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/fields", "Current projection and possible non-excludable system fields."),
    ("R6", "lowercase, XDR 3", "https://cortex-docs.paloaltonetworks.com/cortex-xdr-3.x/cortex-xdr-3.x-documentation/cortex-xdr-xql/functions/lowercase", "Version-scoped string normalization; current general page retrieval failed."),
    ("R6b", "Indexed lowercase example", "https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Lowercasing-a-literal-string?contentId=NcAsuVD5jrBpE0EZmIwXLA", "Substantive official indexed lowercase/alter example."),
    ("R7", "Nested if example", "https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-4-if-with-nested-if-for-complex-logic", "Substantive official indexed three-argument conditional code; direct fetch failed."),
    ("R8", "Conditional alter example", "https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-9-Using-conditional-and-null-handling-functions-if", "Official indexed conditional assignment; current general if/alter retrieval failed."),
    ("R8b", "alter", "https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/alter.md", "Dated skill reference documents comma-separated constant/field/function assignments; no successful fresh standalone retrieval."),
    ("R9", "Unit 42 unsigned DLL investigation", "https://unit42.paloaltonetworks.com/unsigned-dlls/", "Phase 1 historical combined insensitive 30-day config example; not an inventory test."),
    ("R10", "limit", "https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/limit", "Current explicit result bound; no measured performance claim."),
]

PROHIBITED_GENERIC_LITERALS = {
    "ai", "vpn", "remote", "cloud", "agent", "security", "visual", "code",
}


def quoted(value: str) -> str:
    """Use plain documented string literals; fail before inventing escape rules."""
    if not isinstance(value, str) or any(c in value for c in ('"', "\\", "\n", "\r", "\t")):
        raise ValueError(f"Value needs an independently reviewed XQL escaping contract: {value!r}")
    return '"' + value + '"'


def validate_literal(value: str) -> str:
    """Validate an exact application label; return its normalized collision key."""
    if not isinstance(value, str) or not value or value != value.strip():
        raise ValueError(f"Invalid exact-name candidate: {value!r}")
    if not value.isascii() or any(c in value for c in "*?"):
        raise ValueError(f"Candidate needs separate matching/case evidence: {value!r}")
    quoted(value)
    normalized = value.lower()
    if normalized in PROHIBITED_GENERIC_LITERALS:
        raise ValueError(f"Generic one-token candidate is prohibited: {value!r}")
    return normalized


def load_catalog() -> tuple[dict, dict[str, dict]]:
    catalog = yaml.safe_load(CATALOG.read_text(encoding="utf-8"))
    categories = {c["category_id"]: c for c in catalog["categories"]}
    if len(categories) != len(catalog["categories"]) or len(categories) != 30:
        raise ValueError("Expected 30 unique category IDs")
    if catalog["product_count"] != len(catalog["products"]):
        raise ValueError("Declared product count differs from actual catalog")
    ids: set[str] = set()
    literals: dict[str, str] = {}
    for product in catalog["products"]:
        pid = product["product_id"]
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", pid) or pid in ids:
            raise ValueError(f"Invalid or duplicate product ID: {pid}")
        ids.add(pid)
        if product["category"] not in categories or not product["application_name_patterns"]:
            raise ValueError(f"Missing category or candidates: {pid}")
        if product["review_priority"] != "POLICY_DEPENDENT_UNASSIGNED":
            raise ValueError(f"Public priority is not policy-neutral: {pid}")
        for pattern in product["application_name_patterns"]:
            value = pattern["value"]
            if pattern["operator"] != "equals_ci":
                raise ValueError(f"Invalid exact-name candidate: {pid}")
            normalized = validate_literal(value)
            if normalized in literals:
                raise ValueError(f"Exact literal collision: {value}: {literals[normalized]}, {pid}")
            literals[normalized] = pid
        for value in mappings(product, categories).values():
            quoted(value)
    if set(Counter(p["category"] for p in catalog["products"])) != set(categories):
        raise ValueError("Every category must have primary products")
    return catalog, categories


def mappings(product: dict, categories: dict[str, dict]) -> dict[str, str]:
    return {
        "detected_product": product["canonical_product_name"],
        "product_id": product["product_id"],
        "tool_family": categories[product["category"]]["name"],
        "tool_subcategory": product["subcategory"],
        "expected_product_vendor": product["vendor"],
        "corporate_relevance": product["corporate_security_context"],
        "review_priority": product["review_priority"],
    }


def literals_for(products: list[dict]) -> list[str]:
    return [n["value"].lower() for p in products for n in p["application_name_patterns"]]


def predicate(product: dict) -> str:
    values = literals_for([product])
    if len(values) == 1:
        return "application_name_normalized = " + quoted(values[0])
    return "application_name_normalized in (" + ", ".join(map(quoted, values)) + ")"


def query_text(products: list[dict], categories: dict[str, dict]) -> str:
    lines = [
        "config case_sensitive = false timeframe = 30d",
        "| preset = host_inventory_applications",
        '| filter application_name != null and application_name != ""',
        "| fields " + ", ".join(SOURCE_FIELDS),
        "| alter application_name_normalized = lowercase(application_name)",
        "| filter application_name_normalized in (" + ", ".join(map(quoted, literals_for(products))) + ")",
        "| alter " + ", ".join(f'{field} = "UNMAPPED"' for field in DERIVED_FIELDS),
    ]
    # All assignments use a field from an earlier stage, so evaluation order of
    # assignments inside an alter stage is immaterial. Collision checks ensure
    # these predicates are disjoint, rather than relying on first-match priority.
    for product in products:
        condition = predicate(product)
        lines.append("| alter " + ", ".join(
            f"{field} = if({condition}, {quoted(value)}, {field})"
            for field, value in mappings(product, categories).items()
        ))
    lines.extend([
        '| filter product_id != "UNMAPPED"',
        "| fields " + ", ".join(OUTPUT_FIELDS),
        "| limit 1000",
    ])
    return "\n".join(lines) + "\n"


def metadata(catalog: dict, categories: dict[str, dict], products: list[dict], category_id: str | None, query_name: str, guide_name: str) -> dict:
    name = categories[category_id]["name"] if category_id else "All primary Cyber Hygiene categories"
    return {
        "schema_version": "1.0.0", "query_id": "cyber-hygiene-" + (category_id or "all-detected-tools"),
        "title": name + " inventory review candidates", "module": "Cyber Hygiene",
        "name": name + " inventory review candidates",
        "id": "cyber-hygiene-" + (category_id or "all-detected-tools"),
        "category": category_id or "all-primary-categories", "category_name": name,
        "subcategory": "Multiple catalog subcategories" if len({p["subcategory"] for p in products}) > 1 else products[0]["subcategory"],
        "description": "Return policy-neutral application-inventory name candidates; not evidence of execution, current installation, approval or maliciousness.",
        "artifact_role": "GENERATED_CATEGORY_QUERY" if category_id else "GENERATED_MASTER_QUERY",
        "query_file": query_name, "documentation_file": guide_name,
        "generated_by": "tools/generate_query_library.py", "classifier_source": "catalog/software-catalog.yaml",
        "catalog_sha256": hashlib.sha256(CATALOG.read_bytes()).hexdigest(),
        "product": "Cortex XDR", "product_version": "Unknown; historical Cortex XDR example ceiling",
        "platform": "Windows, macOS and Linux are documented for Host Inventory applications; actual tenant and product coverage unverified",
        "execution_surface": "Query Center interactive", "documentation_review_date": catalog["research_date"],
        "last_reviewed": catalog["research_date"],
        "status": "VERSION-DEPENDENT", "qualifiers": ["OFFICIAL-EXAMPLE", "TENANT-UNVERIFIED"],
        "validation_status": "requires-tenant-validation",
        "confidence": "UNMEASURED; exact-name specificity is not measured identity accuracy",
        "xsiam_compatibility": "UNVERIFIED; separate field-binding record and compiler/runtime validation required",
        "production_ready": False, "read_only": True,
        "source": {"kind": "preset", "name": "host_inventory_applications", "fields": SOURCE_FIELDS,
                   "field_evidence": "Historical Cortex XDR Unit 42 OpenSSL example, updated 2022-11-04",
                   "field_status": "VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED",
                   "types": "Unknown in tenant; application_name must be string; remaining fields projected without conversion"},
        "data_source": "application inventory preset; current field binding and tenant population unverified",
        "preset": "host_inventory_applications",
        "timeframe": "30d", "timezone": "Not configured; record resolved UTC bounds and operator display timezone",
        "result_limit": 1000, "ordering": "UNSPECIFIED",
        "output_grain": "One admitted matching application-inventory row; reports, duplicates, components and versions retained until cap",
        "latest_snapshot": False, "completeness_claim": False, "output_fields": OUTPUT_FIELDS,
        "matching": {"operator": "Full-string equals_ci using lowercase, equality/in and case_sensitive=false",
                     "primary_category_only": True, "product_count": len(products), "literal_count": len(literals_for(products)),
                     "raw_name_preserved": True, "trim_or_suffix_removal": False,
                     "display_name_status": "UNVERIFIED_CORTEX_DISPLAY_NAME",
                     "collisions": "Generation fails on duplicate literals; no first-match ambiguity resolution",
                     "unmatched": "Excluded; no fallback category", "aliases": "Descriptive aliases are not compiled"},
        "products": [{"product_id": p["product_id"], "canonical_product_name": p["canonical_product_name"],
                      "category": p["category"], "subcategory": p["subcategory"], "expected_product_vendor": p["vendor"],
                      "application_name_patterns": [n["value"] for n in p["application_name_patterns"]],
                      "corporate_relevance": p["corporate_security_context"], "review_priority": p["review_priority"],
                      "inventory_coverage": p["inventory_coverage"], "validation_notes": p["validation_notes"],
                      "expected_false_positives": p["expected_false_positives"], "identity_corroboration": p["identity_corroboration"],
                      "product_reference": p["evidence"]} for p in products],
        "review_priority": "POLICY_DEPENDENT_UNASSIGNED",
        "corporate_relevance": categories[category_id]["corporate_security_context"] if category_id else "Cross-category corporate software-inventory review; policy dependent",
        "vendor_interpretation": "Curated catalog brand/project; not reported publisher or verified legal entity",
        "null_behavior": "Exclude null/empty names; preserve null endpoint_name/platform/version on matching rows",
        "system_fields": "Non-excludable product system fields may appear if present; not relied upon",
        "false_positives": ["Identical labels on spoofed, repackaged or unrelated software", "Approved installations are inventory matches; only an unsupported policy verdict would make them policy false positives"],
        "false_positive_considerations": ["Identical labels on spoofed, repackaged or unrelated software", "An approved installation is not an unauthorized-software verdict"],
        "false_negatives": ["Unlisted version/locale/edition/architecture/whitespace variants", "Portable, embedded, web-only, extension or unregistered packages absent from inventory", "Collection, access, retention and result-cap gaps"],
        "limitations": ["No identity, execution, session, current-installation, protection-health or compromise proof", "No unique endpoint or installation counts", "Primary category membership only; secondary roles do not duplicate products"],
        "prerequisites": {"build_license_identity_rbac_sbac": "Unknown", "collection_retention_population": "Unknown", "field_schema_types": "Unknown"},
        "validation": {level: {"result": "NOT RUN", "scope": "Complete query", "rationale": reason} for level, reason in [
            ("S", "Independent controlled query evaluation not run; generator integrity checks are separate"),
            ("D", "No current source binds every material construct and field to one named release"),
            ("C", "No named tenant schema/compiler acceptance"), ("E", "No tenant query execution/results")
        ]},
        "claim_level_documentation": "Individual sources/constructs have documented support with the scopes and retrieval gaps recorded in references; this is not complete-query D PASS",
        "compiler_and_runtime_size": "UNMEASURED; query length/stages and volume require bounded target checks",
        "performance_and_accuracy": "UNMEASURED; no precision/recall, resource or runtime claim",
        "comment_compatibility": "UNVERIFIED for exact target; no comments emitted",
        "references": [{"id": rid, "title": title, "url": url, "supports": note} for rid, title, url, note in REFERENCES],
        "next_step": "Record target build/preset/types/access; compile progressively and execute bounded controlled fixtures",
    }


def cell(value: str) -> str:
    return str(value).replace("|", "\\|").replace("\n", " ")


def readme_text(meta: dict) -> str:
    parent = "../.." if meta["artifact_role"] == "GENERATED_CATEGORY_QUERY" else ".."
    rows = []
    notes = []
    for p in meta["products"]:
        labels = "; ".join("`" + v + "`" for v in p["application_name_patterns"])
        rows.append("| " + " | ".join(map(cell, [p["product_id"], p["canonical_product_name"], labels, p["category"], p["subcategory"], p["expected_product_vendor"]])) + " |")
        notes.append(f"- **{p['canonical_product_name']}** (`{p['product_id']}`): " + " ".join(p["validation_notes"]) + f" Inventory coverage: `{p['inventory_coverage']}`. [Product reference]({p['product_reference']['product_reference_url']}); retrieval status `{p['product_reference']['retrieval_status']}` as of {p['product_reference']['retrieval_date']}. Review context: {p['corporate_relevance']}")
    references = "\n".join(f"- **{r['id']}:** [{r['title']}]({r['url']}) — {r['supports']}" for r in meta["references"])
    return f"""# {meta['category_name']} — inventory review candidates

[Query]({meta['query_file']}) · [Metadata]({meta['query_file'].replace('.xql', '.metadata.yaml') if meta['artifact_role'] == 'GENERATED_MASTER_QUERY' else 'query-metadata.yaml'}) · [Catalog]({parent}/catalog/software-catalog.yaml)

Generated by [generate_query_library.py]({parent}/tools/generate_query_library.py). Update the catalog and regenerate; do not maintain classifier lists in this guide or query independently.

## Objective and evidence

Return application-inventory rows matching **{meta['matching']['product_count']} catalog products / {meta['matching']['literal_count']} full-name candidates**, using primary category ownership only. This supports corporate software review. A reported label does not prove identity, execution, sessions, current installation, unauthorized software, protection health or compromise.

Target: **Cortex XDR interactive Query Center**, at the historical Cortex XDR example evidence ceiling. Exact build, entitlement, identity, RBAC/SBAC, collection and retention are Unknown. **XSIAM compatibility is UNVERIFIED** and requires a separate field-binding record plus compiler/runtime validation. Documentation cut: **{meta['documentation_review_date']}**.

**VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED**. Complete-query **S: NOT RUN; D: NOT RUN; C: NOT RUN; E: NOT RUN**. Individual documented constructs have bounded source support, but no current reference binds every construct and field to one named deployment. Generator structural checks do not upgrade these four results. This is an unvalidated query candidate, not a production rule.

## Data source and output

`host_inventory_applications` is a **preset**, not the `host_inventory` dataset [R1]. Four field spellings — `endpoint_name`, `platform`, `application_name`, `version` — come from the historical Unit 42 **Cortex XDR** example updated 2022-11-04 [R2]. This is not a complete current schema or XSIAM field contract. Confirm all four types/population in the target; `application_name` must be a string. Other source fields are projected without conversion.

Grain: **one admitted matching application-inventory row**, ordered arbitrarily and capped at **1,000**. Duplicates, reports, components and versions remain separate and may look identical after projection. There is no aggregation, join, deduplication or report-time selection. Row counts are not endpoint or installation counts. Hostnames are not assumed unique.

The explicit **30d** lookback is a review window, not a freshness or retention guarantee. Current installation and latest-complete-report semantics are not reconstructed. No `endpoint_id`, `report_timestamp`, source `vendor` or `install_date` is used. Record resolved UTC bounds/execution time and the operator's display timezone; the query sets no timezone. Start tenant validation with a narrower window and lower limit. The final cap does not bound upstream work; even fewer than 1,000 rows do not prove complete fleet coverage. Master-query size, compiler stage/length limits, runtime, resource use, result volume and precision/recall are **unmeasured**.

| Field | Interpretation |
|---|---|
| `endpoint_name`, `platform`, `version` | Unmodified source context; nulls retained and types/population unverified. |
| `application_name` | Unmodified complete source label. |
| `application_name_normalized` | Lowercase matching copy; no trim, tokenization, punctuation or suffix removal. |
| `detected_product`, `product_id` | Canonical catalog candidate and stable ID; not authenticated identity. |
| `tool_family`, `tool_subcategory` | Primary category name and catalog subcategory; not observed behavior. |
| `expected_product_vendor` | Curated catalog brand/project; not a source publisher or verified legal entity. |
| `corporate_relevance` | Catalog governance context; editorial guidance, not an automatic violation. |
| `review_priority` | Always `POLICY_DEPENDENT_UNASSIGNED`. |

Product-defined non-excludable system fields may also appear if present [R5]; the query does not rely on them. Sanitize hostnames and extra system output before sharing.

## Exact products covered

Only these whole strings match, case-insensitively. Every label remains `UNVERIFIED_CORTEX_DISPLAY_NAME`. Descriptive aliases and secondary categories do not add matches. A vendor/project page supports product-family context, not a Cortex display name or installed publisher.

| Product ID | Canonical product | Complete candidate labels | Primary category | Subcategory | Expected vendor/project |
|---|---|---|---|---|---|
{chr(10).join(rows)}

## Logic and maintenance

1. Configure the insensitive 30-day context, choose the preset, exclude null/empty names and project four necessary source fields [R1–R5, R9].
2. Lowercase a separate name copy and admit only complete catalog literals with `in`; whitespace-only names do not match [R4, R6, R6b].
3. Initialize derived fields, then apply sequential three-argument `if(condition, catalog_value, existing_value)` assignments through `alter` [R7, R8, R8b]. Conditions use the normalized name established before these stages; same-stage assignment order cannot affect them. No deeply nested master classifier is generated.
4. Each product has disjoint exact literals. Generation fails on duplicate literals, so sequential order does not resolve ambiguous identities. All output labels come from the same catalog record. Filter the unmatched sentinel, retain raw evidence and derived labels, then apply the terminal result cap [R5, R10].

If future identity candidates overlap, hold the change until ambiguity can be represented and all candidates retained; do not introduce first-match precedence. Generated labels are data, not source fields. The generator rejects unreviewed string escaping and non-ASCII matching patterns to avoid silently defining case/escape behavior. Revisit those boundaries explicitly if catalog requirements change.

## Corporate relevance and product-specific limits

{chr(10).join(notes)}

## False positives, false negatives and tuning

Repackaged, spoofed or unrelated packages may register the same label. Corroborate identity with independently validated publisher/package/signature evidence before interpreting a candidate as a confirmed product. An approved business installation is a legitimate inventory match; this query does not classify it as a policy violation.

Exact literals intentionally miss unlisted versions, locales, architectures, editions, custom client names, whitespace and component suffixes. Portable binaries, browser/IDE extensions, embedded runtimes, OS capabilities, web/PWA use and unregistered packages may have no application entry at all. Collection, permissions, retention, stale/offline endpoints and truncation also reduce coverage. Historical admitted rows can describe removed applications. Zero matches do not establish absence.

Add names only with sanitized positive/negative label fixtures, platform/packaging context and corroborated identity; do not enable descriptive aliases automatically or broaden to generic substrings. Approval and priority require governed product/version, asset scope, business need, account/workspace, owner, effective period and exception policy. Missing policy is Unknown. Category membership alone does not establish risk or use of optional capabilities.

## Planned validation — NOT RUN

| Fixture | Expected check |
|---|---|
| Every listed literal and mixed-case form | Correct ID and all catalog mappings; raw case preserved. |
| A listed label with extra suffix, prefix, version or whitespace | Excluded unless that exact variant is separately listed. |
| A descriptive alias absent from enabled labels, or another category's primary product | Excluded from this category; the master includes a product only through its listed primary record. |
| Null, empty and whitespace-only names | Excluded before classification; never stringified. |
| Null hostname/platform/version with a matching name | Row retained without invented identity or values. |
| Duplicate rows, two versions or components | Retained until the result cap; no installation-count claim. |
| Approved installation | Inventory match with unassigned priority. |
| Time-boundary, removed software, stale/offline endpoint | Verify admission and coverage without current-state claims. |
| Restricted identity and result-cap cases | Record visibility and truncation; no absence inference. |

The platform/data owner must establish exact XDR build, entitlement, preset discovery, four field types, populated examples, collection health, retention and effective access. Confirm derived names do not overwrite an unexpected source contract. Compile a narrow source/field probe, add transformations progressively and compile the exact file. Execute bounded positive, benign, negative, null and edge fixtures only in the authorized tenant. Retain query/catalog hashes, sanitized schema/compiler/result evidence, resolved UTC bounds, identity scope, counts and cap state. Owner names remain unassigned.

If a source/field fails, obtain exact schema evidence instead of guessing a replacement. If `if`, `alter`, `lowercase` or combined `config` is rejected, verify deployed syntax/version before changing it. Zero results require inspection of collection, retention, permissions and raw labels. Stop on unexpected source, volume or sensitive output. No persistent query writes are present, so configuration rollback is N/A; use the target's supported cancellation flow for an active query when needed.

BIOC, scheduled/real-time correlation, API, XQLp and saved-object deployment require separate compatibility and lifecycle checks. This library creates no rules, Cases/Issues, containment or enforcement actions.

## Official references and unresolved constructs

Sources reviewed or retrieval-attempted on **{meta['documentation_review_date']}**. The [research register]({parent}/docs/research/palo-alto-xql-research.md) preserves source boundaries; the [reference repository analysis]({parent}/docs/research/reference-repository-analysis.md) informs layout only. The [taxonomy]({parent}/docs/cyber-hygiene-taxonomy.md), [architecture]({parent}/docs/architecture.md) and [methodology]({parent}/docs/methodology.md) govern maintenance.

{references}

Current standalone `if`, `alter` and general `lowercase` retrieval gaps remain unresolved. Indexed official examples and the dated language reference support the bounded forms used here, not an exhaustive refreshed grammar, current field contract or compiler-size guarantee. Tenant acceptance/execution and XSIAM field binding remain open.
"""


def artifacts(catalog: dict, categories: dict[str, dict]) -> dict[Path, str]:
    result: dict[Path, str] = {}
    for category_id in [*categories, None]:
        products = [p for p in catalog["products"] if category_id is None or p["category"] == category_id]
        directory = Path("cyber-hygiene") / category_id if category_id else Path("cyber-hygiene")
        query_name = ("detect-ai-tools.xql" if category_id == "ai-tools" else f"detect-{category_id}-tools.xql") if category_id else "all-detected-tools.xql"
        guide_name = "README.md" if category_id else "all-detected-tools.md"
        metadata_name = "query-metadata.yaml" if category_id else "all-detected-tools.metadata.yaml"
        meta = metadata(catalog, categories, products, category_id, query_name, guide_name)
        result[directory / query_name] = query_text(products, categories)
        result[directory / guide_name] = readme_text(meta)
        result[directory / metadata_name] = yaml.safe_dump(meta, sort_keys=False, allow_unicode=True, width=110)
    counts = Counter(p["category"] for p in catalog["products"])
    rows = "\n".join(f"| [{c['name']}]({cid}/README.md) | {counts[cid]} | [XQL]({cid}/{'detect-ai-tools.xql' if cid == 'ai-tools' else f'detect-{cid}-tools.xql'}) |" for cid, c in categories.items())
    result[Path("cyber-hygiene/README.md")] = f"""# Cyber Hygiene query library

**30 category queries and one [master query](all-detected-tools.xql)** classify **{len(catalog['products'])} product records / {len(literals_for(catalog['products']))} exact candidate labels** from the [catalog](../catalog/software-catalog.yaml). [Master guide](all-detected-tools.md) · [Master metadata](all-detected-tools.metadata.yaml).

Target: **Cortex XDR interactive Query Center**, using a historical Cortex XDR field example. **VERSION-DEPENDENT / OFFICIAL-EXAMPLE / TENANT-UNVERIFIED**. Complete-query **S/D/C/E: NOT RUN** for every file. XSIAM compatibility is **UNVERIFIED** and requires separate field binding. These are software-inventory review candidates, not production detections or a malicious-software list.

Each row reports a whole-name candidate in the admitted 30-day inventory window. Raw names are preserved; all derived product/category/vendor/context values come from the catalog. Primary ownership avoids duplicating products across category views. Priority remains `POLICY_DEPENDENT_UNASSIGNED`. No current-state, latest-snapshot, execution, approval or fleet-completeness claim is made. Each query returns at most 1,000 rows without guaranteed ordering. Master-query compiler limits, resource use and result size are unmeasured.

| Primary category | Products | Query |
|---|---:|---|
{rows}

Read the adjacent guide and metadata before tenant validation. Confirm the deployed XDR build, preset, source fields/types, collection, retention and access; compile incrementally and execute bounded fixtures. Zero rows do not prove absence. Rule/API/XQLp conversion needs a separate review.

Maintenance: run `python tools/generate_query_library.py` from the repository root after installing PyYAML. Run `python tools/generate_query_library.py --check` for deterministic artifact drift and structural validation. These author checks do not change S/D/C/E. The generator writes only its 94 declared query/guide/metadata/index artifacts and never deletes unrelated files.
"""
    return result


def validate(result: dict[Path, str], catalog: dict, categories: dict[str, dict]) -> None:
    query_paths = [p for p in result if p.suffix == ".xql"]
    if len(query_paths) != 31 or len(result) != 94:
        raise ValueError("Expected 31 queries and 94 generated files")
    for path in query_paths:
        text = result[path]
        cid = path.parent.name if path.name != "all-detected-tools.xql" else None
        products = [p for p in catalog["products"] if cid is None or p["category"] == cid]
        expected = set(literals_for(products))
        admission = next(line for line in text.splitlines() if line.startswith("| filter application_name_normalized in"))
        if set(re.findall(r'"([^\"]+)"', admission)) != expected:
            raise ValueError(f"Candidate coverage mismatch: {path}")
        if text.count("(") != text.count(")") or '//' in text or '/*' in text:
            raise ValueError(f"Delimiter/comment check failed: {path}")
        # Check code tokens outside literals, so editorial catalog text cannot
        # accidentally trigger source/stage denylist checks.
        code = re.sub(r'"[^\"]*"', '""', text)
        if re.search(r"\b(endpoint_id|report_timestamp|vendor|install_date|windowcomp|dedup|join|target|contains)\b", code):
            raise ValueError(f"Unapproved field/stage: {path}")
        if not text.startswith("config case_sensitive = false timeframe = 30d\n| preset = host_inventory_applications\n") or not text.endswith("| limit 1000\n"):
            raise ValueError(f"Source/time/limit mismatch: {path}")
        meta_path = path.with_name("query-metadata.yaml") if cid else path.with_suffix(".metadata.yaml")
        meta = yaml.safe_load(result[meta_path])
        if meta["product"] != "Cortex XDR" or any(v["result"] != "NOT RUN" for v in meta["validation"].values()):
            raise ValueError(f"Evidence ceiling mismatch: {path}")
        if {p["product_id"] for p in meta["products"]} != {p["product_id"] for p in products}:
            raise ValueError(f"Product coverage mismatch: {path}")
        for p in products:
            condition = predicate(p)
            for field, value in mappings(p, categories).items():
                if f"{field} = if({condition}, {quoted(value)}, {field})" not in text:
                    raise ValueError(f"Mapping missing: {path}, {p['product_id']}, {field}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Read-only drift and structural validation")
    args = parser.parse_args()
    catalog, categories = load_catalog()
    result = artifacts(catalog, categories)
    validate(result, catalog, categories)
    changed = []
    for relative, content in result.items():
        destination = ROOT / relative
        expected = content.encode("utf-8")
        if not destination.exists() or destination.read_bytes() != expected:
            changed.append(str(relative))
            if not args.check:
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes(expected)
    if args.check and changed:
        raise SystemExit("Generated artifact drift:\n" + "\n".join(changed))
    digest = hashlib.sha256()
    for relative, content in sorted(result.items()):
        digest.update(relative.as_posix().encode("utf-8") + b"\0" + content.encode("utf-8"))
    print(json.dumps({"mode": "check" if args.check else "generate", "categories": len(categories),
                      "products": len(catalog["products"]), "literals": len(literals_for(catalog["products"])),
                      "queries": 31, "generated_files": len(result), "changed_files": len(changed),
                      "artifact_set_sha256": digest.hexdigest(), "structural_validation": "PASS",
                      "complete_query_S_D_C_E": "NOT RUN"}, indent=2))


if __name__ == "__main__":
    main()
