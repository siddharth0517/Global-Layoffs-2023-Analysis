-- Total Layoffs by Industry

SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM cleaned_layoff
GROUP BY industry
ORDER BY total_layoffs DESC
LIMIT 10;

-- Layoffs Trend Over Time

SELECT DATE_FORMAT(`date`, '%Y-%m') AS month, SUM(total_laid_off) AS total_layoffs
FROM cleaned_layoff
GROUP BY month
ORDER BY month;

-- Companies with the Most Layoffs

SELECT company, SUM(total_laid_off) AS total_layoffs
FROM cleaned_layoff
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;

-- Country-wise Layoffs

SELECT country, SUM(total_laid_off) AS total_layoffs
FROM cleaned_layoff
GROUP BY country
ORDER BY total_layoffs DESC;

-- Percentage of Employees Laid Off Per Company

SELECT company, AVG(percentage_laid_off) AS avg_percentage
FROM cleaned_layoff
GROUP BY company
ORDER BY avg_percentage DESC
LIMIT 10;

-- Total Number of Companies that Completely Laid OFF

select count(percentage_laid_off) as Total_Number_of_Companies_that_Completely_Laid_OFF
FROM cleaned_layoff
where percentage_laid_off = 1;





SELECT * FROM cleaned_layoff;
