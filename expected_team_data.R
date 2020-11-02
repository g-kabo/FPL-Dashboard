
library(tidyverse)
library(rvest)


#url2 = "https://fbref.com/en/comps/9/stats/Premier-League-Stats#stats_standard::none"
url2 = "https://fbref.com/en/comps/9/Premier-League-Stats#all_league_structure"

xp_team_data = read_html(url2) %>%
  html_table()

xp_team_data = xp_team_data[[1]]

xp_team_data = xp_team_data %>%
  janitor::clean_names()%>%
  select(-c(attendance,top_team_scorer,goalkeeper,notes) ) %>%
  as_tibble()


xp_team_data[,4:ncol(xp_team_data)-1] <- sapply(xp_team_data[,4:ncol(xp_team_data)-1],as.numeric)



xp_team_data =  xp_team_data %>%
  mutate(diff_gf = gf - x_g,
         diff_ga = ga - x_ga,
         diff_g_diff = g_diff - x_g_diff,
         gf_per_90 = round(gf/mp,1),
         ga_per_90 = round(ga/mp,1),
         x_gf_per_90 = round(x_g/mp,1),
         x_ga_per_90 = round(x_ga/mp,1),
         perf_diff_gf_per_90 = gf_per_90 - x_gf_per_90,
         perf_diff_ga_per_90 = ga_per_90 - x_ga_per_90,
         g_diff_per_90 = round(g_diff/mp,1),
         x_g_diff_90 = round(x_g_diff_90,1),
         perf_diff_90 = round(g_diff_per_90 - x_g_diff_90,1),
        last_5 =  str_remove_all(last_5," ") 
  )%>% 
  relocate( rk,squad,mp,w,d,l,pts,last_5,
            gf,x_g,diff_gf,
            ga,x_ga,diff_ga,
            g_diff,x_g_diff,diff_g_diff,
            gf_per_90,x_gf_per_90,perf_diff_gf_per_90,
            ga_per_90,x_ga_per_90,perf_diff_ga_per_90,
            g_diff_per_90,x_g_diff_90,perf_diff_90,
            )


saveRDS(xp_team_data,file = "xp_team_data.rds")


