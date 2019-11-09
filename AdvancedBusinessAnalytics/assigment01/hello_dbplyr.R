# install.packages("dbplyr")

library(dbplyr)
library(DBI)
library(tidyverse)

con <- DBI::dbConnect(RMariaDB::MariaDB(),
                      host="35.223.7.35",
                      user="root",
                      password=rstudioapi::askForPassword("Database Passaport"),
                      dbname="dbtest")

teams <- tbl(con, "team")


teams
