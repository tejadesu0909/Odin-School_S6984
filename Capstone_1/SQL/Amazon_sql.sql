
use project;
select * from project.amazon;
show columns from project.amazon;
select * from amazon where 1 is null or 2 is null or 
1 is null or 3 is null or 4 is null or 5 is null or 6 is null or 7 is null or 8 is null or 9 is null or
10 is null or 11 is null or 12 is null or 13 is null or 14 is null or 15 is null or 16 is null or 17 is null;
-- there are no null values in the data set; 
-- 1. Data Wrangling is done. 
-- that means we had a data base and it has no null values 


--1. What is the count of distinct cities in the dataset?
select count(distinct(City)) as Unique_Cities from project.amazon;

--2. For each branch, what is the corresponding city?
select branch, city from project.amazon group by branch, city;

--3. What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT `Product line`) AS distinct_product_lines_count
FROM project.amazon;
select `Product line` from project.amazon group by `Product line`;

--4. Which payment method occurs most frequently?
select payment, count(Payment) as frequent_payment_method from project.amazon group by payment;

--5. Which product line has the highest sales?
select `product line`, round(sum(total),2) as 'Total purchase' from project.amazon 
group by `product line`
order by 'Total purchase' desc
limit 1;


--6. How much revenue is generated each month?
select monthname(date) as 'Month', round(sum(total),2) as Total_purchase
from project.amazon 
group by monthname(date)
order by round(sum(total),2) desc ;

-- 7. In which month did the cost of goods sold reach its peak?
select  monthname(date) as 'Month' ,  round(sum(cogs),2) as 'Total Goods' 
from project.amazon
group by monthname(date)  
order by round(sum(cogs),2) desc 
limit 1;


-- 8. Which product line generated the highest revenue
select `Product line`, round(sum(total),2) as 'Highest revenue'
from project.amazon 
group by `Product line`
order by round(sum(total),2) desc
limit 1;

-- 9. In which city was the highest revenue recorded?
select city, round(sum(total),2) as 'Highest revenue'
from project.amazon 
group by city 
order by round(sum(total),2) desc
limit 1;

-- 10. Which product line incurred the highest Value Added Tax?
select `Product line`, round(sum(`Tax 5%`),2) as 'Highest VAT' from project.amazon
group by `Product line`
order by round(sum('Tax 5%'),2) desc 
limit 1; 

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select `product line`, sum(total) as total_sales,
case 
    when sum(total) > (select avg(sum(total)) from (select sum(total) from project.amazon group by `product line`)as subquery)  then 'Good'
    else 'Bad'
end as Sales_status
from project.amazon 
group by `product line`;

-- 12. Identify the branch that exceeded the average number of products sold.
show columns from project.amazon;

select branch,sum(Quantity) as Quantities_sold 
from project.amazon 
group by branch 
having sum(Quantity) > (select avg(Quantities_sold) from (select sum(Quantity) as Quantities_sold from project.amazon group by branch) as subquery);


-- 13. Which product line is most frequently associated with each gender?
WITH male_count AS (
    SELECT COUNT(*) AS occurance_count, `product line`, gender 
    FROM project.amazon 
    WHERE gender = 'Male' 
    GROUP BY `product line`, gender 
    ORDER BY occurance_count DESC 
    LIMIT 1
),
female_count AS (
    SELECT COUNT(*) AS occurance_count, `product line`, gender 
    FROM project.amazon 
    WHERE gender = 'Female' 
    GROUP BY `product line`, gender 
    ORDER BY occurance_count DESC 
    LIMIT 1
)
SELECT * 
FROM female_count 
union all 
select * 
from male_count
order by occurance_count desc ;



-- 14. Calculate the average rating for each product line.
select `product line`, round(avg(rating),2) as Avg_rating from project.amazon group by `product line`
order by Avg_rating desc;

-- 15. Count the sales occurrences for each time of day on every weekday.
alter table project.amazon
drop column timofday;

alter table project.amazon
add column timeofday varchar(20);

show columns from project.amazon;
update project.amazon 
set timeofday = 
    case 
        when hour(`time`) between 6 and 12 then 'Morning'
        when hour(`time`) between 12 and 17 then 'Afternoon'
        when hour(`time`) between 17 and 21 then 'Evening'
    else 'Night'
    End;


select count(*) as sales_count, dayname(`Date`) as day_name, timeofday
from project.amazon
where dayname(`Date`) not in ('Saturday', 'Sunday')
group by day_name, timeofday
ORDER BY sales_count DESC;

-- 16.Identify the customer type contributing the highest revenue.
select `customer type` , round(sum(total),2) as total_revenue
from project.amazon
group by `customer type` 
order by total_revenue desc;

-- 17. Determine the city with the highest VAT percentage.
select city, round(sum(`tax 5%`)/sum(total)*100,2) as max_vat
from project.amazon 
group by city 
order by max_vat
limit 1;  

-- 18. Identify the customer type with the highest VAT payments.
show columns from project.amazon;
select `customer type`, round(sum(`Tax 5%`),2) as total_vat 
from project.amazon 
group by `customer type`
order by total_vat desc
limit 1;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct(`customer type`)) as count_of_customer_types
from project.amazon;

select distinct(`customer type`) from project.amazon; 


-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct(Payment)) as count_payment_methods 
from project.amazon;

select distinct(Payment) from project.amazon;


-- 21. Which customer type occurs most frequently?
-- 22. Identify the customer type with the highest purchase frequency.

show columns from project.amazon;

select `Customer type`, count(*) as occurence_type
from project.amazon
group by `Customer type`
order by occurence_type desc
limit 1;

-- 23. Determine the predominant gender among customers.
select gender, count(*) as gender_count from project.amazon 
group by gender;

-- 24. Examine the distribution of genders within each branch.
select gender, branch, count(*) as count_gender from  project.amazon
group by branch, gender
order by count_gender desc ;

-- 25. Identify the time of day when customers provide the most ratings.

select timeofday,dayname(date), count(*) as rating_count 
from project.amazon 
where rating is not null
group by timeofday, dayname(date)
order by rating_count desc 
limit 1;


-- 26. Determine the time of day with the highest customer ratings for each branch.
with branch_a as (select timeofday,dayname(`date`), count(*) as rating_count, branch
from project.amazon
where branch = 'A'
group by branch, timeofday ,dayname(`date`)
order by rating_count desc limit 1),
    branch_b as (select timeofday,dayname(`date`), count(*) as rating_count, branch
from project.amazon
where branch = 'B'
group by branch, timeofday,dayname(`date`) 
order by rating_count desc limit 1),
    branch_c as (select timeofday,dayname(`date`), count(*) as rating_count, branch
from project.amazon
where branch = 'C'
group by branch, timeofday ,dayname(`date`)
order by rating_count desc limit 1)
select * from branch_a 
union all 
select * from branch_b
union all 
select * from branch_c
order by rating_count desc ;

-- 27. Identify the day of the week with the highest average ratings.
select round(avg(rating),2) as avg_rating, dayname(`date`) as day_of_week from project.amazon group by dayname(`date`)
order by avg_rating desc 
limit 1;

-- 28. Determine the day of the week with the highest average ratings for each branch.
select branch, round(avg(rating),2) as avg_rating, dayname(`date`) as day_of_week
from project.amazon 
group by dayname(`date`), branch
order by avg_rating desc 
limit 1;
