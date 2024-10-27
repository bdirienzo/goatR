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
