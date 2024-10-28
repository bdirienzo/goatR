# test-download_datasets.R
library(testthat)
library(withr)
library(mockery)

test_that("download_datasets works when id_station is NULL", {
  with_tempdir({

    download_datasets()

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
      "Invalid station ID. Valid options are:"
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
    # Mock download.file to simulate an error
    mock_download_file_error <- function(url, destfile, ...) {
      stop("Simulated download error")
    }
    # Use mockery::stub to replace download.file with the mock function
    stub(download_datasets, 'download.file', mock_download_file_error)
    expect_error(
      download_datasets("NH0472"),
      "Download failed. Please check the station ID and your internet connection. Error: Simulated download error"
    )
  })
})
