#' Build a Global LSA Space
#'
#' Builds a single LSA space across all rows (documents/utterances) and returns
#' both the LSA result and the original data with reduced vectors appended.
#'
#' @param df Data frame with at least a `text` column.
#' @param text_col Column with text. Default: "text".
#' @param k Number of LSA dimensions. Default: 100.
#' @param verbose Print progress messages? Default: TRUE.
#'
#' @return A list with:
#' \describe{
#'   \item{lsa_result}{Result from [lsa::lsa()].}
#'   \item{dtm}{Term-document matrix (base matrix).}
#'   \item{df_with_vectors}{`df` with columns of `lsa_result$dk` cbind-ed.}
#' }
#'
#' @examples
#' \dontrun{
#' space <- build_global_space(my_df, text_col = "text", k = 100)
#' }
#' @importFrom tm TermDocumentMatrix
#' @importFrom lsa lsa
#' @export
build_global_space <- function(df, text_col = "text", k = 100, verbose = TRUE) {
  corpus <- build_corpus(df, text_col = text_col)
  dtm <- as.matrix(tm::TermDocumentMatrix(corpus))
  if (verbose) message("Computing LSA (dims = ", k, ")...")
  lsa_result <- lsa::lsa(dtm, dims = k)

  df_with_vectors <- cbind(df, lsa_result$dk)
  list(
    lsa_result = lsa_result,
    dtm = dtm,
    df_with_vectors = df_with_vectors
  )
}
