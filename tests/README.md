# Adapter validation

Run local contract checks from the repository root:

```bash
bash tests/run-tests.sh
```

These checks cover R syntax, unambiguous RDS discovery, comma-separated
parameter translation, all three canonical output-bundle routes, App Panel
bindings, selected/all cell-type collection controls, v3 runtime selection,
adapter-summary provenance constants, and managed-source hashes.

They do **not** restore a representative Seurat object or validate Code Ocean.
Before release, the exact merged commit must run all three aggregation modes
in Code Ocean, including supported legacy `SCTAssay` restoration, and the raw
and continuous bundles must be consumed by their documented downstream tools.
