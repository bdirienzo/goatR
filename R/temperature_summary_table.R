#' Generate Temperature Summary Table for a Weather Station
#'
#' This function calculates summary statistics for temperature data from a specific weather station.
#' It reads a CSV file containing weather data, filters it by station ID, and returns the average, maximum,
#' minimum temperature, standard deviation, and total number of observations.
#'
#' @param station_id Character. The unique identifier of the weather station (e.g., "NH0472").
#' @param path Character. Path to the folder containing the CSV datasets. Defaults to "datasets-raw/".
#'
#' @return A data frame with summary statistics for the specified weather station, including:
#' \describe{
#'   \item{average_temperature}{Numeric. The average temperature recorded at 150 cm height.}
#'   \item{max_temperature}{Numeric. The maximum temperature recorded at 150 cm height.}
#'   \item{min_temperature}{Numeric. The minimum temperature recorded at 150 cm height.}
#'   \item{standard_deviation}{Numeric. The standard deviation of the temperature recorded at 150 cm height.}
#'   \item{total_days}{Integer. The total number of observations used for calculating the summary statistics.}
#' }
#'
#' @examples Simple example using two sample data frames
# Create sample data for two stations
station1 <- data.frame(
  fecha = seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-12-01"), by = "month"),
  id = "Station1",
  temperatura_abrigo_150cm = c(25, 26, 24, 22, 20, 18, 17, 19, 21, 23, 24, 25)
)

station2 <- data.frame(
  fecha = seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-12-01"), by = "month"),
  id = "Station2",
  temperatura_abrigo_150cm = c(15, 16, 18, 19, 20, 22, 23, 21, 19, 17, 16, 15)
)

# Generate the plot
p <- monthly_temperature_plot(
  station1,
  station2,
  title = "Monthly Average Temperature Comparison"
)
print(p)

#' @import dplyr
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
