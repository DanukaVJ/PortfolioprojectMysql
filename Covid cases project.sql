
select Location, date, total_cases, new_cases, total_deaths, population
From coviddeathsnew
order by 1,2;


-- Looking at Total Cases vs Total Death
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
From coviddeathsnew
where Location like '%state%'
order by 5 Desc;

-- Looking at Total Cases vs Population

Select Location, date, total_cases, population, (total_cases/population)*100 AS covid_Percentage_against_population
From coviddeathsnew
Where Location =  'Sri Lanka' AND date  between '01/01/2021' AND '12/31/2021'
order by 5 Desc;


-- Looking at contries with highest infection rate compare to population
Select Location, population, Max(total_cases) AS Highest_Insfection, max((total_cases/population)*100 ) AS Highest_Insfection_percentage
From coviddeathsnew
-- where Location = 'India'
group by Location, population
order by Highest_Insfection Desc
;

-- Showing countries with Higherst death count  by Location
Select Location, max(cast(total_deaths AS double)) AS TotalDeathCount
from coviddeathsnew
group by Location
order by TotalDeathCount Desc
 ;


-- Break Things down by Continents

-- Showing continents with the highest death count per population
Select continent, max(cast(total_deaths As double)) AS Max_totaldeathCount
From coviddeathsnew
Where continent <> ''
Group by continent
order by Max_totaldeathCount Desc
;

-- Global Numbers

Select date, sum(new_cases) AS Total_cases, sum(new_deaths) AS Total_Death , (( sum(new_deaths) / sum(new_cases)))*100 AS Death_percentage
From coviddeathsnew
Where continent is not null AND date between '1/1/2022' AND '12/31/2023'
group by date
order by 1,2 ;


-- Looking at Total Population vs Vaccination

Select CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations 
	, SUM(CV.new_vaccinations) over (partition by CD.location order by CD.location,CD.date) AS Cumalative_TotalVaccination
From coviddeathsnew AS CD join covidvaccination AS CV
on CD.location = CV.location 
	AND CD.date = CV.date
Where CV.new_vaccinations <> ''
order by 2,3
;


-- USE CTE
with PopvsVac (continent, Location, date, Population, new_vaccination, Cumalative_TotalVaccination)
AS
(
Select CD.continent, CD.location, CD.date, CD.population,CV.new_vaccinations 
	, SUM(CV.new_vaccinations) over (partition by CD.location order by CD.location,CD.date) AS Cumalative_TotalVaccination
From coviddeathsnew AS CD join covidvaccination AS CV
on CD.location = CV.location 
	AND CD.date = CV.date
Where CV.new_vaccinations <> ''
-- order by 2,3
)
Select * , (Cumalative_TotalVaccination/Population)*100
From PopVsVac 
;




-- PIVOT TABLE ------
SELECT 
  date, 
  SUM(CASE WHEN continent = 'North America' THEN new_vaccinations END) AS `North America`,
  SUM(CASE WHEN continent = 'South America' THEN new_vaccinations END) AS `South America`,
  SUM(CASE WHEN continent = 'Asia' THEN new_vaccinations END) AS `Asia`,
  SUM(CASE WHEN continent = 'Europe' THEN new_vaccinations END) AS `Europe`,
  SUM(CASE WHEN continent = 'Africa' THEN new_vaccinations END) AS `Africa`,
  SUM(CASE WHEN continent = 'Oceania' THEN new_vaccinations END) AS `Oceania`
FROM 
  covidvaccination
Where date between '1/1/2021' AND '12/31/2021'
GROUP BY 
  date
 ;


 






