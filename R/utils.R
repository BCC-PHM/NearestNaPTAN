#' Convert UKOS eastings and northings to longitude and latitude
#'
#' @param df Data frame containing UKOS eastings and northings
#' @param easting_col Eastings column name
#' @param northing_col Northings column name
#'
#' @return Returns original data frame with additional longitude and latitude columns
#' @export
#'
#' @examples
#' 
#' df <- data.frame(
#'   "EAST" = c(436403, 436400),
#'   "NORTH" = c(280955, 280967)
#' )
#' 
#' ukos_to_lonlat(
#'   df,
#'   easting_col = "EAST",
#'   northing_col = "NORTH"
#' )
ukos_to_lonlat <- function(
    df,
    easting_col = "Easting",
    northing_col = "Northing"
    ) {
  
  sf_obj <- sf::st_as_sf(
    df,
    coords = c(easting_col, northing_col),
    crs = 27700
  )
  
  sf_ll <- sf::st_transform(sf_obj, 4326)
  
  coords <- sf::st_coordinates(sf_ll)
  
  df$Longitude <- coords[, 1]
  df$Latitude  <- coords[, 2]
  
  return(df)
}

check_col_names <- function(
    df,
    col_name_list,
    func_name
) {
  if (!all(col_name_list %in% colnames(df))) {
    stop(
      paste(
        "Column names given to",
        func_name,
        "do not match the given data frame."
        )
    )
  }
}
