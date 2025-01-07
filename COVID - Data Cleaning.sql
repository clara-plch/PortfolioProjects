-- -------------------------------------------
--      INDUSTRY LAYOFF DURING COVID		--
-- -------------------------------------------

-- Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

SELECT *
FROM layoffs;

-- -------------------------------------------
-- 0. Create a staging table
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns
-- -------------------------------------------

-- 0. Create a staging table

CREATE TABLE layoffs_staging 
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging 
SELECT * 
FROM layoffs;

-- 1. Remove Duplicates

-- Show unique rows
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- Show non unique rows
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

-- Look at one example to confirm 
SELECT *
FROM layoffs_staging
WHERE company = 'Oda';

-- Remove duplicated rows :
-- 1. Create a new column with the row numbers in
-- 2. Delete where row numbers are over 2
-- 3. Delete this column

-- Create a new staging table 
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

-- Insert rows from first table with row_num partition
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Delete all duplicates (where row_num > 1)
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Verification
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- 2. Standardize the Data

-- Unwanted spaces
SELECT company, TRIM(company) 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Harmonize the names
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- INDUSTRY
-- --> wee see that Crypto industry is written 3 different ways
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- COUNTRY
-- --> we see there is United States and United States.
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';

-- DATE
-- Convert date from string to month-day-year format
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Null Values or Blank Values

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- We see one Airbnb industry is null and one has Travel, so we can fill up the blank with Travel too
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'; 

-- Update blank to null
UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = '';

-- Check remaining nulls
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- Populate those nulls if possible
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

-- Bally's still has a NULL industry : however there is no other populated row we can copy
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- 4. Remove Any Columns/Rows

-- Rows where with no data on total laid off and percentage laid off (won't be useful)
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

-- Delete row_num column now
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;