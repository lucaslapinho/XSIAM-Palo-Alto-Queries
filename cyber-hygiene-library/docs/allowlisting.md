# Corporate allowlisting model

Classification and approval are separate. Public queries do not label software unauthorized.

An organization-specific allowlist record should include:

```yaml
product_id: teamviewer
version_scope: "<approved range or any>"
asset_scope: "<group/class, not public identifiers>"
identity_scope: "<role or population>"
business_unit: "<owner>"
business_purpose: "<justification>"
account_or_workspace: "<managed tenancy where relevant>"
approver: "<role>"
effective_from: "<date>"
expires_at: "<date>"
exceptions: []
evidence_reference: "<internal governed record>"
```

Required states are `APPROVED`, `DENIED`, `EXCEPTION`, and `UNKNOWN`; missing policy is `UNKNOWN`, never `DENIED`. Compare by stable product ID only after identity corroboration. Scope/version/time mismatches produce a review candidate, not an incident.

Allowlists need an owner, expiry, change history, least scope, and periodic review. Do not publish private asset groups, users, tenant names, or business exceptions in this repository.
