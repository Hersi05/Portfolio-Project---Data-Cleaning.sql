--- Data Cleaing

select * from layoffs;

--- 1 Remove Duplicate 



create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert layoffs_staging
select * from layoffs;

select * from layoffs_staging;

--- 2 Standardize the Data
-- if I look at industry it looks like I have some null and empty rows, let's take a look at these

select company, trim(company)
from layoffs_staging;


update layoffs_staging
set company = trim(company);

select distinct industry
from layoffs_staging
order by 1;

select *
from layoffs_staging
where industry like 'Crypto%';

update layoffs_staging
set industry = 'Crypto'
where industry like  'Crypto%';

-- everything looks good except apparently I have some "United States" and some "United States." with a period at the end. Let's standardize this.

select distinct country
from layoffs_staging
order by 1 ;

select * from layoffs_staging
where country like 'United States%';

update layoffs_staging
set country = 'United States'
where country like  'United States%';

select location, industry, date from layoffs_staging;


select `date`,
str_to_date(`date` , '%m/%d/%Y') 
from layoffs_staging;

-- I can use str to date to update this field

update layoffs_staging
set `date` = str_to_date(`date` , '%m/%d/%Y') ;

select `date` from layoffs_staging;


--- 3 Remov Null Values or blank values

select * from layoffs_staging
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging
set industry = null 
where industry ='';

select * from layoffs_staging
where industry is null
or industry = '';

select * from layoffs_staging
where company like 'Bally%';

select * from layoffs_staging
where company = 'Airbnb';

select t1.industry, t2.industry
from layoffs_staging t1
join layoffs_staging t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
order by 1;

update layoffs_staging t1
join layoffs_staging t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;


--- 4 Remove any columns

select * from layoffs_staging
where total_laid_off is null
and percentage_laid_off is null;

-- Delete Useless data I can't really use

delete
from layoffs_staging
where total_laid_off is null
and percentage_laid_off is null;

select * from layoffs_staging;










