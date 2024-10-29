#' Generate a Monthly Average Temperature Plot for Multiple Stations
#'
#' This function creates a line plot showing the monthly average of temperature measurements (`temperatura_abrigo_150cm`) for multiple Argentine weather stations.
#'
#' @param ... One or more data frames, each containing data for a weather station. Each data frame must include the following columns:
#'   - **fecha**: Date column (`Date` or character) representing the date of the observation.
#'   - **id**: Character or factor column serving as a unique identifier for the weather station.
#'   - **temperatura_abrigo_150cm**: Numeric column representing the temperature measurement at 150 cm height.
#'
#'   You can pass multiple data frames separated by commas, e.g., `station1`, `station2`, `station3`.
#'
#' @param colors A named vector specifying the colors to use for each station in the plot. The names should correspond to station IDs. If `NULL`, a set of dark colors will be generated automatically.
#' @param title The title of the plot. Defaults to `"Temperature"` if not specified.
#'
#' @return A `ggplot` object representing the monthly average temperature plot.
#'
#' @details
#' The function performs the following steps:
#' 1. Validates that all inputs are data frames and contain the required columns.
#' 2. Converts the `fecha` column to `Date` type if necessary.
#' 3. Extracts the month from the `fecha` column and orders it according to the calendar.
#' 4. Calculates the monthly average temperature for each station.
#' 5. Generates a line plot with points, coloring each station differently.
#'
#' **RECOMENDATION:** Use this function in conjunction with our other functions available at @seealso
#'
#' @examples monthly_temperature_plot(NH0472, NH0439)
#' @import dplyr
#' @import ggplot2
#' @seealso `goatR::download_datasets` to download datasets from Argentine weather stations, and `goatR::read_datasets` to read the downloaded datasets into R.
#' @export
monthly_temperature_plot <- function(..., colors = NULL, title = "Temperature") {
  data_list <- list(...)
  if (!all(sapply(data_list, is.data.frame))) {
    stop("All inputs must be data frames.")
  }
  data <- do.call(rbind, data_list)
  required_columns <- c("fecha", "id", "temperatura_abrigo_150cm")
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
  data <- data |>
    mutate(month = factor(format(fecha, "%B"), levels = month.name))
  data_summary <- data |>
    group_by(id, month) |>
    summarise(average_temperature = mean(temperatura_abrigo_150cm, na.rm = TRUE)) |>
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
  p <- ggplot(data_summary, aes(x = month, y = average_temperature, color = as.factor(id), group = id)) +
    geom_line(linewidth = 1.2) +
    geom_point(size = 2) +
    scale_color_manual(values = colors) +
    labs(title = title, x = "Month", y = "Average Temperature (°C)", color = "Station") +
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
