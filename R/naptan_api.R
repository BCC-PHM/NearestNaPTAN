
get_single_region_nodes <- function(
    region_name
) {
  
  allowed_region_names <- naptanr::lookup_atco_codes()$AreaName
  
  # check that given name is allowed
  if (!(region_name %in% allowed_region_names)) {
    stop(
      paste0(
        "Given region name '",
        region_name, 
        "' not allowed.", 
        "\n  Use `naptanr::lookup_atco_codes()` to find allowed region names."
      )
    )
  }
  
  node_data <- naptanr::call_naptan_region(region_name)

  return(node_data)  
  
}

get_multi_region_nodes <- function(
    region_array
) {
  node_df_list <- list()
  for (region_i in region_array) {
    node_data_i <- get_single_region_nodes(region_i)
    node_df_list[[region_i]] <- node_data_i
  }
  
  node_data <- data.table::rbindlist(node_df_list)
  
  return(node_data)
}

get_single_region_nodes("West Midlands")