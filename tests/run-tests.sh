#!/usr/bin/env bash
set -euo pipefail

Rscript -e 'invisible(parse(file = "code/functions/Seurat_Pseudobulk.R")); invisible(parse(file = "code/adapter/Seurat_Pseudobulk_Adapter.R")); invisible(parse(file = "code/main.R"))'
Rscript tests/test-adapter-inputs.R
Rscript tests/test-output-bundle.R
python3 tests/test-app-panel.py
python3 tests/test-source-parity.py

echo "All local OMIX Seurat Pseudobulk adapter checks passed"
