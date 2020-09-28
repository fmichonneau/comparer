##' @importFrom fs dir_ls
cpr_list_files <- function(path, recurse = TRUE, type = "file", ...) {
  fs::dir_ls(path, recurse = recurse, type = type, ...)
}

##' @importFrom tools md5sum
cpr_md5sum <- function(files) {
  tools::md5sum(files)
}

##' Compares whether the content of the files in two directory are identical.
##' This can be useful when you cannot rely on the timestamps or the size of the
##' files to know if their contents have changed.
##'
##' By default, to compare the content of the files, the following arguments are
##' passed to `fs::dir_ls`:
##' - `recurse = TRUE`
##' - `type = "file"`.
##'
##' Files that are only found in one folder will have `NA` in the `identical`
##' column.
##'
##' @title Compare the files in two folders
##' @param path_1 path of the first folder to compare
##' @param path_2 path of the second folder to compare
##' @param ... additional arguments to be passed to `fs::dir_ls` (see details)
##' @return a tibble with 4 columns:
##'   - the names of the files that are found in both folders
##'   - their respective MD5 hashes
##'   - whether the hashes (and therefore the files) are identical
##' @export
##' @importFrom fs path_tidy path_common
##' @importFrom tidyr pivot_wider
##' @importFrom dplyr mutate
##' @importFrom rlang .data
compare_folders <- function(path_1, path_2, ...) {

  path_1 <- normalizePath(fs::path_tidy(path_1))
  path_2 <- normalizePath(fs::path_tidy(path_2))

  cnt <- purrr::map(
    list(path_1, path_2),
    cpr_list_files,
    ...
  )

  res <- purrr::map_df(
    cnt,
    function(x) {
      tibble::tibble(
        path = fs::path_common(fs::path_dir(x)),
        files = gsub(.data$path, "", x),
        md5 = cpr_md5sum(x)
      )
    }
  ) %>%
    tidyr::pivot_wider(
      names_from = .data$path,
      values_from = .data$md5
    )


  res %>%
    dplyr::mutate(
      identical = .data[[names(.)[2]]] == .data[[names(res)[3]]]
    )

}
