create database world_layoff;
use world_layoff;
select * from layoffs;

-- REMOVE DUPLICATES--
-- STANDARDISE DATA--
-- NULL VALUE OR BLANK VALUES--
-- REMOVE ANY COLUMN --

/* in MySQL
CREATE TABLE layoff_staging
LIKE layoffs;
*/

SELECT * 
INTO layoff_staging 
FROM layoffs;

SELECT *
FROM layoff_staging; --WE NEED TO HAVE RAW DATA SO WE DULPICATED LAYOFFS--

-- REMOVE DUPLICATES --

SELECT * ,
ROW_NUMBER() OVER( 
PARTITION BY company,industry,total_laid_off,percentage_laid_off,'date'
ORDER BY(date))
AS row_num
FROM layoff_staging;

WITH duplicate_cte AS(
SELECT * ,
ROW_NUMBER() OVER( 
PARTITION BY company,industry,total_laid_off,percentage_laid_off,'date'
ORDER BY(date))
AS row_num
FROM layoff_staging)
SELECT * FROM duplicate_cte WHERE row_num>1;

WITH duplicate_cte AS(
SELECT * ,
ROW_NUMBER() OVER( 
PARTITION BY company,industry,total_laid_off,percentage_laid_off,'date'
ORDER BY(date))
AS row_num
FROM layoff_staging
)
DELETE FROM duplicate_cte WHERE row_num>1;






