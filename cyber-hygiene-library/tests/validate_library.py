#!/usr/bin/env python3
"""Static repository checks; never presented as Cortex compilation/execution."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from generate_query_library import validate_literal  # noqa: E402

CATALOG = yaml.safe_load((ROOT / "catalog/software-catalog.yaml").read_text(encoding="utf-8"))
FORBIDDEN_SOURCE_FIELDS = ("endpoint_id", "report_timestamp", "install_date", "reported_vendor")
FORBIDDEN_WRITES = ("| target ",)


def fail(message: str) -> None:
    raise AssertionError(message)


def main() -> int:
    for generic in ("ai", "vpn", "remote", "cloud", "agent", "security", "visual", "code"):
        try:
            validate_literal(generic)
        except ValueError:
            pass
        else:
            fail(f"generic literal was accepted: {generic}")
    for specific in ("Signal", "Cursor", "Nmap"):
        if validate_literal(specific) != specific.lower():
            fail(f"specific product name was rejected: {specific}")

    result = subprocess.run(
        [sys.executable, str(ROOT / "tools/generate_query_library.py"), "--check"],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    if result.returncode:
        print(result.stdout)
        print(result.stderr, file=sys.stderr)
        fail("generated artifacts drift from catalog/generator")

    categories = {c["category_id"] for c in CATALOG["categories"]}
    products = CATALOG["products"]
    if len(categories) != 30 or len(products) != CATALOG["product_count"]:
        fail("catalog declared counts do not match")

    literals: dict[str, str] = {}
    for product in products:
        if product["review_priority"] != "POLICY_DEPENDENT_UNASSIGNED":
            fail(f"public priority assigned: {product['product_id']}")
        for pattern in product["application_name_patterns"]:
            if pattern["operator"] != "equals_ci":
                fail(f"non-exact operator: {product['product_id']}")
            key = pattern["value"].lower()
            if key in literals:
                fail(f"literal collision: {key}: {literals[key]}, {product['product_id']}")
            literals[key] = product["product_id"]

    xql_files = sorted((ROOT / "cyber-hygiene").rglob("*.xql"))
    if len(xql_files) != 31:
        fail(f"expected 31 XQL files, got {len(xql_files)}")

    category_product_ids: set[str] = set()
    for xql in xql_files:
        text = xql.read_text(encoding="utf-8")
        low = text.lower()
        if not text.startswith("config case_sensitive = false timeframe = 30d\n"):
            fail(f"unexpected first stage: {xql}")
        if "| preset = host_inventory_applications" not in text:
            fail(f"missing preset: {xql}")
        if "| limit 1000\n" not in text:
            fail(f"missing explicit limit: {xql}")
        if "//" in text or "/*" in text:
            fail(f"unverified inline comments: {xql}")
        if any(field in low for field in FORBIDDEN_SOURCE_FIELDS):
            fail(f"unverified source field: {xql}")
        if any(stage in low for stage in FORBIDDEN_WRITES):
            fail(f"state-changing XQL: {xql}")

        if xql.name == "all-detected-tools.xql":
            metadata_path = xql.with_suffix(".metadata.yaml")
            guide_path = xql.with_suffix(".md")
        else:
            metadata_path = xql.parent / "query-metadata.yaml"
            guide_path = xql.parent / "README.md"
        if not metadata_path.exists() or not guide_path.exists():
            fail(f"missing companions: {xql}")
        metadata = yaml.safe_load(metadata_path.read_text(encoding="utf-8"))
        required_metadata = {
            "name", "id", "category", "subcategory", "description", "data_source",
            "preset", "timeframe", "platform", "status", "confidence",
            "corporate_relevance", "review_priority", "false_positive_considerations",
            "limitations", "validation_status", "last_reviewed", "references",
        }
        if missing := required_metadata - set(metadata):
            fail(f"required metadata keys missing {sorted(missing)}: {metadata_path}")
        if metadata["validation_status"] != "requires-tenant-validation":
            fail(f"unexpected validation status: {metadata_path}")
        for level in ("S", "D", "C", "E"):
            if metadata["validation"][level]["result"] != "NOT RUN":
                fail(f"unexpected complete-query {level} status: {metadata_path}")
        xsiam_boundary = metadata.get("xsiam_compatibility", metadata.get("cross_product_compatibility", ""))
        if metadata["product"] != "Cortex XDR" or "UNVERIFIED" not in xsiam_boundary:
            fail(f"product/binding boundary missing: {metadata_path}")
        if xql.name != "all-detected-tools.xql":
            category_product_ids.update(p["product_id"] for p in metadata["products"])

    expected = {p["product_id"] for p in products}
    if category_product_ids != expected:
        fail("category metadata does not cover every catalog product exactly")

    print(f"PASS: 30 categories, {len(products)} products, {len(literals)} literals, 31 XQL candidates")
    print("Boundary: static repository checks only; Cortex S/D/C/E not advanced")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
