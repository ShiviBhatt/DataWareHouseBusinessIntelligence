--1.
Select primaryTitle AS MovieTitle, Avg(Worldwide_LifetimeGross) AS WorldwideGross, Avg(Domestic_Pct) AS DomesticGrossPercentage,
title_imdb_url, BoxOffice_Rank
from dbo.bi_top1k_movies_box_office_worldwide
Group by primaryTitle, title_imdb_url, BoxOffice_Rank
Order by Avg(Worldwide_LifetimeGross) DESC, Avg(Domestic_Pct)

--2. 
Select primaryTitle AS MovieTitle, Release_Year, Avg(Worldwide_LifetimeGross) AS WorldwideGross, Avg(Domestic_Pct) AS DomesticGrossPercentage,
Avg(runtimeMinutes) AS RunTimeMinutes
from dbo.bi_top1k_movies_box_office_worldwide
Group by primaryTitle, Release_Year
Order by Avg(Worldwide_LifetimeGross) DESC, Avg(Domestic_Pct), Avg(runtimeMinutes)

--3. 
Select primaryTitle AS MovieTitle, BoxOffice_Rank, Domestic_LifetimeGross, Foreign_LifetimeGross, runtimeMinutes
from dbo.bi_top1k_movies_box_office_worldwide
Group by primaryTitle, title_imdb_url, BoxOffice_Rank, Domestic_LifetimeGross, Foreign_LifetimeGross, runtimeMinutes

--4. 
Select n.primaryName, n.name_imdb_url, n.birthYear, n.deathYear
from dbo.bi_top1k_imdb_name_basics n


