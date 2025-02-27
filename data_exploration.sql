SELECT * 
FROM coviddeaths
LIMIT 100000;

SELECT *
FROM covidvaccinations
LIMIT 100000;

-- update blanck to null
UPDATE 
	coviddeaths 
SET 
	continent = CASE continent WHEN '' THEN NULL ELSE continent END,
	total_cases = CASE total_cases WHEN '' THEN NULL ELSE total_cases END,
    new_cases = CASE new_cases WHEN '' THEN NULL ELSE new_cases END,
	total_deaths = CASE total_deaths WHEN '' THEN NULL ELSE total_deaths END,
    new_cases_smoothed = CASE new_cases_smoothed WHEN '' THEN NULL ELSE new_cases_smoothed END,
    new_deaths = CASE new_deaths WHEN '' THEN NULL ELSE new_deaths END,
    new_deaths_smoothed = CASE new_deaths_smoothed WHEN '' THEN NULL ELSE new_deaths_smoothed END,
    total_cases_per_million = CASE total_cases_per_million WHEN '' THEN NULL ELSE total_cases_per_million END,
    new_cases_smoothed_per_million = CASE new_cases_smoothed_per_million WHEN '' THEN NULL ELSE new_cases_smoothed_per_million END,
    total_deaths_per_million = CASE total_deaths_per_million WHEN '' THEN NULL ELSE total_deaths_per_million END,
	total_deaths_per_million = CASE total_deaths_per_million WHEN '' THEN NULL ELSE total_deaths_per_million END,
    new_deaths_per_million = CASE new_deaths_per_million WHEN '' THEN NULL ELSE new_deaths_per_million END,
	new_deaths_smoothed_per_million = CASE new_deaths_smoothed_per_million WHEN '' THEN NULL ELSE new_deaths_smoothed_per_million END,
	reproduction_rate = CASE reproduction_rate WHEN '' THEN NULL ELSE reproduction_rate END,
	icu_patients = CASE icu_patients WHEN '' THEN NULL ELSE icu_patients END,
	hosp_patients = CASE hosp_patients WHEN '' THEN NULL ELSE hosp_patients END,
	hosp_patients_per_million = CASE hosp_patients_per_million WHEN '' THEN NULL ELSE hosp_patients_per_million END,
	weekly_icu_admissions = CASE weekly_icu_admissions WHEN '' THEN NULL ELSE weekly_icu_admissions END,
	weekly_icu_admissions_per_million = CASE weekly_icu_admissions_per_million WHEN '' THEN NULL ELSE weekly_icu_admissions_per_million END,
	weekly_hosp_admissions = CASE weekly_hosp_admissions WHEN '' THEN NULL ELSE weekly_hosp_admissions END,
	weekly_hosp_admissions_per_million = CASE weekly_hosp_admissions_per_million WHEN '' THEN NULL ELSE weekly_hosp_admissions_per_million END;
UPDATE 
	covidvaccinations 
SET  
	continent = CASE continent WHEN '' THEN NULL ELSE continent END,
	new_tests = CASE new_tests WHEN '' THEN NULL ELSE new_tests END,	
	total_tests	= CASE total_tests WHEN '' THEN NULL ELSE total_tests END,
	total_tests_per_thousand = CASE total_tests_per_thousand WHEN '' THEN NULL ELSE total_tests_per_thousand END,	
	new_tests_per_thousand = CASE new_tests_per_thousand WHEN '' THEN NULL ELSE new_tests_per_thousand END,	
	new_tests_smoothed = CASE new_tests_smoothed WHEN '' THEN NULL ELSE new_tests_smoothed END,	 
	new_tests_smoothed_per_thousand = CASE new_tests_smoothed_per_thousand WHEN '' THEN NULL ELSE new_tests_smoothed_per_thousand END,		
	positive_rate = CASE positive_rate WHEN '' THEN NULL ELSE positive_rate END,	
	tests_per_case = CASE tests_per_case WHEN '' THEN NULL ELSE tests_per_case END,	
	tests_units = CASE tests_units WHEN '' THEN NULL ELSE tests_units END,		
	total_vaccinations = CASE total_vaccinations WHEN '' THEN NULL ELSE total_vaccinations END,	
	people_vaccinated = CASE people_vaccinated WHEN '' THEN NULL ELSE people_vaccinated END,	
	people_fully_vaccinated	= CASE people_fully_vaccinated WHEN '' THEN NULL ELSE people_fully_vaccinated END,	
	new_vaccinations = CASE new_vaccinations WHEN '' THEN NULL ELSE new_vaccinations END,	
	new_vaccinations_smoothed = CASE new_vaccinations_smoothed WHEN '' THEN NULL ELSE new_vaccinations_smoothed END,	
	total_vaccinations_per_hundred = CASE total_vaccinations_per_hundred WHEN '' THEN NULL ELSE total_vaccinations_per_hundred END,	
	people_vaccinated_per_hundred = CASE people_vaccinated_per_hundred WHEN '' THEN NULL ELSE people_vaccinated_per_hundred END,	
	people_fully_vaccinated_per_hundred = CASE people_fully_vaccinated_per_hundred WHEN '' THEN NULL ELSE people_fully_vaccinated_per_hundred END,	
	new_vaccinations_smoothed_per_million = CASE new_vaccinations_smoothed_per_million WHEN '' THEN NULL ELSE new_vaccinations_smoothed_per_million END,
    stringency_index = CASE stringency_index WHEN '' THEN NULL ELSE stringency_index END,
	population_density = CASE population_density WHEN '' THEN NULL ELSE population_density END,	
    median_age = CASE median_age WHEN '' THEN NULL ELSE median_age END,	
    aged_65_older = CASE aged_65_older WHEN '' THEN NULL ELSE aged_65_older END,	
    aged_70_older = CASE aged_70_older WHEN '' THEN NULL ELSE aged_70_older END,	
    gdp_per_capita  = CASE gdp_per_capita WHEN '' THEN NULL ELSE gdp_per_capita END,	 
    extreme_poverty = CASE extreme_poverty WHEN '' THEN NULL ELSE extreme_poverty END,	
    cardiovasc_death_rate = CASE cardiovasc_death_rate WHEN '' THEN NULL ELSE cardiovasc_death_rate END,	
    diabetes_prevalence = CASE diabetes_prevalence WHEN '' THEN NULL ELSE diabetes_prevalence END,	
    female_smokers = CASE female_smokers WHEN '' THEN NULL ELSE female_smokers END,	
    male_smokers = CASE male_smokers WHEN '' THEN NULL ELSE male_smokers END,	
    handwashing_facilities = CASE handwashing_facilities WHEN '' THEN NULL ELSE handwashing_facilities END,	
    hospital_beds_per_thousand = CASE hospital_beds_per_thousand WHEN '' THEN NULL ELSE hospital_beds_per_thousand END,	
    life_expectancy = CASE life_expectancy WHEN '' THEN NULL ELSE life_expectancy END,	
    human_development_index = CASE human_development_index WHEN '' THEN NULL ELSE human_development_index END;

-- Select datas
SELECT location, `date`, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY location, `date`;

-- Looking at Total Cases vs Total Deaths (%of people who died that had COVID)
-- Show the probability of dying when contracting COVID in a specific country
SELECT location, `date`, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathsPercentage
FROM coviddeaths
WHERE location like '%states%'
ORDER BY location, `date`;

-- Looking at Total Cases vs Population 
-- Show the percentage of population that had COVID
SELECT location, `date`, population, total_cases, (total_cases/population)*100 AS CasesPercentage
FROM coviddeaths
WHERE location like '%states%'
ORDER BY location, `date`;

-- Looking at Countries & Total Cases vs Population
-- Shows countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS MaxCasesPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY MaxCasesPercentage DESC;

-- Shows countries with highest death count per population    
SELECT location, MAX(CAST(total_deaths as UNSIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Shows continent with highest death count per population  
-- correct way
-- SELECT location, MAX(CAST(total_deaths as UNSIGNED)) AS TotalDeathCount
-- FROM coviddeaths
-- WHERE continent IS NULL
-- GROUP BY location
-- ORDER BY TotalDeathCount DESC;
-- not correct but to continue with project
SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount -- CAST AS UNSIGNED (UNSIGNED = INT) since all my variables are text or CONVERT(UNSIGNED, total_deaths) 
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-------- GLOBAL NUMBERS --------- 
-- Shows total new cases, deaths and death percentage per date
SELECT `date`, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY `date`
ORDER BY 1,2;
-- Shows total new cases, total deaths and total percentage of death
SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-------------- JOIN COVID VACCINATIONS TABLE -------------------
SELECT * 
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
LIMIT 100000;

-- Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
-- WHERE dea.location like '%Canada%'
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
LIMIT 100000;

-- USE CTE (to use Total Population vs Vaccinations)
WITH PopulationVsVaccinations (continent, location, date, population, new_vaccinations, RollingVaccinations)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
-- WHERE dea.location like '%Canada%'
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3
LIMIT 100000
)
SELECT *, (RollingVaccinations/population)*100
FROM PopulationVsVaccinations;

-- TEMP TABLE
DROP TABLE IF EXISTS PercentVaccinations;
CREATE TABLE PercentVaccinations
(
continent text,
location text,
date text,
population text,
new_vaccinations text,
RollingVaccinations text
);
INSERT INTO  PercentVaccinations
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
-- WHERE dea.location like '%Canada%'
WHERE dea.continent IS NOT NULL
LIMIT 100000
);
SELECT *, (RollingVaccinations/population)*100
FROM PercentVaccinations
LIMIT 100000;

-- CREATING VIEW (to store data for visualizations)

CREATE VIEW PercentVaccinationsView AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
-- WHERE dea.location like '%Canada%'
WHERE dea.continent IS NOT NULL
LIMIT 100000
);

-- CREATE OTHER VIEWS !!!