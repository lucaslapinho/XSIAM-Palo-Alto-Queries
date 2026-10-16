# Database Clients

[Open query](detect-database-clients-tools.xql) · [All categories and usage](../README.md)

Find application-inventory rows whose complete name matches one of the labels below. This query covers **5 products / 7 labels**.

## Products and matching labels

| Product candidate | Product ID | Exact labels, ignoring case | Name evidence |
|---|---|---|---|
| DBeaver Community | `dbeaver-community` | `dbeaver`; `dbeaver community` | [Inherited candidate](https://dbeaver.io/) |
| HeidiSQL | `heidisql` | `heidisql` | [Inherited candidate](https://www.heidisql.com/) |
| MySQL Workbench | `mysql-workbench` | `mysql workbench` | [Inherited candidate](https://www.mysql.com/products/workbench/) |
| Oracle SQL Developer | `oracle-sql-developer` | `oracle sql developer`; `sql developer` | [Product-name candidate](https://www.oracle.com/database/sqldeveloper/) |
| pgAdmin 4 | `pgadmin4` | `pgadmin 4` | [Inherited candidate](https://www.pgadmin.org/) |

Labels are curated candidates, not display names captured from a Cortex tenant. Extra versions, suffixes, prefixes, whitespace and unlisted editions do not match. Preserve `application_name` as the original evidence when confirming a product.

Evidence labels distinguish product-name candidates, vendor-installed-app labels, documented renames and inherited entries. Even a vendor-installed-app label remains unobserved in Cortex. Inherited references retain their original research status/date; a link alone is not a fresh retrieval claim. See the [coverage review](../coverage.md#name-evidence).

## Review focus

Database access; review connection secrets, production privileges, exports and approved destinations.

Added Oracle SQL Developer with two candidate product-name forms. ZIP/portable distributions, JDBC drivers, IDE plugins and web consoles can be absent. No production connection, database privilege or export is established.

- **Oracle SQL Developer**: Both are vendor product-name forms, not tenant display-name aliases. ZIP distributions may not register in inventory.

A match does not establish execution, current installation, approval, exposure or a security incident. Browser extensions, portable tools, web applications and unregistered packages can be absent from application inventory.

## Use and tune

1. Follow the shared [prerequisites and validation steps](../README.md#before-running).
2. Start with a shorter lookback and a small result limit. The published defaults are `30d` and `1000`.
3. Inspect raw inventory labels before adding a variant. Update both the initial `in (...)` filter and the corresponding `if(...)` assignments; make the same change in the master query.
4. Keep labels disjoint across product IDs. Do not replace whole-name matching with generic keywords such as `agent`, `remote` or `ai`.

Output: `endpoint_name`, `platform`, `application_name`, `version`, `detected_product`, `product_id`, `tool_family`. Each output row is one matching inventory row; duplicate reports and versions remain separate. The result cap returns a sample with no guaranteed order.

Review date: **2026-10-16**. Static review only; tenant schema, compilation and execution remain unverified. See the shared [evidence and limitations](../README.md#evidence-and-limitations).
