
--- FULL SCRIPT ---

-- 1. Full excecution to check columns.

SELECT * FROM [Hotel Revenue].[dbo].[2018]
SELECT * FROM [Hotel Revenue].[dbo].[2019]
SELECT * FROM [Hotel Revenue].[dbo].[2020]

-- 2. Column homogeinity, so we apply Union. 

SELECT * FROM [Hotel Revenue].[dbo].[2018]
UNION
SELECT * FROM [Hotel Revenue].[dbo].[2019]
UNION
SELECT * FROM [Hotel Revenue].[dbo].[2020]

--> We get a unified dataset.

-- 3. Make a Temporary Table out of our previous Query.

SELECT * 
	INTO #HotelsUnions
FROM 
(
SELECT * FROM [Hotel Revenue].[dbo].[2018]
UNION
SELECT * FROM [Hotel Revenue].[dbo].[2019]
UNION
SELECT * FROM [Hotel Revenue].[dbo].[2020]) a

-- 4. TempTable > Permanent Table


SELECT *
INTO dbo.Hotels_Unions
FROM #HotelsUnions

-- Lets print it:

select * from [Hotel Revenue].[dbo].[Hotels_Unions]


-- Before exporting for
--   Further analysis and visualizations, we 
--    try to increase our understanding. 

--- Exploratory Data Analysis (EDA) ---

-- 5. Is the hotel revenue growing by year? 
--    No Revenue column !
--     Instead: "ADR" and "Stays" columns. 

SELECT
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as Revenue
from [Hotel Revenue].[dbo].[Hotels_Unions]
group by arrival_date_year, hotel
order by Revenue

-- Observation: 2020 is incomplete, so the revenue is reasonable.

-- We also want this column to be present in our table, so 
--   in table>desing, we make a new computed column 'Calculated Revenue' with the formula
--     stated above: (stays_in_week_nights+stays_in_weekend_nights)*adr

-- 6. We want to make use of our "Market Segment" Table.

select * 
from [Hotel Revenue].[dbo].[Hotels_Unions]
left join 
[Hotel Revenue].[dbo].[market_segments]
ON
[Hotel Revenue].[dbo].[Hotels_Unions].market_segment = 
[Hotel Revenue].[dbo].[market_segments].market_segment

-- 6. We also want to make use of our "Meal Costs" Table, and as ready, we create a view of it,
--    so we can from now on run queries to our complete data.


select * 
from [Hotel Revenue].[dbo].[Hotels_Unions]
left join 
[Hotel Revenue].[dbo].[market_segments] ON [Hotel Revenue].[dbo].[Hotels_Unions].market_segment = [Hotel Revenue].[dbo].[market_segments].market_segment
left join 
[Hotel Revenue].[dbo].[meal_costs] ON  [Hotel Revenue].[dbo].[meal_costs].[meal] = [Hotel Revenue].[dbo].[Hotels_Unions].meal;

-- Exported as XLSX and re-imported.



-- Now that we have a full dataset, we proceed to run some exploratory queries

-- 1. Gain knowleade over Week vs Weekends stays


select hotel, arrival_date_year, SUM (stays_in_week_nights) as Week , SUM (stays_in_weekend_nights) as Weekend 
FROM [Hotel Revenue].[dbo].[All]
group by hotel, arrival_date_year





SELECT
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as Revenue
from [Hotel Revenue].[dbo].[Hotels_Unions]
group by arrival_date_year, hotel
order by Revenue