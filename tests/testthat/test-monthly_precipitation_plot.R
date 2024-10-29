# tests/testthat/test-monthly_precipitation_plot.R

library(testthat)
library(ggplot2)
library(dplyr)
library(rlang)

# Helper function to create sample data frames
create_sample_df <- function(id, dates, precipitation) {
  data.frame(
    fecha = dates,
    id = id,
    precipitacion_pluviometrica = precipitation,
    stringsAsFactors = FALSE
  )
}

test_that("Function returns a ggplot object with valid input", {
  # Create sample data frames
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

  # Call the function
  plot <- monthly_precipitation_plot(df1, df2, title = "Test Precipitation Plot")

  # Check if the output is a ggplot object
  expect_s3_class(plot, "ggplot")

  # Optionally, check if the plot has the correct title
  expect_equal(plot$labels$title, "Test Precipitation Plot")
})

test_that("Function handles missing required columns", {
  # Create a data frame missing 'precipitacion_pluviometrica'
  df_missing <- data.frame(
    fecha = as.Date(c("2023-01-15")),
    id = "StationC",
    stringsAsFactors = FALSE
  )

  # Expect the function to throw an error
  expect_error(
    monthly_precipitation_plot(df_missing),
    regexp = "The following columns are missing in the data: precipitacion_pluviometrica"
  )
})

test_that("Function handles invalid date formats", {
  # Create a data frame with invalid 'fecha' format
  df_invalid_date <- data.frame(
    fecha = c("2023-01-15", "invalid_date", "2023-03-15"),
    id = "StationD",
    precipitacion_pluviometrica = c(20, 30, 40),
    stringsAsFactors = FALSE
  )

  # Expect the function to throw an error during date conversion
  expect_error(
    monthly_precipitation_plot(df_invalid_date),
    regexp = "Could not convert all entries in 'fecha' to Date type. Please check the date format."
  )
})

test_that("Function handles non-Date 'fecha' by converting them", {
  # Create a data frame with 'fecha' as character
  df_char_date <- create_sample_df(
    id = "StationE",
    dates = c("2023-04-10", "2023-05-10", "2023-06-10"),
    precipitation = c(25, 35, 45)
  )

  # Call the function
  plot <- monthly_precipitation_plot(df_char_date)

  # Check if the plot is created successfully
  expect_s3_class(plot, "ggplot")

  # Optionally, check if 'month' was correctly added
  # This requires accessing the data inside the function, which isn't directly possible
  # Alternatively, check the labels or other plot attributes
  expect_equal(plot$labels$x, "Month")
})

test_that("Function handles custom colors correctly when names are provided", {
  # Create sample data frames
  df1 <- create_sample_df(
    id = "StationF",
    dates = as.Date(c("2023-07-15", "2023-08-15", "2023-09-15")),
    precipitation = c(70, 80, 90)
  )

  df2 <- create_sample_df(
    id = "StationG",
    dates = as.Date(c("2023-07-20", "2023-08-20", "2023-09-20")),
    precipitation = c(40, 50, 60)
  )

  # Define custom colors with names
  custom_colors <- c("StationF" = "#1f77b4", "StationG" = "#ff7f0e")

  # Call the function with custom colors
  plot <- monthly_precipitation_plot(df1, df2, colors = custom_colors)

  # Build the plot to access internal data
  built_plot <- ggplot_build(plot)

  # Extract the fill colors from the first layer
  layer_data <- built_plot$data[[1]]

  # Iterate through each station and verify the color
  for (station in names(custom_colors)) {
    expected_color <- custom_colors[station]
    actual_color <- unique(layer_data$fill[layer_data$id == station])
    expect_equal(actual_color, expected_color, info = paste("Color mismatch for", station))
  }
})

test_that("Function handles custom colors correctly when names are not provided", {
  # Create sample data frames
  df1 <- create_sample_df(
    id = "StationH",
    dates = as.Date(c("2023-10-15", "2023-11-15", "2023-12-15")),
    precipitation = c(100, 110, 120)
  )

  df2 <- create_sample_df(
    id = "StationI",
    dates = as.Date(c("2023-10-20", "2023-11-20", "2023-12-20")),
    precipitation = c(80, 90, 100)
  )

  # Define custom colors without names
  custom_colors <- c("#2ca02c", "#d62728")

  # Call the function with custom colors
  plot <- monthly_precipitation_plot(df1, df2, colors = custom_colors)

  # Build the plot to access internal data
  built_plot <- ggplot_build(plot)

  # Extract the fill colors from the first layer
  layer_data <- built_plot$data[[1]]

  # Get unique station IDs in the order they appear
  unique_ids <- unique(layer_data$id)

  # Assign custom colors based on the order of station IDs
  for (i in seq_along(unique_ids)) {
    station <- unique_ids[i]
    expected_color <- custom_colors[i]
    actual_color <- unique(layer_data$fill[layer_data$id == station])
    expect_equal(actual_color, expected_color, info = paste("Color mismatch for", station))
  }
})

test_that("Function handles custom colors correctly when colors vector is unnamed and length matches", {
  # Create sample data frames
  df1 <- create_sample_df(
    id = "StationL",
    dates = as.Date(c("2023-03-10", "2023-04-10")),
    precipitation = c(55, 65)
  )

  df2 <- create_sample_df(
    id = "StationM",
    dates = as.Date(c("2023-03-20", "2023-04-20")),
    precipitation = c(75, 85)
  )

  # Define a colors vector with correct length but without names
  correct_length_colors <- c("#9467bd", "#8c564b")

  # Call the function with custom colors
  plot <- monthly_precipitation_plot(df1, df2, colors = correct_length_colors)

  # Build the plot to access internal data
  built_plot <- ggplot_build(plot)

  # Extract the fill colors from the first layer
  layer_data <- built_plot$data[[1]]

  # Get unique station IDs in the order they appear
  unique_ids <- unique(layer_data$id)

  # Assign custom colors based on the order of station IDs
  for (i in seq_along(unique_ids)) {
    station <- unique_ids[i]
    expected_color <- correct_length_colors[i]
    actual_color <- unique(layer_data$fill[layer_data$id == station])
    expect_equal(actual_color, correct_length_colors[i], info = paste("Color mismatch for", station))
  }
})

test_that("Function throws error when colors vector length does not match number of stations", {
  # Create sample data frames
  df1 <- create_sample_df(
    id = "StationJ",
    dates = as.Date(c("2023-01-10", "2023-02-10")),
    precipitation = c(15, 25)
  )

  df2 <- create_sample_df(
    id = "StationK",
    dates = as.Date(c("2023-01-20", "2023-02-20")),
    precipitation = c(35, 45)
  )

  # Define a colors vector with incorrect length
  incorrect_colors <- c("red")

  # Expect the function to throw an error
  expect_error(
    monthly_precipitation_plot(df1, df2, colors = incorrect_colors),
    regexp = "Colors vector must be named with station IDs or match the number of stations."
  )
})

test_that("Function handles default colors when colors parameter is NULL", {
  # Create sample data frames
  df1 <- create_sample_df(
    id = "StationN",
    dates = as.Date(c("2023-05-15", "2023-06-15")),
    precipitation = c(95, 105)
  )

  df2 <- create_sample_df(
    id = "StationO",
    dates = as.Date(c("2023-05-20", "2023-06-20")),
    precipitation = c(85, 75)
  )

  # Call the function without specifying colors
  plot <- monthly_precipitation_plot(df1, df2)

  # Check if the plot is created successfully
  expect_s3_class(plot, "ggplot")

  # Verify that 'fill' is mapped to 'as.factor(id)' using as_label()
  expect_equal(as_label(plot$mapping$fill), "as.factor(id)")

  # Build the plot to access internal data
  built_plot <- ggplot_build(plot)

  # Extract the fill colors from the first layer
  layer_data <- built_plot$data[[1]]

  # Since default colors are used, verify that colors are assigned
  # Assuming two stations, check that two unique colors are assigned
  unique_colors <- unique(layer_data$fill)
  expect_equal(length(unique_colors), 2, info = "Default colors should assign unique colors to each station")
})

test_that("Function handles single data frame input", {
  # Create a single data frame
  df_single <- create_sample_df(
    id = "StationP",
    dates = as.Date(c("2023-07-10", "2023-08-10", "2023-09-10")),
    precipitation = c(65, 75, 85)
  )

  # Call the function with a single data frame
  plot <- monthly_precipitation_plot(df_single, title = "Single Station Precipitation")

  # Check if the plot is a ggplot object
  expect_s3_class(plot, "ggplot")

  # Check the plot title
  expect_equal(plot$labels$title, "Single Station Precipitation")

  # Use ggplot_build to extract plot data
  built_plot <- ggplot_build(plot)

  # Extract fill colors from the first layer
  layer_data <- built_plot$data[[1]]

  # Since there's only one station, all fill colors should be the same
  expect_true(length(unique(layer_data$fill)) == 1, info = "All bars should have the same color for a single station")
})

test_that("Function handles empty input data frames", {
  # Create an empty data frame with required columns
  df_empty <- data.frame(
    fecha = as.Date(character()),
    id = character(),
    precipitacion_pluviometrica = numeric(),
    stringsAsFactors = FALSE
  )

  # Expect the function to throw an error due to empty data
  expect_error(
    monthly_precipitation_plot(df_empty),
    regexp = "The combined data frame has no rows. Please provide data with at least one observation."
  )
})

test_that("Function handles NA values in 'precipitacion_pluviometrica'", {
  # Create a data frame with NA precipitation values
  df_na <- create_sample_df(
    id = "StationS",
    dates = as.Date(c("2023-12-10", "2023-12-15", "2023-12-20")),
    precipitation = c(NA, 120, 130)
  )

  # Call the function
  plot <- monthly_precipitation_plot(df_na)

  # Check if the plot is created successfully
  expect_s3_class(plot, "ggplot")

  # Use ggplot_build to extract plot data
  built_plot <- ggplot_build(plot)

  # Extract the summarized data from the first layer
  plot_data <- built_plot$data[[1]]

  # Check that the month with NA precipitation is handled correctly (sum = 250)
  # Assuming "December" is the month in the data
  december_data <- plot_data[plot_data$x == "December", ]

  # Verify that the total precipitation for December is 250
  expect_equal(december_data$y, 120 + 130, info = "Total precipitation for December should be 250")
})
