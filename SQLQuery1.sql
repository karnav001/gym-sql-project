     -- Membership & Revenue Analysis
--1 Total revenue per month
select datepart(month,payment_date) as Month_of_Payment
,datepart(year,payment_date) as Year_of_Payment,sum(amount)as Total_amount
from payments group by datepart(month,payment_date),datepart(year,payment_date)
--2 Most popular membership type
SELECT 
    membership_type, 
    COUNT(*) AS Number_of_Members
FROM 
    members
GROUP BY 
    membership_type
ORDER BY 
    Number_of_Members DESC;
	--3 Average revenue per member
SELECT 
    SUM(amount) * 1.0 / COUNT(DISTINCT M.member_id) AS Average_Revenue_Per_Member
FROM 
    members M
INNER JOIN 
    payments P ON M.member_id = P.member_id
	       --Customer Retention
	--4 How many members joined each month?

select count(name) as No_of_member ,DATEPART(MONTH,join_date) as Month,
DATEPART(YEAR,join_date)as Year
from members group by DATEPART(MONTH,join_date) ,
DATEPART(year,join_date)
--5 How many members haven't checked in in the last 30/60 days
SELECT COUNT(*) as "Members_Haven't_Checked"
FROM members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id
    FROM checkins
    WHERE checkin_date >= DATEADD(DAY, -30, GETDATE())
);
--6 Which membership type has the highest retention
SELECT 
    m.membership_type,
    COUNT(CASE WHEN lp.last_payment_date >= DATEADD(DAY, -90, '2023-12-31') THEN 1 END) * 1.0 / COUNT(*) 
	AS Retention_Rate
FROM members m
LEFT JOIN (
    SELECT 
        member_id,
        MAX(payment_date) AS last_payment_date
    FROM payments
    GROUP BY member_id
) lp ON m.member_id = lp.member_id
GROUP BY m.membership_type
ORDER BY Retention_Rate DESC
     --Gym Usage Trends
--7 What are the busiest days of the week
SELECT 
    DATENAME(WEEKDAY, checkin_date) AS day_of_week,
    COUNT(*) AS total_checkins
FROM 
    checkins
GROUP BY 
    DATENAME(WEEKDAY, checkin_date)
ORDER BY 
    total_checkins DESC;

--8 What time of year has the highest check-ins
	SELECT 
    DATENAME(MONTH, checkin_date) AS month_name,
    MONTH(checkin_date) AS month_number,
    COUNT(*) AS total_checkins
FROM 
    checkins
GROUP BY 
    DATENAME(MONTH, checkin_date), MONTH(checkin_date)
ORDER BY 
    total_checkins DESC;
	--9 Who are the top 10 most active members
	SELECT TOP 10
    m.member_id,
    m.name,
    COUNT(c.checkin_id) AS total_checkins
FROM 
    checkins c
JOIN 
    members m ON c.member_id = m.member_id
GROUP BY 
    m.member_id, m.name
ORDER BY 
    total_checkins DESC;

	---10 Breakdown of members by gender and age group
	SELECT 
    gender,
    CASE 
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS total_members
FROM 
    members
GROUP BY 
    gender,
    CASE 
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Over 50'
    END
ORDER BY 
    gender, age_group;
	--11 Average age by membership type
	SELECT 
    membership_type,
    AVG(age) AS average_age
FROM 
    members
GROUP BY 
    membership_type


	





































