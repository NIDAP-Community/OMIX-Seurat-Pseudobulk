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
  layer = "counts"
)
summary_lines <- readLines(summary_path, warn = FALSE)
stopifnot(
  "Canonical module version: 0.4.2" %in% summary_lines,
  "Canonical interface version: 1" %in% summary_lines,
  "Canonical source: 79adee59eb1ed021b7a08288eaca6bd11d11fe04" %in% summary_lines,
  paste0(
    "Published runtime: ghcr.io/nidap-community/omix-r-seurat-conversion@",
    "sha256:93efb77801cabe1371cdb4fffc83246f964471e7ffeeb873efff16068caa9a8a"
  ) %in% summary_lines,
  "Code Ocean environment identity: pending platform resolution" %in% summary_lines
)

message("OMIX Seurat Pseudobulk adapter input-discovery checks passed")
