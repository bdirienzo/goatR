% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_datasets.R
\name{download_datasets}
\alias{download_datasets}
\title{Download a dataset from an \strong{Argentine weather station}}
\usage{
download_datasets(id_station = NULL, path = NULL)
}
\arguments{
\item{id_station}{A string representing the identifier for the desired weather station.
Valid options include: \code{"NH0472"}, \code{"NH0910"}, \code{"NH0046"}, \code{"NH0098"}, and \code{"NH0437"}.
This identifier constructs the download URL, and only these identifiers are accepted. If no \code{id_station} is specified, the function will download all 5 files.}

\item{path}{An optional file path where the downloaded file will be saved. By default, the file will be saved
to a "datasets-raw" folder within the current working directory, with a file name based on the station identifier.}
}
\value{
\itemize{
\item A \code{.csv} file located in the specified or default path, containing data from the selected weather station.
\item A string representing the path where the \code{.csv} file is saved
}
}
\description{
The function \emph{download_datasets()} downloads a CSV file from a remote repository, containing data from a selected Argentine weather station.
The user can specify the weather station by providing a valid identifier. If no custom path is specified, the function will save the file in
a default "datasets-raw" folder within the current working directory. If no \code{id_station} is specified, all 5 of them will be downloaded.
}
\details{
\itemize{
\item If the \code{path} parameter is not specified, this function creates a "datasets-raw" folder in the working directory (if it doesn't already exist)
and saves the dataset there using the format \code{"datasets-raw/<id_station>.csv"}.
\item \strong{WARNING:} This function may overwrite existing datasets if a file with the same name exists in the specified path!
}
}
\examples{
# Download the dataset with ID "NH0472" to the default "datasets-raw" folder
download_datasets("NH0472")

# Use the id_station directly in read_datasets to load the data
data <- read_datasets(id_station = "NH0472")

# Download the dataset with ID "NH0910" to a specified custom location
if (!dir.exists("./custom_folder")) {
  dir.create("./custom_folder")}
download_datasets("NH0910", "./custom_folder/NH0910_data.csv")
data <- read_datasets(path = "./custom_folder/NH0910_data.csv")
download_datasets("NH0910", "./custom_folder/NH0910_data.csv")

# Download all available datasets to the default "datasets-raw" folder
download_datasets()

}
\seealso{
\code{goatR::read_datasets} to load and view the downloaded dataset.
}
