CREATE PROCEDURE [etl].[InitCalendarDim]
	@StartDate date
	,@EndDate date
AS

with cte_dates as 
(
	select YEAR(@StartDate) * 10000 + MONTH(@StartDate) * 100 + DAY(@StartDate) as CalendarKey
		,CAST(@StartDate as date) as DateName
		,DATEPART(weekday, @StartDate) as DayOfWeek
		,DATENAME(weekday, @StartDate) as WeekdayName
		,DATEPART(WEEK, @StartDate) as WeekOfYear
		,CONCAT(YEAR(@StartDate), '-', DATEPART(WEEK, @StartDate)) as WeekName
		,DATEPART(DAY, @StartDate) as DayOfMonth
		,DATEPART(MONTH, @StartDate) as MonthOfYear
		,DATENAME(MONTH, @StartDate) as MonthName
		,DATEPART(QUARTER, @StartDate) as QuarterOfYear
		,CONCAT(YEAR(@StartDate), ' Q', DATEPART(QUARTER, @StartDate)) as QuarterName
		,DATEPART(dayofyear, @StartDate) as DayOfYear
		,DATEPART(YEAR, @StartDate) as Year
		,CASE DATENAME(weekday, @StartDate) 
			WHEN 'Saturday' THEN 1
			WHEN 'Sunday' THEN 1
			ELSE 0 END as IsWeekDay
	UNION ALL
	select YEAR(DATEADD(day, 1, DateName)) * 10000 + MONTH(DATEADD(day, 1, DateName)) * 100 + DAY(DATEADD(day, 1, DateName))
		,DATEADD(day, 1, DateName)
		,DATEPART(weekday, DATEADD(day, 1, DateName))
		,DATENAME(weekday, DATEADD(day, 1, DateName))
		,DATEPART(WEEK, DATEADD(day, 1, DateName))
		,CONCAT(YEAR(DATEADD(day, 1, DateName)), '-', DATEPART(WEEK, DATEADD(day, 1, DateName)))
		,DATEPART(day, DATEADD(day, 1, DateName))
		,DATEPART(MONTH, DATEADD(day, 1, DateName))
		,DATENAME(MONTH, DATEADD(day, 1, DateName))
		,DATEPART(QUARTER, DATEADD(day, 1, DateName))
		,CONCAT(YEAR(DATEADD(day, 1, DateName)), ' Q', DATEPART(QUARTER, DATEADD(day, 1, DateName)))
		,DATEPART(dayofyear, DATEADD(day, 1, DateName))
		,DATEPART(YEAR, DATEADD(day, 1, DateName))
		,CASE DATENAME(weekday, DATEADD(day, 1, DateName))
			WHEN 'Saturday' THEN 1
			WHEN 'Sunday' THEN 1
			ELSE 0 END 
	from cte_dates
	where DateName < @EndDate
) 
insert into dim.Calendar
(
	CalendarKey
	,DateName
	,DayOfWeek
	,WeekdayName
	,WeekOfYear
	,WeekName
	,DayOfMonth
	,MonthOfYear
	,MonthName
	,QuarterOfYear
	,QuarterName
	,DayOfYear
	,Year
	,IsWeekday
	,CreatedDate
)
select *
	,GETDATE() as CreatedDate
from cte_dates
option (MAXRECURSION 20000)


