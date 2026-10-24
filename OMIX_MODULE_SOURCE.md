# Canonical OMIX Module Source

## Canonical module

- **Module:** [OMIX Seurat Pseudobulk](https://github.com/NIDAP-Community/OMIX/tree/main/modules/OMIX-Seurat-Pseudobulk)
- **Canonical path:** `modules/OMIX-Seurat-Pseudobulk/`
- **Canonical module version:** `0.5.0`
- **Canonical interface version:** `1`
- **Canonical release tag:** **Pending** — no validated namespaced module tag is established.
- **Canonical source reference:** [`c04608a215aae16d15296036e2df6975a6c34b94`](https://github.com/NIDAP-Community/OMIX/commit/c04608a215aae16d15296036e2df6975a6c34b94)
- **Interface schema:** [schemas/interface.yml](https://github.com/NIDAP-Community/OMIX/blob/c04608a215aae16d15296036e2df6975a6c34b94/modules/OMIX-Seurat-Pseudobulk/schemas/interface.yml)
- **Module contract:** [OMIX module contract](https://github.com/NIDAP-Community/OMIX/blob/main/docs/module-contract.md)

## Adapter release record

| Field | Recorded value |
| --- | --- |
| Adapter version | **Pending** — baseline tag not yet established. |
| Adapter release tag | **Pending** representative platform validation and explicit approval. |
| Platform release | **Pending** Code Ocean capsule creation, validation, and release approval. |
| Canonical runtime profile | `r-seurat-conversion` |
| Published OMIX runtime | `ghcr.io/nidap-community/omix-r-seurat-conversion:r4.4.3-v3`; immutable public identity `ghcr.io/nidap-community/omix-r-seurat-conversion@sha256:23dea282248fa4335c60f9b87538be04929acba67a10047267a0a31bd2e8391c` |
| Runtime source commit | [`98df6d452538cc896d534e11aae4eb6a761b7f9f`](https://github.com/NIDAP-Community/OMIX/commit/98df6d452538cc896d534e11aae4eb6a761b7f9f) |
| Runtime lockfile | `starter-environments/r-seurat-conversion/renv.lock` at runtime source commit `98df6d452538cc896d534e11aae4eb6a761b7f9f`; SHA-256 `a0af1162d74d10fcf8cda9313e67b9db575d72adc04ed9b9d56f4909d0b08b29` |
| Runtime publication evidence | [GitHub Actions run 40106621939](https://github.com/NIDAP-Community/OMIX/actions/runs/40106621939) |
| Runtime verification evidence | [GitHub Actions run 40110151312](https://github.com/NIDAP-Community/OMIX/actions/runs/40110151312) |
| Adapter-selected base image | `codeocean/omix-r-seurat-conversion:r4.4.3-v3` |
| Code Ocean environment identity | **Pending** import and immutable resolution in Code Ocean; it is not inferred from GHCR. |
| Capsule run | **Pending** representative validation of all three aggregation modes. |
| Syncweaver mapping | `.syncweaver-lock.json` **Pending** generation by Syncweaver; the initial interim Harbor export and hashes are recorded below. |

The source commit, canonical tag, adapter tag, public OCI digest, Code Ocean
environment identity, capsule run, and platform release are separate facts.

## Exported scientific files

| Canonical file | Adapter copy | SHA-256 | Purpose |
| --- | --- | --- | --- |
| `R/Seurat_Pseudobulk.R` | `code/functions/Seurat_Pseudobulk.R` | `a2e31545f1c168343936ab402e31419ed0331b50b6e531395ca58ca1c84036ae` | Canonical aggregation and single/selected/all collection output-bundle implementation |

The complete canonical `R/` tree contains this one file at the recorded source
commit. The adapter copy is byte-identical; no formatting or behavioral edit
was applied. The `0.5.0` collection implementation is a byte-identical
canonical export. Its collection mode creates independent nested ordinary
bundles and never pools cells or fits a downstream statistical model.

## Syncweaver mapping

- **Canonical source directory:** `modules/OMIX-Seurat-Pseudobulk/R/`
- **Adapter destination:** `code/functions/`
- **Generated lockfile:** **Pending** Syncweaver generation. Do not hand-author
  `.syncweaver-lock.json`.
- **Interim content verification:** SHA-256 and exact-file-set checks are in
  `tests/test-source-parity.py`.
- **Host-side drift:** None in this initial export.

## Interface translation

All canonical user-settable fields retain their schema names and defaults.
`seurat_rds` and `cell_type_selection` are represented by Code Ocean file
selectors. The RDS can also be resolved from exactly one `.rds` below `/data`.
`output_dir` is intentionally hidden and fixed to `/results` by the platform
adapter. Comma-delimited App Panel values for `metadata_columns` and
`cell_filter_values` are translated to the canonical character-vector
arguments without changing their contents. The App Panel cannot express
conditional required fields, so its descriptions identify that `cell_type` is
required in `one` mode and `cell_type_selection` in `selected` mode; the
adapter enforces both conditions before sourcing the scientific function.

The adapter does not add a second aggregation method, infer metadata fields,
pool cell types, or run a downstream statistical model. In selected/all mode,
it retains the root collection catalog and manifest plus every nested ordinary
bundle so the downstream Limma collection route can validate and consume the
complete collection.

## Platform-validation status

The Code Ocean environment's immutable identity and all current-candidate
capsule runs remain **Pending**. Historical v1- and v2-runtime runs do not
validate this `0.5.0`/v3 candidate: raw run `1149091` and SCT run `1149544`
exercised the pre-v2 adapter, while Harmony run `1149333` failed and motivated
the bridge/runtime correction. No cross-environment equivalence claim is made.

## Canonical registration

The canonical module's `deployment_adapters` list and README register
`https://github.com/NIDAP-Community/OMIX-Seurat-Pseudobulk`. Code Ocean
configuration remains solely in this deployment repository.

The canonical contract fixes `feature_id_column` to `GeneName`, the only value
implemented by the bundle writer and supported by downstream DEG and Limma
handoffs. The App Panel presents that fixed allowed value without widening or
reimplementing the canonical interface.

## Synchronization procedure

1. Make scientific or reusable-interface changes in canonical OMIX.
2. Validate its function, schema, CLI, tests, README, changelog, and version.
3. Export the complete released canonical `R/` tree byte-for-byte into
   `code/functions/` through Syncweaver, or the documented interim Harbor
   process while automation remains unavailable.
4. Update the immutable source reference and per-file hashes in the same
   reviewable adapter pull request.
5. Have Beacon verify file parity, App Panel/schema translation, fixture
   behavior, and runtime provenance.
6. Validate the exact merged adapter commit in Code Ocean before recording a
   tag or platform release.

If a deployment run exposes a scientific issue, backport the correction to
canonical OMIX before updating this managed export.
