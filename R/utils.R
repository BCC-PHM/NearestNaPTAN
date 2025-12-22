ukos_to_lonlat <- function(df,
                           easting_col = "Easting",
                           northing_col = "Northing") {
  
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
