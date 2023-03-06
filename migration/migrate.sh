#! /bin/bash

# 2021_LFS Data Sheet finalv2
ssconvert --export-type=Gnumeric_stf:stf_csv --export-file-per-sheet "data/2021_LFS Data Sheet finalv2.xlsx" "data/2021_LFS Data Sheet finalv2-%s.csv"
cat "data/2021_LFS Data Sheet finalv2-Industry Profiles.csv" | php csv_extract.php --range 5-23 | php csv_refill.php --col 7 --col 8 --col 11 --col 14 --col 17 --col 20 --col 23 --col 26 --col 29 --col 32 --col 35 --col 38 --col 41 --col 43 --col 45 --col 47 --col 49 --col 51 --col 53 --col 55 > "load/labour_force_survey_industry.csv"
cat "data/2021_LFS Data Sheet finalv2-Regional Profiles.csv" | php csv_extract.php --range 6-13 > "load/labour_force_survey_regional_employment.csv"
cat "data/2021_LFS Data Sheet finalv2-Regional Profiles.csv" | php csv_extract.php --range 20-27 > "load/labour_force_survey_regional_industry_region.csv"
cat "data/2021_LFS Data Sheet finalv2-Regional Profiles.csv" | php csv_extract.php --range 34-41 > "load/labour_force_survey_regional_industry_province.csv"

# 2022 HOO BC and Region for new tool
ssconvert --export-type=Gnumeric_stf:stf_csv --export-file-per-sheet "data/2022 HOO BC and Region for new tool.xlsx" "data/2022 HOO BC and Region for new tool-%s.csv"
cat "data/2022 HOO BC and Region for new tool-Sheet1.csv" | php csv_extract.php --range 2 > "load/high_opportunity_occupations.csv"

# 3.3.1_WorkBC_Career_Profile_Data_2022-2032
ssconvert --export-type=Gnumeric_stf:stf_csv --export-file-per-sheet "data/3.3.1_WorkBC_Career_Profile_Data_2022-2032.xlsx" "data/3.3.1_WorkBC_Career_Profile_Data_2022-2032-%s.csv"
cat "data/3.3.1_WorkBC_Career_Profile_Data_2022-2032-Regional Outlook.csv" | php csv_extract.php --range 5 > load/career_regional.csv
cat "data/3.3.1_WorkBC_Career_Profile_Data_2022-2032-Provincial Outlook.csv" | php csv_extract.php --range 4 > load/career_provincial.csv

# 3.3.2_WorkBC_Industry_Profile_2022-2032_revised_Feb24
ssconvert --export-type=Gnumeric_stf:stf_csv --export-file-per-sheet "data/3.3.2_WorkBC_Industry_Profile_2022-2032_revised_Feb24.xlsx" "data/3.3.2_WorkBC_Industry_Profile_2022-2032_revised_Feb24-%s.csv"
cat "data/3.3.2_WorkBC_Industry_Profile_2022-2032_revised_Feb24-BC.csv" | php csv_extract.php --range 4 > load/industry_outlook.csv

# 3.3.3_WorkBC_Regional_Profile_Data_2022-2032_FINAL_Nov25
ssconvert --export-type=Gnumeric_stf:stf_csv --export-file-per-sheet "data/3.3.3_WorkBC_Regional_Profile_Data_2022-2032_FINAL_Nov25.xlsx" "data/3.3.3_WorkBC_Regional_Profile_Data_2022-2032_FINAL_Nov25-%s.csv"
cat "data/3.3.3_WorkBC_Regional_Profile_Data_2022-2032_FINAL_Nov25-Regional Profiles - LMO.csv" | php csv_extract.php --range 5 > load/regional_labour_market_outlook.csv
cat "data/3.3.3_WorkBC_Regional_Profile_Data_2022-2032_FINAL_Nov25-Top Industries.csv" | php csv_extract.php --range 5 | php csv_empty.php > load/regional_top_industries.csv
cat "data/3.3.3_WorkBC_Regional_Profile_Data_2022-2032_FINAL_Nov25-Top Occupation.csv" | php csv_extract.php --range 5 | php csv_empty.php > load/regional_top_occupations.csv

# 2022 HOO BC and Region for new tool
ssconvert --export-type=Gnumeric_stf:stf_csv --export-file-per-sheet "data/2022 HOO BC and Region for new tool.xlsx" "data/2022 HOO BC and Region for new tool-%s.csv"
cat "data/2022 HOO BC and Region for new tool-Sheet1.csv" | php csv_extract.php --range 2 > load/high_opportunity_occupations.csv

# 2021 BC Population Distribution
ssconvert --export-type=Gnumeric_stf:stf_csv --export-file-per-sheet "data/2021 BC Population Distribution.xlsx" "data/2021 BC Population Distribution-%s.csv"
cat "data/2021 BC Population Distribution-Region Population Estimates.csv" | php csv_extract.php --range 3-11 > load/population.csv

# Load all data in the database.
for f in load/*.load; do pgloader -l workbc.lisp "$f"; done
psql -c 'TRUNCATE monthly_labour_market_updates'
for f in load/updates/*.csv; do SOURCE="/app/$f" pgloader -l workbc.lisp load/updates/monthly_labour_market_updates.load; done
