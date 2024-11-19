#' Convert package documentation to markdown
#'
#' @param pkg A single string giving the package name.
#' @param topics The topics from the package documentation to include, as listed
#' in `help(package = pkg)`. If `NULL`, all package topics will be included in
#' output.
#'
#' @returns
#' A single string giving markdown descriptions for each help topic in the
#' package. The function will error if the package isn't installed.
#'
#' @examples
#' pkg_prompt("splines")
#'
#' @export
# todo: should this be able to include vignettes?
pkg_prompt <- function(pkg, topics = NULL) {
  check_pkg(pkg)

  topics_files <- unique(help.search("*", package = pkg)$matches$Topic)
  if (!is.null(topics)) {
    check_character(topics)
    topics_files <- filter_topics(topics_files, topics)
  }

  res <- list()
  for (topic in topics_files) {
    res[topic] <- rd2markdown::rd2markdown(topic = topic, package = pkg)
  }

  paste_topics(res, pkg)
}

check_pkg <- function(pkg, call = caller_env()) {
  check_string(pkg)
  if (!is_installed(pkg)) {
    cli::cli_abort(
      "Package {.pkg {pkg}} must be installed to convert its
       documentation to plain text.",
      call = call
    )
  }

  invisible(pkg)
}

filter_topics <- function(topics, include, call = caller_env()) {
  matches <- include %in% topics

  if (all(!matches)) {
    cli::cli_abort(
      "{.arg topics} did not match any entries in {.arg pkg}'s documentation.",
      call = call
    )
  }

  if (any(!matches)) {
    cli::cli_warn(
      "Element{?s} {.field {include[!matches]}} in {.arg include} did not match any
       documentation topics and will be excluded from results.",
      call = call
    )
  }

  topics[topics %in% include]
}

paste_topics <- function(x, pkg) {
  res <- c("# Documentation for the ", pkg, " package\n")

  for (elt in x) {
    res <- c(res, "\n", decrease_header_level(elt), "\n")
  }

  paste0(res, collapse = "")
}

decrease_header_level <- function(x) {
  gsub("# ", "## ", x, fixed = TRUE)
}
