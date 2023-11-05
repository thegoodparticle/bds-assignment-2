inputData = LOAD 'resources/MHA_Population_Report.csv' USING PigStorage(',');

filteredData = FILTER inputData BY ($0 == '2001' OR $0 == '2011');

columns = FOREACH filteredData GENERATE (chararray) $1 AS city, (chararray) $0 AS census_year, (float) $17 AS literates, (float) $5 AS population;

groupByCityYear = GROUP columns BY (city, census_year);

literacyCount = FOREACH groupByCityYear {literates_sum = SUM(columns.literates); population_sum = SUM(columns.population); GENERATE group, (float)(literates_sum/population_sum*100) as literacy_count;};

STORE literacyCount INTO 'literacy_rate_out';