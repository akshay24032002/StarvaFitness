use starva

select * from dailyActivity
select * from heartrateSeconds
select * from hourlyIntensities
select * from hourlyCalories
select * from hourlySteps
select * from sleepDay
select * from weightLogInfo

select count(distinct Time) from heartrateSeconds

SELECT 
    Id,Time_Period,format(ActivityHour,'yyyy-MM-dd') as date,
    SUM(Calories) AS TotalCalories
FROM hourlyCalories
WHERE Time_Period=0 and format(ActivityHour,'yyyy-MM-dd') = '2016-04-12'
GROUP BY Id,Time_Period,format(ActivityHour,'yyyy-MM-dd')
ORDER BY date



select count(distinct Id) from dailyActivity
select min(ActivityDay),max(ActivityDay) from dailyActivity
select min(TotalSteps),max(TotalSteps) from dailyActivity
select *,round(TotalDistance,2) from dailyActivity order by TotalDistance desc

select min(Value),MAX(Value) from heartrateSeconds
select distinct Id,Time,Value,Time_Period,hr_zone,count(TimeBlock) from heartrateSeconds where Value > 80 group by Id,Time,Value,Time_Period,hr_zone order by value desc
select * from heartrateSeconds where Value > 80 order by Id

1. Daily Steps vs Calories Burned :

SELECT a.Id,a.ActivityDay,a.TotalSteps,a.Calories FROM dailyActivity a ORDER BY a.TotalSteps DESC

2. Join Daily Activity with Sleep Data :

SELECT distinct a.Id,a.ActivityDay,s.TotalMinutesAsleep,s.TotalTimeInBed,avg(a.TotalSteps) as average_steps
FROM dailyActivity a JOIN sleepDay s ON a.Id = s.Id group by a.Id,a.ActivityDay,s.TotalMinutesAsleep,
s.TotalTimeInBed ORDER BY s.TotalMinutesAsleep DESC

3. Heart Rate Summary by Day :

SELECT Id,Time,AVG(Value) AS AvgHeartRate,MAX(Value) AS MaxHeartRate,MIN(Value) AS MinHeartRate FROM heartrateSeconds
GROUP BY Id,Time ORDER BY Time

4. Hourly Steps and Calories Merge :

SELECT s.Id,s.TimeBlock,SUM(s.StepTotal) AS total_steps,SUM(c.Calories) AS total_calories FROM hourlySteps s
JOIN hourlyCalories c ON s.Id = c.Id AND s.ActivityHour = c.ActivityHour GROUP BY s.Id,s.timeBlock
ORDER BY total_steps DESC

5. Daily Weight Changes:

SELECT Id,Date,WeightKg,BMI FROM weightLogInfo ORDER BY Id, Date

6. Top 5 Most Active Users (by Total Distance):

SELECT TOP 5 Id,SUM(TotalDistance) AS TotalDistance FROM dailyActivity GROUP BY Id 
ORDER BY TotalDistance DESC;

7. Calories Burned by Intensity Level :

SELECT Id,ActivityDay,SedentaryMinutes,LightlyActiveMinutes,FairlyActiveMinutes,VeryActiveMinutes
FROM dailyActivity ORDER BY ActivityDay

8. Merge the data all data sets :

SELECT a.Id,a.ActivityDay,a.TotalSteps,a.TotalDistance,a.VeryActiveMinutes AS intensity_very_active,a.ModeratelyActiveDistance,a.LightActiveDistance,
a.VeryActiveMinutes,a.FairlyActiveMinutes,a.SedentaryMinutes,a.Calories,a.TotalActiveMinutes,a.steps_category,a.calories_per_step,
a.SedentaryMinutes AS intensity_sedentary,
s.TotalMinutesAsleep,s.TotalTimeInBed,s.timeBlock,s.Sleep_efficiency,s.sleep_quality,s.time_to_sleep,
w.WeightKg,w.BMI,w.Time_Period,w.TimeBlock,w.BMI_Category,
ds.StepTotal AS daily_step_total,ds.Time_Period,ds.TimeBlock
FROM dailyActivity a LEFT JOIN sleepDay s ON a.Id = s.Id AND a.ActivityDay = s.SleepDay
LEFT JOIN weightLogInfo w ON a.Id = w.Id AND a.ActivityDay = w.Date
LEFT JOIN hourlySteps ds ON a.Id = ds.Id AND a.ActivityDay = ds.ActivityHour
LEFT JOIN hourlyIntensities di ON a.Id = di.Id AND a.ActivityDay = di.ActivityHour
ORDER BY a.Id, a.ActivityDay

