# Cortex XSIAM XQL Queries

100 authored queries, organized by category. Each query has a plain `.xql` file and a companion `.md` explaining its purpose, data sources, inputs, usage and interpretation.

## Categories

| Category | Queries | Purpose |
|---|---:|---|
| [Asset Visibility](asset-visibility/README.md) | 4 | Endpoint inventory, application coverage and asset context. |
| [Cyber Hygiene](cyber-hygiene/README.md) | 10 | Software inventory, policy review and configuration hygiene. |
| [Dashboard](dashboard/README.md) | 2 | Aggregated metrics and reporting queries. |
| [Investigation](investigation/README.md) | 24 | Host, process, file, identity and activity investigation pivots. |
| [Security Operations](security-operations/README.md) | 6 | Operational monitoring, audit and workflow visibility. |
| [Threat Hunting](threat-hunting/README.md) | 54 | Behavior-focused hypotheses for analyst-led threat hunting. |

## Using a query

1. Open a category and select a query from its index.
2. Read the companion documentation and supply the required inputs.
3. Copy the `.xql` contents into Cortex XSIAM XQL Search and validate against your tenant.

**31 query candidates** use authored source and field names. **69 schema templates** are named `*.template.xql` and contain `{{TOKEN}}` mappings that must be supplied from the actual tenant schema. Templates are not ready to execute unchanged.

Full-query tenant compilation and execution have not been performed. Product version, available telemetry and field population must be checked locally. Investigative matches are leads, not proof of compromise.

## File layout

```text
README.md
<category>/
  README.md
  nNNN-query-name.xql
  nNNN-query-name.md
  nNNN-query-name.template.xql
  nNNN-query-name.template.md
```

The collection includes all authored items N001–N100. Query IDs remain stable for reference. Community-maintained content; not an official Palo Alto Networks library.

## Extended Cyber Hygiene Library

The [Cyber Hygiene Query Library](cyber-hygiene-library/README.md) adds a documented, catalog-driven collection of 31 candidate XQL queries: 30 category queries and one consolidated query covering 124 products across 30 software categories. Every query has English usage notes, metadata, validation guidance, and a clear `NOT RUN` execution status until it is validated in a tenant.

## License

Licensed under the [Apache License 2.0](LICENSE).
