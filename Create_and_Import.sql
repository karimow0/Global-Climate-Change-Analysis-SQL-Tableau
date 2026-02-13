create database climate_change; 
USE climate_change;

CREATE TABLE Australia (
    Record_ID VARCHAR(50) PRIMARY KEY, 
    Date DATE, 
    Country VARCHAR(100), 
    City VARCHAR(100), 
    Temperature FLOAT, 
    Humidity INT,
    Precipitation FLOAT, 
    Air_Quality_Index INT, 
    Extreme_Weather_Events VARCHAR(50), 
    Climate_Classification VARCHAR(50),
    Climate_Zone VARCHAR(50), 
    Biome_Type VARCHAR(50), 
    Heat_Index FLOAT, 
    Wind_Speed FLOAT, 
    Wind_Direction VARCHAR(50), 
    Season VARCHAR(50), 
    Population_Exposure BIGINT, 
    Economic_Impact_Estimate BIGINT, 
    Infrastructure_Vulnerability_Score INT
); 
CREATE TABLE USA LIKE Australia; 
CREATE TABLE Brazil LIKE Australia; 
CREATE TABLE Canada LIKE Australia;
CREATE TABLE Germany LIKE Australia; 
CREATE TABLE India LIKE Australia; 
CREATE TABLE South_Africa LIKE Australia;

-- Loading all files:
load data local infile "/Users/karimov/Developer/Data-Analytics-Portfolio/climat_change_project/data/australia_climate_data.csv"
into table Australia
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(Record_ID, @v_DATE, Country, City, Temperature, Humidity, Precipitation, Air_Quality_Index, Extreme_Weather_Events, Climate_Classification, Climate_Zone, Biome_Type, Heat_Index, Wind_Speed, Wind_Direction, Season, Population_Exposure, Economic_Impact_Estimate, Infrastructure_Vulnerability_Score)
set Date = str_to_date(@v_Date, '%m/%d/%Y');

load data local infile "/Users/karimov/Developer/Data-Analytics-Portfolio/climat_change_project/data/usa_climate_data.csv"
into table USA
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(Record_ID, @v_DATE, Country, City, Temperature, Humidity, Precipitation, Air_Quality_Index, Extreme_Weather_Events, Climate_Classification, Climate_Zone, Biome_Type, Heat_Index, Wind_Speed, Wind_Direction, Season, Population_Exposure, Economic_Impact_Estimate, Infrastructure_Vulnerability_Score)
set Date = str_to_date(@v_Date, '%m/%d/%Y');
    
    
load data local infile "/Users/karimov/Developer/Data-Analytics-Portfolio/climat_change_project/data/brazil_climate_data.csv"
into table Brazil
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(Record_ID, @v_DATE, Country, City, Temperature, Humidity, Precipitation, Air_Quality_Index, Extreme_Weather_Events, Climate_Classification, Climate_Zone, Biome_Type, Heat_Index, Wind_Speed, Wind_Direction, Season, Population_Exposure, Economic_Impact_Estimate, Infrastructure_Vulnerability_Score)
set Date = str_to_date(@v_Date, '%m/%d/%Y');

load data local infile "/Users/karimov/Developer/Data-Analytics-Portfolio/climat_change_project/data/canada_climate_data.csv"
into table Canada
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(Record_ID, @v_DATE, Country, City, Temperature, Humidity, Precipitation, Air_Quality_Index, Extreme_Weather_Events, Climate_Classification, Climate_Zone, Biome_Type, Heat_Index, Wind_Speed, Wind_Direction, Season, Population_Exposure, Economic_Impact_Estimate, Infrastructure_Vulnerability_Score)
set Date = str_to_date(@v_Date, '%m/%d/%Y');

load data local infile "/Users/karimov/Developer/Data-Analytics-Portfolio/climat_change_project/data/germany_climate_data.csv"
into table Germany
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(Record_ID, @v_DATE, Country, City, Temperature, Humidity, Precipitation, Air_Quality_Index, Extreme_Weather_Events, Climate_Classification, Climate_Zone, Biome_Type, Heat_Index, Wind_Speed, Wind_Direction, Season, Population_Exposure, Economic_Impact_Estimate, Infrastructure_Vulnerability_Score)
set Date = str_to_date(@v_Date, '%m/%d/%Y');
    
load data local infile "/Users/karimov/Developer/Data-Analytics-Portfolio/climat_change_project/data/india_climate_data.csv"
into table India
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(Record_ID, @v_DATE, Country, City, Temperature, Humidity, Precipitation, Air_Quality_Index, Extreme_Weather_Events, Climate_Classification, Climate_Zone, Biome_Type, Heat_Index, Wind_Speed, Wind_Direction, Season, Population_Exposure, Economic_Impact_Estimate, Infrastructure_Vulnerability_Score)
set Date = str_to_date(@v_Date, '%m/%d/%Y');

load data local infile "/Users/karimov/Developer/Data-Analytics-Portfolio/climat_change_project/data/south_africa_climate_data.csv"
into table South_Africa
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(Record_ID, @v_DATE, Country, City, Temperature, Humidity, Precipitation, Air_Quality_Index, Extreme_Weather_Events, Climate_Classification, Climate_Zone, Biome_Type, Heat_Index, Wind_Speed, Wind_Direction, Season, Population_Exposure, Economic_Impact_Estimate, Infrastructure_Vulnerability_Score)
set Date = str_to_date(@v_Date, '%m/%d/%Y');


-- creating combined data: joining all tables
create table Combined_Data as
select * from Australia
union
select * from Brazil
union
select * from Canada
union 
select * from India
union
select * from Germany
union
select * from South_Africa
union
select * from USA; 