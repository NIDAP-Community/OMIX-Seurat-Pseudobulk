# Deployment Adapter Agent Instructions

This repository is a deployment adapter for the canonical OMIX module recorded
in [OMIX_MODULE_SOURCE.md](OMIX_MODULE_SOURCE.md). Read that file, this
repository's README, and the canonical [OMIX module contract](https://github.com/NIDAP-Community/OMIX/blob/main/docs/module-contract.md)
before editing.

## Ownership

- Canonical OMIX owns aggregation behavior, scientific defaults, portable CLI
  behavior, schemas, and scientific tests.
- This repository owns the Code Ocean UI, mounted-input discovery, `/results`
  placement, environment selection, and platform entry point.
- `code/functions/` is a byte-identical managed export of canonical `R/`.
  Never edit it directly. Fix scientific behavior in OMIX, validate it there,
  and update the complete export through the controlled synchronization path.
- Harbor owns `.codeocean/`, `code/main.R`, `code/adapter/`, `code/run`,
  deployment documentation, and adapter tests. Beacon independently verifies
  source and interface parity before release.

## Working rules

1. Inspect Git status, `.codeocean/app-panel.json`, `OMIX_MODULE_SOURCE.md`,
   and the canonical interface schema before editing.
2. Expose every user-settable canonical parameter with matching names, types,
   choices, and defaults. `/results` is the only intentionally hidden,
   platform-managed parameter.
3. Discover an attached RDS only when exactly one candidate exists. Otherwise
   stop and list candidates; never select by timestamp.
4. Keep the matrix, aligned metadata, manifest, and summaries together in
   `/results` for downstream workflow use.
5. Use the pinned `r-seurat-conversion` runtime. Do not replace it with
   `latest`, `r-singlecell`, or a capsule-local Seurat installation.
6. Do not commit Seurat objects, study data, generated results, credentials,
   package caches, or environment inventories.
7. Report local contract tests separately from representative Code Ocean
   runs. Local synthetic tests are not platform validation.
8. If the exported function differs from the canonical source hash, stop and
   report drift rather than overwriting or reconciling it manually.

## Release discipline

- No adapter tag or platform release is authorized by a green local test.
- Before release, validate all three aggregation modes using supported
  representative objects, inspect output alignment and manifest routing, and
  exercise both downstream routes.
- Keep unknown adapter tag, Code Ocean environment identity, capsule run, and
  platform release fields explicitly `Pending`.
- Follow the canonical [release automation contract](https://github.com/NIDAP-Community/OMIX/blob/main/docs/release-automation-contract.md).
