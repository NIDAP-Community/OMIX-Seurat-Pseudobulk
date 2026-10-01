#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(optparse))

omix_adapter_code_dir <- function() {
  candidates <- commandArgs(FALSE)[grepl("^--file=", commandArgs(FALSE))]
  if (length(candidates) == 0L) return(getwd())
  dirname(normalizePath(sub("^--file=", "", candidates[[1L]]), mustWork = TRUE))
}

option_list <- list(
  make_option("--seurat_rds", type = "character", default = "", help = "Optional explicit Seurat .rds; otherwise discover exactly one below /data"),
  make_option("--donor_column", type = "character", help = "Cell-metadata donor column"),
  make_option("--group_column", type = "character", help = "Cell-metadata experimental-group column"),
  make_option("--cell_type_column", type = "character", help = "Cell-metadata cell-type column"),
  make_option("--cell_type", type = "character", help = "One exact cell-type value"),
  make_option("--metadata_columns", type = "character", default = "", help = "Optional comma-separated invariant donor-level metadata columns"),
  make_option("--cell_filter_column", type = "character", default = "", help = "Optional cell-metadata filter column"),
  make_option("--cell_filter_values", type = "character", default = "", help = "Optional comma-separated values retained from the filter column"),
  make_option("--aggregation_method", type = "character", default = "sum_counts", help = "sum_counts, mean_harmony_corrected_expression, or mean_sctransform_expression [default: %default]"),
  make_option("--assay", type = "character", default = "auto", help = "Source assay or auto [default: %default]"),
  make_option("--layer", type = "character", default = "auto", help = "Source layer or auto [default: %default]"),
  make_option("--feature_id_column", type = "character", default = "GeneName", help = "Output feature-ID column [default: %default]"),
  make_option("--min_cells", type = "integer", default = 20L, help = "Minimum selected cells per donor/group profile [default: %default]"),
  make_option("--on_insufficient_cells", type = "character", default = "error", help = "error or drop [default: %default]"),
  make_option("--output_dir", type = "character", default = "", help = "Platform-managed output directory; defaults to /results")
)

opt <- parse_args(OptionParser(
  usage = paste(
    "Usage: %prog --donor_column DONOR --group_column GROUP",
    "--cell_type_column CELL_TYPE_COLUMN --cell_type CELL_TYPE [options]"
  ),
  option_list = option_list,
  description = "Code Ocean adapter for canonical OMIX Seurat Pseudobulk."
))

for (name in c("donor_column", "group_column", "cell_type_column", "cell_type")) {
  value <- opt[[name]]
  if (is.null(value) || length(value) != 1L || is.na(value) || !nzchar(trimws(value))) {
    stop("--", name, " is required.", call. = FALSE)
  }
}

code_dir <- omix_adapter_code_dir()
source(file.path(code_dir, "adapter", "Seurat_Pseudobulk_Adapter.R"))
source(file.path(code_dir, "functions", "Seurat_Pseudobulk.R"))

seurat_rds <- omix_pseudobulk_find_rds(opt$seurat_rds, code_dir)
output_dir <- omix_pseudobulk_output_dir(opt$output_dir, code_dir)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

cell_filter_column <- if (nzchar(trimws(opt$cell_filter_column))) {
  trimws(opt$cell_filter_column)
} else {
  NULL
}
cell_filter_values <- omix_pseudobulk_split_csv(opt$cell_filter_values)
if (xor(is.null(cell_filter_column), is.null(cell_filter_values))) {
  stop(
    "Supply both --cell_filter_column and --cell_filter_values, or leave both blank.",
    call. = FALSE
  )
}

result <- omix_seurat_pseudobulk(
  seurat_rds = seurat_rds,
  donor_column = opt$donor_column,
  group_column = opt$group_column,
  cell_type_column = opt$cell_type_column,
  cell_type = opt$cell_type,
  metadata_columns = omix_pseudobulk_split_csv(opt$metadata_columns),
  cell_filter_column = cell_filter_column,
  cell_filter_values = cell_filter_values,
  aggregation_method = opt$aggregation_method,
  assay = opt$assay,
  layer = opt$layer,
  feature_id_column = opt$feature_id_column,
  min_cells = opt$min_cells,
  on_insufficient_cells = opt$on_insufficient_cells,
  output_dir = output_dir
)

adapter_summary <- omix_pseudobulk_write_adapter_summary(
  path = file.path(output_dir, "Adapter_Run_Summary.txt"),
  seurat_rds = seurat_rds,
  output_dir = output_dir,
  aggregation_method = opt$aggregation_method,
  assay = opt$assay,
  layer = opt$layer
)

message(
  "Saved the donor-level result bundle to ", normalizePath(output_dir, mustWork = FALSE),
  ": ", basename(result$matrix_path), ", ", basename(result$metadata_path),
  ", ", basename(result$manifest_path), ", ", basename(result$run_summary_path),
  ", and ", basename(adapter_summary)
)
