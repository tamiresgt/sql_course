-- Join plus Group module
-- Functions learned: LEFT JOIN, RIGTH JOIN, INNER JOIN, FULL JOIN, ANTI JOIN, CROSS JOIN, UNION, UNION ALL, GROUP BY, ORDER BY
-- Database: ContosoRetailDW

-- 1.a Create a grouping showing total sales in quantity by year
select top 100 * from FactSales
select * from DimDate

select
	DimDate.CalendarYear,
	sum( FactSales.SalesQuantity) as 'TotalSales'
from FactSales
left join DimDate on FactSales.DateKey = DimDate.Datekey
group by CalendarYear

--1.b Consider only the month of January

select
	DimDate.CalendarYear,
	sum( FactSales.SalesQuantity) as 'TotalSales'
from FactSales
left join DimDate on FactSales.DateKey = DimDate.Datekey
where CalendarMonthLabel = 'January'
group by CalendarYear



--1.c In the resulting table show only the years with total sales greater than or equal to 120000
select
	DimDate.CalendarYear,
	sum( FactSales.SalesQuantity) as 'TotalSales'
from FactSales
left join DimDate on FactSales.DateKey = DimDate.Datekey
where CalendarMonthLabel = 'January'
group by CalendarYear
having sum( FactSales.SalesQuantity) >= 1200000