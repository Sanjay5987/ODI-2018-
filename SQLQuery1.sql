select * from portfolioproject..odi

--Seperating run out and wicket out column from Margin column

alter table portfolioproject..odi
add runs numeric

update portfolioproject..odi
set runs = Left(margin, charindex(' ',Margin) -1)

alter table portfolioproject..odi
add out nvarchar(255) 

update portfolioproject..odi
set out = Right(Margin,len(Margin) -charindex(' ',Margin)) 

alter table portfolioproject..odi
add runout numeric

update portfolioproject..odi
set runout = runs
where out = 'runs'

alter table portfolioproject..odi
add wicketout numeric

update portfolioproject..odi
set wicketout = runs
where out = 'wickets'


--Total matches played in 2018
select Year, count(Year) as Total_matches
from portfolioproject..odi
group by Year

--No. of matches won by teams 

select Winner as teams, count(Winner) as matches_won
from portfolioproject..odi
where Winner <> 'no result'
group by Winner
order by matches_won desc

--Matches where no results were out
Select [Team 1],[Team 2],Ground,Year,month
from portfolioproject..odi
where Winner = 'no result'

--When Match Tied
Select [Team 1],[Team 2],Ground,Year,month
from portfolioproject..odi
where Winner = 'tied'

--Setting up column for lost matches

Alter table portfolioproject..odi
add Loser nvarchar(255)

update portfolioproject..odi
set Loser = [Team 1]
where Winner = [Team 2]

update portfolioproject..odi
set Loser = [Team 2]
where Winner = [Team 1]

--No of matches lost by the teams
Select Loser as team, count(Loser) as matches_lost
from portfolioproject..odi
where Winner <> 'no resut'  or
 Winner <> 'tied' 
group by Loser
Having count(Loser) <> 0
order by matches_lost desc


--No. of matches played in the grounds
Select Ground, count(Ground) as numofmatchesplayed
from portfolioproject..odi
group by Ground
order by numofmatchesplayed desc

--Percentage of matches won by india
select Winner as Team, (Count(Winner)*100/128) as Percentage_of_matches_won
from portfolioproject..odi
where winner = 'India'
Group by Winner

--Top 3 Wins by run
select [Team 1], [Team 2], Winner, Ground, runout as Out_by_run
from portfolioproject..odi
order by Out_by_run Desc


--Top 3 wins by wickets
select [Team 1], [Team 2], Winner, Ground, wicketout as Out_by_wicket
from portfolioproject..odi
order by Out_by_wicket Desc

--Month in which most odis were played
select Month, count(Month) as num_of_matches
from portfolioproject..odi
group by Month
order by num_of_matches desc

--Did india won mostly by chasing or playing first
Select Winner, count(runout) as Playing_first, count(wicketout) as chasing
from portfolioproject..odi
where Winner = 'India'
Group by Winner


