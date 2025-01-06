-- Data Cleaning

SELECT *
FROM layoffs;

-- -------------------------------------------
-- 0. Create a copy of the Table to use
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns
-- -------------------------------------------

-- 0. Create a copy of the table to use, to have the raw data available in case of mistake
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. Remove Duplicates

-- query to see which rows are unique 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- check in this query which rows are not unique 
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- verify quickly that it is correct : we realise it is not since we didnt partition by all column 
-- (so for Oda we see we have the same data for some columns but not all)
SELECT *
FROM layoffs_staging
WHERE company = 'Cazoo';

-- identify which row to remove (dont want to remove both duplicated rows just one)
-- to do so : create a new table and remove where row_num = 2
-- right click on layoffs_stagging --> Copy to Clipboard --> Create Statement --> Paste down here

CREATE TABLE `layoffs_staging2` (
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

SELECT *
FROM layoffs_staging2;

-- insert rows from layoffs_staging with row_num partition
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- delete where row_num > 1
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- verify
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- 2. Standardize the Data = finding issues in your data and fixing it

-- Unwanted spaces
SELECT company, TRIM(company) -- to remove all spaces at beginning and end of company name
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Regroup industry that are written differently with a same name

-- analyze the names in each column:
-- SELECT DISTINCT industry
-- FROM layoffs_staging2
-- ORDER BY 1;
-- then replace / update whats needed

-- INDUSTRY
-- --> wee see that Crypto industry is written 3 different ways
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- COUNTRY
-- we see there is United States and United States.
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';

-- convert date from string to month-day-year format
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- modify the date format as seen in layoffs_staging2 --> columns --> date --> definition (text right now)
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. Null Values or Blank Values
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'; -- we see one Airbnb industry is null and one has Travel, so we can fill up the blanck with Travel too

UPDATE layoffs_staging2 -- we update blanck to null
SET industry = NULL
WHERE industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

-- we see Bally's still has a NULL industry : since there is only one row, so no other populated row we can copy
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


-- 4. Remove Any Columns/Rows
-- remove rows where we have no data on total laid off and percentage laid off (wont be useful)
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- delete row_num column now, dont need anymore
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;