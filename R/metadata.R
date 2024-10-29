#' Metadata of Weather Monitoring Stations
#'
#' This dataset contains metadata about various weather monitoring stations, including their locations, types, and operational details. It is a useful resource for researchers interested in geospatial and temporal analysis of weather data collection across different provinces.
#'
#' @name metadata
#' @docType data
#'
#' @format A data frame with the following columns:
#'
#' \describe{
#'   \item{id}{Character. Unique identifier for each monitoring station (e.g., `A872999`).}
#'   \item{nombre}{Character. Name of the station, often indicating its function or affiliation (e.g., `Instituto de Clima y Agua`).}
#'   \item{tipo}{Character. The type of weather monitoring equipment (e.g., `Nimbus THP`).}
#'   \item{localidad}{Character. The locality or town where the station is located (e.g., `Hurlingham`).}
#'   \item{provincia}{Character. Province in which the station is located (e.g., `Buenos Aires`, `La Pampa`).}
#'   \item{lat}{Numeric. Latitude of the station in decimal degrees (e.g., `-36.54`).}
#'   \item{lon}{Numeric. Longitude of the station in decimal degrees (e.g., `-63.99`).}
#'   \item{altura}{Numeric. Altitude of the station above sea level, in meters (e.g., `165.0`).}
#'   \item{ubicacion}{Character. Additional descriptive information on the location, often including addresses or notable landmarks (e.g., `Jardin Botanico Ragonese INTA`).}
#'   \item{desde}{POSIXct. Date when the station started operations, formatted in ISO 8601 (e.g., `2000-01-04T00:00:00Z[UTC]`).}
#'   \item{hasta}{POSIXct. Date when the station ended operations (if applicable), formatted in ISO 8601 (e.g., `2024-05-23T00:00:00Z[UTC]`).}
#' }
#'
#' @details
#' Each row in the dataset represents a unique weather monitoring station. The data includes spatial and temporal coverage, which can be used for mapping and analyzing the operational status of weather stations across different regions.
#'
#' @usage data(metadata)
#'
#' @examples
#' data(metadata)
#' head(metadata)
#'
#' # Example: Plotting the stations on a map using latitude and longitude
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'   ggplot(metadata, aes(x = lon, y = lat)) +
#'     geom_point() +
#'     labs(title = "Locations of Weather Monitoring Stations",
#'          x = "Longitude", y = "Latitude")
#' }
"metadata"
