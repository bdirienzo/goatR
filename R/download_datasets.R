#' Downloading datasets
#'
#'The function download_datasets() creates the 'data-raw' folder if it does not already exist and downloads all files related to meteorology.
#'
#'WARNING: IT WILL OVERWRITE EXISTING DATASETS!
#'
#' @export
download_datasets <- function(){
  library(readr)
  dir.create("data-raw", showWarnings = FALSE)
  urls <- c(
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/metadatos_completos.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0472.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0910.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0046.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0098.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0437.csv"
  )
  nombres_archivos <- c(
    "metadata.csv",
    "station_NH0472.csv",
    "station_NH0910.csv",
    "station_NH0046.csv",
    "station_NH0098.csv",
    "station_NH0437.csv"
  )

  for (i in seq_along(urls)) {
    download.file(url = urls[i], destfile = file.path("data-raw", nombres_archivos[i]))
  }


}
