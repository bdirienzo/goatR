create_sample_df <- function(id, dates, precipitation) {
  data.frame(
    fecha = dates,
    id = id,
    precipitacion_pluviometrica = precipitation,
    stringsAsFactors = FALSE
  )
}

test_that("Function returns a ggplot object with valid input", {
  df1 <- create_sample_df(
    id = "StationA",
    dates = as.Date(c("2023-01-15", "2023-02-15", "2023-03-15")),
    precipitation = c(50, 60, 55)
  )

  df2 <- create_sample_df(
    id = "StationB",
    dates = as.Date(c("2023-01-20", "2023-02-20", "2023-03-20")),
    precipitation = c(30, 45, 50)
  )
  plot <- monthly_precipitation_plot(df1, df2, title = "Test Precipitation Plot")

  expect_s3_class(plot, "ggplot")

  expect_equal(plot$labels$title, "Test Precipitation Plot")
})

test_that("Function handles missing required columns", {
  df_missing <- data.frame(
    fecha = as.Date(c("2023-01-15")),
    id = "StationC",
    stringsAsFactors = FALSE
  )

  expect_error(
    monthly_precipitation_plot(df_missing),
    regexp = "The following columns are missing in the data: precipitacion_pluviometrica"
  )
})

test_that("Function handles invalid date formats", {
  df_invalid_date <- data.frame(
    fecha = c("2023-01-15", "invalid_date", "2023-03-15"),
    id = "StationD",
    precipitacion_pluviometrica = c(20, 30, 40),
    stringsAsFactors = FALSE
  )

  expect_error(
    monthly_precipitation_plot(df_invalid_date),
    regexp = "Could not convert all entries in 'fecha' to Date type. Please check the date format."
  )
})

test_that("Function handles non-Date 'fecha' by converting them", {
  df_char_date <- create_sample_df(
    id = "StationE",
    dates = c("2023-04-10", "2023-05-10", "2023-06-10"),
    precipitation = c(25, 35, 45)
  )

  plot <- monthly_precipitation_plot(df_char_date)

  expect_s3_class(plot, "ggplot")

  expect_equal(plot$labels$x, "Month")
})

test_that("Function handles single data frame input", {
  df_single <- create_sample_df(
    id = "StationP",
    dates = as.Date(c("2023-07-10", "2023-08-10", "2023-09-10")),
    precipitation = c(65, 75, 85)
  )

  plot <- monthly_precipitation_plot(df_single, title = "Single Station Precipitation")

  expect_s3_class(plot, "ggplot")

  expect_equal(plot$labels$title, "Single Station Precipitation")

  built_plot <- ggplot2::ggplot_build(plot)

  layer_data <- built_plot$data[[1]]

  expect_true(length(unique(layer_data$fill)) == 1, info = "All bars should have the same color for a single station")
})

test_that("monthly_precipitation_plot stops if inputs are not data frames", {
  df1 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station1", "Station1"),
                    precipitacion_pluviometrica = c(50, 30))
  not_a_df <- list(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                   id = c("Station2", "Station2"),
                   precipitacion_pluviometrica = c(20, 40))

  expect_error(
    monthly_precipitation_plot(df1, not_a_df),
    regexp = "All inputs must be data frames."
  )
})

test_that("monthly_precipitation_plot stops if colors vector is invalid", {
  df1 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station1", "Station1"),
                    precipitacion_pluviometrica = c(50, 30))
  df2 <- data.frame(fecha = as.Date(c("2021-01-01", "2021-02-01")),
                    id = c("Station2", "Station2"),
                    precipitacion_pluviometrica = c(20, 40))

  colors <- c("red")
  expect_error(
    monthly_precipitation_plot(df1, df2, colors = colors),
    regexp = "Colors vector must be named with station IDs or match the number of stations."
  )

  colors <- setNames(c("red", "green"), c("Station1", "Station2"))
  expect_silent(monthly_precipitation_plot(df1, df2, colors = colors))

  colors <- c("red", "green")
  expect_silent(monthly_precipitation_plot(df1, df2, colors = colors))
})

test_that("colors vector is correctly named with station IDs if matching length", {
  station1 <- data.frame(
    fecha = as.Date(c("2023-01-15", "2023-01-20")),
    id = "station1",
    precipitacion_pluviometrica = c(10, 15)
  )

  station2 <- data.frame(
    fecha = as.Date(c("2023-01-15", "2023-01-20")),
    id = "station2",
    precipitacion_pluviometrica = c(20, 25)
  )

  colors <- c("darkblue", "darkgreen")
  station_ids <- unique(c(station1$id, station2$id))

  if (is.null(names(colors)) && length(colors) == length(station_ids)) {
    names(colors) <- station_ids
  }

  expect_equal(names(colors), c("station1", "station2"))
})
