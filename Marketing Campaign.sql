create database Cosmetic;
Use Cosmetic;
select * from campaign_performance;

/*change date column data type in campaign_performance table*/
alter table campaign_performance
modify column date DATE;

select * from keyword_data;

/*change date column data type in keyword_data table*/
alter table keyword_data
modify column date DATE;

/*change date column data type in site_data table*/
alter table site_data
modify column date DATE;

select * from site_data;
/*change date column data type in user_level_sales table*/
alter table user_level_sales
modify column date DATE;

/*Sales volumn and website traffic trends*/
SELECT 
  DATE_FORMAT(date, '%Y-%m') AS month,
  SUM(sales) AS sales,
  SUM(sessions) AS sessions
FROM site_data
WHERE client = 'A'
GROUP BY month;

SELECT 
    DATE_FORMAT(date, '%X-%V') AS week, 
    SUM(sales) AS sales, 
    SUM(sessions) AS sessions 
FROM site_data 
WHERE client = 'A' 
GROUP BY week;

SELECT 
    DATE_SUB(date, INTERVAL WEEKDAY(date) DAY) AS week_start,
    SUM(sales) AS sales, 
    SUM(sessions) AS sessions 
FROM site_data 
WHERE client = 'A' 
GROUP BY week_start;

/* Related keywords Search Volume*/
SELECT 
	date,
    SUM(search_volume) AS searches
FROM keyword_data
WHERE
	LOWER(keyword) IN ('eyeliner', 'lipstick', 'lipgloss', 'eyeshadow', 
    'foundation', 'highlighter', 'eyebrow', 'lotion', 'facewash', 'serum')
GROUP BY date;

/*Campaign Effectiveness by Channel*/
select channel,
		sum(attributed_sales) as revenue,
        sum(conversions)/sum(impressions) as conv_rate,
        sum(attributed_sales)/sum(spend) as ROAS,
        SUM(attributed_sales) - sum(spend) as net_profit
from campaign_performance
where client = 'A'
and date between '2022-01-01' and '2022-12-31'
group by 1;

/* Most Purchased Categories*/
select 
	category,
    round(sum(sales),2) as sales
from user_level_sales
where
	age_group = '35-39'
    and region = 'NY'
    and gender = 'F'
    and brand = 'A'
    and date between '2022-01-01' and '2022-12-31'
    group by 1
    order by sales desc;
    
    /* Average Purchase Frequency*/
    select 
		count(distinct order_id)/count(distinct customer_id) as frequency
	from user_level_sales
    where 
		date between '2022-01-01' and '2022-12-31'
	and age_group = '35-39'
    and region = 'NY'
    and gender = 'F'
    and brand = 'A'
    and sales >0;
    
    /* Average Days Since Last Purchase*/
    WITH previous_date AS 
(
    SELECT 
		date,
        LAG(date) OVER (PARTITION BY customer_id ORDER BY date) AS previous_date
	FROM user_level_sales
    WHERE brand = 'A' 
    AND sales > 0 
    AND age_group = '35-39' 
    AND date BETWEEN '2022-01-01' AND '2022-12-31'
    AND region = 'NY' 
    AND gender = 'F'
)
SELECT 
	AVG(DATEDIFF(date, previous_date)) AS days_since_last_purchase
FROM previous_date
WHERE previous_date IS NOT NULL;

    
    
    
    




