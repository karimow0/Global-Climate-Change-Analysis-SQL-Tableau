use climate_change;
SELECT Record_ID, COUNT(*)
FROM Combined_Data
GROUP BY Record_ID
HAVING COUNT(*) > 1;

select distinct Country 
from Combined_Data;
update Combined_Data
set Coutnry = India
where Country = Inda; -- type correction for country names


SELECT * FROM Combined_Data
where Record_ID is null or Record_ID=''   -- checking and updating any null or empty values
	or 'Date' is null or 'Date' = ''
    or Country is null or Country = ''
    or City is null or City = '';
update Combined_Data
set City = 'Toronto'
where Record_ID = 'cnd_227';

select * from Combined_Data
where Temperature is null 
    or Humidity is null 
    or Precipitation is null 
    or Air_Quality_Index is null;
select * from Combined_Data
where Extreme_Weather_Events is null
    or Climate_Classification is null or Climate_Classification=''
    or Climate_Zone is null 
    or Biome_Type is null
    or Heat_Index is null 
    or Wind_Speed is null 
    or Wind_Direction is null 
    or Season is null or Season=''
    or Population_Exposure is null or Population_Exposure=''
    or Economic_Impact_Estimate is null or Economic_Impact_Estimate=''
    or Infrastructure_Vulnerability_Score is null ;
update Combined_Data 
set Population_Exposure = 5275135
where Record_ID = 'aus_1338';
    
