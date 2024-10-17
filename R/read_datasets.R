#' Read datasets
#'
#'The function read_datasets() reads all files related to meteorology and loads them into the global environment.
#'
#' @export
read_datasets <- function(){
  metadatos <- read_csv("datos/metadatos.csv")
  estacion_NH0472 <- read_csv("datos/estacion_NH0472.csv")
  estacion_NH0910 <- read_csv("datos/estacion_NH0910.csv")
  estacion_NH0046 <- read_csv("datos/estacion_NH0046.csv")
  estacion_NH0098 <- read_csv("datos/estacion_NH0098.csv")
  estacion_NH0437 <- read_csv("datos/estacion_NH0437.csv")

  assign("metadatos", metadatos, envir = .GlobalEnv)
  assign("estacion_NH0472", estacion_NH0472, envir = .GlobalEnv)
  assign("estacion_NH0910", estacion_NH0910, envir = .GlobalEnv)
  assign("estacion_NH0046", estacion_NH0046, envir = .GlobalEnv)
  assign("estacion_NH0098", estacion_NH0098, envir = .GlobalEnv)
  assign("estacion_NH0437", estacion_NH0437, envir = .GlobalEnv)
}
