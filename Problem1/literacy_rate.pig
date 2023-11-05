-- Load Maharashtra population data
inputData = LOAD 'resources/MHA_Population_Report.csv' USING PigStorage(',') as 
(CensusYear: int, 
District: chararray, 
Taluka:chararray, 
Town_Village: chararray, 
No_of_households: double, 
Total_population: double, 
Total_male_population: double, 
Total_female_population: double, 
Total_0_to_6_year_children: double, 
Male_0_to_6_year_children: double, 
Female_0_to_6_year_children: double, 
Total_SC_population: double, 
Male_SC_population: double, 
Female_SC_population: double, 
Total_ST_population: double, 
Male_ST_population: double, 
Female_ST_population: double, 
Total_literates: double, 
Male_literates: double,
Female_literates: double, 
Total_iliterates: double, 
Male_iliterates: double, 
Female_iliterates: double, 
Total_main_workers: double, 
Male_main_workers: double, 
Female_main_workers: double, 
Total_non_workers: double, 
Male_non_workers: double, 
Female_non_workers: double);

-- Display schema
DESCRIBE inputData;

-- FILTER data by 2001 and 2011 CensusYears
filteredData = FILTER inputData BY (CensusYear == 2001 OR CensusYear == 2011);

-- Capture only the columns of interest
columns = FOREACH filteredData GENERATE District, CensusYear, Total_literates, Total_population;

-- GROUP BY District and CensusYear
groupByDistrictCensusYear = GROUP columns BY (District, CensusYear);

-- Compute SUM of literates and population of the grouped, using the sums calculate literacy rate
literacyRate = FOREACH groupByDistrictCensusYear {
    literates_sum = SUM(columns.Total_literates); 
    population_sum = SUM(columns.Total_population); 
    GENERATE group, (float)(literates_sum/population_sum*100) as literacy_count;
};

-- Store the output ((District, CensusYear), LiteracyRate) into a file
STORE literacyRate INTO 'literacy_rate_out';