
## This script is for the web scraping of the expected goals and assists data.


library(tidyverse)
library(rvest)

url = "https://fbref.com/en/share/RgcBw"           # Need a better way of getting the data rather than constantly regenerating the table.



xp_data = read_html(url) %>%
  html_nodes("table") %>%
  html_table(header=FALSE)

xp_data = xp_data[[1]]

colnames(xp_data)=paste(xp_data[1,],xp_data[2,])

xp_data = as_tibble(xp_data)

xp_data = janitor::clean_names(xp_data)

xp_data = slice(xp_data,-(1:2)) %>%
  filter(rk != "Rk")

colnames(xp_data) = gsub("performance","true",colnames(xp_data) )
colnames(xp_data) =   gsub("expected_","", colnames(xp_data))


xp_data = xp_data %>%
  select( -rk,-starts_with("per_90") ,-(nation:born) , -contains("_crd_"),-matches ) 

xp_data[,2:11] <- sapply(xp_data[,2:11],as.numeric)


xp_data = xp_data %>%
  mutate( playing_mins_per_match =  round(playing_time_min/playing_time_mp),
          true_att_returns = true_gls + true_ast,
          true_npg = true_gls - true_pk,
          true_att_npg_returns = true_npg + true_ast,
          perf_diff_true_goals = true_gls - x_g,
          perf_diff_npgoals = true_npg - npx_g,
          perf_diff_assist = true_ast - x_a,
          xp_att_returns = x_g + x_a,
          xp_att_npg = npx_g + x_a,
          perf_diff_att_returns = true_att_returns - xp_att_returns,
          perf_diff_att_npg = true_att_npg_returns - xp_att_npg,
          )


saveRDS(xp_data,file="xp_data.rds")



