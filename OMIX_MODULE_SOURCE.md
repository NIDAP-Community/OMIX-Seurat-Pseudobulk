# Canonical OMIX Module Source

## Canonical module

- **Module:** [OMIX Seurat Pseudobulk](https://github.com/NIDAP-Community/OMIX/tree/main/modules/OMIX-Seurat-Pseudobulk)
- **Canonical path:** `modules/OMIX-Seurat-Pseudobulk/`
- **Canonical module version:** `0.4.0`
- **Canonical interface version:** `1`
- **Canonical release tag:** **Pending** — no validated namespaced module tag is established.
- **Canonical source reference:** [`b39dbff7f04ff47b2235a454209a3fb4812e763c`](https://github.com/NIDAP-Community/OMIX/commit/b39dbff7f04ff47b2235a454209a3fb4812e763c)
- **Interface schema:** [schemas/interface.yml](https://github.com/NIDAP-Community/OMIX/blob/b39dbff7f04ff47b2235a454209a3fb4812e763c/modules/OMIX-Seurat-Pseudobulk/schemas/interface.yml)
- **Module contract:** [OMIX module contract](https://github.com/NIDAP-Community/OMIX/blob/main/docs/module-contract.md)

## Adapter release record

| Field | Recorded value |
| --- | --- |
| Adapter version | **Pending** — baseline tag not yet established. |
| Adapter release tag | **Pending** representative platform validation and explicit approval. |
| Platform release | **Pending** Code Ocean capsule creation, validation, and release approval. |
| Canonical runtime profile | `r-seurat-conversion` |
| Published OMIX runtime | `ghcr.io/nidap-community/omix-r-seurat-conversion:r4.4.3-v1`; immutable public identity `ghcr.io/nidap-community/omix-r-seurat-conversion@sha256:4399e2e2da1947b555a96b52e0b33632312b0608d7cef8c74ad2b1947335862c` |
| Runtime lockfile | `starter-environments/r-seurat-conversion/renv.lock` at canonical source commit; SHA-256 `a0af1162d74d10fcf8cda9313e67b9db575d72adc04ed9b9d56f4909d0b08b29` |
| Runtime publication evidence | [GitHub Actions run 35920756817](https://github.com/NIDAP-Community/OMIX/actions/runs/35920756817) |
| Runtime verification evidence | [GitHub Actions run 35999065628](https://github.com/NIDAP-Community/OMIX/actions/runs/35999065628) |
| Adapter-selected base image | `codeocean/omix-r-seurat-conversion:r4.4.3-v1` |
| Code Ocean environment identity | **Pending** import and immutable resolution in Code Ocean; it is not inferred from GHCR. |
| Capsule run | **Pending** representative validation of all three aggregation modes. |
| Syncweaver mapping | `.syncweaver-lock.json` **Pending** generation by Syncweaver; the initial interim Harbor export and hashes are recorded below. |

The source commit, canonical tag, adapter tag, public OCI digest, Code Ocean
environment identity, capsule run, and platform release are separate facts.

## Exported scientific files

| Canonical file | Adapter copy | SHA-256 | Purpose |
| --- | --- | --- | --- |
| `R/Seurat_Pseudobulk.R` | `code/functions/Seurat_Pseudobulk.R` | `52493e6b1be66fadec0343ba7821911efae382f741bad694f9ca00574ae2c16c` | Canonical aggregation and output-bundle implementation |

The complete canonical `R/` tree contains this one file at the recorded source
commit. The adapter copy is byte-identical; no formatting or behavioral edit
was applied.

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
`seurat_rds` is represented by a Code Ocean file selector and can also be
resolved from exactly one `.rds` below `/data`. `output_dir` is intentionally
hidden and fixed to `/results` by the platform adapter. Comma-delimited App
Panel values for `metadata_columns` and `cell_filter_values` are translated to
the canonical character-vector arguments without changing their contents.

The adapter does not add a second aggregation method, infer metadata fields,
or run a downstream statistical model.

## Canonical registration plan

After this adapter is reviewed and accepted, a separate canonical OMIX pull
request should add
`https://github.com/NIDAP-Community/OMIX-Seurat-Pseudobulk` to the module's
`deployment_adapters` list and link the adapter from the canonical module
README. That registration must not copy Code Ocean configuration into OMIX or
change the module's scientific version merely because the adapter exists.

One canonical contract detail also requires domain-owner review before
release: the interface currently presents `feature_id_column` as a general
string parameter, while the bundle writer rejects every value other than
`GeneName`. The adapter exposes the parameter as required by the schema and
documents the current restriction; it does not relax or reimplement it.

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
