#test-naptan_api.R

test_that("api call works", {
  
  suppressMessages({
    test_df <- get_single_region_nodes("West Midlands")
  })
  
  # API returns a data frame
  expect_equal(
    class(test_df), 
    c("data.table", "data.frame")
    )
  
  # data frame contains data
  expect_equal(
    nrow(test_df) > 0, 
    TRUE
  )
  
  # Has necessary column names
  expect_equal(
    all(c("Easting", "Northing") %in% colnames(test_df)),
    TRUE
  )
  
})