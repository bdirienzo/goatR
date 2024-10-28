library(testthat)
library(withr)
library(mockery)

test_that("download_datasets works when id_station is NULL", {
  with_tempdir({
    # Descargar todos los datasets
    download_datasets()
    # Verificar que todos los archivos existen
    expect_true(file.exists("datasets-raw/NH0472.csv"))
    expect_true(file.exists("datasets-raw/NH0910.csv"))
    expect_true(file.exists("datasets-raw/NH0046.csv"))
    expect_true(file.exists("datasets-raw/NH0098.csv"))
    expect_true(file.exists("datasets-raw/NH0437.csv"))
    expect_true(file.exists("datasets-raw/metadatos_completos.csv"))
  })
})

test_that("download_datasets works with a valid id_station", {
  with_tempdir({
    download_datasets("NH0472")
    expect_true(file.exists("datasets-raw/NH0472.csv"))
  })
})

test_that("download_datasets handles invalid id_station", {
  with_tempdir({
    expect_error(
      download_datasets("INVALID_ID"),
      "Invalid station ID. Valid options are: NH0472, NH0910, NH0046, NH0098, NH0437, metadatos_completos"
    )
  })
})

test_that("download_datasets saves file to specified path", {
  with_tempdir({
    dir.create("custom_folder")
    custom_path <- file.path("custom_folder", "NH0472.csv")
    download_datasets("NH0472", path = custom_path)
    expect_true(file.exists(custom_path))
  })
})

test_that("download_datasets handles non-existent directory", {
  with_tempdir({
    custom_path <- file.path("nonexistent_directory", "NH0472.csv")
    expect_error(
      download_datasets("NH0472", path = custom_path),
      "The specified directory does not exist."
    )
  })
})

test_that("download_datasets handles download errors", {
  with_tempdir({
    # Definir una función mock para simular un error en download.file
    mock_download_file_error <- function(url, destfile, ...) {
      stop("Simulated download error")
    }
    # Usar mockery::stub para reemplazar download.file dentro de download_datasets
    stub(download_datasets, 'download.file', mock_download_file_error)
    expect_error(
      download_datasets("NH0472"),
      "Download failed. Please check the station ID and your internet connection. Error: Simulated download error"
    )
  })
})
