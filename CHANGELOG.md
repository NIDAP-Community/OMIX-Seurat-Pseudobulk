# Changelog

## Unreleased

### Added

- Initial Code Ocean deployment adapter for canonical OMIX Seurat Pseudobulk
  `0.4.0`, interface version `1`.
- Byte-identical export of the canonical pseudobulk scientific function.
- Unambiguous Seurat RDS discovery, complete App Panel parameter coverage,
  stable `/results` bundle output, and deployment provenance.
- Local tests for input discovery, parameter translation, output routing,
  App Panel parity, and canonical source hashes.

### Changed

- Synchronized the managed scientific export with canonical OMIX Seurat
  Pseudobulk `0.4.1`.
- Fixed the Code Ocean `feature_id_column` control to the canonical and
  downstream-safe `GeneName` value.
- Updated canonical provenance to Pseudobulk `0.4.2`, interface `1`, while
  retaining the byte-identical managed R export. The `0.4.2` compatibility
  fix is in OmixSeurat rather than the module-owned aggregation function.
- Updated public runtime provenance and the Code Ocean base-image selection to
  published `r-seurat-conversion:r4.4.3-v2`, including its immutable digest,
  unchanged lockfile hash, and publication and verification workflow records.

Current-candidate Seurat-object Code Ocean runs, imported-environment identity,
cross-environment equivalence, downstream DEG/Limma consumption, adapter
version/tag, and platform release remain pending. Historical v1-runtime runs
do not validate this `0.4.2`/v2 candidate.
