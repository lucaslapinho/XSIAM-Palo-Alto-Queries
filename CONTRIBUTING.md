# Contributing

Start with an observable investigation question and the expected result grain. Search the catalog for overlap before adding a new use case.

- Keep titles, descriptions, comments, categories and guides in English, using the existing wrapper and stable IDs.
- Cite primary documentation for language and field claims. Use explicit typed bindings when the tenant schema is unknown.
- Explain null behavior, identity normalization, join cardinality, event ordering, lookback and output bounds.
- Supply positive, benign, negative, null and boundary scenarios. Record compilation and execution separately from static review.
- Preserve ATT&CK as contextual interpretation, and state meaningful false positives and blind spots.
- Use synthetic examples and remove operational identifiers, credentials and private captures.

Submit a pull request with the observable behavior, the affected files, evidence, validation results and remaining gaps. A query should not be described as production-ready based solely on static checks. Update the catalog, individual guide and SHA256SUMS.txt when changing content.
