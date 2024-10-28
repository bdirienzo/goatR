test_that("dataset download works", {
  # Ejecutar las pruebas dentro de un directorio temporal
  withr::with_tempdir({
    # Test 1: Descargar archivo "NH0472" al directorio por defecto en el directorio temporal
    download_datasets("NH0472")
    expect_true(file.exists("datasets-raw/NH0472.csv"))

    # Test 2: Descargar archivo "NH0910" al directorio por defecto en el directorio temporal
    download_datasets("NH0910")
    expect_true(file.exists("datasets-raw/NH0910.csv"))

    # Test 3: Descargar archivo "NH0046" al directorio por defecto en el directorio temporal
    download_datasets("NH0046")
    expect_true(file.exists("datasets-raw/NH0046.csv"))

    # Test 4: Descargar archivo "NH0098" al directorio por defecto en el directorio temporal
    download_datasets("NH0098")
    expect_true(file.exists("datasets-raw/NH0098.csv"))

    # Test 5: Descargar archivo "NH0437" al directorio por defecto en el directorio temporal
    download_datasets("NH0437")
    expect_true(file.exists("datasets-raw/NH0437.csv"))

    # Test 6: Descargar archivo "metadatos_completos" al directorio por defecto en el directorio temporal
    download_datasets("metadatos_completos")
    expect_true(file.exists("datasets-raw/metadatos_completos.csv"))
  })
})

test_that("download_datasets handles errors correctly", {
  # Ejecutar las pruebas de manejo de errores dentro de un directorio temporal
  withr::with_tempdir({
    # Test 1: ID de estación inválido
    expect_error(
      download_datasets("NH00000"),
      "Invalid station ID. Valid options are: NH0472, NH0910, NH0046, NH0098, NH0437, metadatos_completos"
    )

    # Test 2: Directorio no existente
    expect_error(
      download_datasets("NH0437", "./testing/NH0437.csv"),
      "The specified directory does not exist."
    )
  })
})
