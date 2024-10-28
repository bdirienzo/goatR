#' Sample Weather Observation Data
#'
#' This dataset, named station_sample, provides daily weather observations from a specific weather monitoring station (NH0472). It includes various meteorological variables such as temperature, wind speed, and radiation. It serves as a resource for climate studies and analysis of day-to-day weather patterns.
#'
#' @name station_sample
#' @docType data
#'
#' @format A data frame with the following columns:
#'
#' \describe{
#'   \item{id}{Character. Identifier for the weather station (e.g., `NH0472`).}
#'   \item{fecha}{Date. Observation date in YYYY-MM-DD format (e.g., `1961-07-01`).}
#'   \item{temperatura_abrigo_150cm}{Numeric. Temperature at 150 cm under shelter, in degrees Celsius (e.g., `11.1`).}
#'   \item{temperatura_abrigo_150cm_maxima}{Numeric. Maximum daily temperature at 150 cm under shelter, in degrees Celsius (e.g., `13.4`).}
#'   \item{temperatura_abrigo_150cm_minima}{Numeric. Minimum daily temperature at 150 cm under shelter, in degrees Celsius (e.g., `8.8`).}
#'   \item{temperatura_intemperie_5cm_minima}{Numeric. Minimum daily temperature at 5 cm in open air, in degrees Celsius (e.g., `6.2`).}
#'   \item{temperatura_intemperie_50cm_minima}{Numeric. Minimum daily temperature at 50 cm in open air, in degrees Celsius (e.g., `4.5`).}
#'   \item{temperatura_suelo_5cm_media}{Numeric. Average daily soil temperature at 5 cm depth, in degrees Celsius (e.g., `10.0`).}
#'   \item{temperatura_suelo_10cm_media}{Numeric. Average daily soil temperature at 10 cm depth, in degrees Celsius (e.g., `9.8`).}
#'   \item{temperatura_inte_5cm}{Numeric. Temperature at 5 cm under cover, in degrees Celsius (e.g., `7.3`).}
#'   \item{temperatura_inte_50cm}{Numeric. Temperature at 50 cm under cover, in degrees Celsius (e.g., `6.1`).}
#'   \item{humedad_media}{Numeric. Average daily humidity percentage (e.g., `75.3`).}
#'   \item{humedad_maxima}{Numeric. Maximum daily humidity percentage (e.g., `95.0`).}
#'   \item{humedad_minima}{Numeric. Minimum daily humidity percentage (e.g., `60.5`).}
#'   \item{presion_media}{Numeric. Average daily atmospheric pressure, in hPa (e.g., `1015.6`).}
#'   \item{direccion_viento_1000cm}{Numeric. Wind direction at 10 m height, in degrees from north (e.g., `270`).}
#'   \item{velocidad_viento_maxima}{Numeric. Maximum daily wind speed, in m/s (e.g., `8.5`).}
#'   \item{radiacion_global}{Numeric. Global radiation in kJ/m² (e.g., `520.3`).}
#'   \item{radiacion_neta}{Numeric. Net radiation in kJ/m² (e.g., `300.4`).}
#'   \item{evaporacion_tanque}{Numeric. Daily tank evaporation in mm (e.g., `2.5`).}
#'   \item{evapotranspiracion_potencial}{Numeric. Potential evapotranspiration in mm (e.g., `4.0`).}
#'   \item{profundidad_napa}{Numeric. Depth of the water table in meters (e.g., `1.8`).}
#'   \item{horas_frio}{Numeric. Total daily cold hours (e.g., `15.6`).}
#'   \item{unidad_frio}{Numeric. Unit for cold hours, if applicable (e.g., `-`).}
#' }
#'
#' @details
#' Each row represents daily observations from the NH0472 weather station. This dataset can be used to analyze seasonal and daily trends in weather parameters, including temperature variations, humidity levels, and wind conditions.
#'
#' @usage data(station_sample)
#'
#' @examples
#' data(NH0472_sample)
#' head(NH0472_sample)
#'
#' # Example: Plotting temperature trends over time
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'   ggplot(station_sample, aes(x = fecha, y = temperatura_abrigo_150cm)) +
#'     geom_line() +
#'     labs(title = "Temperature at 150 cm Over Time",
#'          x = "Date", y = "Temperature (°C)")
#' }
"station_sample"
