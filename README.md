# OMIX Seurat Pseudobulk — Code Ocean Adapter

Create one donor-level expression bundle for one selected cell type, an ordered
selected set, or all retained cell types from a serialized Seurat object. This
repository supplies the Code Ocean interface for the portable OMIX Seurat
Pseudobulk module; it does not maintain a second aggregation implementation.

## Canonical OMIX module

| Item | Location |
| --- | --- |
| Canonical module | [OMIX Seurat Pseudobulk](https://github.com/NIDAP-Community/OMIX/tree/main/modules/OMIX-Seurat-Pseudobulk) |
| Interface contract | [schemas/interface.yml](https://github.com/NIDAP-Community/OMIX/blob/main/modules/OMIX-Seurat-Pseudobulk/schemas/interface.yml) |
| Development contract | [OMIX module contract](https://github.com/NIDAP-Community/OMIX/blob/main/docs/module-contract.md) |
| Version and source record | [OMIX_MODULE_SOURCE.md](OMIX_MODULE_SOURCE.md) |

The canonical module owns the scientific functions, portable CLI, tests, and
input/output contract. Its complete `R/` tree is exported byte-for-byte under
`code/functions/`. This repository owns only Code Ocean input discovery,
parameter translation, result placement, and runtime selection.

## What this deployment adds

- A Code Ocean App Panel for every user-settable canonical parameter.
- Direct file upload or unambiguous recursive discovery of one Seurat `.rds`.
- Stable output under `/results` as either one matrix/metadata/manifest bundle
  or a collection catalog, root collection manifest, and nested ordinary
  bundles.
- The dedicated `r-seurat-conversion` compatibility runtime.

## Input

Provide exactly one serialized Seurat `.rds` object in either of these ways:

1. Select it explicitly with **Seurat RDS**; or
2. attach one Data Asset or upstream result containing exactly one `.rds` and
   leave **Seurat RDS** blank.

Explicit selection takes precedence. Automatic discovery searches `/data`
recursively and stops with all candidate paths when it finds more than one
RDS. It never chooses an object by timestamp or directory order.

The selected object must contain:

- cell metadata columns for donor, experimental group, and cell type;
- the exact cell-type value requested in one mode, or the selected/all labels
  requested in collection mode; and
- the assay and layer required by the selected aggregation method.

## Run the analysis

1. Provide the Seurat RDS.
2. Enter the donor, group, and cell-type metadata column names. Choose
   **Cell-Type Mode**: `one` requires one exact **Cell Type**; `selected`
   requires an ordered CSV, TSV, or TXT file with exactly one `CellType`
   column; `all` enumerates every non-missing label remaining after filtering.
3. Select the aggregation method. Keep `assay` and `layer` at `auto` unless
   the object uses a documented alternative.
4. Optionally retain invariant donor-level metadata or apply one explicit
   cell-level filter.
5. Run the capsule and keep the matrix, metadata, and manifest together.

The feature identifier is fixed to `GeneName` so that every output bundle
matches the downstream OMIX DEG and Limma handoff contracts.

### Aggregation and downstream routing

| Aggregation method | Default source | Output matrix | Required downstream route |
| --- | --- | --- | --- |
| `sum_counts` | `RNA/counts` | `Pseudobulk_Counts.csv` | OMIX DEG Analysis in `raw_counts` mode |
| `mean_harmony_corrected_expression` | `Harmony/data` | `Harmony_Mean_Expression.csv` | OMIX Limma Analysis; manifest selects `ebayes` |
| `mean_sctransform_expression` | `SCT/data` | `SCT_Mean_Log2_Expression.csv` | OMIX Limma Analysis; manifest selects `ebayes_trend` |

The capsule does not fit a DEG model. Collection mode creates one independent
ordinary pseudobulk bundle per cell type; it does not pool cells or fit a
cell-type-by-group interaction model.

## Outputs and workflow handoff

| Output | Purpose | Downstream use |
| --- | --- | --- |
| One method-specific matrix | Feature-by-donor profiles | DEG Analysis for raw sums; Limma Analysis for continuous means |
| `Pseudobulk_Sample_Metadata.csv` | Aligned Sample, Donor, Group, CellType, Cells, and requested covariates | Must remain aligned with the matrix columns |
| `Pseudobulk_Manifest.dcf` | Matrix semantics and downstream model recommendation | Prevents raw and continuous matrices from being interchanged |
| `Pseudobulk_Run_Summary.txt` | Canonical aggregation and bridge provenance | Run audit |
| `Adapter_Run_Summary.txt` | Resolved Code Ocean input and source/runtime references | Deployment audit |
| `Cell_Type_Profile_Catalog.csv` | Collection profile eligibility and nested bundle paths | Selected/all collection routing and audit |
| `Pseudobulk_Collection_Manifest.dcf` | Root collection routing/provenance record | OMIX Limma Analysis `cell_type_collection` route |
| `Pseudobulk_Collection_Run_Summary.txt` | Collection selection and aggregation summary | Run audit |

Treat these files as one coherent result bundle. In one mode, the ordinary
manifest is not optional when handing continuous Harmony or SCT means to OMIX
Limma Analysis. In selected/all mode, preserve the root collection manifest,
catalog, and complete `cell_types/<stable-id>/` tree; the updated Limma
collection route validates these before producing `L2P_Multi_Input.csv` for
L2P Multi.

## Environment and reproducibility

- **Runtime profile:** `r-seurat-conversion`
- **Published OMIX image:**
  `ghcr.io/nidap-community/omix-r-seurat-conversion@sha256:23dea282248fa4335c60f9b87538be04929acba67a10047267a0a31bd2e8391c`
- **Code Ocean selection:**
  `codeocean/omix-r-seurat-conversion:r4.4.3-v3`
- **Canonical source and pending platform evidence:**
  [OMIX_MODULE_SOURCE.md](OMIX_MODULE_SOURCE.md)

Canonical module `0.5.0` adds the reviewed selected/all collection interface.
The adapter exports its managed function byte-for-byte and preserves the
existing `r-seurat-conversion:r4.4.3-v3` runtime selection.

The public GHCR digest and the imported Code Ocean environment identity are
separate facts. The Code Ocean identity and all current-candidate platform
runs remain pending until the v3 environment is imported, resolved, and used
for the required validation. Historical v1 runs are not equivalence evidence
for this candidate. Record the input-asset version, selected parameters,
adapter commit, and complete runtime identity for a reproducible result.

## Troubleshooting and limitations

| Message or symptom | What to check |
| --- | --- |
| No Seurat RDS found | Upload one `.rds` or attach an asset containing one RDS. |
| Multiple Seurat RDS candidates | Select the intended object explicitly or attach only one candidate. |
| Metadata column or cell type not found | Enter exact, case-sensitive values from the object. |
| A donor/group profile has too few cells | Review `min_cells`; use `drop` only when excluding those profiles is scientifically intended. |
| SCT object cannot be restored | Use the pinned full-Seurat conversion runtime; lightweight SeuratObject-only runtimes do not promise legacy `SCTAssay` compatibility. |
| Continuous output sent to raw-count DEG | Follow `Pseudobulk_Manifest.dcf`; Harmony and SCT means go to Limma Analysis. |

Large Seurat objects may require a larger Code Ocean machine than the default.
The first release still requires representative Code Ocean runs for all three
aggregation methods, including a supported legacy `SCTAssay` object.

## For developers

Read [AGENTS.md](AGENTS.md) and [OMIX_MODULE_SOURCE.md](OMIX_MODULE_SOURCE.md)
before editing. Scientific and reusable-interface changes belong in canonical
OMIX. Do not edit `code/functions/Seurat_Pseudobulk.R` directly.

## References and support

- [Canonical module documentation](https://github.com/NIDAP-Community/OMIX/tree/main/modules/OMIX-Seurat-Pseudobulk)
- [OMIX issue tracker](https://github.com/NIDAP-Community/OMIX/issues)
