library(tidyverse)
library(glue)
library(lubridate)

post_tweet <- print

tribble(
    ~local,    ~data_str,    ~mensagem,
    "PUC-Rio", "17/12/2019", "VAMO LÁ PORRA, JÁ TA ACABANDO!!!",
    "UFRJ",    "14/12/2019", "VAMO LÁ PORRA, DIAS MELHORES VIRÃO!!!",
    "UERJ",    "07/12/2019", "AGUENTA VAI, JÁ TA ACABANDO!!!",
    "UFF",     "20/12/2019", "DALE DALE, JÁ TA ACABANDO!!!"
  ) %>% 
  mutate(
    data=dmy(data_str),
    dias_restantes = data-Sys.Date(),
    tweet_text = glue("O ano letivo na {local} acaba em: {data_str}. Falta só {dias_restantes} dias. {mensagem}")
  ) %>% 
  split(1:nrow(.)) %>% 
  map(function(each_row){
    Sys.sleep(1)
    post_tweet(each_row$tweet_text)
  })
  


