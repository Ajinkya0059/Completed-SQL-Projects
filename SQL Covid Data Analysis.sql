-- Covid Data Analysis


-- 1. Select all columns from bothn the table and order by location and date
select * from coviddeath order by 3,4;
select * from covidvaccination order by 3,4;

-- 2. Select data from the covid death table
select location, date, total_cases, new_cases, total_deaths, population from coviddeath;


-- 3. Total cases VS Total deaths comparison
select location, date, population, total_cases, total_deaths,  (total_deaths/total_cases)*100 as Deathpercentage from coviddeath;

-- 4. United states death comparison
select location, date, population, total_cases, total_deaths,  (total_deaths/total_cases)*100 as Deathpercentage 
from coviddeath 
where location = 'United States'
order by date;

-- 5. Total case vs population in US
select location, date, population, total_cases, (total_cases/population)*100 as Affected_percentage 
from coviddeath 
where location = 'United States'
order by date;

-- 6. Which country has highest infection rate compared to population
select location, population, Max(total_cases) as Highest_Infection_count, max((total_cases/population)*100) as Affected_percentage
from coviddeath 
group by location, population
order by Affected_percentage DESC;

-- 7. Which country has highest death rate compared to population

select location, population, Max(total_deaths) as Highest_Infection_count, max((total_deaths/population)*100) as Death_percentage
from coviddeath 
where continent is not null
group by location, population
order by Death_percentage DESC;

-- 8. Which continent has highest deaths 
select continent,  Max(total_deaths) as Highest_deathcount
from coviddeath 
group by continent
order by Highest_deathcount DESC;

-- 9. Find no of cases and deaths on each date
select date,  sum(new_cases) as New_cases,sum(cast(new_deaths as int)) as New_deaths  
from coviddeath 
group by date
order by date;

-- 10. Find no of total cases and deaths 
select sum(new_cases) as Allcases,sum(cast(new_deaths as int)) as Alldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as percent_deaths 
from coviddeath;

-- 11. Find percent people vaccinated
select death.population, death.location, death.date, vacc.people_vaccinated, (vacc.people_vaccinated/death.population)*100
from coviddeath as death
Join covidvaccination as vacc
on death.date = vacc.date and death.location = vacc.location
order by death.location;


-- 12. Find the total people vacinations on each day.
 select death.population, death.location, death.date, vacc.new_vaccinations, sum(convert(int,vacc.new_vaccinations)) over (partition by death.location order by death.date) as Total_vaccinated_people
from coviddeath as death
Join covidvaccination as vacc
on death.date = vacc.date and death.location = vacc.location
order by death.location, death.date;

-- 13. Use Common Table Expression to calculate the percent vaccinated population
with peoplevacc(population, location, date, new_vaccination,Total_vaccinated_people)
as
(select death.population, death.location, death.date, vacc.new_vaccinations, sum(convert(int,vacc.new_vaccinations)) over (partition by death.location order by death.date) as Total_vaccinated_people
from coviddeath as death
Join covidvaccination as vacc
on death.date = vacc.date and death.location = vacc.location)
select *, (Total_vaccinated_people/population)*100 from peoplevacc;

-- 14. Create view of Total_vaccinated_people
GO
create view [Total_vaccinated_population] as
select death.population, death.location, death.date, vacc.new_vaccinations, sum(convert(int,vacc.new_vaccinations)) over (partition by death.location order by death.date) as Total_vaccinated_people
from coviddeath as death
Join covidvaccination as vacc
on death.date = vacc.date and death.location = vacc.location;
