#' @title fars_read
#' @importFrom readr read_csv
#' @import dplyr
#' @description fars_read checks for CSV file, returns error or loads file
#' @details This function checks for the specified CSV file using the file name provided. If the file does not exist,
#' an error is returned stating that the file does not exist. If the file does exist, the file is loaded as a data frame.
#'
#' @param filename The full file path to the CSV file containing the fars data.
#' @return tibble object containing the data from the CSV file
#' @examples
#' \dontrun{
#' data <- fars_read("accident_2013.csv.bz2")
#' head(data)
#' }
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::as_tibble(data)
}


#' @title make_filename
#' @description make_filename creates a CSV file name using the 4-digit Year provided as a parameter (2013, 2014, or 2015)
#' @details This function creates a file name based on the four-digit year provided to the function.
#' @param year The four-digit numeric year of data for which to create the file name.
#' @return a string of the file name based on the year: "accident_xxxx.csv.bz2", where xxxx represents the year
#' @examples
#' \dontrun{
#' make_filename("2013")
#' }
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  system.file("extdata",
              sprintf("accident_%d.csv.bz2", year),
              package = "farsData",
              mustWork = TRUE)
}


#' @title fars_read_years
#' @import dplyr
#' @description fars_read_years takes a list of years, builds the file names for each year provided, and loads the files
#' @details This function takes a list of four-digits numeric years, creates a list of file names using the years provided,
#' and checks for the specified CSV file using the file names created. If the file does not exist,
#' an error is returned stating that the an invalid year is provided and NULL is returned. If the file does exist, the file
#' is loaded as a data frame containing the month and year with one row for each accident that occurred.
#' @param years A list of four-digit years representing the data of interest
#' @return a list of tibble objects combining the month and year of accidents from each year provided, or NULL for invalid years
#' @seealso \link{fars_read}
#' @seealso \link{make_filename}
#' @examples
#' \dontrun{
#' fars_read_years(c(2013, 2014))
#' }
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}


#' @title fars_summarize_years
#' @importFrom tidyr spread
#' @import dplyr
#' @description fars_summarize_years takes a list of years and summarizes the number of accidents by month and year
#' @details This function uses the four-digit numeric years provided to check the CSV file associated with the specified years. If the
#' file does not exist, an error is returned stating that the file does not exist. If the file does exist, the file is loaded
#' into a list of data frames. The lists are then combined into one data frame, grouped by month and years of data, and summarized
#' by counting the total number of accidents for each month and year combination.
#' @param years A list of four-digit years representing the data of interest
#' @return tibble object of accident data summarized by Month and Year
#' @seealso \link{fars_read_years}
#' @examples
#' \dontrun{
#' fars_summarize_years(c(2013, 2014))
#' }
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}


#' @title fars_map_state
#' @import maps
#' @importFrom graphics points
#' @import dplyr
#' @description fars_map_state takes a state ID number and year to create a map of accident locations
#' @details This function uses a state ID and four-digit year and generates a map of accident locations for the specified state
#' within the specified year.
#'
#' @param state.num The number associated with the state of interest based on the state numbers in the original data
#' @param year A four-digit year representing the year of data of interest
#' @return map of accident locations for the selected state and year
#' @seealso \link{make_filename}
#' @seealso \link{fars_read}
#' @examples
#' \dontrun{
#' fars_map_state(25, 2013)
#' }
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
