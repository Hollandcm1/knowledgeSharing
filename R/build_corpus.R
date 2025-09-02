#' Build Corpus from Text Data
#'
#' Construct a text corpus from a specified text column.
#'
#' @param df A data frame containing text data.
#' @param text_col Column name containing the text. Default: "text".
#'
#' @return A [tm::Corpus] suitable for term-document matrix construction.
#'
#' @examples
#' \dontrun{
#' corpus <- build_corpus(data.frame(text = c("a b c", "d e f")))
#' }
#' @importFrom tm Corpus VectorSource
#' @export
build_corpus <- function(df, text_col = "text") {
  tm::Corpus(tm::VectorSource(df[[text_col]]))
}