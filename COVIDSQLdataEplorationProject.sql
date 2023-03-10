--COVID DATA EXPLORATION PPROJECT

select *
from PortfolioProject..CovidDeaths

order by 3,4
where continent is not null


--select*
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- Selecting the data we will use

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total cases vs Total Deaths
--percentage of deaths per total cases 

select location, date, total_cases, total_deaths,
cast(total_deaths AS float)/cast(total_cases as float)*100 as percentOfDeath
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%haiti%'
order by 1,2

--looking at total cases vs population
--shows what prcentage of population got covid

select location, date, population,total_cases, 
cast(total_cases AS float)/cast(population as float)*100 percentOfPopInfected
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%haiti%'
order by 1,2


--Looking at countries with highest infection rate compared to population
--create view HighestInfectionCount as
select location, population,max(total_cases) as HighestInfectionCount,
max(cast(total_cases AS float)/cast(population as float)*100) as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
 group by location, population
order by PercentOfPopulationInfected desc


--showing the countries with highest Death count 
--Create view totalDeathcount as
select location, MAX (cast (total_deaths as int)) as totalDeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by totalDeathcount desc


--LET'S BREAK IT DOWN BY CONTINENT
-- showing CONTINENT with the highest death count
--create view ContinentTotalDeathcount as
select continent, MAX (cast (total_deaths as int)) as totalDeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by totalDeathcount desc


--Looking at Total cases vs Total Deaths per continent
--percentage of deaths per total cases per continent
--create view percentOfDeath as
select continent, date, total_cases, total_deaths,
cast(total_deaths AS float)/cast(total_cases as float)*100 as percentOfDeath
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%haiti%'
order by 1,2

--looking at total cases vs population per continent
--shows what prcentage of population got covid per continent
--create view ContinentPercentOfPopInfected as
select continent, date, population,total_cases, 
cast(total_cases AS float)/cast(population as float)*100 percentOfPopInfected
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%haiti%'
order by 1,2



--Looking at continent with highest infection rate compared to population
select continent, population,max(total_cases) as HighestInfectionCount,
max(cast(total_cases AS float)/cast(population as float)*100) as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by continent, population
order by PercentOfPopulationInfected desc




-- GLOBAL NUMBERS


select SUM(new_cases) as totalCases ,
SUM(new_deaths)as totalDeath,
SUM(new_deaths)/SUM(new_cases)*100 as percentOfDeath
from PortfolioProject..CovidDeaths
where continent is not null 
--where location like '%haiti%'
--group by date
order by 1

--- looking at Total Population vs Vaccinations
--create view VaccinationProgressbycountry as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast (vac.new_vaccinations as float)) 
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null 
order by 2,3


--USE CTE

With PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
 (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast (vac.new_vaccinations as float)) 
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)
select * , (RollingPeopleVaccinated/population) as PercentofPopVaccinated
from PopvsVac
order by 2,3


--USE TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast (vac.new_vaccinations as float)) 
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null 

select * , (RollingPeopleVaccinated/population) as PercentofPopVaccinated
from #PercentPopulationVaccinated
order by 2,3



--CREATING VIEWS

create view percentDeathCaLoc as 
select location, date, total_cases, total_deaths,
cast(total_deaths AS float)/cast(total_cases as float)*100 as percentOfDeath
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%haiti%'
--order by 1,2


--looking at total cases vs population
--shows what prcentage of population got covid

Create view percentOfPopInfected as
select location, date, population,total_cases, 
cast(total_cases AS float)/cast(population as float)*100 percentOfPopInfected
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%haiti%'
--order by 1,2