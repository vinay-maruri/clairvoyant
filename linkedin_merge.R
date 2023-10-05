library(tidyverse)


comp_df_1 <- read.csv("~/clairvoyant/company_details/companies.csv")
comp_df_2 <- read.csv("~/clairvoyant/company_details/company_industries.csv")
comp_df_3 <- read.csv("~/clairvoyant/company_details/company_specialities.csv")
comp_df_4 <- read.csv("~/clairvoyant/company_details/employee_counts.csv")

job_df_1 <- read.csv("~/clairvoyant/job_details/benefits.csv")
job_df_2 <- read.csv("~/clairvoyant/job_details/job_industries.csv")
job_df_3 <- read.csv("~/clairvoyant/job_details/job_skills.csv")
job_df_4 <- read.csv("~/clairvoyant/job_postings.csv")


job_combined_df <- merge(job_df_4, merge(job_df_3, merge(job_df_2, job_df_1, by = "job_id"), by = "job_id"), by = "job_id")

rm(job_df_1, job_df_2, job_df_3, job_df_4)


df_1 <- merge(comp_df_2, comp_df_1, by = "company_id")
df_2 <- merge(df_1, comp_df_3, by = "company_id")

df_2_wide <- df_2 %>% 
  group_by(company_id, industry, name, description, company_size, state, country, city, zip_code, address, url) %>%
  summarise(specialties = list(unique(speciality)))

df_3 <- merge(df_2_wide, subset(comp_df_4, select = c(company_id, employee_count)), by = "company_id")

comp_combined_df <- distinct(df_3)


merged_df <- merge(job_combined_df, comp_combined_df, by = "company_id")

data.table::fwrite(merged_df, "~/clairvoyant/merged_linkedin.csv")

