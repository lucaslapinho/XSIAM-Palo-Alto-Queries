# XQL style guide

## Scope and status

These rules target read-only interactive Query Center candidates. Rule/API/XQLp compatibility is separate. Complete-query validation remains tenant-unverified.

## Source and configuration

- Put `config` first.
- Name the preset/dataset explicitly.
- Use the narrowest useful timeframe and an explicit output limit.
- Record product, version, surface, identity scope, timezone, retention, and evidence status outside executable text.

## Naming

- Source fields retain vendor spelling.
- Derived fields use lowercase `snake_case`.
- Stable product/category IDs use lowercase kebab-case in YAML and filenames.
- Use `application_name_normalized`, `detected_product`, `product_id`, `tool_family`, `tool_subcategory`, `expected_product_vendor`, `corporate_relevance`, and `review_priority` consistently.

## Filters and nulls

- Filter null/empty strings before type-sensitive functions.
- Parenthesize mixed `and`/`or` logic.
- Do not treat null, empty string, zero, and absence as equivalent.
- Prefer reviewed exact literals; prohibit unbounded generic terms.

## `alter`

- Use `alter` for derived values; `fields` is projection only.
- Initialize mapping fields explicitly and preserve fall-through values.
- Keep mapping predicates disjoint; fail generation on literal collisions.
- Do not overwrite raw evidence fields.

## `fields`

- Project only fields required by downstream stages and the final decision.
- Remember that aliases replace original names downstream.
- Never add a field solely because it appeared in an unverified example.

## `comp`, `windowcomp`, `dedup`, and joins

- State row grain before and after every cardinality change.
- Define grouping keys, null behavior, tie behavior, and discarded fields.
- For joins, document key types, uniqueness, multiplicity, time alignment, unmatched rows, and conflict strategy.
- Sort again after stages that do not preserve order.
- Do not use latest-report logic until the report identity/time and snapshot semantics are verified.

## Sorting and limits

- Sort before limit only when top/bottom/newest semantics are required.
- An unsorted limit returns an unspecified subset.
- A final limit bounds returned rows, not scanned work or fleet completeness.

## Case normalization and strings

- Preserve raw strings and create a normalized copy.
- Exact match is the default taxonomy operation.
- Trimming, suffix removal, regex, tokenization, and substring matching require product-specific positive/negative evidence.

## Timestamps

- Distinguish source report time, record time, insertion time, execution time, and display timezone.
- Do not transfer `_time` semantics or type to `report_timestamp`.
- A maximum timestamp within a window is not proof of global freshness or a complete snapshot.

## Comments

Keep explanations in adjacent Markdown unless comment support is verified for the exact product/version/surface and import path. Generated XQL contains no inline comments.

## Performance

- Filter nulls and reviewed product candidates early when no later snapshot selection depends on excluded rows.
- Project required fields before expensive transformations.
- Generate category views; measure the master query before operational use.
- Do not claim faster/lower-cost behavior without comparable tenant measurements.

## False positives and policy

Separate identity false positives from approved true matches. Query output must remain policy-neutral. Allowlist, severity, suppression, grouping, and response require separate governed artifacts.
