use climate_change;

-- 1. Simple Analysis -----------------------------------
-- Monthely temperature Trends
select monthname(Date) as month_name, 
	round(avg(Temperature)) as avg_temp
from Combined_Data
group by monthname(Date), month_name
order by monthname(Date);


-- Extreme Weather Events by Temperature Range
select 
	case 
		when Temperature < 10 then 'Very Cold(<10C)'
        when Temperature between 10 and 15 then 'Cold(10C-15C)'
        when Temperature between 15 and 20 then 'Moderate(15C-20C)'
        when Temperature between 20 and 25 then 'Warm(20C-25C)'
        else 'Hot(>25C)'
	end as Temperature_Range, 
	Extreme_Weather_Events, 
	count(*) as Event_Count
from Combined_Data
where Extreme_Weather_Events <>'None'
group by Temperature_Range, Extreme_Weather_Events
order by Temperature_Range, Event_Count desc;





-- Top 5 Air Quality Health Risks
select 
    Country,
	City, 
	truncate(avg(Air_Quality_Index), 0) as 'Average AQI',
	count(*) as 'Days above AQI', 
	sum(Population_Exposure) as 'Total Population Exposure', 
	round(avg(Temperature), 1) as 'Average Temperature'
from Combined_Data
where Date between '2025-03-03' and '2025-03-17'
group by Country, City
having avg(Air_Quality_Index) > 100
order by avg(Air_Quality_Index) desc
limit 5;






create index idx_date on Combined_Data(Date); 
create index idx_geo_temp on Combined_Data(Country, City, Temperature);

-- 2. Reporting Layer     ----------------------------------------------------------------------------

-- which cities are experiencing extreme weather events this week? 
--  and what are their economic and population impacts?(every week)
create or replace view weekly_risk_report as
select 
    Country,
	City, 
    Extreme_Weather_Events,
    count(*) as 'Event Type',
    round(AVG(Temperature), 1) as 'Average Temperature',
	sum(Population_Exposure) as 'Total Population Exposure', 
    sum(Economic_Impact_Estimate) as 'Total Economic Impact', 
    truncate(avg(Infrastructure_Vulnerability_Score), 0) as 'Average Vulnerability Score'
from Combined_Data
where (Date between '2025-03-03' and '2025-03-09')  -- or (Date BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE())
	and Extreme_Weather_Events != 'None'
group by Country, City, Extreme_Weather_Events
order by sum(Economic_Impact_Estimate) desc;


-- which biome types are most risk from extreme weather events this week?(every week)
create or replace view biome_analysis as
select Biome_Type, 
	count(*) as total_disaster_events,
    count(distinct case when Extreme_Weather_Events != 'None' then concat(Country, City) end) as 'Impacted Locations',
    sum(case when Extreme_Weather_Events != 'None' then 1 else 0 end) as 'Extreme Weather Count',
    group_concat(distinct 
		case when Extreme_Weather_Events != 'None' then Extreme_Weather_Events end
        separator ', ') as 'Event Types',
    sum(Economic_Impact_Estimate) as total_economic_loss,
    truncate(avg(Air_Quality_Index), 0) as avg_biome_aqi, 
    truncate(avg(Infrastructure_Vulnerability_Score), 0) as avg_structural_risk
from Combined_Data
where Date between '2025-03-03' and '2025-03-09'
group by Biome_Type
order by total_economic_loss desc;





-- 3. ADVANCED ANALYTICS LAYER----------------------------------------------------

/* the 'heat-health' risk index */
create or replace view advanced_city_risk_index as
with CityAverages as (
	select Country, 
		City, 
        avg(Air_Quality_Index) as avg_AQI, 
        avg(Temperature) as avg_TEMP, 
        avg(Infrastructure_Vulnerability_Score) as avg_Vulnerability, 
        sum(Population_Exposure) as total_POP
	from Combined_Data
    where Date between '2025-03-01' and '2025-03-31'
    group by Country, City
)
select Country,  -- applying the weights to create the score
	City, 
    round((avg_AQI * 0.4) + 
		(avg_TEMP * 1.5) +  
        (avg_Vulnerability * 2.5), 2) as climate_vulnerability_score
from CityAverages
order by climate_vulnerability_score desc;


/* The Extreme Deviation & Trend Monitor
Find the "Climate Outliers"—the specific days where a city was significantly more dangerous than its surrounding region.*/
create or replace view climate_anomaly_tracker as 
with RegionalBaselines as (
	select Date, 
		Country, 
        City, 
        Temperature, 
        Air_Quality_Index, 
        avg(Temperature) over(partition by Country) as national_avg_temp, 
        avg(Air_Quality_Index) over(partition by City order by Date rows between 2 preceding and current row) as rolling_3day_aqi
	from Combined_Data
)
select *, 
    round(Temperature - national_avg_temp, 2) as temp_deviation_from_national, 
    case 
		when(Temperature - national_avg_temp) > 7 then 'Extreme Heat Anomaly'
		when(Temperature - national_avg_temp) > 4 then 'Moderate Heat Anomaly'
        else 'Normal Range'
	end as thermal_status
from RegionalBaselines
where Date between '2025-03-01' and '2025-03-31'
order by temp_deviation_from_national desc;
    
      
      

      
      
-- 4. UTILITY LAYER ------------------------------------------------------------------------------
-- The Dynamic Reporting Procedure
delimiter //
create procedure GetTopMetricReport(in metricName varchar(64), in topLimit int)
begin 
	set @query = concat(
		'select Country, City, round(avg(', metricName, ') 2) as performance_value', 
        'from Combined_Data ', 
        'group by Country, City ', 
        'order by performance_value desc ', 
        'limit ', topLimit
	);
    prepare stmt from @query; 
    execute stmt; 
    deallocate prepare stmt;
end //
delimiter ;


/* The Modular Risk Function & Correlated Subquery */
delimiter //
create function DetermineHeatRisk(temp decimal(10, 2))
returns varchar(20)
deterministic
begin
	declare risk_label varchar(20); 
    if temp > 30 then set risk_label = 'EXTREME'; 
    elseif temp > 20 then set risk_label = 'MODERATE'; 
    else set risk_label = 'LOW'; 
    end if; 
    return risk_label; 
end //

delimiter ;
select 
	c1.Date, 
    c1.Country, 
    c1.City, 
    c1.Temperature, 
    fn_DetermineHeatRisk(c1.Temperature) as heat_risk_status, 
    (select round(avg(Temperature), 2)
    from Combined_Data c2
    where c2.Country = c1.Country) as national_day_avg
from Combined_Data c1
where c1.Date = '2025-03-09'
and c1.Temperature > (
	select avg(Temperature) from Combined_Data c3 where c3.Country = c1.Country)
order by c1.Temperature desc;


      
