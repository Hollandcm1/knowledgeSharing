#' Run Knowledge Sharing Analysis
#'
#' Compute sliding-window centroids over a conversation and quantify how the
#' centroid changes across windows (cosine similarity and Euclidean delta).
#' Can operate overall or per group.
#'
#' @param df A data frame with at least participant, text, and time columns.
#' @param participant_col Column name for participant IDs. Default: "participant".
#' @param group_col Optional column name for grouping (e.g., team). Default: NULL.
#' @param text_col Column name of text. Default: "text".
#' @param time_col Column indicating temporal order (integer index or timestamp). Default: "X".
#' @param k LSA dimensions. Default: 100.
#' @param window_size Integer window length (utterances). Default: 10.
#' @param anchor "end" or "center" for window anchor times. Default: "end".
#' @param verbose Logical; messages. Default: TRUE.
#'
#' @return A named list keyed by group name (or "overall" if no group), where each element contains:
#' \describe{
#'   \item{centroids}{Matrix of window centroids (n_windows x k).}
#'   \item{summary}{Data frame with window metadata and change metrics.}
#'   \item{visualizations}{List of ggplots from [visualize_ks_plot()].}
#'   \item{df}{Group data with reduced vectors appended.}
#' }
#'
#' @examples
#' \dontrun{
#' out <- run_ks(cleaned_df, group_col = NULL, time_col = "X", window_size = 10)
#' out$overall$visualizations$cosine_plot
#' }
#'
#' @importFrom dplyr select group_split group_by group_keys arrange
#' @importFrom purrr map set_names
#' @importFrom magrittr %>%
#' @export
run_ks <- function(df,
                   participant_col = "participant",
                   group_col = NULL,
                   text_col = "text",
                   time_col = "X",
                   k = 100,
                   window_size = 10,
                   anchor = c("end", "center"),
                   verbose = TRUE) {
  anchor <- match.arg(anchor)

  # Standardize column names internally
  required <- c(participant_col, text_col, time_col)
  missing  <- setdiff(required, names(df))
  if (length(missing) > 0) stop("Missing required columns: ", paste(missing, collapse = ", "))

  names(df)[names(df) == participant_col] <- "participant"
  names(df)[names(df) == text_col]        <- "text"
  names(df)[names(df) == time_col]        <- "X"
  if (!is.null(group_col)) names(df)[names(df) == group_col] <- "group"

  keep <- c("participant", "X", "text")
  if (!is.null(group_col)) keep <- c(keep, "group")
  df <- df[, keep, drop = FALSE]

  if (is.null(group_col)) df$group <- "overall"

  # Sort by group/time
  if (!is.null(group_col)) {
    df <- df[order(df$group, df$X), ]
  } else {
    df <- df[order(df$X), ]
  }

  # Build one global LSA space and append document vectors
  space <- build_global_space(df, text_col = "text", k = k, verbose = verbose)
  df_w  <- space$df_with_vectors

  # Split by group and compute windowed centroids / changes
  grouped <- dplyr::group_split(dplyr::group_by(df_w, .data$group))
  group_names <- dplyr::group_keys(dplyr::group_by(df_w, .data$group))$group

  purrr::set_names(grouped, group_names) %>%
    purrr::map(function(gdf) {
      # Select reduced vectors (drop non-vector columns)
      vectors <- dplyr::select(gdf, -participant, -group, -X, -text)
      vectors <- as.matrix(vectors)

      out <- build_sliding_centroids(dk = vectors,
                                     time_index = gdf$X,
                                     window_size = window_size,
                                     anchor = anchor,
                                     verbose = verbose)

      change_df <- compute_centroid_change(out$centroids, out$summary)
      visuals   <- visualize_ks_plot(change_df, title_prefix = ifelse(gdf$group[1], paste0(gdf$group[1], ": "), ""))

      list(
        centroids     = out$centroids,
        summary       = change_df,
        visualizations = visuals,
        df            = gdf
      )
    })
}