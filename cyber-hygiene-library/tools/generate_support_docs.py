#!/usr/bin/env python3
"""Generate conceptual correlation documents and the validation matrix."""

from __future__ import annotations

from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]

SPECS = [
    ("unapproved-remote-access-tool", "Unapproved Remote Access Tool", "remote-access", "remote access", "support ownership, unattended access, authentication and session logging"),
    ("unapproved-vpn-client", "Unapproved VPN Client", "vpn-tunneling-proxy", "VPN/tunneling/proxy", "approved destinations, split tunneling and network controls"),
    ("pentest-tool-on-standard-workstation", "Pentest Tool on Standard User Workstation", "penetration-testing", "penetration-testing/dual-use", "authorized engagement scope, operator and asset role"),
    ("gaming-software-on-corporate-endpoint", "Gaming Software on Corporate Endpoint", "gaming", "gaming platform", "business purpose, endpoint class and policy"),
    ("unauthorized-ai-client", "Unauthorized AI Client", "ai-tools", "AI client", "approved account tenancy, submitted data, retention and connectors"),
    ("unauthorized-cloud-storage-client", "Unauthorized Cloud Storage Client", "cloud-storage", "cloud storage/synchronization", "managed account, shared folders and data classification"),
    ("multiple-endpoint-security-products", "Multiple Endpoint Security Products", "endpoint-security", "endpoint-security", "management, enrollment, health, compatibility and migration state"),
    ("unexpected-developer-tooling", "Unexpected Developer Tooling", "development-ides", "developer tooling", "asset role, approved engineering population and repository access"),
]

COMMON_REFS = """## Official references

- [Create a correlation rule](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/detect-investigate-and-respond-to-threats/threat-management/detection-rules/what-are-detection-rules/whats-a-correlation-rule/create-a-correlation-rule) — rule-surface constraints; review date 2026-09-20.
- [XSIAM datasets and presets](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets) — preset existence, not concrete field binding.

These sources do not establish tenant license, schema, rule-editor acceptance, Issue generation, grouping, severity, or efficacy.
"""


def correlation_doc(slug: str, title: str, category: str, family: str, context: str) -> str:
    multiple = slug == "multiple-endpoint-security-products"
    logic = (
        "After tenant-verified endpoint identity and snapshot semantics, group current inventory candidates by endpoint and count distinct corroborated endpoint-security product IDs. Produce a review candidate only when the organization-defined coexistence condition is met."
        if multiple else
        f"Join or compare a corroborated {family} product candidate with an organization-specific policy record using stable product ID plus asset/user/business scope, version and effective time. Emit only policy mismatches or expired exceptions."
    )
    grain = (
        "One output row should mean one endpoint/evaluated corroborated product set/policy/window result. Retain every member product ID and source evidence; do not reduce the set to a single product label."
        if multiple else
        "One output row should mean one endpoint/product/policy evaluation in a recorded window."
    )
    return f"""# {title}

**Artifact class:** `CONCEPTUAL / TENANT-UNVERIFIED`
**Rule surface:** undecided candidate; no importable correlation syntax
**S/D/C/E:** `NOT RUN / NOT RUN / NOT RUN / NOT RUN`

## Objective

Identify policy-exception candidates involving {family} software after product identity, current inventory state, endpoint scope, and policy have been independently established.

## Source query

Primary input: [`cyber-hygiene/{category}/README.md`](../../cyber-hygiene/{category}/README.md). The query supplies reported inventory candidates only. It does not prove execution, use, current installation, or policy violation.

## Required datasets and contracts

- Tenant-validated application-inventory source and fields.
- Stable endpoint identity, endpoint class/owner/business unit, and current-snapshot semantics.
- Governed software-policy/allowlist source with owner, scope, version, effective dates, expiry, exceptions, and audit history.
- For operational correlation: exact XSIAM product/build, license, rule surface, identity, RBAC/SBAC, retention, schedule/window, and Issue field contract.

## Correlation logic

{logic}

{grain} Duplicate inventory components, versions, reports, null keys, delayed data, and reused hostnames need explicit handling. Query Center success does not prove correlation-editor compatibility.

## Business context

Review {context}. The same product can be expected, required, tolerated, or prohibited in different asset/user/business scopes.

## Exclusions and allowlists

Do not exclude by product name alone. An allowlist must bind product ID, version scope, endpoint/user/business scope, purpose, owner, approver, effective dates, expiry, and exception evidence. Missing policy is `UNKNOWN`, not `DENIED`.

## False positives and false negatives

False positives include correct product candidates on approved assets, stale/duplicate reports, incomplete policy scope, identical-name packages, migrations, and managed exceptions. False negatives include missing inventory coverage, unregistered/portable/rebranded software, unlisted suffixes, null identities, stale endpoints, restricted visibility, expired retention, and policy records not available to the evaluation.

## Severity considerations

No universal severity is assigned. A risk owner considers endpoint role, owner, business unit, privileged/regulated asset status, server/workstation context, data sensitivity, approved-software policy, identity confidence, freshness, and corroborating behavior. An inventory/policy mismatch alone does not establish malicious activity.

## Recommended investigation

1. Confirm collection health, source field binding, report freshness, and endpoint identity.
2. Corroborate package/publisher/signature identity using validated telemetry.
3. Review the scoped allowlist and exception history with its owner.
4. Determine whether software is installed now and whether it was executed using separate evidence.
5. Escalate only after business context and adverse behavior are established.

## Prerequisites and validation

Use positive, approved-benign, negative-lookalike, null, duplicate, removed-application, newest-empty-report, boundary-time, restricted-identity, and high-volume fixtures. Measure candidate and Issue volume before choosing thresholds or suppression. Validate editor/compiler, historical execution, shadow, and bounded canary separately. Define owner, monitoring, disable/rollback, exception review, and retirement before promotion.

## Non-claims

No rule was created, compiled, executed, enabled, or deployed. No Issue/Case, severity, grouping, suppression, hit rate, performance, or response action is claimed. This document authorizes no uninstall, block, isolation, or containment action.

{COMMON_REFS}"""


def write_correlations() -> None:
    base = ROOT / "correlations/cyber-hygiene"
    base.mkdir(parents=True, exist_ok=True)
    links = []
    for slug, title, category, family, context in SPECS:
        path = base / f"{slug}.md"
        path.write_text(correlation_doc(slug, title, category, family, context), encoding="utf-8")
        links.append(f"- [{title}](cyber-hygiene/{slug}.md) — conceptual, requires tenant validation")
    (ROOT / "correlations/README.md").write_text(
        "# Correlation candidates\n\nThese documents are policy-aware design candidates, not rules. No syntax, severity, Issue/Case behavior or deployment is claimed.\n\n" + "\n".join(links) + "\n",
        encoding="utf-8",
    )
    (base / "README.md").write_text(
        "# Cyber Hygiene correlation candidates\n\nAll eight candidates are `CONCEPTUAL / TENANT-UNVERIFIED` with S/D/C/E NOT RUN. Inventory observations remain separate from execution and behavioral telemetry.\n",
        encoding="utf-8",
    )


def write_matrix() -> None:
    rows = []
    for metadata_path in sorted((ROOT / "cyber-hygiene").rglob("*.yaml")):
        data = yaml.safe_load(metadata_path.read_text(encoding="utf-8"))
        if "query_file" not in data:
            continue
        query = metadata_path.parent / data["query_file"]
        label = query.relative_to(ROOT).as_posix()
        rows.append(f"| `{label}` | Yes — static structure only | Partial — claim-level | No | Yes — documented, not tenant-measured | requires-tenant-validation |")
    header = """# Query validation matrix

Review date: **2026-09-20**. “Syntax Reviewed” means local structural inspection only; it is not an XQL compiler pass. “Official Docs Checked” is partial because individual constructs/source examples were reviewed while no current source establishes the complete query and concrete schema for one release. Complete-query S/D/C/E remain NOT RUN.

| Query | Syntax Reviewed | Official Docs Checked | Tenant Tested | False Positives Reviewed | Status |
|---|---:|---:|---:|---:|---|
"""
    (ROOT / "docs/query-validation-matrix.md").write_text(header + "\n".join(rows) + "\n", encoding="utf-8")


if __name__ == "__main__":
    write_correlations()
    write_matrix()
    print(f"Generated {len(SPECS)} correlation candidates and validation matrix")
