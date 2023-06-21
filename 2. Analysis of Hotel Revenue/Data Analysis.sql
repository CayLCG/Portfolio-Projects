-- The following SQL code shows the step-by-step analysis of Hotel Revenue up until 2020
-- Each set of code is numbered and should be executed on its own and not together
-- To be used in conjunction with my Power BI figures for data visualisation

--______________________________________________________________________________

-- 1.
---- Import all the 2020 raw data from the excel sheet

select * from dbo.['2020$']

--______________________________________________________________________________

-- 2.
---- Import all the raw data from the excel sheet

select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']

--______________________________________________________________________________

-- 3.
---- Storing all he raw data in a unified table form 
---- We can then easily import data using 'Hotels_Data' instead of typing out all 3 select statements
USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)

--______________________________________________________________________________

-- 4.
---- Notice line 8, instead of typing our all 3 select statements, we can now use 'Hotels_Data' instead
---- Extracting the number of "Stay-ins"
USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)
select stays_in_week_nights + stays_in_weekend_nights from Hotels_Data

--______________________________________________________________________________

-- 5.
---- Shows the Hotel Revenue of the row that the raw data was given
USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)
select (stays_in_week_nights + stays_in_weekend_nights) * adr as Hotel_Revenue from Hotels_Data

--______________________________________________________________________________

-- 6.
---- Shows the Hotel Revenue of the row that the raw data was given and its corresponding year
USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)

select
arrival_date_year,
(stays_in_week_nights + stays_in_weekend_nights) * adr as Hotel_Revenue from Hotels_Data

--______________________________________________________________________________

-- 7.
---- Shows total Hotel Revenue of the corresponding year
---- Sums up all individual Hotel Revenue of a particular year
---- Shows the change in Hotel Revenue over the years
USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)

select
arrival_date_year,
SUM((stays_in_week_nights + stays_in_weekend_nights) * adr) as Hotel_Revenue from Hotels_Data
group by arrival_date_year

--______________________________________________________________________________

-- 8.
---- Shows the total Hotel Revenue of corresponding hotels and their corresponding year
---- Sums up all individual Hotel Revenue of a particular year
---- Shows the change in Hotel Revenue over the years of different hotels
---- Hotel Revenue is rounded to the nearest dollar for ease of visualisation
USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)

select
arrival_date_year,
hotel,
round(SUM((stays_in_week_nights + stays_in_weekend_nights) * adr), 0) as Hotel_Revenue from Hotels_Data
group by arrival_date_year, hotel

--______________________________________________________________________________

-- 9.
---- Inner join operation between "Hotels_Data" and the table "market_segment$" using the "market_segment" column as the 
---- ~ joining condition. The result is a combined result set with columns from both tables
---- Ensures that only the rows with matching market segment values are included in the output.
---- Useful for retrieving the hotel data associated with specific market segments or for analyzing the relationship between the hotel data and market segments

USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)

select * from Hotels_Data
join dbo.market_segment$
on Hotels_Data.market_segment = market_segment$.market_segment

--______________________________________________________________________________

-- 10.
---- It performs a LEFT JOIN operation between "Hotels_Data" and the "market_segment$" table using the "market_segment" column as the joining condition.
---- It performs another LEFT JOIN operation, this time between the result of the previous join and the "meal_cost$" table. The joining condition is based on the "meal" column from the "meal_cost$" table and the "meal" column from the previous join result ("Hotels_Data").
---- This allows for combining relevant information from multiple tables into a single result
---- Provide insights into market segments associated with the hotel data, and the join with the "meal_cost$" table can provide information about the meal costs associated with specific meals.
USE PortfolioProject2

;with Hotels_Data as (
select * from dbo.['2020$']
union
select * from dbo.['2019$']
union
select * from dbo.['2018$']
)

select * from Hotels_Data
left join dbo.market_segment$
on Hotels_Data.market_segment = market_segment$.market_segment
left join dbo.meal_cost$
on meal_cost$.meal	= Hotels_Data.meal
