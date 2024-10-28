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
#' @examples
#' # Example usage:
#' temperature_summary_table("NH0472")
#'
#' @import dplyr
#' @export

temperature_summary_table <- function(station_id, path = "datasets-raw/") {
  station_data <- read.csv(paste0(path, station_id, ".csv"))

  station_data |>
    filter(id == station_id) |>
    group_by(id) |>
    summarise(
      average_temperature = mean(temperatura_abrigo_150cm, na.rm = TRUE),
      max_temperature = max(temperatura_abrigo_150cm, na.rm = TRUE),
      min_temperature = min(temperatura_abrigo_150cm, na.rm = TRUE),
      standard_deviation = sd(temperatura_abrigo_150cm, na.rm = TRUE),
      total_days = n()
    )
}
