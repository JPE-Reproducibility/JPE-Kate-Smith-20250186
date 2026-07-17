GetTempAverages <- function(metofficefile, metofficevar, shp, savefile) {

  # read NetCDF 
  f <- file.path(metofficedatadir, metofficefile)
  r <- rast(f, sub = metofficevar)
  
  # align CRS
  shp_tempcrs <- st_transform(shp, crs = crs(r, proj = TRUE))
  
  # extract and average
  vals <- terra::extract(r, vect(shp_tempcrs))  # returns ID + layer columns
  temp_means <- vals %>%
    group_by(ID) %>%
    summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE)))
  
  # rename months if 12 layers
  lyr_cols <- setdiff(names(temp_means), "ID")
  if (length(lyr_cols) == 12) {
    names(temp_means)[match(lyr_cols, names(temp_means))] <-
      c("Jan","Feb","Mar","Apr","May","Jun","July","Aug","Sep","Oct","Nov","Dec")
  }
  
  # combine & save
  out_df <- cbind(st_drop_geometry(shp_tempcrs), temp_means)
  write.csv(out_df, file = savefile, row.names = FALSE)
}