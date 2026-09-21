# File tree — Cyber Hygiene release

This tree records the project files delivered on 2026-09-21. It excludes generated Python bytecode and future modules.

```text
XSIAM-Palo-Alto-Queries/
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── catalog/
│   ├── README.md
│   └── software-catalog.yaml
├── cyber-hygiene/
│   ├── README.md
│   ├── all-detected-tools.xql
│   ├── all-detected-tools.md
│   ├── all-detected-tools.metadata.yaml
│   ├── ai-development/
│   │   ├── detect-ai-development-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── ai-tools/
│   │   ├── detect-ai-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── antivirus/
│   │   ├── detect-antivirus-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── browsers/
│   │   ├── detect-browsers-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── cloud-storage/
│   │   ├── detect-cloud-storage-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── containers/
│   │   ├── detect-containers-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── crypto-mining/
│   │   ├── detect-crypto-mining-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── database-clients/
│   │   ├── detect-database-clients-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── developer-utilities/
│   │   ├── detect-developer-utilities-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── development-ides/
│   │   ├── detect-development-ides-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── endpoint-security/
│   │   ├── detect-endpoint-security-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── file-transfer/
│   │   ├── detect-file-transfer-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── gaming/
│   │   ├── detect-gaming-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── local-ai/
│   │   ├── detect-local-ai-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── messaging/
│   │   ├── detect-messaging-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── network-utilities/
│   │   ├── detect-network-utilities-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── other-shadow-it/
│   │   ├── detect-other-shadow-it-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── p2p-torrent/
│   │   ├── detect-p2p-torrent-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── password-managers/
│   │   ├── detect-password-managers-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── penetration-testing/
│   │   ├── detect-penetration-testing-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── personal-collaboration/
│   │   ├── detect-personal-collaboration-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── privacy-anonymization/
│   │   ├── detect-privacy-anonymization-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── remote-access/
│   │   ├── detect-remote-access-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── remote-shell-ssh/
│   │   ├── detect-remote-shell-ssh-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── screen-capture/
│   │   ├── detect-screen-capture-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── scripting-automation/
│   │   ├── detect-scripting-automation-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── social-applications/
│   │   ├── detect-social-applications-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── system-administration/
│   │   ├── detect-system-administration-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   ├── virtualization/
│   │   ├── detect-virtualization-tools.xql
│   │   ├── README.md
│   │   └── query-metadata.yaml
│   └── vpn-tunneling-proxy/
│       ├── detect-vpn-tunneling-proxy-tools.xql
│       ├── README.md
│       └── query-metadata.yaml
├── correlations/
│   ├── README.md
│   └── cyber-hygiene/
│       ├── README.md
│       ├── gaming-software-on-corporate-endpoint.md
│       ├── multiple-endpoint-security-products.md
│       ├── pentest-tool-on-standard-workstation.md
│       ├── unapproved-remote-access-tool.md
│       ├── unapproved-vpn-client.md
│       ├── unauthorized-ai-client.md
│       ├── unauthorized-cloud-storage-client.md
│       └── unexpected-developer-tooling.md
├── docs/
│   ├── allowlisting.md
│   ├── architecture.md
│   ├── cyber-hygiene-taxonomy.md
│   ├── file-tree.md
│   ├── methodology.md
│   ├── qa-review.md
│   ├── query-validation-matrix.md
│   ├── validation-guide.md
│   ├── xql-style-guide.md
│   └── research/
│       ├── palo-alto-xql-research.md
│       └── reference-repository-analysis.md
├── tests/
│   ├── README.md
│   └── validate_library.py
└── tools/
    ├── generate_query_library.py
    └── generate_support_docs.py
```
