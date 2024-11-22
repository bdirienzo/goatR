testthat::test_that("read_datasets reads data correctly with id_station", {
  data_read <- read_datasets(id_station = "NH0472")
  data_original <- utils::read.csv(base::file.path("datasets-raw", "NH0472.csv"))
  testthat::expect_equal(data_read, data_original)
})

testthat::test_that("read_datasets throws error when file does not exist", {
  testthat::expect_error(
    read_datasets(id_station = "INVALID_ID"),
    "The file or path doesn't exist"
  )
})

testthat::test_that("read_datasets reads data correctly with path", {
  path <- base::file.path("datasets-raw", "NH0472.csv")
  data_read <- read_datasets(path = path)
  data_original <- utils::read.csv(path)
  testthat::expect_equal(data_read, data_original)
})

testthat::test_that("read_datasets throws error when neither id_station nor path are provided", {
  testthat::expect_error(
    read_datasets(),
    "Either 'id_station' or 'path' must be provided."
  )
})
