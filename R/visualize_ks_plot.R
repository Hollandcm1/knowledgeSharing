#' Visualize Knowledge Sharing (Windowed Centroid Change)
#'
#' Create line plots showing how much the centroid shifts between adjacent windows.
#'
#' @param change_df A data frame as returned by [compute_centroid_change()],
#'   containing `anchor_time`, `cosine_to_prev`, `delta_euclid`.
#' @param title_prefix Character to prepend to plot titles. Default: "".
#'
#' @return A list of ggplot objects: `cosine_plot`, `euclid_plot`, `combined_plot`, and `cosine_colored_by_euclid_plot`.
#'
#' @examples
#' \dontrun{
#' vis <- visualize_ks_plot(change_df)
#' vis$cosine_plot
#' }
#' @importFrom ggplot2 ggplot aes geom_line labs theme_minimal
#' @export
visualize_ks_plot <- function(change_df, title_prefix = "") {
  cosine_plot <- ggplot2::ggplot(
    change_df, ggplot2::aes(x = anchor_time, y = cosine_to_prev)
  ) +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = paste0(title_prefix, "Windowed Cosine Similarity to Previous Window"),
      x = "Time (anchor)", y = "Cosine Similarity"
    ) +
    ggplot2::theme_minimal()

  euclid_plot <- ggplot2::ggplot(
    change_df, ggplot2::aes(x = anchor_time, y = delta_euclid)
  ) +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = paste0(title_prefix, "Windowed Euclidean Delta to Previous Window"),
      x = "Time (anchor)", y = "Euclidean Distance"
    ) +
    ggplot2::theme_minimal()

  combined_plot <- change_df %>%
    dplyr::mutate(
      euclid_scaled = delta_euclid / max(delta_euclid, na.rm = TRUE)
    ) %>%
    tidyr::pivot_longer(cols = c(cosine_to_prev, euclid_scaled),
                        names_to = "metric", values_to = "value") %>%
    ggplot2::ggplot(ggplot2::aes(x = anchor_time, y = value, color = metric)) +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = paste0(title_prefix, "Cosine vs. Euclidean (scaled)"),
      x = "Time (anchor)",
      y = "Value (cosine or scaled distance)"
    ) +
    ggplot2::theme_minimal()

  cosine_colored_by_euclid_plot <- ggplot2::ggplot(
    change_df, ggplot2::aes(x = anchor_time, y = cosine_to_prev)
  ) +
    ggplot2::geom_line() +  # <- line uses default color
    ggplot2::geom_point(ggplot2::aes(color = delta_euclid), size = 1.5) +  # <- only points mapped to color
    ggplot2::scale_color_gradient(low = "blue", high = "red", name = "Euclidean\nDistance") +
    ggplot2::labs(
      title = paste0(title_prefix, "Cosine Similarity (points colored by Euclidean Distance)"),
      x = "Time (anchor)", y = "Cosine Similarity"
    ) +
    ggplot2::theme_minimal()

  list(
    cosine_plot = cosine_plot,
    euclid_plot = euclid_plot,
    combined_plot = combined_plot,
    cosine_colored_by_euclid_plot = cosine_colored_by_euclid_plot
  )
}