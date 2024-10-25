#' Load datasets
#'
#'The function load.datasets() reads all files related to meteorology from 'data-raw' folder and loads them into the global environment.
#'
#' @export
read_datasets <- function(){
load("data/metereological_data.rda")

}
