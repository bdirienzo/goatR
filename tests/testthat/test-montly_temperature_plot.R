test_that("monthly_temperature_plot works with valid inputs", {
  set.seed(123)

  station1 <- data.frame(
    fecha = seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-12-01"), by = "month"),
    id = "Station1",
    temperatura_abrigo_150cm = runif(12, min = 15, max = 25)
  )

  station2 <- data.frame(
    fecha = seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-12-01"), by = "month"),
    id = "Station2",
    temperatura_abrigo_150cm = runif(12, min = 10, max = 20)
  )

  p <- monthly_temperature_plot(
    station1,
    station2,
    title = "Monthly Average Temperature Comparison"
  )

  expect_s3_class(p, "ggplot")
})

test_that("monthly_temperature_plot handles missing data", {
  station_with_na <- data.frame(
    fecha = seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-12-01"), by = "month"),
    id = "StationNA",
    temperatura_abrigo_150cm = c(NA, runif(10, min = 15, max = 25), NA)
  )

  p <- monthly_temperature_plot(
    station_with_na,
    title = "Plot with Missing Data"
  )

  expect_s3_class(p, "ggplot")
})

test_that("monthly_temperature_plot returns error with incorrect input types", {
  incorrect_data <- data.frame(
    date = seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-12-01"), by = "month"),
    station_id = "StationIncorrect",
    temperature = runif(12, min = 15, max = 25)
  )

  expect_error(
    monthly_temperature_plot(
      incorrect_data,
      title = "Plot with Incorrect Data"
    ),
    "The following columns are missing in the data: fecha, id, temperatura_abrigo_150cm"
  )
})

test_that("monthly_temperature_plot handles non-Date fecha column", {
  station_char_fecha <- data.frame(
    fecha = format(seq.Date(from = as.Date("2021-01-01"), to = as.Date("2021-12-01"), by = "month"), "%Y-%m-%d"),
    id = "StationCharFecha",
    temperatura_abrigo_150cm = runif(12, min = 15, max = 25)
  )

  p <- monthly_temperature_plot(
    station_char_fecha,
    title = "Plot with Character fecha"
  )

  expect_s3_class(p, "ggplot")
})

test_that("monthly_temperature_plot handles custom colors correctly", {
  station1 <- data.frame(
    fecha = seq.Date(from = as.Date("2021-01-01"), length.out = 12, by = "month"),
    id = "Station1",
    temperatura_abrigo_150cm = runif(12, min = 15, max = 25)
  )

  station2 <- data.frame(
    fecha = seq.Date(from = as.Date("2021-01-01"), length.out = 12, by = "month"),
    id = "Station2",
    temperatura_abrigo_150cm = runif(12, min = 10, max = 20)
  )

  custom_colors <- c("Station1" = "blue", "Station2" = "green")

  p <- monthly_temperature_plot(
    station1,
    station2,
    colors = custom_colors,
    title = "Plot with Custom Colors"
  )

  expect_s3_class(p, "ggplot")

  plot_data <- ggplot_build(p)$data[[1]]
  expect_true(all(unique(plot_data$colour) %in% custom_colors))
})

test_that("monthly_temperature_plot errors when inputs are not data frames", {
  expect_error(
    monthly_temperature_plot(
      "not a data frame",
      title = "Invalid Input"
    ),
    "All inputs must be data frames."
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

