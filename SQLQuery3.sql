--COVID 19 Data Exploration
--Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


SELECT *
FROM PortfolioProjects..covidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortfolioProjects..CovidVaccinations
--ORDER BY 3,4

--SELECT data that we are going to be using

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProjects..covidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Looking at total cases vs total deaths
--Shows the death rate for covid infected in the given country

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathRate
FROM PortfolioProjects..covidDeaths
WHERE location='india'
AND continent IS NOT NULL
ORDER BY 1,2

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathRate
FROM PortfolioProjects..covidDeaths
WHERE location='united states'
AND continent IS NOT NULL
ORDER BY 1,2

--Total cases vs Population
--Shows the percentage of people who got infected with covid

SELECT location,date,total_cases,population,(total_cases/population)*100 AS percentage_of_population_infected
FROM PortfolioProjects..covidDeaths
WHERE location='india'
ORDER BY 1,2

SELECT location,date,total_cases,population,(total_cases/population)*100 AS percentage_of_population_infected
FROM PortfolioProjects..covidDeaths
WHERE location='united states'
ORDER BY 1,2

--Countries with highest infection rate compared to population

SELECT location,population,MAX(total_cases) as highest_infection_count,MAX((total_cases/population)*100) as percent_population_infected
FROM PortfolioProjects..covidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY percent_population_infected DESC

--Countries with highest death count

SELECT location,MAX(cast(total_deaths as int)) AS total_death_count 
FROM PortfolioProjects..covidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC 

--Showing continents with highest death count

SELECT continent,MAX(cast(total_deaths as int)) AS total_death_count 
FROM PortfolioProjects..covidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC 

--Global Numbers

SELECT date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_percentage
FROM PortfolioProjects..covidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_percentage
FROM PortfolioProjects..covidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Total populations vs vaccinations
--Shows percentage of population who have recieved atleast single dose of vaccine

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Rolling_vaccinations
FROM PortfolioProjects..covidDeaths dea
JOIN PortfolioProjects..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--Using CTE to perform calculation on partition by in previous query

WITH PopvsVac(continent,location,date,population,new_vaccinations,Rolling_vaccinations)
AS(SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Rolling_vaccinations
FROM PortfolioProjects..covidDeaths dea
JOIN PortfolioProjects..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL)
SELECT *,(Rolling_vaccinations/population)*100 AS pop_percentage_vaccinated
FROM PopvsVac

--Creating VIEW to store data for later visualizations

CREATE VIEW
Percent_Population_Vaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Rolling_vaccinations
FROM PortfolioProjects..covidDeaths dea
JOIN PortfolioProjects..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL



	












