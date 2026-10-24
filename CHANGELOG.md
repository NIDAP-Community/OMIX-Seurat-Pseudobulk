# Changelog

## Unreleased

### Added

- Code Ocean translation for canonical selected/all cell-type collection mode,
  including the ordered selection-file control, root collection artifacts, and
  preserved nested ordinary bundles for downstream Limma collection routing.
- Initial Code Ocean deployment adapter for canonical OMIX Seurat Pseudobulk
  `0.4.0`, interface version `1`.
- Byte-identical export of the canonical pseudobulk scientific function.
- Unambiguous Seurat RDS discovery, complete App Panel parameter coverage,
  stable `/results` bundle output, and deployment provenance.
- Local tests for input discovery, parameter translation, output routing,
  App Panel parity, and canonical source hashes.

### Changed

- Updated the Code Ocean base-image selection and runtime provenance to the
  published `r-seurat-conversion:r4.4.3-v3` immutable image. This deployment
  configuration update supplies OmixSeurat 0.4.0 required by selected/all
  Pseudobulk collection; it does not change canonical aggregation behavior.

- Declared the attached representative Seurat asset in the App Panel's
  top-level `datasets` array so a released capsule can expose a replaceable
  workflow input node. This changes deployment wiring only; aggregation
  behavior, managed scientific code, runtime, and standalone input discovery
  are unchanged.
- Synchronized the managed scientific export with canonical OMIX Seurat
  Pseudobulk `0.4.1`.
- Fixed the Code Ocean `feature_id_column` control to the canonical and
  downstream-safe `GeneName` value.
- Updated canonical provenance to Pseudobulk `0.4.2`, interface `1`, while
  retaining the byte-identical managed R export. The `0.4.2` compatibility
  fix is in OmixSeurat rather than the module-owned aggregation function.
- Synchronized the managed scientific export and source record with canonical
  Pseudobulk `0.5.0` at `c04608a`. This is an adapter-only translation of the
  already-reviewed canonical collection interface; the runtime pin is
  unchanged.
- Updated public runtime provenance and the Code Ocean base-image selection to
  published `r-seurat-conversion:r4.4.3-v2`, including its immutable digest,
  unchanged lockfile hash, and publication and verification workflow records.

Current-candidate Seurat-object Code Ocean runs, imported-environment identity,
cross-environment equivalence, downstream DEG/Limma consumption, adapter
version/tag, and platform release remain pending. Historical v1- and
v2-runtime runs do not validate this `0.5.0`/v3 candidate.
