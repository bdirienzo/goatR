testthat::test_that("download_datasets works when id_station is NULL", {
  withr::with_tempdir({
    download_datasets()
    testthat::expect_true(file.exists("datasets-raw/NH0472.csv"))
    testthat::expect_true(file.exists("datasets-raw/NH0910.csv"))
    testthat::expect_true(file.exists("datasets-raw/NH0046.csv"))
    testthat::expect_true(file.exists("datasets-raw/NH0098.csv"))
    testthat::expect_true(file.exists("datasets-raw/NH0437.csv"))
    testthat::expect_true(file.exists("datasets-raw/metadatos_completos.csv"))
  })
})

testthat::test_that("download_datasets works with a valid id_station", {
  withr::with_tempdir({
    download_datasets("NH0472")
    testthat::expect_true(file.exists("datasets-raw/NH0472.csv"))
  })
})

testthat::test_that("download_datasets handles invalid id_station", {
  withr::with_tempdir({
    testthat::expect_error(
      download_datasets("INVALID_ID"),
      "Invalid station ID. Valid options are:"
    )
  })
})

testthat::test_that("download_datasets saves file to specified path", {
  withr::with_tempdir({
    dir.create("custom_folder")
    custom_path <- file.path("custom_folder", "NH0472.csv")
    download_datasets("NH0472", path = custom_path)
    testthat::expect_true(file.exists(custom_path))
  })
})

testthat::test_that("download_datasets handles non-existent directory", {
  withr::with_tempdir({
    custom_path <- file.path("nonexistent_directory", "NH0472.csv")
    testthat::expect_error(
      download_datasets("NH0472", path = custom_path),
      "The specified directory does not exist."
    )
  })
})

testthat::test_that("download_datasets handles download errors", {
  withr::with_tempdir({
    mock_download_file_error <- function(url, destfile, ...) {
      stop("Simulated download error")
    }
    mockery::stub(download_datasets, 'download.file', mock_download_file_error)
    testthat::expect_error(
      download_datasets("NH0472"),
      "Download failed. Please check the station ID and your internet connection. Error: Simulated download error"
    )
  })
})
