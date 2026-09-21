# Cortex Cyber Hygiene Query Library

Open-source-ready, evidence-bounded Cortex XDR/XSIAM query library for corporate software-inventory review. This first release implements **Cyber Hygiene only**: 31 XQL candidates, 30 categories, 124 cataloged products, and 160 exact-name candidates.

> Status: **tenant validation required**. The query text is grounded in a historical Cortex XDR application-inventory example. XSIAM documents the preset but requires a separate field binding. No query was compiled or executed in a tenant.

## Purpose

The library helps answer: “Which visible application-inventory rows reported a reviewed product-name candidate in the selected window?” It does not claim software execution, session use, current installation, approval status, maliciousness, protection health, or complete fleet coverage.

## Scope

Included: application-inventory classification, policy-neutral taxonomy, category/master queries, allowlist design, conceptual correlation candidates, validation material, and static maintenance checks.

Not included: Threat Hunting, Detection Engineering implementation, Incident Investigation, Identity, Cloud, Network, Endpoint behavior, Persistence, Credential Access, Lateral Movement, Exfiltration, playbooks, response actions, or production rule deployment.

## Architecture

The [software catalog](catalog/software-catalog.yaml) is the single classifier source. [The generator](tools/generate_query_library.py) produces standalone category and master queries plus their guides and metadata. [Static validation](tests/validate_library.py) checks catalog integrity, drift, metadata, evidence boundaries, and documentation topology. See [architecture](docs/architecture.md) and [methodology](docs/methodology.md).

## Cyber Hygiene

- 30 primary categories, each with one XQL candidate, README, and metadata file.
- One [master query](cyber-hygiene/all-detected-tools.xql) covering all 124 products.
- Exact whole-name matching only; raw names preserved.
- Policy-neutral `review_priority: POLICY_DEPENDENT_UNASSIGNED`.
- No current-snapshot reconstruction because `endpoint_id` and `report_timestamp` remain unverified for this preset.

Browse the complete generated [Cyber Hygiene index](cyber-hygiene/README.md).

## Query catalog

| Query | Category | Purpose | Data source | Status |
|---|---|---|---|---|
| [All detected tools](cyber-hygiene/all-detected-tools.md) | All 30 | Classify all catalog candidates | `host_inventory_applications` preset | Requires tenant validation |
| [Penetration testing](cyber-hygiene/penetration-testing/README.md) | Security / dual-use | Inventory review | Same preset | Requires tenant validation |
| [Remote access](cyber-hygiene/remote-access/README.md) | Remote administration | Inventory review | Same preset | Requires tenant validation |
| [VPN/tunneling/proxy](cyber-hygiene/vpn-tunneling-proxy/README.md) | Connectivity | Inventory review | Same preset | Requires tenant validation |
| [Antivirus](cyber-hygiene/antivirus/README.md) | Antivirus | Installed-product candidates | Same preset | Requires tenant validation |
| [Endpoint security](cyber-hygiene/endpoint-security/README.md) | EDR / endpoint security | Installed-product candidates | Same preset | Requires tenant validation |
| [AI tools](cyber-hygiene/ai-tools/README.md) | AI clients | Inventory review | Same preset | Requires tenant validation |
| [AI development](cyber-hygiene/ai-development/README.md) | AI development | Inventory review | Same preset | Requires tenant validation |
| [Local AI](cyber-hygiene/local-ai/README.md) | Local runtimes | Inventory review | Same preset | Requires tenant validation |
| [Development IDEs](cyber-hygiene/development-ides/README.md) | Development | Inventory review | Same preset | Requires tenant validation |
| [Developer utilities](cyber-hygiene/developer-utilities/README.md) | Development | Inventory review | Same preset | Requires tenant validation |
| [Social applications](cyber-hygiene/social-applications/README.md) | Social | Inventory review | Same preset | Requires tenant validation |
| [Messaging](cyber-hygiene/messaging/README.md) | Communication | Inventory review | Same preset | Requires tenant validation |
| [Gaming](cyber-hygiene/gaming/README.md) | Gaming | Inventory review | Same preset | Requires tenant validation |
| [Cloud storage](cyber-hygiene/cloud-storage/README.md) | File synchronization | Inventory review | Same preset | Requires tenant validation |
| [File transfer](cyber-hygiene/file-transfer/README.md) | File movement | Inventory review | Same preset | Requires tenant validation |
| [P2P/torrent](cyber-hygiene/p2p-torrent/README.md) | P2P | Inventory review | Same preset | Requires tenant validation |
| [Browsers](cyber-hygiene/browsers/README.md) | Browsers | Inventory review | Same preset | Requires tenant validation |
| [Password managers](cyber-hygiene/password-managers/README.md) | Credentials | Inventory review | Same preset | Requires tenant validation |
| [Virtualization](cyber-hygiene/virtualization/README.md) | Virtualization | Inventory review | Same preset | Requires tenant validation |
| [Containers](cyber-hygiene/containers/README.md) | Containers | Inventory review | Same preset | Requires tenant validation |
| [Network utilities](cyber-hygiene/network-utilities/README.md) | Network tooling | Inventory review | Same preset | Requires tenant validation |
| [System administration](cyber-hygiene/system-administration/README.md) | Administration | Inventory review | Same preset | Requires tenant validation |
| [Database clients](cyber-hygiene/database-clients/README.md) | Database tooling | Inventory review | Same preset | Requires tenant validation |
| [Remote shell/SSH](cyber-hygiene/remote-shell-ssh/README.md) | Remote shell | Inventory review | Same preset | Requires tenant validation |
| [Scripting/automation](cyber-hygiene/scripting-automation/README.md) | Automation | Inventory review | Same preset | Requires tenant validation |
| [Screen capture](cyber-hygiene/screen-capture/README.md) | Capture/recording | Inventory review | Same preset | Requires tenant validation |
| [Personal collaboration](cyber-hygiene/personal-collaboration/README.md) | Collaboration | Inventory review | Same preset | Requires tenant validation |
| [Crypto/mining](cyber-hygiene/crypto-mining/README.md) | Crypto/mining | Inventory review | Same preset | Requires tenant validation |
| [Privacy/anonymization](cyber-hygiene/privacy-anonymization/README.md) | Privacy | Inventory review | Same preset | Requires tenant validation |
| [Other review candidates](cyber-hygiene/other-shadow-it/README.md) | Other policy review | Inventory review | Same preset | Requires tenant validation |

## How to use

1. Read the query's README and metadata.
2. Confirm product/build, Query Center surface, license, identity, RBAC/SBAC, preset availability, fields/types, collection, retention, and result limits.
3. Begin with a narrow timeframe and small bound; compile one stage at a time.
4. Run controlled positive, benign, negative, null, suffix, duplicate, and boundary fixtures.
5. Preserve raw values and record S/D/C/E separately. A successful compile is not a successful execution or a complete inventory.

See the [validation guide](docs/validation-guide.md) and [validation matrix](docs/query-validation-matrix.md).

## How to tune

Add a product label only after capturing a sanitized raw inventory value, platform/package context, identity corroboration, and negative lookalikes. Update the catalog, regenerate, run `python tools/generate_query_library.py --check`, then run `python tests/validate_library.py`. Avoid generic substring rules.

## Corporate allowlisting

Classification is not approval. An organization-specific allowlist needs product ID, version, asset/user/business-unit scope, purpose, owner, approver, effective dates, expiry, exceptions, and evidence. See [allowlisting](docs/allowlisting.md).

## Correlations

The [correlation candidates](correlations/README.md) are conceptual only. They do not create rules or Issues/Cases, and they assign no universal severity. Direct BIOC or real-time conversion is not assumed.

## Limitations

- Complete current preset schema and XSIAM field binding are unavailable.
- Queries do not choose a latest complete report; historical/duplicate rows may remain.
- Exact matching misses suffixes, localization, custom branding, portable binaries, extensions, PWAs, embedded controls, and unregistered tools.
- The 1,000-row cap can truncate; it does not bound upstream work.
- The 113 KB master query has not been compiled or performance-tested.
- Product references do not prove Cortex display names or tenant presence.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Contributions must include product/category rationale, exact candidate labels, evidence, lookalike negatives, affected queries, and validation status. Tenant identifiers and private allowlists must not be committed.

## Palo Alto documentation references

The dated source register and implementation impact are in [Palo Alto XQL research](docs/research/palo-alto-xql-research.md). Primary references include current XSIAM/XDR datasets and presets, Host Inventory, XQL `config`, `filter`, `fields`, `windowcomp`, `join`, `limit`, and rule-surface documentation.

## Disclaimer

Community project; not official Palo Alto Networks content or product support. Software categories are governance aids, not maliciousness labels. Validate every artifact against your product version, tenant schema, policies, and legal/privacy requirements. No response action is authorized by this repository.

License selection is intentionally pending maintainer approval before public publication; public availability alone does not grant reuse rights.
