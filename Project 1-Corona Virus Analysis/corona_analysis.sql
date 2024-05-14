-- Active: 1714717450460@@127.0.0.1@3306@corona

-- Q1. Check NULL values
SELECT 
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Null_Province,
    SUM(CASE WHEN CountryRegion IS NULL THEN 1 ELSE 0 END) AS Null_CountryRegion,
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS Null_Latitude,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS Null_Longitude,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS Null_Confirmed,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS Null_Deaths,
    SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS Null_Recovered
FROM CoronaVirusData;

-- Q2. Update NULL values with zeros
UPDATE CoronaVirusData
SET 
    Province = COALESCE(Province, '0'),
    CountryRegion = COALESCE(CountryRegion, '0'),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, '0'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0)
WHERE 
    Province IS NULL 
    OR CountryRegion IS NULL 
    OR Latitude IS NULL 
    OR Longitude IS NULL 
    OR Date IS NULL 
    OR Confirmed IS NULL 
    OR Deaths IS NULL 
    OR Recovered IS NULL;
-- Q3. Check total number of rows
SELECT COUNT(*) AS Total_Rows FROM CoronaVirusData;
-- Q4. Check start_date and end_date
SELECT MIN(Date) AS Start_Date, MAX(Date) AS End_Date FROM CoronaVirusData;

-- Q5. Number of months present in dataset
SELECT COUNT(DISTINCT DATE_FORMAT(Date, '%Y-%m')) AS Months_Count FROM CoronaVirusData;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    AVG(Confirmed) AS Avg_Confirmed,
    AVG(Deaths) AS Avg_Deaths,
    AVG(Recovered) AS Avg_Recovered
FROM CoronaVirusData
GROUP BY DATE_FORMAT(Date, '%Y-%m');
---

-- Q7. Find most frequent value for confirmed, deaths, recovered each month
SELECT 
    Month,
    Mode_Confirmed,
    Mode_Deaths,
    Mode_Recovered
FROM (
    SELECT 
        DATE_FORMAT(Date, '%Y-%m') AS Month,
        ROUND(AVG(Confirmed), 0) AS Mode_Confirmed,
        ROUND(AVG(Deaths), 0) AS Mode_Deaths,
        ROUND(AVG(Recovered), 0) AS Mode_Recovered,
        ROW_NUMBER() OVER(PARTITION BY DATE_FORMAT(Date, '%Y-%m') ORDER BY COUNT(*) DESC) AS rn
    FROM CoronaVirusData
    GROUP BY DATE_FORMAT(Date, '%Y-%m'), Confirmed, Deaths, Recovered
) AS t
WHERE rn = 1;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year,
    MIN(Confirmed) AS Min_Confirmed,
    MIN(Deaths) AS Min_Deaths,
    MIN(Recovered) AS Min_Recovered
FROM CoronaVirusData
GROUP BY YEAR(Date);

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year,
    MAX(Confirmed) AS Max_Confirmed,
    MAX(Deaths) AS Max_Deaths,
    MAX(Recovered) AS Max_Recovered
FROM CoronaVirusData
GROUP BY YEAR(Date);

-- Q10. The total number of cases of confirmed, deaths, recovered each month
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    SUM(Confirmed) AS Total_Confirmed,
    SUM(Deaths) AS Total_Deaths,
    SUM(Recovered) AS Total_Recovered
FROM CoronaVirusData
GROUP BY DATE_FORMAT(Date, '%Y-%m');

-- Q11. Check how corona virus spread out with respect to confirmed case
SELECT 
    SUM(Confirmed) AS Total_Confirmed,
    AVG(Confirmed) AS Average_Confirmed,
    VARIANCE(Confirmed) AS Variance_Confirmed,
    STDDEV(Confirmed) AS Stdev_Confirmed
FROM CoronaVirusData;

-- Q12. Check how corona virus spread out with respect to death case per month
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    SUM(Deaths) AS Total_Deaths,
    AVG(Deaths) AS Average_Deaths,
    VARIANCE(Deaths) AS Variance_Deaths,
    STDDEV(Deaths) AS Stdev_Deaths
FROM CoronaVirusData
GROUP BY DATE_FORMAT(Date, '%Y-%m');

-- Q13. Check how corona virus spread out with respect to recovered case
SELECT 
    SUM(Recovered) AS Total_Recovered,
    AVG(Recovered) AS Average_Recovered,
    VARIANCE(Recovered) AS Variance_Recovered,
    STDDEV(Recovered) AS Stdev_Recovered
FROM CoronaVirusData;

-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    CountryRegion,
    MAX(Confirmed) AS Highest_Confirmed
FROM CoronaVirusData
GROUP BY CountryRegion
ORDER BY MAX(Confirmed) DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT 
    CountryRegion,
    SUM(Deaths) AS Total_Deaths,
FROM CoronaVirusData
GROUP BY CountryRegion
ORDER BY MIN(Total_Deaths)
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case
SELECT 
    CountryRegion,
    SUM(Recovered) AS Total_Recovered
FROM CoronaVirusData
GROUP BY CountryRegion
ORDER BY SUM(Recovered) DESC
LIMIT 5;
