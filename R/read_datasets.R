#' Read a downloaded dataset from an **Argentine weather station**
#'
#' The `read_datasets()` function reads a CSV file containing meteorological data for a specific weather station.
#' The function loads the data into the global environment, allowing analysis and further manipulation.
#'
#' @param id_station A string representing the identifier for the desired weather station, if `path` is not provided.
#'   Valid identifiers include: `"NH0472"`, `"NH0910"`, `"NH0046"`, `"NH0098"`, and `"NH0437"`. This parameter is used to construct the path to the CSV file.
#' @param path An optional string specifying the file path of the CSV file to be read. If provided, `id_station` is ignored.
#'
#' @details This function is designed to work in conjunction with `download_datasets()`, which downloads and saves the weather station data.
#'
#'   There are three ways to use this function:
#'   1. **Using `download_datasets()` with the default path**: If the file is saved in the default `"datasets-raw"` folder,
#'      you only need to provide the `id_station` parameter to read the file.
#'   2. **Using a custom path**: If you saved the file in a custom folder, provide the complete file path using the `path` parameter.
#'   3. **Using the return value of `download_datasets()`**: You can store the path returned by `download_datasets()` in a variable
#'      and pass it to `read_datasets()` via the `path` parameter.
#'
#' @return A data frame containing the weather station data if the file is successfully read.
#'
#' @examples
#' # Use download_datasets() with default path, then read using id_station
#' download_datasets("NH0472")
#' data <- read_datasets(id_station = "NH0472")
#'
#' # Use a custom path
#' download_datasets("NH0910", "./custom_folder/NH0910_data.csv")
#' data <- read_datasets(path = "./custom_folder/NH0910_data.csv")
#'
#' # Store the path from download_datasets() and use it directly in read_datasets()
#' file_path <- download_datasets("NH0046")
#' data <- read_datasets(path = file_path)
#'
#' @seealso `goatR::download_datasets` to download and save weather station datasets.
#'
#' @export
read_datasets <- function(id_station = NULL, path = NULL) {

  if (is.null(path)) {
    if (is.null(id_station)) {
      cli::cli_abort("Either 'id_station' or 'path' must be provided.")
    }
  }

  if (is.null(path)) {
    path <- file.path("datasets-raw", paste0(id_station, ".csv"))
  }

  if (file.exists(path)) {
    data <- read.csv(path)

    if (!is.null(id_station)) {
      assign(id_station, data, envir = parent.frame())
    }

    cli::cli_alert_success("Data loaded successfully from {cli::col_green(path)}.")
    return(data)
  } else {
    cli::cli_abort("The file or path doesn't exist: {cli::col_red(path)}. Please check again.")
  }
}
