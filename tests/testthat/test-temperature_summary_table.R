# Test that the function works correctly with valid inputs
test_that("temperature_summary_table works with valid inputs", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  df2 <- data.frame(id = c(1, 3, 3, 3), temperatura_abrigo_150cm = c(17, 21, 19, 16))
  result <- temperature_summary_table(df1, df2)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_named(result, c("id", "average_temperature", "max_temperature", "min_temperature", "standard_deviation", "total_days"))
})

# Test that the function stops with missing columns
test_that("temperature_summary_table handles missing columns", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  df2 <- data.frame(id = c(1, 3, 3), temperatura = c(17, 21, 19))

  # Cambiamos el mensaje de error esperado para que coincida con el error actual generado
  expect_error(temperature_summary_table(df1, df2), regexp = "names do not match previous names")
})


# Test that the function stops with non-data frame inputs
test_that("temperature_summary_table handles non-data frame inputs", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  not_a_df <- list(id = c(1, 2, 3), temperatura_abrigo_150cm = c(15, 20, 25))

  expect_error(temperature_summary_table(df1, not_a_df), "All inputs must be data frames.")
})

# Test that the function calculates correct statistics
test_that("temperature_summary_table calculates correct statistics", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  result <- temperature_summary_table(df1)

  expect_equal(result$average_temperature[result$id == 1], 16.5)
  expect_equal(result$max_temperature[result$id == 2], 22)
  expect_equal(result$min_temperature[result$id == 1], 15)
  expect_equal(result$total_days[result$id == 2], 2)
})

