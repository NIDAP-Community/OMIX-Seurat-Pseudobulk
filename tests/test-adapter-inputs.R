source(file.path("code", "adapter", "Seurat_Pseudobulk_Adapter.R"))

root <- tempfile("omix-seurat-pseudobulk-inputs-")
dir.create(root, recursive = TRUE)
old_roots <- getOption("omix.seurat_pseudobulk.data_roots")
options(omix.seurat_pseudobulk.data_roots = root)
on.exit({
  options(omix.seurat_pseudobulk.data_roots = old_roots)
  unlink(root, recursive = TRUE)
}, add = TRUE)

first <- file.path(root, "nested", "object.rds")
dir.create(dirname(first), recursive = TRUE)
saveRDS(list(fixture = TRUE), first)

resolved <- omix_pseudobulk_find_rds("", file.path(getwd(), "code"))
stopifnot(identical(resolved, normalizePath(first)))

explicit <- omix_pseudobulk_find_rds(first, file.path(getwd(), "code"))
stopifnot(identical(explicit, normalizePath(first)))

second <- file.path(root, "other.RDS")
saveRDS(list(fixture = TRUE), second)
ambiguous <- tryCatch(
  omix_pseudobulk_find_rds("", file.path(getwd(), "code")),
  error = conditionMessage
)
stopifnot(
  grepl("Multiple Seurat RDS candidates", ambiguous, fixed = TRUE),
  grepl(normalizePath(first), ambiguous, fixed = TRUE),
  grepl(normalizePath(second), ambiguous, fixed = TRUE)
)

unlink(c(first, second))
missing <- tryCatch(
  omix_pseudobulk_find_rds("", file.path(getwd(), "code")),
  error = conditionMessage
)
stopifnot(grepl("No Seurat RDS", missing, fixed = TRUE))

not_rds <- file.path(root, "object.txt")
writeLines("not an RDS", not_rds)
invalid_extension <- tryCatch(
  omix_pseudobulk_find_rds(not_rds, file.path(getwd(), "code")),
  error = conditionMessage
)
stopifnot(grepl(".rds extension", invalid_extension, fixed = TRUE))

stopifnot(
  identical(omix_pseudobulk_split_csv("Batch, Sex, Batch"), c("Batch", "Sex")),
  is.null(omix_pseudobulk_split_csv(""))
)

summary_path <- file.path(root, "Adapter_Run_Summary.txt")
omix_pseudobulk_write_adapter_summary(
  path = summary_path,
  seurat_rds = not_rds,
  output_dir = root,
  aggregation_method = "sum_counts",
  assay = "RNA",
  layer = "counts",
  cell_type_mode = "selected",
  cell_type_selection = "ordered-cell-types.csv"
)
summary_lines <- readLines(summary_path, warn = FALSE)
stopifnot(
  "Cell-type mode: selected" %in% summary_lines,
  "Cell type: (not supplied)" %in% summary_lines,
  "Cell-type selection: ordered-cell-types.csv" %in% summary_lines,
  "Canonical module version: 0.5.0" %in% summary_lines,
  "Canonical interface version: 1" %in% summary_lines,
  "Canonical source: c04608a215aae16d15296036e2df6975a6c34b94" %in% summary_lines,
  paste0(
    "Published runtime: ghcr.io/nidap-community/omix-r-seurat-conversion@",
    "sha256:23dea282248fa4335c60f9b87538be04929acba67a10047267a0a31bd2e8391c"
  ) %in% summary_lines,
  "Code Ocean environment identity: pending platform resolution" %in% summary_lines
)

message("OMIX Seurat Pseudobulk adapter input-discovery checks passed")
