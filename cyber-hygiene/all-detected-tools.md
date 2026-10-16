# All detected tools — consolidated inventory review

[Open query](all-detected-tools.xql) · [Category index and shared instructions](README.md)

This query combines the 30 primary software categories into one inventory review. It uses the same **233 product/family candidates and 293 exact labels** as the category queries. The [coverage review](coverage.md) explains source evidence, family grouping and coverage gaps.

## When to use it

Use the consolidated file for a cross-category sample after validating a smaller category query in your tenant. It returns at most 1,000 matching inventory rows, without guaranteed order. A busy category can occupy most of that sample; do not use it to infer fleet-wide category prevalence or absence.

## Logic and output

The query reads `host_inventory_applications`, excludes null/empty names, preserves four source fields, matches whole lowercase labels and assigns `detected_product`, `product_id`, and `tool_family`. Product mappings are ordered alphabetically for maintenance; the matched labels are disjoint. No join or deduplication changes row grain.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Duplicate reports, components and versions remain separate. Derived names identify candidates only. Refer to the [category guides](README.md#query-index) for exact labels and review context.

## Editing and validation

Keep each product's labels consistent between the initial filter, its three conditional assignments, and its category query. For a new product, choose a stable ID and one primary category, then validate positive, mixed-case and near-match labels. Do not add generic keyword matching or overlapping ownership.

The master has 233 sequential product-mapping stages. Compiler limits and resource use are unmeasured. Prefer category queries; the expanded master is a convenience candidate, not a performance-tested fleet report. If it is rejected or too expensive in your build, use the category queries rather than assuming an engine limit or silently dropping products.

Review date: **2026-10-16**. Offline mapping and consistency checks do not establish Cortex acceptance. Tenant schema, compilation and execution remain unverified; see [evidence and limitations](README.md#evidence-and-limitations) and [before running](README.md#before-running).
