
# Calculate distance from given coordinate to all nodes within given distance
calc_distances<- function(
    long,
    lat,
    node_data,
    search_radius_m = 2000
) {
  
  nodes <- purrr::map2_dfr(
    long,
    lat,
    ~spatialrisk::points_in_circle(node_data, .y, .x,
                                   lon = Longitude,
                                   lat = Latitude,
                                   radius = search_radius_m))
  
  return(nodes)
}


calc_all_distances <- function(
) {
  for (coord in coords) {
    distance <- calc_distance()
  }
}

get_nearest_node <- function(
  coord_df,
  region_array,
  long_name = "longitude",
  lat_name = "latitude"
) {
  # Get node data from API
  node_data <- get_multi_region_nodes()
  

  
}