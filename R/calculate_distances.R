source("R/naptan_api.R")
source("R/utils.R")

# Calculate distance from given coordinate to all nodes within given distance
find_nodes <- function(
    long,
    lat,
    node_data,
    search_radius_m = 2000
) {
  
  nodes <- purrr::map2_dfr(
    lat,
    long,
    ~spatialrisk::points_in_circle(node_data, .y, .x,
                                   lon = Longitude,
                                   lat = Latitude,
                                   radius = search_radius_m))
  
  return(nodes)
}


find_all_nodes <- function(
    df,
    node_data,
    longitude_col = "Longitude",
    latitude_col = "Latitude",
    search_radius_m = 2000
) {
  nodes_list <- list()
  for (i in 1:nrow(df)) {
    nodes_list[[i]] <- calc_distances(
      df[[longitude_col]][i],
      df[[latitude_col]][i],
      node_data,
      search_radius_m = search_radius_m
    )
  }
  
  # Combine all data frames
  nodes_output <- data.table::rbindlist(nodes_list) %>%
    # Remove doubles keeping the minimum distances
    dplyr::arrange(distance_m) %>%
    dplyr::group_by(NaptanCode) %>%
    dplyr::slice_min(distance_m, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup()
  
  return(nodes_output)
}

get_nearest_node <- function(
  coord_df,
  region_array,
  longitude_col = "longitude",
  latitude_col = "latitude",
  search_radius_m = 2000
) {
  
  # Get node data from API
  node_data <- get_multi_region_nodes(region_array) 
  
  nearest_node <- find_all_nodes(
    coord_df,
    node_data,
    longitude_col = longitude_col,
    latitude_col = latitude_col,
    search_radius_m = search_radius_m
    ) %>%
    dplyr::slice_min(distance_m, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup()
  
  return(nearest_node)

}

get_nearest_node_dist <- function(
    coord_df,
    region_array,
    longitude_col = "longitude",
    latitude_col = "latitude",
    search_radius_m = 2000
) {
  
  min_dist <- get_nearest_node(
    coord_data,
    region_array,
    longitude_col = longitude_col,
    latitude_col = latitude_col,
    search_radius_m = search_radius_m
  )$distance_m
  
  return(min_dist)
}

coord_data <- node_data %>% 
    dplyr::rename(
      LONG = Longitude,
      LAT = Latitude
    ) %>%
  head(3)

get_nearest_node_dist(
  coord_data,
  c("West Midlands"),
  longitude_col = "LONG",
  latitude_col = "LAT",
  search_radius_m = 200
)