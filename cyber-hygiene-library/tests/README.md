# Static tests

Run:

```text
python tools/generate_query_library.py --check
python tests/validate_library.py
```

Checks cover YAML parsing, declared counts, stable IDs, exact-literal collisions, policy neutrality, generated drift, query/guide/metadata topology, forbidden unverified source fields, read-only XQL, query limits, validation status, and master/category coverage.

These tests are not an XQL parser, Cortex compiler, tenant execution, product-identity test, performance benchmark, or production-readiness assessment. They never change S/D/C/E tenant evidence.
