<p align="center">
  <img src="assets/icon.png" width="128" height="128" alt="Cortex XQL Library community project icon">
</p>

<h1 align="center">Cortex XQL Library</h1>

<p align="center">Investigate activity. Develop hunt hypotheses. Understand the evidence.</p>

<p align="center">
  <a href="CATALOG.md">Browse the library</a> ·
  <a href="GETTING-STARTED.md">Getting started</a> ·
  <a href="VALIDATION.md">Validation status</a> ·
  <a href="https://github.com/lucaslapinho/XSIAM-Palo-Alto-Queries/releases">Releases</a>
</p>

A community collection of **80 XQL use cases for Cortex XSIAM**, covering threat hunting, investigations, endpoint visibility, identity, cloud, Kubernetes and platform operations. Every query has an English title, description, category and investigation guide, with explicit evidence boundaries.

| In this release | Count | Meaning |
|---|---:|---|
| Query candidates | **11** | Use documented or inspected source fields; still require complete-query tenant validation. |
| Schema binding templates | **69** | Contain analytic pipelines and typed source contracts; require inspected mappings and the necessary telemetry before use. |
| Individual guides | **80** | Explain scope, parameters, limitations, references and validation steps. |

**Validation status:** independent static review is complete. Full-query compilation and execution in Cortex remain **NOT RUN**. A hunt result is an investigation lead, and an ATT&CK mapping describes a hypothesis rather than proven technique coverage.

## Explore by category

| Category | Use cases | Browse |
|---|---:|---|
| Asset Visibility | 3 | [Open category](CATALOG.md#asset-visibility) |
| Cyber Hygiene | 2 | [Open category](CATALOG.md#cyber-hygiene) |
| Dashboard | 1 | [Open category](CATALOG.md#dashboard) |
| Investigation | 19 | [Open category](CATALOG.md#investigation) |
| Security Operations | 6 | [Open category](CATALOG.md#security-operations) |
| Threat Hunting | 49 | [Open category](CATALOG.md#threat-hunting) |

## Start with a question

- [N026 — Investigation - Selected Endpoint Process Start Timeline](queries/investigation/process-activity/n026-investigation-selected-endpoint-process-start-timeline.xql) — Build a selected endpoint process-start timeline.
- [N083 — Investigation - Selected SHA-256 Process and File Prevalence](queries/investigation/file-identity/n083-investigation-selected-sha-256-process-and-file-prevalence.xql) — Review a SHA-256 across process and file observations.
- [N094 — Security Operations - Cortex Management Audit Timeline](queries/security-operations/cortex-audit/n094-security-operations-cortex-management-audit-timeline.xql) — Investigate Cortex management-audit activity.
- [N097 — Security Operations - Collector Error and Warning Audit Records](queries/security-operations/collection-health/n097-security-operations-collector-error-and-warning-audit-records.xql) — Review collector warnings and errors.
- [N071 — Threat Hunting - AWS Access Key Creation and First Observed Use](queries/threat-hunting/cloud-credentials/n071-threat-hunting-aws-access-key-creation-and-first-observed-use.xql) — Develop a cloud access-key creation and subsequent-use investigation.
- [N073 — Threat Hunting - Kubernetes Bindings to Reviewed Privileged Roles](queries/threat-hunting/kubernetes-rbac/n073-threat-hunting-kubernetes-bindings-to-reviewed-privileged-roles.xql) — Review Kubernetes bindings to time-valid privileged roles.

## Use the library

1. Choose an entry from the [catalog](CATALOG.md) and read its guide.
2. For a template, inspect the actual sources and map every required token using the supplied bindings file. Some contracts require additional telemetry or a reviewed normalized view.
3. Set ordinary parameters, such as the selected endpoint or SHA-256, and retain an appropriate timeframe.
4. Copy **only the body after `:Query:`** into the verified interactive XQL editor. Compile it, then validate representative positive, benign, negative, null and boundary cases.

The metadata wrapper is a repository format, not a Cortex import format. Interactive-query compatibility does not establish BIOC or correlation-rule compatibility. See [Getting started](GETTING-STARTED.md) for the binding workflow.

## Repository layout

| Location | Contents |
|---|---|
| [`queries/`](queries/) | Categorized `.xql` files with stable IDs. |
| [`guides/`](guides/) | One investigation guide per use case. |
| [`bindings/`](bindings/) | Unfilled, typed mapping files for the 69 templates. |
| [`catalog/`](catalog/) | CSV and JSON catalogs for indexing and tooling. |
| [`qa/`](qa/) | Retained static review and integrity evidence. |
| [`scripts/`](scripts/) | Local binding utility and lexical helper; no tenant API calls. |
| [`assets/`](assets/) | Original community-project icon and its generation prompt. |

## Contribute

See [CONTRIBUTING.md](CONTRIBUTING.md) for the query format, evidence requirements and review workflow. Keep actual tenant values and operational results out of reusable examples. Contributions should state what was observed, what was inferred and what remains unverified.

Maintained by [lucaslapinho](https://github.com/lucaslapinho). Independent community content; not an official Palo Alto Networks repository. Cortex and related product names identify the intended platform.
