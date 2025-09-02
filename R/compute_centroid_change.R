#' Quantify Change Between Adjacent Window Centroids
#'
#' Given a matrix of window centroids, compute cosine similarity to the previous
#' window and Euclidean delta between centroids.
#'
#' @param centroids Matrix (n_windows x k) of window centroids.
#' @param summary_df A data frame produced by [build_sliding_centroids()] containing
#'   at least `window_id` and `anchor_time`.
#'
#' @return The input `summary_df` with two extra columns:
#' \describe{
#'   \item{cosine_to_prev}{Cosine similarity to the previous window centroid (NA for the first).}
#'   \item{delta_euclid}{Euclidean distance to the previous window centroid (NA for the first).}
#' }
#'
#' @examples
#' \dontrun{
#' changed <- compute_centroid_change(out$centroids, out$summary)
#' }
#' @importFrom lsa cosine
#' @export
compute_centroid_change <- function(centroids, summary_df) {
  stopifnot(nrow(centroids) == nrow(summary_df))

  n <- nrow(centroids)
  cosine_to_prev <- rep(NA_real_, n)
  delta_euclid   <- rep(NA_real_, n)

  if (n >= 2) {
    for (i in 2:n) {
      c_now  <- centroids[i, ]
      c_prev <- centroids[i - 1L, ]
      cosine_to_prev[i] <- lsa::cosine(c_now, c_prev)
      delta_euclid[i]   <- sqrt(sum((c_now - c_prev)^2))
    }
  }

  dplyr::mutate(summary_df,
                cosine_to_prev = cosine_to_prev,
                delta_euclid   = delta_euclid)
}