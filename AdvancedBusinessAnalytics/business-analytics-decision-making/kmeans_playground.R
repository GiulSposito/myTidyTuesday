library(tidyverse)
library(xlsx)

market <- read.xlsx("./AdvancedBusinessAnalytics/business-analytics-decision-making/Market_Segmentation_XLMiner.xlsx",
                    sheetIndex = 1, startRow = 3, header = T) %>% 
  as_tibble() %>% 
  filter(complete.cases(.))

scl <- market %>% 
  select(-Customer) %>% 
  scale()

str(scl)

clusters <- 1:10 %>% 
  map(function(.x,.dt) kmeans(.dt,.x), .dt=scl)

clusters %>% 
  map_dbl( function(.k) return(.k$tot.withinss)) %>% 
  plot(type="l")


