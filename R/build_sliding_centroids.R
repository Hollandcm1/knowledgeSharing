#' Sliding-Window Centroids in a Fixed LSA Space
#'
#' Compute centroids over a moving window of utterances using the reduced-space
#' document matrix (rows = utterances, columns = LSA dimensions).
#'
#' @param dk Numeric matrix (n_docs x k) of reduced-space document vectors (e.g., `lsa_result$dk` rows).
#' @param time_index Numeric or integer vector of length `nrow(dk)`, used for labeling windows by time.
#' @param window_size Integer window size (e.g., 10). Default: 10.
#' @param anchor Either "end" (use window end row's time) or "center" (use median row's time). Default: "end".
#' @param verbose Logical; messages. Default: TRUE.
#'
#' @return A list with:
#' \describe{
#'   \item{centroids}{Matrix (n_windows x k) of window centroids.}
#'   \item{summary}{Data frame with `window_id`, `start_row`, `end_row`, `anchor_time`.}
#' }
#'
#' @examples
#' \dontrun{
#' out <- build_sliding_centroids(dk, time_index = df$X, window_size = 10)
#' }
#' @export
build_sliding_centroids <- function(dk,
                                    time_index,
                                    window_size = 10,
                                    anchor = c("end", "center"),
                                    verbose = TRUE) {
  anchor <- match.arg(anchor)
  stopifnot(nrow(dk) == length(time_index))

  n <- nrow(dk)
  if (n < window_size) {
    stop("Not enough rows (", n, ") for window_size = ", window_size, ".")
  }
  n_windows <- n - window_size + 1L

  if (verbose) message("Computing ", n_windows, " sliding-window centroids (w=", window_size, ")...")

  # cumulative sums for fast window means
  csum <- apply(dk, 2, cumsum)
  centroids <- matrix(NA_real_, nrow = n_windows, ncol = ncol(dk))

  starts <- seq_len(n_windows)
  ends   <- starts + window_size - 1L
  mids   <- floor((starts + ends) / 2)

  for (i in seq_len(n_windows)) {
    s <- starts[i]; e <- ends[i]
    if (s == 1L) {
      window_sum <- csum[e, ]
    } else {
      window_sum <- csum[e, ] - csum[s - 1L, ]
    }
    centroids[i, ] <- window_sum / window_size
  }

  anchor_time <- if (anchor == "end") time_index[ends] else time_index[mids]

  summary <- tibble::tibble(
    window_id  = seq_len(n_windows),
    start_row  = starts,
    end_row    = ends,
    anchor_time = anchor_time
  )

  list(
    centroids = centroids,
    summary   = summary
  )
}