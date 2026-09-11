# Getting started

Use this library in the Cortex XSIAM interactive XQL editor after inspecting the target release, schema, data scope, access and retention. All complete-query compiler and execution checks remain NOT RUN.

## Query candidates

The 11 candidates use documented or inspected fields. Read the selected guide, replace any ordinary sentinel parameters, select the right scope and timeframe, and compile the complete body. Candidate status is not a guarantee that another tenant has compatible or populated fields.

## Schema binding templates

Each template has an individual guide and a matching `bindings/<id>.bindings.example.json`. Values intentionally start as null. Identify real datasets and fields with the required types, identity namespaces, source outcomes and row grain. A normalized data contract may need an additional source or reviewed view; substitution cannot create missing telemetry.

Copy the example into a local file, fill every binding, and render a new file:

```shell
python scripts/bind_query.py path/to/query.xql path/to/query.bindings.local.json bound/query.xql
```

Use the actual paths linked in the selected guide. The utility refuses unfilled or unexpected bindings, stage injection and existing output files. It checks the source hash when supplied. It performs text substitution only and writes a provenance sidecar; it never calls Cortex. Review the complete rendered body and the provenance together. A file-creation collision can leave an incomplete new output, which must not be used.

## The repository wrapper

```text
//Title
English title

//Description
English description

//Category
Category / Subcategory

:Query:

XQL body
```

Paste only the body after `:Query:`. The wrapper is not executable XQL and is not a saved-query import contract.

## Validate the result

Compile in the intended editor, then use a bounded timeframe and representative source events. Exercise the guide's positive, benign, negative, null and edge cases. Check identity joins, timestamps, duplicate rows and missing sources. A terminal limit caps displayed output, not upstream work. Empty results do not establish absence without verified collection and coverage.

[Catalog](CATALOG.md) · [Validation details](VALIDATION.md)
