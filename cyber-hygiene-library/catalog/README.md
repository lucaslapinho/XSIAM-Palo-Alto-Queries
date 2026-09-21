# Software catalog

`software-catalog.yaml` is the authoritative, policy-neutral classifier source. It contains 124 product records across 30 primary categories and 160 exact case-insensitive candidate labels.

All labels are research candidates with `tenant_validated: false`. Product references support product-family context only. They do not verify a Cortex inventory label, publisher field, installation, execution, approval, or risk.

Maintain stable product/category IDs, preserve raw labels, reject cross-product literal collisions, and keep organization-specific allowlists outside the public catalog. Regenerate queries after every catalog change.
