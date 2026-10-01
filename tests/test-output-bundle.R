source(file.path("code", "functions", "Seurat_Pseudobulk.R"))

sample_ids <- c("D1__A", "D1__B", "D2__A", "D2__B")
metadata <- data.frame(
  Sample = sample_ids,
  Donor = c("D1", "D1", "D2", "D2"),
  Group = c("A", "B", "A", "B"),
  Batch = c("Run1", "Run1", "Run2", "Run2"),
  CellType = rep("Monocytes", 4L),
  Cells = c(25L, 30L, 27L, 31L),
  stringsAsFactors = FALSE
)
matrix_table <- data.frame(
  GeneName = c("GeneA", "GeneB"),
  D1__A = c(10, 5),
  D1__B = c(20, 4),
  D2__A = c(12, 6),
  D2__B = c(24, 5),
  check.names = FALSE
)

specifications <- list(
  sum_counts = list(
    matrix_element = "counts",
    filename = "Pseudobulk_Counts.csv",
    matrix_type = "raw_integer_counts",
    downstream = "OMIX-DEG-Analysis",
    variance = "voom_precision_weights",
    assay = "RNA",
    layer = "counts"
  ),
  mean_harmony_corrected_expression = list(
    matrix_element = "expression",
    filename = "Harmony_Mean_Expression.csv",
    matrix_type = "harmony_corrected_mean_expression",
    downstream = "OMIX-Limma-Analysis",
    variance = "ebayes",
    assay = "Harmony",
    layer = "data"
  ),
  mean_sctransform_expression = list(
    matrix_element = "expression",
    filename = "SCT_Mean_Log2_Expression.csv",
    matrix_type = "sctransform_mean_log2_expression",
    downstream = "OMIX-Limma-Analysis",
    variance = "ebayes_trend",
    assay = "SCT",
    layer = "data"
  )
)

for (method in names(specifications)) {
  specification <- specifications[[method]]
  input <- list(
    metadata = metadata,
    feature_id_column = "GeneName",
    sample_id_column = "Sample",
    sample_columns = sample_ids,
    provenance = list(
      bridge = "OmixSeurat",
      assay = specification$assay,
      layer = specification$layer,
      aggregation = if (identical(method, "sum_counts")) {
        "sum_by_donor_and_group"
      } else {
        "mean_by_donor_and_group"
      }
    )
  )
  input[[specification$matrix_element]] <- matrix_table

  output_dir <- tempfile(paste0("omix-seurat-pseudobulk-", method, "-"))
  result <- .omix_write_seurat_pseudobulk_bundle(
    input = input,
    output_dir = output_dir,
    seurat_rds = "representative-object.rds",
    aggregation_method = method
  )
  manifest <- base::read.dcf(result$manifest_path)
  written_matrix <- utils::read.csv(result$matrix_path, check.names = FALSE)
  written_metadata <- utils::read.csv(result$metadata_path, check.names = FALSE)

  stopifnot(
    identical(basename(result$matrix_path), specification$filename),
    identical(names(written_matrix)[-1L], sample_ids),
    identical(as.character(written_metadata$Sample), sample_ids),
    identical(unname(manifest[1L, "matrix_type"]), specification$matrix_type),
    identical(unname(manifest[1L, "expected_downstream_module"]), specification$downstream),
    identical(unname(manifest[1L, "recommended_variance_model"]), specification$variance),
    all(file.exists(c(
      result$matrix_path,
      result$metadata_path,
      result$manifest_path,
      result$run_summary_path
    )))
  )
}

message("OMIX Seurat Pseudobulk three-mode output-bundle checks passed")
