--CREATE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS(
SELECT 
    CD.continent,
	CD.location,
	CD.date,
	CD.population,
	CV.new_vaccinations,
	SUM(CONVERT(int,CV.new_vaccinations)) OVER(PARTITION BY CD.location ORDER BY  CD.continent,
	CD.location ROWS UNBOUNDED PRECEDING ) AS RollingPeopleVaccinated
FROM CovidDeaths CD
JOIN CovidVaccinations CV
    ON CD.location = CV.location AND CD.date = CV.date
WHERE CD.continent is not NULL
)
SELECT *, (RollingPeopleVaccinated / Population)*100 
FROM PopvsVac

--CREATE #TEMP_TABLE

DROP TABLE IF EXISTS #Temp_PercentPopulationVaccinated
CREATE TABLE #Temp_PercentPopulationVaccinated
(
Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

INSERT INTO #Temp_PercentPopulationVaccinated
SELECT 
    CD.continent,
	CD.location,
	CD.date,
	CD.population,
	CV.new_vaccinations,
	SUM(CONVERT(int,CV.new_vaccinations)) OVER(PARTITION BY CD.location ORDER BY  CD.continent,
	CD.location ROWS UNBOUNDED PRECEDING ) AS RollingPeopleVaccinated
FROM CovidDeaths CD
JOIN CovidVaccinations CV
    ON CD.location = CV.location AND CD.date = CV.date
WHERE CD.continent is not NULL

SELECT *, (RollingPeopleVaccinated / population)*100 
FROM #Temp_PercentPopulationVaccinated


--CREATE VIEW FOR DATA VISUALIZATION
CREATE VIEW PercentPeopleVaccinated AS
SELECT 
    CD.continent,
	CD.location,
	CD.date,
	CD.population,
	CV.new_vaccinations,
	SUM(CONVERT(int,CV.new_vaccinations)) OVER(PARTITION BY CD.location ORDER BY  CD.continent,
	CD.location ROWS UNBOUNDED PRECEDING ) AS RollingPeopleVaccinated
FROM CovidDeaths CD
JOIN CovidVaccinations CV
    ON CD.location = CV.location AND CD.date = CV.date
WHERE CD.continent is not NULL

SELECT *
FROM PercentPeopleVaccinated