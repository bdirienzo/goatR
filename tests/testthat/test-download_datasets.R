test_that("dataset download works", {

  #Test 1
  download_datasets("NH0472")
  expect_true(file.exists("datasets-raw/NH0472.csv"))

  #Test 2
  download_datasets("NH0910")
  expect_true(file.exists("datasets-raw/NH0910.csv"))

  #Test 3
  download_datasets("NH0046")
  expect_true(file.exists("datasets-raw/NH0046.csv"))

  #Test 4
  download_datasets("NH0098")
  expect_true(file.exists("datasets-raw/NH0098.csv"))

  #Test 5
  download_datasets("NH0437")
  expect_true(file.exists("datasets-raw/NH0437.csv"))

  #Test 6
  download_datasets("metadatos_completos")
  expect_true(file.exists("datasets-raw/metadatos_completos.csv"))

  #Test 7
  download_datasets("metadatos_completos", "/Users/user/Documents/Austral/2024/2º cuatrimestre/Programación II/Estudio/Goatr/testing/metadatos_conpletos.csv")
  expect_true(file.exists("/Users/user/Documents/Austral/2024/2º cuatrimestre/Programación II/Estudio/Goatr"))

})

  test_that("download_datasets handles errors correctly", {

    # Test 1: Invalid station ID
    expect_error(download_datasets("NH00000"),
                   "Invalid station ID. Valid options are: NH0472, NH0910, NH0046, NH0098, NH0437, metadatos_completos")

    # Test 2: Invalid directory
    expect_error(download_datasets("NH0437", "./testing/NH0437.csv"),
      "The specified directory does not exist."
    )
})
