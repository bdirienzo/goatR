#' Temperature Summary Table
#'
#' This function generates a summary table of temperature data from multiple stations.
#'
#' @param ... Data frames representing temperature data for various stations. Each data frame should contain a column named "id" representing station identifiers, and a column named "temperatura_abrigo_150cm" representing temperature measurements at 150 cm height.
#'
#' @return A data frame summarizing the temperature statistics for each station, including average temperature, maximum and minimum temperature, standard deviation, and total number of days.
#'
#' @details The function combines the input data frames into a single data frame, validates the required columns, and then groups the data by station ID to compute the desired summary statistics. The required columns are "id" and "temperatura_abrigo_150cm". If any of the input data frames are missing these columns, an error will be thrown.
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
