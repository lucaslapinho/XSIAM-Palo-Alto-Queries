# Contributing

Contributions are welcome for the Cyber Hygiene module. Future modules require a separate architecture decision.

## Add or change a product

Submit a catalog change containing:

- stable `product_id` and canonical product name;
- vendor/project label and primary source URL with review date;
- primary category, subcategory, and justified secondary categories;
- exact proposed application-name literals;
- platform/package assumptions and product/component boundaries;
- negative lookalikes and expected identity collisions;
- corporate-security context written without maliciousness or universal-risk claims;
- affected query/category;
- tenant evidence status and Cortex version when available;
- sanitized positive, benign, negative, null, suffix, and ambiguity fixtures.

Do not add generic patterns such as `ai`, `vpn`, `remote`, `cloud`, `agent`, `security`, `visual`, or `code`. `alternate_names` are descriptive and do not automatically become match patterns.

## Evidence

Distinguish product research from Cortex display-name evidence. A vendor page proves neither the installed-app label nor tenant presence. Never claim tenant compilation or execution without retained product/build, surface, identity scope, exact artifact hash, timeframe, and sanitized result evidence.

## Regenerate and validate

```text
python tools/generate_query_library.py
python tools/generate_query_library.py --check
python tests/validate_library.py
```

Review all generated diffs. Do not hand-edit generated query, category README, or metadata files; change the catalog or generator.

## Pull-request checklist

- [ ] Change is Cyber Hygiene only.
- [ ] Product identity and category rationale are documented.
- [ ] Exact labels and lookalike negatives are provided.
- [ ] No private tenant identifiers, users, URLs, allowlists, or secrets are present.
- [ ] Inventory is not described as execution or behavior.
- [ ] Policy priority remains unassigned in public artifacts.
- [ ] S/D/C/E claims match retained evidence.
- [ ] Generator drift check and static tests pass.
- [ ] README, metadata, validation matrix, and changelog impacts are reviewed.

## Licensing

Before GitHub publication, the maintainer must choose and add an explicit open-source license. Contributions should not copy content whose license is unknown.
