--_______________________________________________________________


--_______________________________________________________________

-- 1. 
----- Importing all the raw data

select * from [dbo].[Sales]

--_______________________________________________________________

-- 2. 
---- Importing unique cities, year, etc. from the raw data

select distinct CITY from [dbo].[Sales]
select distinct year_id from [dbo].[Sales]
select distinct status from [dbo].[Sales]
select distinct PRODUCTLINE from [dbo].[Sales]
select distinct COUNTRY from [dbo].[Sales]
select distinct DEALSIZE from [dbo].[Sales]
select distinct TERRITORY from [dbo].[Sales]

--_______________________________________________________________

-- 3. 
---- Analysis of YEAR_ID using their corresponding sales revenue
---- Arranged by descending order of sales revenue
---- To find out which year brought in the highest sales revenue

select YEAR_ID, sum(sales) as Revenue
from [dbo].[Sales]
group by YEAR_ID
order by 2 desc

--_______________________________________________________________

-- 4.
---- Explore possible reasons why 2005 brought in the least sales revenue
---- Possibly due to operating only 5 months in 2005

select distinct MONTH_ID from [dbo].[Sales]
where YEAR_ID = 2005

--_______________________________________________________________

-- 5. 
---- Analysis of PRODUCTLINE using their corresponding sales revenue
---- Arranged by descending order of sales revenue
---- To find out which PRODUCTLINE brought in the highest sales revenue

select PRODUCTLINE, sum(sales) as Revenue
from [dbo].[Sales]
group by PRODUCTLINE
order by 2 desc

--_______________________________________________________________

-- 6.
---- Analysis of DEALSIZE using their corresponding sales revenue
---- Arranged by descending order of sales revenue
---- To find out which DEALSIZE brought in the highest sales revenue

select DEALSIZE, sum(sales) as Revenue
from [dbo].[Sales]
group by DEALSIZE
order by 2 desc

--_______________________________________________________________

-- 7.
---- Analysis of sales revenue using month and sales figures for a particular year
---- Arranged by descending order of sales revenue
---- To find out which month of a particular year made the most revenue
---- To find out the relationship between sales revenue and sales figures

select MONTH_ID, sum(sales) as Revenue, count(ORDERNUMBER) as SalesFigures
from [PortfolioProject3].[dbo].[Sales]
where YEAR_ID = 2004
group by MONTH_ID
order by 2 desc

--_______________________________________________________________

-- 8.
---- From 7., we found out that November seems to be the month that brings in the most revenue
---- To find out which PRODUCTLINE is closely associated with the month of November

select MONTH_ID, PRODUCTLINE, sum(sales) as Revenue, count(ORDERNUMBER) as SalesFigures
from [PortfolioProject3].[dbo].[Sales]
where YEAR_ID = 2004 and MONTH_ID = 11
group by MONTH_ID, PRODUCTLINE
order by 3 desc

--_______________________________________________________________

-- 9.
---- Using the RFM (Recency-Frequency-Monetary) Framework for analysis
---- To find out the most recent order of customers
---- To find out how often customers purchase the products
---- To find out how much customers spend
---- To find out the 'best' customer by segmentation and categorisation

DROP TABLE IF EXISTS #RFM
; with RFM as
(
	select
		CUSTOMERNAME,
		sum(sales) as MonetaryValue,
		avg(sales) as AvgMonetaryValue,
		count(ORDERNUMBER) as SalesFigures,
		MAX(ORDERDATE) as MostRecentOrder,
		(select MAX(ORDERDATE) from [dbo].[Sales]) as FinalDateProvided,
		DATEDIFF(DD, MAX(ORDERDATE), (select MAX(ORDERDATE) from [dbo].[Sales])) as DaysFromMostRecentOrder
	from [PortfolioProject3].[dbo].[Sales]
	group by CUSTOMERNAME
),

RFM_Calc as
(
	select r.*,
		NTILE(4) OVER (order by DaysFromMostRecentOrder desc) as RFM_Recency,
		NTILE(4) OVER (order by SalesFigures) as RFM_Frequency,
		NTILE(4) OVER (order by MonetaryValue) as RFM_Monetary
	from RFM r
)
select c.*, (RFM_Recency + RFM_Frequency + RFM_Monetary) as RFM_Cell,
cast(RFM_Recency as varchar) + cast(RFM_Frequency as varchar) + cast(RFM_Monetary as varchar) as RFM_Cell_String
into #RFM
from RFM_Calc c

select CUSTOMERNAME, RFM_Recency, RFM_Frequency, RFM_Monetary,
	case
		when RFM_Cell_String in (111, 112, 121, 122, 123, 132, 211, 212, 114, 141) then 'Lost Customers'
		when RFM_Cell_String in (133, 134, 143, 244, 334, 343, 344, 144) then 'Slipping away, cannot lose'
		when RFM_Cell_String in (311, 411, 412, 331) then 'New Customers'
		when RFM_Cell_String  in (221, 222, 223, 232, 233, 234, 322) then 'Potential Churners'
		when RFM_Cell_String in (323, 333, 321, 422, 421, 332, 423, 432) then 'Active Customers'
		when RFM_Cell_String in (433, 434, 443, 444) then 'Loyal Customers'
	end RFM_Segment
from #RFM

--_______________________________________________________________

-- 10.
---- To find out the combination of products that are often purchased together

select distinct ORDERNUMBER, stuff(

	(select ',' + PRODUCTCODE
	from [dbo].[Sales] as p
	where ORDERNUMBER in
	(
		select ORDERNUMBER
		from (
			select ORDERNUMBER, count(*) rn
			from [PortfolioProject3].[dbo].[Sales]
			where STATUS = 'Shipped'
			group by ORDERNUMBER
		) as m
		where rn = 3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path ('')), 1, 1, '') as ProductCodes

from [dbo].[Sales] as s
order by 2 desc

--_______________________________________________________________
