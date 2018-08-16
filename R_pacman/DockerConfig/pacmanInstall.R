# Install packages using pacman
pacman::p_install("devtools")
pacman::p_install_version(
  c( "data.table", "plyr", "ggplot2", "httr", "jsonlite", "lubridate", "earth", "geosphere", "lattice", "mda", "optparse", "padr", "rzmq", "stringdist", "tidyr", "tm"),
  c( "1.10.4.-2", "1.8.4", "2.2.1", "1.3.1", "1.5", "1.6.0", "4.5.1", "1.5-5", "0.20-35", "0.4-9", "1.4.4", "0.4.0", "0.9.3", "0.9.4.6", "0.7.2", "0.7-2" )
  )

