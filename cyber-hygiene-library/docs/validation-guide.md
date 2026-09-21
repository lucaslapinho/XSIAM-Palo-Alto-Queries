# Tenant validation guide

## Before running

Record a safe tenant alias, exact Cortex product/build, license, environment, Query Center surface, execution identity, RBAC/SBAC scope, collection configuration, retention, and documentation review date.

## Gate 1 — source and schema

Confirm `host_inventory_applications` exists and capture sanitized types/population for `application_name`, `version`, `endpoint_name`, and `platform`. For XSIAM, this is a mandatory binding gate. Do not substitute plausible field names.

## Gate 2 — bounded compilation

Compile progressively: source; projected fields; null guard; lowercase copy; one literal; one mapping; full category query; master only after categories. Record exact artifact SHA-256 and compiler output. A compile pass establishes no rows or correctness.

## Gate 3 — bounded execution

Use a narrow time window and small result bound first. Retain sanitized start/end, identity scope, status, counts, cap state, and source-health context. Stop on unexpected source, volume, or sensitive output.

## Gate 4 — semantic fixtures

Test known positive, approved benign, negative lookalikes, null/empty/whitespace, version/locale/architecture suffixes, duplicate rows, multiple versions, component variants, boundary time, restricted identity, stale/disabled collection, and result truncation.

## Gate 5 — inventory semantics

Before adding latest-report logic, verify stable endpoint key, timestamp type/meaning, full versus delta reports, newest empty report, removed application, timestamp ties, duplicates, delayed arrival, reinstalled agents, reused names, and UI/source comparison. Do not infer uninstall from an absent application row.

## Gate 6 — scale

Compile and measure the 113 KB master separately. Capture runtime, queued state, processed volume if exposed, returned rows, errors, and semantic comparison to category queries. A smaller result is not proof of lower cost.

## Gate 7 — target surface

Query Center acceptance does not establish BIOC, scheduled/real-time correlation, API, saved-query, widget, or XQLp support. Validate each destination independently with current documentation and editor evidence.

## Evidence record

For every query record S/D/C/E independently as PASS, FAIL, NOT RUN, or N/A. Never convert source-document support into compiler/execution evidence. Zero rows mean only zero visible matches under the recorded source, timeframe, identity, coverage, and logic.
