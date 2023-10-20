/*
Covid 19 Data Exploration
Skills used: Joins, Aggregate Functions, Converting Data types, 
Sorting Data, Grouping Data
*/

--Total Cases vs Total Deaths in U.S
-- Shows likelihood of dying with covid in your country
SELECT location, date, total_cases, total_deaths, 
FORMAT(
        ((CAST(total_deaths AS float) / CAST(total_cases AS float)) * 100),
        'N2'
    ) + '%' as DeathRate
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
ORDER BY 1,2;


--Global Stats
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--Death count by continent
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'lower middle income', 'low income')
Group by location
order by TotalDeathCount desc




--Highest rate of infection by location
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases)/population*100  as PercentPopulationInfected
From CovidProject..CovidDeaths
--Where location like '%states%'
Where location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'lower middle income', 'low income')
Group by Location, Population
order by PercentPopulationInfected desc




-- Total Cases vs Population
-- Percentage of population with covid
SELECT location, date, total_cases, population, 
FORMAT(
        ((CAST(total_cases AS float) / CAST(population AS float)) * 100),
        'N2'
    ) + '%' as InfectedRate
FROM CovidProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2;




--Top 10 locations with highest tests conducted
SELECT TOP(10) location, SUM(CAST(total_tests as bigint)) AS total_tests
FROM CovidProject..CovidVaccinations
GROUP BY location
ORDER BY total_tests DESC



--Countries with highest infection rate
SELECT location, population, MAX(total_cases) AS HighestInfected, MAX((total_cases/population))*100 as InfectedRate
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY InfectedRate DESC;


--Countries with the highest death count
SELECT location, CAST(MAX(total_deaths) AS int) as TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;



--Total Population vs Vaccinations
SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
FROM CovidProject..CovidDeaths death
join CovidProject..CovidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
WHERE death.continent is not null
order by 2,3;
