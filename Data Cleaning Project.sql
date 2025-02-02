-- SQL Project - Data Cleaning

select * 
from layoffs;

-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
create table clean_layoff
like layoffs;

select *
from clean_layoff;

insert clean_layoff
select *
from layoffs;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

-- 1. Remove Duplicates

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		clean_layoff
) duplicates
WHERE 
	row_num > 1;
    
WITH DELETE_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		clean_layoff
) duplicates
WHERE 
	row_num > 1
)
delete 
from DELETE_CTE;


CREATE TABLE `clean_layoff2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from clean_layoff2;

insert into clean_layoff2
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		clean_layoff;

delete from clean_layoff2
where row_num > 1;

-- 2. Standardizing Data 

-- Company column

select distinct company 
from clean_layoff2;


select company, trim(company) 
from clean_layoff2;

update clean_layoff2
set company= trim(company);

-- Industry Column

select distinct industry
from clean_layoff2
order by industry ;

select industry 
from clean_layoff2
where industry like 'crypto%'
;

update clean_layoff2
set industry= 'Crypto'
where industry like 'crypto%';

-- Country Column

select distinct country
from clean_layoff2
order by 1;

select distinct country ,  trim(trailing '.' from country)
from clean_layoff2
order by 1;

update clean_layoff2
set country= trim(trailing '.' from country)
where country like 'united States%';

-- Date Column

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from clean_layoff2;

update clean_layoff2
set `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE clean_layoff2
MODIFY COLUMN `date` DATE;

-- 3. Null Values

select *
from clean_layoff2
where industry is null
or industry = ''; 

update clean_layoff2
set industry = null
where industry = '';

update clean_layoff2 c1
join clean_layoff2 c2
on c1.company = c2.company
set c1.industry = c2.industry
where c1.industry is null
and c2.industry is not null;


create table Cleaned_layoff
like clean_layoff2;


insert Cleaned_layoff
select *
from clean_layoff2;

select * 
from Cleaned_layoff;

-- 4. removing cloumns or rows

DELETE FROM Cleaned_layoff
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

ALTER TABLE Cleaned_layoff
DROP COLUMN row_num;


select *
from Cleaned_layoff;
