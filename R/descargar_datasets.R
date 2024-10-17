#' Descarga de datasets
#'
#'La función descargar_datasets() crea la carpeta datos en caso que no exista y descarga todos los archivos relacionados con la meteorología
#'
#'!!CUIDADO, REESCRIBE LOS DATASETS EN CASO QUE YA EXISTAN!!
#'
#' @export
descargar_datasets <- function(){
  library(readr)
  dir.create("datos", showWarnings = FALSE)
  urls <- c(
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/metadatos_completos.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0472.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0910.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0046.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0098.csv",
    "https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/NH0437.csv"
  )
  nombres_archivos <- c(
    "metadatos.csv",
    "estacion_NH0472.csv",
    "estacion_NH0910.csv",
    "estacion_NH0046.csv",
    "estacion_NH0098.csv",
    "estacion_NH0437.csv"
  )

  for (i in seq_along(urls)) {
    download.file(url = urls[i], destfile = file.path("datos", nombres_archivos[i]))
  }
}
