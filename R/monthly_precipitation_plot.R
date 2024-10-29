#' Monthly Precipitation Plot
#'
#' This function generates a plot showing the total monthly precipitation for multiple stations.
#'
#' @param ... One or more data frames, each containing data for a station. Each data frame must contain the columns 'fecha', 'id', and 'precipitacion_pluviometrica'.
#' @param colors A vector specifying the colors to use for the plot. If not provided, dark colors will be generated.
#' @param title The title of the plot. Defaults to "Accumulated Precipitation by Month" if not specified.
#' @return A ggplot object representing the plot.
#' @examples monthly_precipitation_plot(NH0472)
#' @import dplyr
#' @import ggplot2
#' @seealso `goatR::download_datasets` to download datasets from Argentine weather stations, and `goatR::read_datasets` to read the downloaded datasets into R.
#' @export
monthly_precipitation_plot <- function(..., colors = NULL, title = "Accumulated Precipitation by Month") {
  data_list <- list(...)
  if (!all(sapply(data_list, is.data.frame))) {
    stop("All inputs must be data frames.")
  }

  data <- do.call(rbind, data_list)

  required_columns <- c("fecha", "id", "precipitacion_pluviometrica")
  missing_columns <- setdiff(required_columns, names(data))
  if (length(missing_columns) > 0) {
    stop(paste("The following columns are missing in the data:", paste(missing_columns, collapse = ", ")))
  }

  if (!inherits(data$fecha, "Date")) {
    data$fecha <- as.Date(data$fecha)
    if (any(is.na(data$fecha))) {
      stop("Could not convert all entries in 'fecha' to Date type. Please check the date format.")
    }
  }

  data <- data %>%
    mutate(month = factor(format(fecha, "%B"), levels = month.name))

  data_summary <- data %>%
    group_by(id, month) %>%
    summarise(total_precipitation = sum(precipitacion_pluviometrica, na.rm = TRUE)) %>%
    ungroup()

  station_ids <- unique(data_summary$id)

  if (is.null(colors)) {
    dark_colors <- colors()[grep("dark", colors())]
    if (length(dark_colors) < length(station_ids)) {
      dark_colors <- rep(dark_colors, length.out = length(station_ids))
    }
    colors <- sample(dark_colors, length(station_ids))
    names(colors) <- station_ids
  } else {
    if (is.null(names(colors))) {
      if (length(colors) == length(station_ids)) {
        names(colors) <- station_ids
      } else {
        stop("Colors vector must be named with station IDs or match the number of stations.")
      }
    }
  }

  p <- ggplot(data_summary, aes(x = month, y = total_precipitation, fill = as.factor(id))) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = colors) +
    labs(title = title, x = "Month", y = "Total Precipitation (mm)", fill = "Station") +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      axis.title = element_text(face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )

  return(p)
}
