--FIRST PORTOFOLIO PORJECT

Select *
From PortofolioProject..CovidVaccinations
where continent is not null
Order by 3,4

----Select Data that we are going to using

Select location, date, total_cases, new_cases, total_deaths, population
from PortofolioProject..CovidDeaths
Order by 1,2 

-- looking at Total Cases vs Total Deaths

Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
Where location like '%state%'
Order by 1,2 

looking at total cases vs Population 
show what precentage of population  got covid

Select Location, date, Population, total_cases, (total_cases/Population)*100 as PercentPopulationInfected
from PortofolioProject..CovidDeaths
Where location like '%state%'
Order by 1,2 

--Looking countries with the Highest Infection rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
from PortofolioProject..CovidDeaths
--Where location like '%state%'
Group by Location, Population
Order by PercentPopulationInfected desc

--Showing countries with the higest Death Count per Population

Select Location, SUM(cast(total_deaths as int)) as HighestDeathCount
from PortofolioProject..CovidDeaths
--Where location like '%state%'	
where continent is not null
Group by Location
Order by HighestDeathCount desc

--BREAK THINGS DOWN  BY CONTINENT

Select continent, MAX(cast(total_deaths as int)) as HighestDeathCount
from PortofolioProject..CovidDeaths
--Where location like '%state%'
where continent is not null
Group by continent
Order by HighestDeathCount desc

--LET'S BREAK  THINGS DOWN C0NTINENT

--Showing the continent  with the highest death  count per population
Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
from PortofolioProject..CovidDeaths
--Where location like '%state%'
where continent is not null
Group by location
Order by HighestDeathCount desc

--Global Numbers

Select SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths,
Sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
--Where location like '%state%'
where Continent is not null
--Group by Date
Order by 1,2 



--Looking at Total Population

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeaths dea				
Join PortofolioProject..CovidVaccinations vac			
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population,New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeaths dea				
Join PortofolioProject..CovidVaccinations vac			
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac



--TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinatios numeric,
RollingPeopleVaccinated numeric
)



Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeaths dea				
Join PortofolioProject..CovidVaccinations vac			
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated