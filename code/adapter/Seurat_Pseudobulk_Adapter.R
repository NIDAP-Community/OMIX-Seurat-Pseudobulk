# Code Ocean-only input and output translation for OMIX Seurat Pseudobulk.
# Scientific aggregation remains in code/functions/Seurat_Pseudobulk.R.

omix_pseudobulk_split_csv <- function(value) {
  if (is.null(value) || length(value) == 0L || is.na(value) || !nzchar(trimws(value))) {
    return(NULL)
  }
  values <- trimws(strsplit(value, ",", fixed = TRUE)[[1L]])
  values <- values[nzchar(values)]
  if (length(values) == 0L) NULL else unique(values)
}

omix_pseudobulk_data_roots <- function(code_dir) {
  configured <- getOption("omix.seurat_pseudobulk.data_roots")
  if (!is.null(configured)) {
    roots <- as.character(configured)
  } else {
    roots <- c("/data", file.path(dirname(code_dir), "data"))
  }
  unique(roots[dir.exists(roots)])
}

omix_pseudobulk_validate_rds <- function(path, label = "Seurat RDS") {
  if (!is.character(path) || length(path) != 1L || is.na(path) || !nzchar(trimws(path))) {
    stop(label, " must be one non-empty path.", call. = FALSE)
  }
  if (!file.exists(path)) {
    stop(label, " was not found: ", path, call. = FALSE)
  }
  if (dir.exists(path)) {
    stop(label, " must be a file, not a directory: ", path, call. = FALSE)
  }
  if (!identical(tolower(tools::file_ext(path)), "rds")) {
    stop(label, " must have the .rds extension: ", path, call. = FALSE)
  }
  normalizePath(path, mustWork = TRUE)
}

omix_pseudobulk_find_rds <- function(upload = "", code_dir = getwd()) {
  if (!is.null(upload) && length(upload) == 1L && !is.na(upload) && nzchar(trimws(upload))) {
    return(omix_pseudobulk_validate_rds(upload, "Selected Seurat RDS"))
  }

  roots <- omix_pseudobulk_data_roots(code_dir)
  candidates <- unlist(lapply(roots, function(root) {
    list.files(
      root,
      pattern = "\\.rds$",
      recursive = TRUE,
      full.names = TRUE,
      ignore.case = TRUE,
      include.dirs = FALSE
    )
  }), use.names = FALSE)
  candidates <- sort(unique(normalizePath(candidates, mustWork = TRUE)))

  if (length(candidates) == 0L) {
    roots_label <- if (length(roots) == 0L) "/data" else paste(roots, collapse = ", ")
    stop(
      "No Seurat RDS was found under ", roots_label,
      ". Upload it explicitly or attach one data asset containing exactly one .rds file.",
      call. = FALSE
    )
  }
  if (length(candidates) > 1L) {
    stop(
      "Multiple Seurat RDS candidates were found. Select one explicitly:\n- ",
      paste(candidates, collapse = "\n- "),
      call. = FALSE
    )
  }
  candidates[[1L]]
}

omix_pseudobulk_output_dir <- function(requested = "", code_dir = getwd()) {
  if (!is.null(requested) && length(requested) == 1L && !is.na(requested) &&
      nzchar(trimws(requested))) {
    return(requested)
  }
  if (dir.exists("/results")) "/results" else file.path(dirname(code_dir), "results")
}

omix_pseudobulk_write_adapter_summary <- function(
  path,
  seurat_rds,
  output_dir,
  aggregation_method,
  assay,
  layer
) {
  lines <- c(
    "OMIX Seurat Pseudobulk Code Ocean adapter summary",
    paste("Resolved Seurat RDS:", normalizePath(seurat_rds, mustWork = FALSE)),
    paste("Output directory:", normalizePath(output_dir, mustWork = FALSE)),
    paste("Aggregation method:", aggregation_method),
    paste("Requested assay:", assay),
    paste("Requested layer:", layer),
    "Canonical module version: 0.4.1",
    "Canonical interface version: 1",
    "Canonical source: e3cc933ad812ca4af8fc6427e1f23e2a2ccd5e96",
    paste0(
      "Published runtime: ghcr.io/nidap-community/omix-r-seurat-conversion@",
      "sha256:4399e2e2da1947b555a96b52e0b33632312b0608d7cef8c74ad2b1947335862c"
    ),
    "Code Ocean environment identity: pending platform resolution"
  )
  writeLines(lines, path)
  invisible(path)
}
