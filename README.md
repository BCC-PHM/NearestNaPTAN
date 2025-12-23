# NearestNaPTAN

This package uses the `naptanr` package to query the National Public Transport Access Nodes (NaPTAN) API and find NaPTAN nodes within a given radius of given coordinates. 

## Installition

The package is used in the same way as any other R package you might be familiar with. However, the installation uses a slightly different function. We can install the package directly from GitHub by typing the following command into the RStudio console:

``` r
devtools::install_github("BCC-PHM/NearestNaPTAN")
```

## Basic Usage

### API Query

Basic queries to the API can be made using `get_single_region_nodes()` or `get_multi_region_nodes()`. 

Example:
```r
nodes <- get_single_region_nodes("West Midlands") %>%
    select(c(ATCOCode, CommonName, Status, Longitude, Latitude))
head(nodes)
```

```text
      ATCOCode       CommonName   Status Longitude Latitude
        <char>           <char>   <char>     <num>    <num>
1: 43000000101 Attwood Crescent   active -1.466086 52.42538
2: 43000000102 Attwood Crescent inactive -1.466129 52.42548
3: 43000000201   New Green Park   active -1.461557 52.42657
4: 43000000202   New Green Park   active -1.461686 52.42678
5: 43000000301 Corinthian Place inactive -1.460428 52.42622
6: 43000000601  Westwood Church   active -1.571427 52.38423
```

### Finding Nodes Within Radius

Given an input data frame of longitude and latitude coordinates, all nodes within a given distance can be found using `get_all_nodes()`, the nearest node from any given coordinate using `get_nearest_node()`, or the distance in meters to the nearest node using `get_nearest_node_dist()`.

Example: 

``` r
coord_df <- data.frame(
"LONG" = c(-1.9060413, -1.7802142),
"LAT" = c(52.4803994, 52.4115384)
)

min_dist <- get_nearest_node_dist(
  coord_df,
  c("West Midlands"),
  longitude_col = "LONG",
  latitude_col = "LAT",
  search_radius_m = 200
)

min_dist
```

``` text
[1] 79.30363
```


### License

This repository is dual licensed under the [Open Government v3]([https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) & MIT. All code and outputs are subject to Crown Copyright.
