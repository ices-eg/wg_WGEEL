style_table1 <- function(tab) {
  
  # Capitalize first letter of column, make header, last column and second
  # last row in boldface and make last row italic
  names(tab) <- pandoc.strong.return(names(tab))
  emphasize.strong.cols(ncol(tab))
  emphasize.strong.rows(nrow(tab))
  set.alignment("right")
  
  return(tab)
}