source(file.path("code", "functions", "Seurat_Pseudobulk.R"))

selection_path <- tempfile(fileext = ".csv")
utils::write.csv(
  data.frame(CellCategory = c("CD4 T cells", "CD14+ Monocytes"), check.names = FALSE),
  selection_path,
  row.names = FALSE,
  quote = TRUE
)
stopifnot(identical(
  .omix_read_cell_category_selection(selection_path),
  c("CD4 T cells", "CD14+ Monocytes")
))

duplicate_path <- tempfile(fileext = ".csv")
utils::write.csv(data.frame(CellCategory = c("Mono", "Mono")), duplicate_path, row.names = FALSE)
duplicate_error <- tryCatch(.omix_read_cell_category_selection(duplicate_path), error = identity)
stopifnot(inherits(duplicate_error, "error"))
stopifnot(grepl("duplicate", conditionMessage(duplicate_error), ignore.case = TRUE))

invalid_column_path <- tempfile(fileext = ".csv")
utils::write.csv(data.frame(Label = "Mono"), invalid_column_path, row.names = FALSE)
invalid_column_error <- tryCatch(.omix_read_cell_category_selection(invalid_column_path), error = identity)
stopifnot(inherits(invalid_column_error, "error"))
stopifnot(grepl("exactly one column named 'CellCategory'", conditionMessage(invalid_column_error), fixed = TRUE))

first_id <- .omix_cell_category_stable_id("CD4 T cells")
second_id <- .omix_cell_category_stable_id("CD4-T-cells")
stopifnot(identical(first_id, .omix_cell_category_stable_id("CD4 T cells")))
stopifnot(!identical(first_id, second_id))
stopifnot(grepl("^cc-cd4-t-cells-[0-9a-f]{32}$", first_id))

message("OMIX Seurat Pseudobulk collection helper checks passed")
