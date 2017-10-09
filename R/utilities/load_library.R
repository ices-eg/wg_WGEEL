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
