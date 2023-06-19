
-- The following SQL code shows the analysis of COVID Deaths and Infection Rates up until 30 April 2021

--_______________________________________________________________________________

-- 1. 
---- Importing excel sheet data for COVID Deaths
---- Arranged by alphabetical order, ascending date and ascending Total Cases

Select *
From PortfolioProject..CovidDeaths$
order by 3,4

--_______________________________________________________________________________

-- 2. 
---- Importing excel sheet data for COVID Vaccinations
---- Arranged by alphabetical order, ascending date and ascending Total Cases

Select *
From PortfolioProject..CovidVaccinations$
order by 3,4

--_______________________________________________________________________________

-- 3. 
---- Importing data that we are planning to use
---- We will be looking at Countries, Date, Total Cases, New Cases, Total Deaths, Population
---- Delete the '--' from the 3rd line if you want to filter out edge cases whereby continent was not inputted in the raw data
---- Arranged by alphabetical order and ascending date

Select 
Location, 
Date, 
Total_Cases, 
New_Cases, 
Total_Deaths, 
Population
From PortfolioProject..CovidDeaths$
-- Where continent is not null
order by 1,2

--_______________________________________________________________________________

-- 4. 
---- Importing data that we are planning to use
---- We will be looking at Countries, Date, Total Cases, New Cases, Total Deaths, Population
---- Filtering out edge cases whereby continent was not inputted in the raw data
---- Arranged by alphabetical order and ascending date

Select Location, 
Date, 
Total_Cases, 
New_Cases, 
Total_Deaths, 
Population
From PortfolioProject..CovidDeaths$
Where continent is not null
order by 1,2

--_______________________________________________________________________________

-- 5. 
---- Number of COVID cases per Country
---- Comparing Total Cases against Population
---- Shows the Infected Percentage per Country
---- Arranged by alphabetical order and ascending date

Select Location, 
Date, 
Population, 
Total_Cases, 
(Total_Cases/Population)*100 as Infected_Percentage
From PortfolioProject..CovidDeaths$
order by 1,2

--_______________________________________________________________________________

-- 6. 
---- COVID cases of Countries with 'United' in their names
---- Comparing Total Cases against Population
---- Shows the Infected Percentage of specific Countries
---- Arranged by alphabetical order and ascending date

Select Location, 
Date, 
Population, 
Total_Cases, 
(Total_Cases/Population)*100 as Infected_Percentage
From PortfolioProject..CovidDeaths$
Where location like '%United%'
order by 1,2

--_______________________________________________________________________________

-- 7. 
---- Global cases and global deaths
---- Comparing Total Cases against Total Deaths
---- Shows the Mortality Rate/ likelihood of dying if one contracts COVID from a global point of view
---- Filtering out edge cases whereby continent was not included in the raw data
---- Arranged in terms of ascending date

Select SUM(New_Cases) as Total_Cases, 
SUM(cast(New_Deaths as int)) as Total_Deaths,
SUM(cast(New_Deaths as int))/SUM(New_Cases)*100 as Mortality_Rate
From PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--_______________________________________________________________________________

-- 8.
---- Compares the cumulative Total Cases against Total Deaths per Country everyday
---- Shows the Mortality Percentage per Country everyday
---- Filtering out edge cases whereby continent was not included in the raw data
---- Arranged by alphabetical order and ascending date

Select Location, 
Date, 
Population,
Total_Cases,
Total_Deaths, 
(Total_Deaths/Total_Cases)*100 as MortalityPercentage
From PortfolioProject..CovidDeaths$
where Continent is not null 
order by 1,2

--_______________________________________________________________________________

-- 9.
---- Compares the cumulative Total Cases against Total Deaths of a specific Country everyday
---- Shows the Mortality Percentage of a specific Country everyday
---- Filtering out edge cases whereby continent was not included in the raw data
---- Arranged by alphabetical order and ascending date

Select Location, 
Date, 
Population,
Total_Cases,
Total_Deaths, 
(Total_Deaths/Total_Cases)*100 as MortalityPercentage
From PortfolioProject..CovidDeaths$
Where Location like '%Sudan%'
and Continent is not null 
order by 1,2

--_______________________________________________________________________________

-- 10. 
---- The Total Death Count of the different continents
---- Catching edge cases whereby continent was not inputted in the raw data
---- Catching edge cases whereby continent was marked as 'World', 'European Union' or 'International'
---- European Union was already account for as part of Europe
---- Arranged by Total Death Count in descending order

Select Location as Continent, 
SUM(cast(New_Deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths$
Where Continent is null 
and Location not in ('World', 'European Union', 'International')
Group by Location
order by Total_Death_Count desc

--_______________________________________________________________________________

-- 11.
---- Comparing the Total Death Count of different countries
---- Shows countries with the highest Total Death Count
---- Filtering out edge cases whereby Continent was not included in the raw data 
---- Arranged by descending order of Total Death Count

Select Location, 
MAX(cast(Total_Deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths$
Where Continent is not null
Group by Location
order by Total_Death_Count desc

--_______________________________________________________________________________

-- 12.
---- Total Death Count of Countries with 'South' in their names
---- Shows the Total Death Count of a specific Country
---- Filtering out edge cases whereby Continent was not included in the raw data 
---- Arranged by descending order of Total Death Count

Select Location, 
MAX(cast(Total_Deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths$
Where Location like '%South%'
and Continent is not null
Group by Location
order by Total_Death_Count desc

--_______________________________________________________________________________

-- 13.
---- Compare Total Death Counts of different Continents 
---- Shows the Continents with the highest Total Death Count
---- Filtering out edge cases whereby Continent was not included in the raw data 

Select Continent, 
MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
-- Where location like '%states%'
Where Continent is not null
Group by continent
order by TotalDeathCount desc

--_______________________________________________________________________________

-- 14.
---- Comparing Population against Infection Count everyday per country
---- Shows the Percentage of Population Infected
---- Arranged by Percentage of Population Infected in descending order

Select Location as Country, 
Population,
Date, 
MAX(Total_Cases) as Infection_Count,  
MAX((Total_Cases/Population))*100 as Percent_Population_Infected
From PortfolioProject..CovidDeaths$
Group by Location, Population, Date
order by Percent_Population_Infected desc

--_______________________________________________________________________________

-- 15.
---- Comparing Population against Highest Infection Count per country
---- Shows the Highest Percentage of Population Infected in a day
---- Arranged by Highest Percentage of Population Infected in descending order

Select Location as Country, 
Population, 
MAX(Total_Cases) as Highest_Infection_Count,  
Max((Total_Cases/Population))*100 as Percent_Population_Infected
From PortfolioProject..CovidDeaths$
Group by Location, Population
order by Percent_Population_Infected desc

--_______________________________________________________________________________

-- 16.
---- Shows the cumulative number of Vaccinated People
---- Arranged by alphabetical order and ascending date

Select dea.Continent, 
dea.Location, 
dea.Date, 
dea.Population, 
MAX(vac.total_vaccinations) as Cumulative_People_Vaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.Location = vac.Location
	and dea.Date = vac.Date
Where dea.Continent is not null
group by dea.Continent, dea.Location, dea.Date, dea.Population
order by 1,2,3

--_______________________________________________________________________________

-- 17.
---- Shows the cumulative number of Vaccinated People of a specific Country
---- Arranged by alphabetical order and ascending date

Select dea.Continent, 
dea.Location, 
dea.Date, 
dea.Population, 
MAX(vac.total_vaccinations) as Cumulative_People_Vaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.Location = vac.Location
	and dea.Date = vac.Date
Where dea.Continent is not null
and dea.Location like '%China%'
group by dea.Continent, dea.Location, dea.Date, dea.Population
order by 1,2,3

--_______________________________________________________________________________

-- 18.
---- Shows the number of New Vaccinations, Cumulative number of Vaccinated people and Percentage of population Vaccinated
---- Filtering out edge cases whereby Continent was not included in the raw data 
---- Arranged by alphabetical order and ascending date

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Cumulative_People_Vaccinated)
as
(
Select dea.Continent, dea.Location, dea.Date, dea.Population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as Cumulative_People_Vaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.Location = vac.Location
	and dea.Date = vac.Date
where dea.Continent is not null 
)
Select *, (Cumulative_People_Vaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac

--_______________________________________________________________________________
