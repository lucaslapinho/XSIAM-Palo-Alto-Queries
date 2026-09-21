# Unapproved Remote Access Tool

**Artifact class:** `CONCEPTUAL / TENANT-UNVERIFIED`
**Rule surface:** undecided candidate; no importable correlation syntax
**S/D/C/E:** `NOT RUN / NOT RUN / NOT RUN / NOT RUN`

## Objective

Identify policy-exception candidates involving remote access software after product identity, current inventory state, endpoint scope, and policy have been independently established.

## Source query

Primary input: [`cyber-hygiene/remote-access/README.md`](../../cyber-hygiene/remote-access/README.md). The query supplies reported inventory candidates only. It does not prove execution, use, current installation, or policy violation.

## Required datasets and contracts

- Tenant-validated application-inventory source and fields.
- Stable endpoint identity, endpoint class/owner/business unit, and current-snapshot semantics.
- Governed software-policy/allowlist source with owner, scope, version, effective dates, expiry, exceptions, and audit history.
- For operational correlation: exact XSIAM product/build, license, rule surface, identity, RBAC/SBAC, retention, schedule/window, and Issue field contract.

## Correlation logic

Join or compare a corroborated remote access product candidate with an organization-specific policy record using stable product ID plus asset/user/business scope, version and effective time. Emit only policy mismatches or expired exceptions.

One output row should mean one endpoint/product/policy evaluation in a recorded window. Duplicate inventory components, versions, reports, null keys, delayed data, and reused hostnames need explicit handling. Query Center success does not prove correlation-editor compatibility.

## Business context

Review support ownership, unattended access, authentication and session logging. The same product can be expected, required, tolerated, or prohibited in different asset/user/business scopes.

## Exclusions and allowlists

Do not exclude by product name alone. An allowlist must bind product ID, version scope, endpoint/user/business scope, purpose, owner, approver, effective dates, expiry, and exception evidence. Missing policy is `UNKNOWN`, not `DENIED`.

## False positives and false negatives

False positives include correct product candidates on approved assets, stale/duplicate reports, incomplete policy scope, identical-name packages, migrations, and managed exceptions. False negatives include missing inventory coverage, unregistered/portable/rebranded software, unlisted suffixes, null identities, stale endpoints, restricted visibility, expired retention, and policy records not available to the evaluation.

## Severity considerations

No universal severity is assigned. A risk owner considers endpoint role, owner, business unit, privileged/regulated asset status, server/workstation context, data sensitivity, approved-software policy, identity confidence, freshness, and corroborating behavior. An inventory/policy mismatch alone does not establish malicious activity.

## Recommended investigation

1. Confirm collection health, source field binding, report freshness, and endpoint identity.
2. Corroborate package/publisher/signature identity using validated telemetry.
3. Review the scoped allowlist and exception history with its owner.
4. Determine whether software is installed now and whether it was executed using separate evidence.
5. Escalate only after business context and adverse behavior are established.

## Prerequisites and validation

Use positive, approved-benign, negative-lookalike, null, duplicate, removed-application, newest-empty-report, boundary-time, restricted-identity, and high-volume fixtures. Measure candidate and Issue volume before choosing thresholds or suppression. Validate editor/compiler, historical execution, shadow, and bounded canary separately. Define owner, monitoring, disable/rollback, exception review, and retirement before promotion.

## Non-claims

No rule was created, compiled, executed, enabled, or deployed. No Issue/Case, severity, grouping, suppression, hit rate, performance, or response action is claimed. This document authorizes no uninstall, block, isolation, or containment action.

## Official references

- [Create a correlation rule](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/detect-investigate-and-respond-to-threats/threat-management/detection-rules/what-are-detection-rules/whats-a-correlation-rule/create-a-correlation-rule) — rule-surface constraints; review date 2026-09-20.
- [XSIAM datasets and presets](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets) — preset existence, not concrete field binding.

These sources do not establish tenant license, schema, rule-editor acceptance, Issue generation, grouping, severity, or efficacy.
