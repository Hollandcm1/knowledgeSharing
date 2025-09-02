#' Save Knowledge Sharing Figures
#'
#' @param ks_result Output of [run_ks()].
#' @param dir Directory to save into. Default: "ks_figures".
#' @param width,height Plot dimensions in inches.
#' @export
ks_save_figures <- function(ks_result, dir = "ks_figures", width = 8, height = 4.5) {
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  for (g in names(ks_result)) {
    vis <- ks_result[[g]]$visualizations
    ggplot2::ggsave(file.path(dir, paste0(g, "_cosine.png")), vis$cosine_plot, width = width, height = height, dpi = 300)
    ggplot2::ggsave(file.path(dir, paste0(g, "_euclid.png")), vis$euclid_plot, width = width, height = height, dpi = 300)
  }
}