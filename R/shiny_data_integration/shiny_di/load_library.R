# load and if needed install package(s)
# 
# Author: lbeaulaton
###############################################################################

#' @title Load library
#' @description load and if needed install package(s)
#' @param library name of the library/ries to be loaded
load_library = function(library)
{
	if(!all(library %in% installed.packages()[, 'Package']))
		install.packages(library[!library %in% installed.packages()[, 'Package']], dep = T)
	for(i in 1:length(library))
		require(library[i], character.only = TRUE)
}

#' @title load_package function, same as above but individual, and not using installed.packages
#' @description load and if needed install package(s)
#' @param x name of the library/ries to be loaded
load_package <- function(x)
{
  if (!is.character(x)) stop("Package should be a string")
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}