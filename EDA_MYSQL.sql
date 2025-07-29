-- Exploratory Data Analysis

select *
from layoffs_thread2;

-- BASIC QUERIES

-- 1Q.What is the maximum number of employees laid off in a single event,
-- and the highest percentage of workforce laid off by any company in the dataset?

select max(total_laid_off),max(percentage_laid_off)
from layoffs_thread2;

-- 2Q.Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM world_layoffs.layoffs_thread2
WHERE  percentage_laid_off = 1;

-- 3Q. Among the companies that laid off 100% of their workforce, 
-- which ones had the highest amount of funds raised before the layoffs?
SELECT *
FROM world_layoffs.layoffs_thread2
WHERE  percentage_laid_off = 1
order by funds_raised_millions desc;

--  4Q. What is the time range of the layoff events in the dataset — from the earliest to the most recent?
select min(`date`),max(`date`)
from layoffs_thread2;

-- INTERMEDIATE QUERIES

-- 5Q. Which are the top 4 companies that laid off 100% of their workforce, and had the highest number of total layoffs?
SELECT *
FROM world_layoffs.layoffs_thread2
WHERE  percentage_laid_off = 1
order by total_laid_off desc
limit 4;

--  6Q. Which are the next 3 companies (ranked 5th to 7th) that laid off 100% of their workforce,
--  based on the total number of employees laid off?
SELECT *
FROM world_layoffs.layoffs_thread2
WHERE  percentage_laid_off = 1
order by total_laid_off desc
limit 4,3;

-- 7Q. fetch top 5 companies with the highest total number of employees 
-- laid off across all their layoff events?
SELECT company,sum(total_laid_off)
from layoffs_thread2
group by company
order by 2 desc
limit 5;

--  8Q. Which industries experienced the highest total number of layoffs across all companies in the dataset?
SELECT industry,sum(total_laid_off)
from layoffs_thread2
group by industry
order by 2 desc;

--  9Q. Which countries reported the highest total number of layoffs in the dataset?
SELECT country,sum(total_laid_off)
from layoffs_thread2
group by country
order by 2 desc;

-- 10 Q. What is the year-wise trend of total layoffs,
-- how many employees were laid off in each year?
SELECT year(`date`),sum(total_laid_off)
from layoffs_thread2
group by year(`date`)
order by 1 desc;

-- 11 Q. What is the month-wise trend of total layoffs across the dataset?
SELECT substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoffs_thread2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

-- ADVANCED QUERIES

-- Write an SQL query to generate a report that shows:
  -- The total number of layoffs for each month (in 'YYYY-MM' format).
  -- A running (cumulative) total of layoffs across all months, ordered chronologically.
-- Your output should include two columns:
     -- dates: Month in 'YYYY-MM' format
     -- rolling_total_layoffs: Cumulative sum of total_laid_off up to that month
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_thread2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off,SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

-- Write an SQL query to identify the top 5 companies with the highest total layoffs for each year.
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_thread2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;








