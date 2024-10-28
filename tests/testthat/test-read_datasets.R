# tests/testthat/test-read_datasets.R
library(testthat)

test_that("read_datasets reads data correctly with id_station", {
  # Leer el dataset usando read_datasets
  data_read <- read_datasets(id_station = "NH0472")

  # Leer el dataset directamente desde el archivo usando read.csv
  data_original <- read.csv(file.path("datasets-raw", "NH0472.csv"))

  # Verificar que los datasets son iguales
  expect_equal(data_read, data_original)
})

test_that("read_datasets throws error when file does not exist", {
  # Intentar leer un id_station que no existe
  expect_error(
    read_datasets(id_station = "INVALID_ID"),
    "The file or path doesn't exist"
  )
})

test_that("read_datasets reads data correctly with path", {
  # Especificar la ruta al archivo existente
  path <- file.path("datasets-raw", "NH0472.csv")
  data_read <- read_datasets(path = path)

  # Leer el dataset directamente desde el archivo usando read.csv
  data_original <- read.csv(path)

  # Verificar que los datasets son iguales
  expect_equal(data_read, data_original)
})

test_that("read_datasets throws error when neither id_station nor path are provided", {
  # Llamar a la función sin argumentos
  expect_error(
    read_datasets(),
    "Either 'id_station' or 'path' must be provided."
  )
})
