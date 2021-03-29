# load packages and APIs ----
library(pacman)
p_load(gtrendsR,tidyverse,statebins)

# get the search terms ----
search_terms_0 <- c("COVID Symptoms","Coronavirus Symptoms","Sore Throat","Shortness of Breath","Fatigue")
search_terms_1 <-  c( "Cough", "Corona Virus Testing Centers", "Loss of Smell", "Lysol","Antibodies")
search_terms_2 <- c("Face Masks","Coronavirus Vaccine","COVID Stimulus Check")

result_0 = gtrends(keyword=search_terms_0, geo=c("US"), "2020-01-01 2020-12-01") 
result_1 = gtrends(keyword=search_terms_1, geo=c("US"), "2020-01-01 2020-12-01") 
result_2 = gtrends(keyword=search_terms_2, geo=c("US"), "2020-01-01 2020-12-01") 

# get the interest over time ---- 
data_0 <- result_0$interest_over_time
data_1 <- result_1$interest_over_time
data_2 <- result_2$interest_over_time

# get the region ----
region_0 <- result_0$interest_by_region 
region_1 <- result_1$interest_by_region 
region_2 <- result_2$interest_by_region 

# combine the three data sets ---- 
data <- data_0 %>% full_join(data_1) %>% full_join(data_2)
region <- region_0 %>% full_join(region_1) %>% full_join(region_2)

# clean up the directory ----
if(exists("data")) {rm("data_0","data_1","data_2")}
if(exists("region")) {rm("region_0","region_1","region_2")}

# subset out what we need from the datasets ---- 
trend <- data %>% 
  select(date,hits,keyword) %>% 
  mutate_at("hits", ~ifelse(. == "<1", 0.5, .)) %>% 
  mutate_at("hits", ~as.numeric(.)) 

if(exists("trend")) {rm(data)}
