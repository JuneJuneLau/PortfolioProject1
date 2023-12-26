--Select *
--From CovidDeath
--Order by 3,4

--Looking at total cases vs total deaths
--Show likelihood of died if getting covid
--Select location, date, total_cases, total_deaths, (total_deaths/cast(total_cases as float))*100 as Death_Rate
--From dbo.CovidDeath
--Where location like '%States%'
--Order by 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid
--Select location,continent, date, total_cases, population, (total_cases/population)*100 as Newcases_Rate
--From dbo.CovidDeath
--Where location like 'World'
--Order by 1,2

--Looking at countries with highest infection rate compared to population
--Select location, max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as Newcases_Rate
--From dbo.CovidDeath
--Where continent is not NULL
--Group by location, population
--Order by Newcases_Rate desc

--Showing Countries with highest Death count per population
--Select continent,location, max(cast(total_deaths as int)) as HighestDeathCount, population
--From dbo.CovidDeath
--Where continent is not NULL
--Group by location,population,continent
--Order by HighestDeathCount desc

--Showing Contients with highest death count per population
--Select continent, max(cast(total_deaths as int)) as HighestDeathCount
--From dbo.CovidDeath
--Where continent is not NULL
--Group by continent
--Order by HighestDeathCount desc

--Global numbers on total new cases and total deaths cases each day

--Select date, sum(new_cases) as TotalWorldNewCases, sum(cast(new_deaths as int)) as TotalWorldNewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as World_Death_Rate
--From dbo.CovidDeath
--where continent is not null
--Group by date
--Order by 1

----Global numbers on total new cases and total deaths cases
--Select sum(new_cases) as TotalWorldNewCases, sum(cast(new_deaths as int)) as TotalWorldNewDeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as World_Death_Rate
--From dbo.CovidDeath
--where new_cases > 0 and continent is not null
--Order by 1

----Looking at total population vs vaccinations
--Select Vac.continent, Vac.location, Vac.date, Dea.population, Vac.new_vaccinations, sum(Cast(Vac.new_vaccinations as float)) over (Partition by Vac.location Order by Vac.location,Vac.date) as RollingPplVaccinated
--From dbo.[CovidVaccination'] Vac
--Join dbo.CovidDeath Dea
--	On Vac.location = Dea.location
--	and Vac.date = Dea.date
--Where Vac.continent is not null
--Order by 2,3



--Find out the vaccinations per population in each location
--Use CTE
--With PopvsVac (Continent, Location, date, Population, new_vaccinations, RollingPplVaccinated)
--as
--(Select Vac.continent, Vac.location, Vac.date, Dea.population, Vac.new_vaccinations, sum(Cast(Vac.new_vaccinations as float)) over (Partition by Vac.location Order by Vac.location,Vac.date) as RollingPplVaccinated
--From dbo.[CovidVaccination'] Vac
--Join dbo.CovidDeath Dea
--	On Vac.location = Dea.location
--	and Vac.date = Dea.date
--Where Vac.continent is not null
----Order by 2,3
--)
--Select Location, population, Max(RollingPplVaccinated/Population)*100 as VaccinationRate
--From PopvsVac
--Group by Location, population
--Order by 1

--Temp Table
--Drop Table if  exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population int,
--new_vaccinations int,
--RollingPplVaccinated numeric
--)
--insert into #PercentPopulationVaccinated
--Select Vac.continent, Vac.location, Vac.date, Dea.population, Vac.new_vaccinations, sum(Cast(Vac.new_vaccinations as float)) over (Partition by Vac.location Order by Vac.location,Vac.date) as RollingPplVaccinated
--From dbo.[CovidVaccination'] Vac
--Join dbo.CovidDeath Dea
--	On Vac.location = Dea.location
--	and Vac.date = Dea.date
--Where Vac.continent is not null
----Order by 2,3

--Select*
--From #PercentPopulationVaccinated


--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select Vac.continent, Vac.location, Vac.date, Dea.population, Vac.new_vaccinations, sum(Cast(Vac.new_vaccinations as float)) over (Partition by Vac.location Order by Vac.location,Vac.date) as RollingPplVaccinated
From dbo.[CovidVaccination'] Vac
Join dbo.CovidDeath Dea
	On Vac.location = Dea.location
	and Vac.date = Dea.date
Where Vac.continent is not null
--Order by 2,3
