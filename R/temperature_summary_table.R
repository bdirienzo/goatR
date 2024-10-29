#' Temperature Summary Table
#'
#' Generates a summary table of temperature data from multiple stations.
#'
#' The function *temperature_summary_table()* takes one or more data frames as input, each containing temperature data from different weather stations, and returns a summary of the temperature statistics for each station. The required columns are: "id" for station identifiers and "temperatura_abrigo_150cm" for temperature measurements at 150 cm height.
#'
#' @param ... One or more data frames representing temperature data for various stations. Each data frame should contain:
#' - **"id"**: representing station identifiers.
#' - **"temperatura_abrigo_150cm"**: representing temperature measurements at a height of 150 cm.
#'
#' @details The function combines the input data frames into a single data frame, validates that the required columns are present, and groups the data by station ID to compute the summary statistics. If any input data frame lacks the required columns "id" or "temperatura_abrigo_150cm", the function will stop with an error message.
#'
#' **WARNING:** This function will stop if the required columns are not found in any of the data frames provided.
#'
#' @return A data frame summarizing the temperature statistics for each station, including:
#'
#' - Average temperature ('average_temperature')
#' - Maximum temperature ('max_temperature')
#' - Minimum temperature ('min_temperature')
#' - Standard deviation of temperature ('standard_deviation')
#' - Total number of days with temperature data ('total_days')
#'
#' @examples
#' # Example of using temperature_summary_table with two data frames
#' df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
#' df2 <- data.frame(id = c(1, 3, 3, 3), temperatura_abrigo_150cm = c(17, 21, 19, 16))
#' temperature_summary_table(df1, df2)
#'
#' @seealso `goatR::read_datasets` to load and view the temperature datasets.
#'
#' @import dplyr
#' @export

temperature_summary_table <- function(...) {
  station_data_list <- list(...)

  if (!all(sapply(station_data_list, is.data.frame))) {
    stop("All inputs must be data frames.")
  }

  combined_data <- do.call(rbind, station_data_list)

  required_columns <- c("id", "temperatura_abrigo_150cm")
  missing_columns <- setdiff(required_columns, names(combined_data))
  if (length(missing_columns) > 0) {
    stop(paste("The following columns are missing in the data:", paste(missing_columns, collapse = ", ")))
  }

  combined_data |>
    group_by(id) |>
    summarise(
      average_temperature = mean(temperatura_abrigo_150cm, na.rm = TRUE),
      max_temperature = max(temperatura_abrigo_150cm, na.rm = TRUE),
      min_temperature = min(temperatura_abrigo_150cm, na.rm = TRUE),
      standard_deviation = sd(temperatura_abrigo_150cm, na.rm = TRUE),
      total_days = n()
    )
}
