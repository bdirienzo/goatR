#' Monthly Precipitation Plot
#'
#' Generates a bar plot illustrating the total monthly precipitation across multiple weather stations.
#'
#' This function accepts one or more data frames, each representing data from a different weather station. It aggregates the monthly precipitation data and visualizes it using a grouped bar chart. Users can customize the plot colors and title as needed.
#'
#' @param ... One or more data frames, each containing data for a weather station. Each data frame must include the following columns:
#'   - **fecha** Date of the precipitation measurement. Should be in a format coercible to \code{Date}.
#'   - **id** Identifier for the weather station.
#'   - **precipitacion_pluviometrica** Numeric value representing the precipitation in millimeters.
#'
#'  You can pass multiple data frames separated by commas, e.g., "station1", "station2", "station3"
#' @param colors Optional. A character vector specifying the colors to use for each station in the plot. If not provided, the function will generate a set of dark colors automatically. The vector should either be named with station IDs or have a length matching the number of stations.
#' @param title Optional. A string specifying the title of the plot. Defaults to \code{"Accumulated Precipitation by Month"}.
#'
#' @return A \code{ggplot} object representing the total monthly precipitation for each station.
#'
#' @seealso goatR::download_datasets for downloading datasets from Argentine weather stations, and goatR::read_datasets for reading the downloaded datasets into R.
#'
#' @examples
#' \dontrun{
#' # Assuming you have two data frames: station1 and station2
#' plot <- monthly_precipitation_plot(station1, station2, title = "Monthly Precipitation")
#' print(plot)
#' }
#'
#' @export
monthly_precipitation_plot <- function(..., colors = NULL, title = "Accumulated Precipitation by Month") {
  data_list <- list(...)

  if (!all(sapply(data_list, is.data.frame))) {
    cli::cli_abort("All inputs must be data frames.")
  }

  data <- do.call(rbind, data_list)
  required_columns <- c("fecha", "id", "precipitacion_pluviometrica")
  missing_columns <- setdiff(required_columns, names(data))

  if (length(missing_columns) > 0) {
    cli::cli_abort("The following columns are missing in the data: {missing_columns}")
  }

  if (!inherits(data$fecha, "Date")) {
    data$fecha <- as.Date(data$fecha)
    if (any(is.na(data$fecha))) {
      cli::cli_abort("Could not convert all entries in 'fecha' to Date type. Please check the date format.")
    }
  }

  data <- data |>
    dplyr::mutate(month = factor(format(fecha, "%B"), levels = month.name))

  data_summary <- data |>
    dplyr::group_by(id, month) |>
    dplyr::summarise(total_precipitation = sum(precipitacion_pluviometrica, na.rm = TRUE)) |>
    dplyr::ungroup()

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
        cli::cli_abort("Colors vector must be named with station IDs or match the number of stations.")
      }
    }
  }

  p <- ggplot2::ggplot(data_summary, ggplot2::aes(x = month, y = total_precipitation, fill = as.factor(id))) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::scale_fill_manual(values = colors) +
    ggplot2::labs(title = title, x = "Month", y = "Total Precipitation (mm)", fill = "Station") +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
      legend.position = "bottom",
      legend.title = ggplot2::element_text(face = "bold"),
      axis.title = ggplot2::element_text(face = "bold"),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
    )

  return(p)
}
