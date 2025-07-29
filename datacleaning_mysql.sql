-- STEP 1: REMOVE DUPLICATES
SELECT * FROM layoffs;
show tables;

--  created a backup table
create table layoffs_threat
like layoffs;

--  insert data into table
insert into layoffs_threat
select*
from layoffs;

SELECT * FROM layoffs_threat;

--  check for duplicate records using row_number()
with duplicate_Cte as
(
select *,
row_number()over(
partition by company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) as rn
from layoffs_threat
)
select *
from duplicate_Cte
where rn>1;

--  created a new working table with row numbers to help remove duplicataes

CREATE TABLE `layoffs_thread2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
`row_num` INT
);

--  insert data with row_number into new table

insert into layoffs_thread2
select *,
row_number()over(
partition by company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) as rn
from layoffs_threat;

select *
from layoffs_thread2;

-- Deleting duplicate rows(row_num >1)
set sql_safe_updates=0;

delete
from layoffs_thread2
where row_num >1;


-- STEP 2: Standardizing  the Data

select distinct(company)
from layoffs_thread2;

select distinct(trim(company))
from layoffs_thread2;
 
 select company,trim(company)
 from layoffs_thread2;
 -- standardize company names(removing leading and trailing spaces)
 set sql_safe_updates=0;
update layoffs_thread2
set company= trim(company);
 
 select distinct industry
 from layoffs_thread2
 order by 1;
 
 
 -- STEP 3: Handling NULL as well as Blankl Values
 
 UPDATE world_layoffs.layoffs_thread2
SET industry = NULL
WHERE industry = '';

-- Fill NULL industries by matching same companies with known industries

UPDATE layoffs_thread2 t1
JOIN layoffs_thread2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

select *
from layoffs_thread2
where industry like 'Crypto%';
 
 -- standardize industry names (fixing incosistent spelling/cases)
 update layoffs_thread2
 set industry ='Crypto'
 where industry like 'crypto%';
 
 select *
from layoffs_thread2;

select distinct location
from layoffs_thread2
order by 1;

select distinct country,trim(trailing '.' from country)
from layoffs_thread2
order by 1;

-- fixing country name formatting(removing trailing dots)
update layoffs_thread2
set country = trim(trailing '.' from country)
where country like 'united states%';

select *
from layoffs_thread2 ;

select `date`,
str_to_date(`date`, '%m/%d/%y')layoffs_thread2
from layoffs_thread2;

-- convert `date` from text to DATE format
update layoffs_thread2
set `date` = str_to_date(`date`, '%m/%d/%Y');

-- Modifying the column to proper datatype
alter table layoffs_thread2
modify column `date` date;

select *
from layoffs_thread2
where total_laid_off is null
and percentage_laid_off is null;

-- Delete rows where both layoffs and percentage column are null
DELETE FROM world_layoffs.layoffs_thread2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

select * 
from layoffs_thread2;

-- STEP 4: DROP UNNECESSARY COLUMNS

alter table layoffs_thread2
drop column row_num;

select * 
from layoffs_thread2









 









