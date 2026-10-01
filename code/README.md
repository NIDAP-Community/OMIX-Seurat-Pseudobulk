# Deployment code

- `main.R` translates Code Ocean named parameters and places outputs in
  `/results`.
- `adapter/Seurat_Pseudobulk_Adapter.R` owns mounted-input discovery and
  deployment provenance only.
- `functions/Seurat_Pseudobulk.R` is the byte-identical canonical scientific
  export. Do not edit it in this repository.
- `run` is the Code Ocean launcher.
