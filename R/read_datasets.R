#' Read datasets
#'
#'The function read_datasets() reads all files related to meteorology from 'data-raw' folder and loads them into the global environment.
#'
#' @export
read_datasets <- function(){
  metadata <- read_csv("data-raw/metadata.csv")
  station_NH0472 <- read_csv("data-raw/station_NH0472.csv")
  station_NH0910 <- read_csv("data-raw/station_NH0910.csv")
  station_NH0046 <- read_csv("data-raw/station_NH0046.csv")
  station_NH0098 <- read_csv("data-raw/station_NH0098.csv")
  station_NH0437 <- read_csv("data-raw/station_NH0437.csv")

  assign("metadata", metadata, envir = .GlobalEnv)
  assign("station_NH0472", station_NH0472, envir = .GlobalEnv)
  assign("station_NH0910", station_NH0910, envir = .GlobalEnv)
  assign("station_NH0046", station_NH0046, envir = .GlobalEnv)
  assign("station_NH0098", station_NH0098, envir = .GlobalEnv)
  assign("station_NH0437", station_NH0437, envir = .GlobalEnv)

  metereological_data <- rbind(station_NH0472, station_NH0910, station_NH0046, station_NH0098, station_NH0437)
  usethis::use_data(metereological_data, overwrite = TRUE)
}
