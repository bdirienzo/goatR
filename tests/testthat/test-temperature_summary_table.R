test_that("temperature_summary_table works with valid inputs", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  df2 <- data.frame(id = c(1, 3, 3, 3), temperatura_abrigo_150cm = c(17, 21, 19, 16))
  result <- temperature_summary_table(df1, df2)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_named(result, c("id", "average_temperature", "max_temperature", "min_temperature", "standard_deviation", "total_days"))
})

test_that("temperature_summary_table handles missing columns", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  df2 <- data.frame(id = c(1, 3, 3), temperatura = c(17, 21, 19))

  expect_error(temperature_summary_table(df1, df2), regexp = "names do not match previous names")
})

test_that("temperature_summary_table handles non-data frame inputs", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  not_a_df <- list(id = c(1, 2, 3), temperatura_abrigo_150cm = c(15, 20, 25))

  expect_error(temperature_summary_table(df1, not_a_df), "All inputs must be data frames.")
})

test_that("temperature_summary_table calculates correct statistics", {
  df1 <- data.frame(id = c(1, 1, 2, 2), temperatura_abrigo_150cm = c(15, 18, 20, 22))
  result <- temperature_summary_table(df1)

  expect_equal(result$average_temperature[result$id == 1], 16.5)
  expect_equal(result$max_temperature[result$id == 2], 22)
  expect_equal(result$min_temperature[result$id == 1], 15)
  expect_equal(result$total_days[result$id == 2], 2)
})

test_that("temperature_summary_table stops with missing required columns", {
  df1 <- data.frame(temperatura_abrigo_150cm = c(15, 18, 20, 22))
  df2 <- data.frame(temperatura_abrigo_150cm = c(17, 21, 19, 16))

  expect_error(
    temperature_summary_table(df1, df2),
    regexp = "The following columns are missing in the data: id"
  )

  df1 <- data.frame(id = c(1, 1, 2, 2))
  df2 <- data.frame(id = c(1, 3, 3, 3))

  expect_error(
    temperature_summary_table(df1, df2),
    regexp = "The following columns are missing in the data: temperatura_abrigo_150cm"
  )

  df1 <- data.frame(other_column = c(1, 2, 3, 4))
  df2 <- data.frame(other_column = c(5, 6, 7, 8))

  expect_error(
    temperature_summary_table(df1, df2),
    regexp = "The following columns are missing in the data: id, temperatura_abrigo_150cm"
  )
})
test_that("monthly_temperature_plot stops if inputs are not data frames", {
  df1 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station1", "Station1"),
                    temperatura_abrigo_150cm = c(20, 22))
  not_a_df <- list(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                   id = c("Station2", "Station2"),
                   temperatura_abrigo_150cm = c(18, 19))

  expect_error(
    monthly_temperature_plot(df1, not_a_df),
    regexp = "All inputs must be data frames."
  )
})

test_that("monthly_temperature_plot repeats dark_colors vector to match stations", {
  df1 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station1", "Station1"),
                    temperatura_abrigo_150cm = c(20, 22))
  df2 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station2", "Station2"),
                    temperatura_abrigo_150cm = c(18, 19))

  dark_colors <- setNames(c("darkblue", "darkgreen"), c("Station1", "Station2"))

  expect_silent(monthly_temperature_plot(df1, df2, colors = dark_colors))
})


test_that("monthly_temperature_plot assigns colors automatically if NULL", {
  df1 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station1", "Station1"),
                    temperatura_abrigo_150cm = c(20, 22))
  df2 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station2", "Station2"),
                    temperatura_abrigo_150cm = c(18, 19))

  expect_silent(monthly_temperature_plot(df1, df2, colors = NULL))
})

test_that("monthly_temperature_plot assigns correct number of colors", {
  df1 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station1", "Station1"),
                    temperatura_abrigo_150cm = c(20, 22))
  df2 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station2", "Station2"),
                    temperatura_abrigo_150cm = c(18, 19))
  colors <- c("red", "green")

  expect_silent(monthly_temperature_plot(df1, df2, colors = colors))
})

test_that("monthly_temperature_plot errors if colors vector is invalid", {
  df1 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station1", "Station1"),
                    temperatura_abrigo_150cm = c(20, 22))
  df2 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station2", "Station2"),
                    temperatura_abrigo_150cm = c(18, 19))

  colors <- c("red")

  expect_error(
    monthly_temperature_plot(df1, df2, colors = colors),
    regexp = "Colors vector must be named with station IDs or match the number of stations."
  )
})

