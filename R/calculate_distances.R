source("R/naptan_api.R")
source("R/utils.R")


#' Find all nodes within search_radius_m of long and lat (Single point)
#'
#' @param long Longitude 
#' @param lat Latitude
#' @param node_data NAPTAN node data from get_single_region_nodes() or get_multi_region_nodes()
#' @param search_radius_m Search radius in meters
#'
#' @return Returns data frame of NAPTAN nodes within search_radius_m of given coordinates
#' @export
#'
#' @examples 
#' node_data <- get_single_region_nodes("West Midlands")
#' 
#' nodes_in_300m <- find_nodes(
#'    -1.9060413,
#'    52.4803994,
#'    node_data,
#'    search_radius_m = 300 # metres
#' )
#' 
#' nodes_in_300m
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


#' Find all nodes within search_radius_m of long and lat of multiple coordinates
#'
#' @param coord_df Data frame with longitude and latitude of points from which to find NAPTAN nodes
#' @param node_data NAPTAN node data from 
#' @param longitude_col Longitude column name
#' @param latitude_col Latitude column name
#' @param search_radius_m Search radius in meters
#'
#' @return Returns data frame of NAPTAN nodes within search_radius_m of all given coordinates
#' @export
#'
#' @examples
#' node_data <- get_single_region_nodes("West Midlands")
#' 
#' coord_df <- data.frame(
#'   "LONG" = c(-1.9060413, -1.7802142),
#'   "LAT" = c(52.4803994, 52.4115384)
#' )
#' 
#' nodes_in_300m <- find_all_nodes(
#'   coord_df, 
#'   node_data,
#'   longitude_col = "LONG",
#'   latitude_col = "LAT",
#'   search_radius_m = 300 # metres
#' )
#' 
#' nodes_in_300m
find_all_nodes <- function(
    coord_df,
    node_data,
    longitude_col = "Longitude",
    latitude_col = "Latitude",
    search_radius_m = 2000
) {
  nodes_list <- list()
  for (i in 1:nrow(coord_df)) {
    nodes_list[[i]] <- find_nodes(
      coord_df[[longitude_col]][i],
      coord_df[[latitude_col]][i],
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


#' Get single NAPTAN node closest to any of the given coordinates
#'
#' @param coord_df Data frame with longitude and latitude of points from which to find NAPTAN nodes
#' @param region_array Array of NAPTAN regions. Use `naptanr::lookup_atco_codes()` to find allowed region names.
#' @param longitude_col Longitude column name
#' @param latitude_col Latitude column name
#' @param search_radius_m Search radius in meters
#'
#' @return Returns a single row data frame with the NAPTAN node closest to all given coordinates
#' @export
#'
#' @examples
#' 
#' coord_df <- data.frame(
#' "LONG" = c(-1.9060413, -1.7802142),
#' "LAT" = c(52.4803994, 52.4115384)
#' )
#' 
#' nearest_node <- get_nearest_node(
#'   coord_df,
#'   c("West Midlands"),
#'   longitude_col = "LONG",
#'   latitude_col = "LAT",
#'   search_radius_m = 200
#' )
#' 
#' nearest_node
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

#' Get distance in meters to nearest NAPTAN node from any of the given coordinates
#'
#' @param coord_df Data frame with longitude and latitude of points from which to find NAPTAN nodes
#' @param region_array Array of NAPTAN regions. Use `naptanr::lookup_atco_codes()` to find allowed region names.
#' @param longitude_col Longitude column name
#' @param latitude_col Latitude column name
#' @param search_radius_m Search radius in meters
#'
#' @return Returns a single row data frame with the NAPTAN node closest to all given coordinates
#' @export
#'
#' @examples
#' 
#' coord_df <- data.frame(
#' "LONG" = c(-1.9060413, -1.7802142),
#' "LAT" = c(52.4803994, 52.4115384)
#' )
#' 
#' min_dist <- get_nearest_node_dist(
#'   coord_df,
#'   c("West Midlands"),
#'   longitude_col = "LONG",
#'   latitude_col = "LAT",
#'   search_radius_m = 200
#' )
#' 
#' min_dist
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




