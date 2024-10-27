#' Download a dataset from an **Argentine weather station**
#'
#' The function *download_datasets()* downloads a CSV file from a remote repository, containing data from a selected Argentine weather station.
#' The user can specify the weather station by providing a valid identifier. If no custom path is specified, the function will save the file in
#' a default "datasets-raw" folder within the current working directory. If no `id_station` is specified, all 5 of them will be downloaded.
#'
#' @param id_station A string representing the identifier for the desired weather station.
#'   Valid options include: `"NH0472"`, `"NH0910"`, `"NH0046"`, `"NH0098"`, and `"NH0437"`.
#'   This identifier constructs the download URL, and only these identifiers are accepted. If no `id_station` is specified, the function will download all 5 files.
#' @param path An optional file path where the downloaded file will be saved. By default, the file will be saved
#'   to a "datasets-raw" folder within the current working directory, with a file name based on the station identifier.
#'
#' @details
#' - If the `path` parameter is not specified, this function creates a "datasets-raw" folder in the working directory (if it doesn't already exist)
#'   and saves the dataset there using the format `"datasets-raw/<id_station>.csv"`.
#' - **WARNING:** This function may overwrite existing datasets if a file with the same name exists in the specified path!
#'
#' @return
#' - A `.csv` file located in the specified or default path, containing data from the selected weather station.
#' - A string representing the path where the `.csv` file is saved
#'
#' @examples
#' # Download the dataset with ID "NH0472" to the default "datasets-raw" folder
#' download_datasets("NH0472")
#'
#' # Use the id_station directly in read_datasets to load the data
#' data <- read_datasets(id_station = "NH0472")
#'
#' # Download the dataset with ID "NH0910" to a specified custom location
#' if (!dir.exists("./custom_folder")) {
#'  dir.create("./custom_folder")}
#' download_datasets("NH0910", "./custom_folder/NH0910_data.csv")
#' data <- read_datasets(path = "./custom_folder/NH0910_data.csv")
#' download_datasets("NH0910", "./custom_folder/NH0910_data.csv")
#'
#' # Download all available datasets to the default "datasets-raw" folder
#' download_datasets()
#'
#' @seealso `goatR::read_datasets` to load and view the downloaded dataset.
#'
#' @export
download_datasets <- function(id_station = NULL, path = NULL) {
  all_stations <- c("NH0472", "NH0910", "NH0046", "NH0098", "NH0437", "metadatos_completos")

  if (is.null(id_station)) {
    lapply(all_stations, function(station) {
      download_datasets(id_station = station)
    })
    return(invisible())
  }

  if (is.null(path)) {
    dir.create("datasets-raw", showWarnings = FALSE)
    path <- file.path("datasets-raw", paste0(id_station, ".csv"))
  }

  url <- sprintf("https://raw.githubusercontent.com/rse-r/intro-programacion/main/datos/%s.csv", id_station)

  tryCatch({
    download.file(url, path)
    message("File downloaded successfully to: ", path)
    return(path)
  },
  error = function(e) {
    stop("Download failed. Please check the station ID and your internet connection. Error: ", conditionMessage(e))
  },
  warning = function(w) {
    warning("Download failed. Please check the station ID and your internet connection. Warning: ", conditionMessage(w))
  })
}
