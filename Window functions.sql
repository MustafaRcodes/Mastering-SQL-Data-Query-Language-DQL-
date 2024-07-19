-- WINDOW FUNCTIONS -- 
/* 
ROW_NUMBER(): Unique sequential integer. in sequance without gap. give position number and no duplicate
RANK(): Rank with gaps for ties. Give number by position, if same values in order by, rank will be the same/duplicate number and will skim next number
DENSE_RANK(): Rank without gaps for ties. Give number numarically, if same values in order by, rank will be the same/duplicate number, not by position
LAG(): Access previous row's value.
LEAD(): Access next row's value.
PERCENT_RANK(): Relative rank as a percentage.
CUME_DIST(): Cumulative distribution percentage.
NTILE(): Divides data into buckets (e.g., quartiles).
FIRST_VALUE(): First value in ordered partition.
LAST_VALUE(): Last value in ordered partition.
NTH_VALUE(): Nth value in ordered partition.

PARTITION BY -- MEANS IT WILL GIVE RESULT BASED ON PARTITION BY
ORDER BY -- MEANS IT WILL ORDER RESULT BASED ON ORDER BY
*/

-- SUM SALARY - ROLLING TOTAL -- 

SELECT
   dem.first_name,
   dem.last_name,
   gender,
   salary,
   SUM(salary) OVER (PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
   FROM 
     employee_demographic dem
    JOIN employee_salary sal
         ON dem.employee_id = sal.employee_id;
         
-- ROW_NUMBER(): Unique sequential integer --

SELECT
   dem.employee_id,
   dem.first_name,
   dem.last_name,
   gender,
   salary,
   ROW_NUMBER() OVER()
   FROM 
     employee_demographic dem
    JOIN employee_salary sal
         ON dem.employee_id = sal.employee_id;

SELECT
   dem.employee_id,
   dem.first_name,
   dem.last_name,
   gender,
   salary,
   ROW_NUMBER() OVER(PARTITION BY gender)
   FROM 
     employee_demographic dem
    JOIN employee_salary sal
         ON dem.employee_id = sal.employee_id;

-- ROW NUMBER, RANK AND DENSE RANK --
         
SELECT
   dem.employee_id,
   dem.first_name,
   dem.last_name,
   gender,
   salary,
   ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
   RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
   DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
   FROM 
     employee_demographic dem
    JOIN employee_salary sal
         ON dem.employee_id = sal.employee_id;

-- LEAD AND LAG --
-- will display the past record --
SELECT e.*,
LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id DESC) AS prev_emp_salary
FROM employee e;

-- Two records previous to the first record --

SELECT e.*,
LAG(salary,2,0) OVER(PARTITION BY dept_name ORDER BY emp_id DESC) AS prev_emp_salary
FROM employee e;

-- Comparision -- 

SELECT e.*,
LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id DESC) AS prev_emp_salary,
CASE WHEN e.salary > LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id DESC) then 'Higher than previous employee'
	 WHEN e.salary < LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id DESC) then 'Lower than previous employee'
     WHEN e.salary = LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id DESC) then 'Same than previous employee'
ELSE 'check'
END AS sal_range
FROM employee e;

-- Will display the next record-- 
SELECT e.*,
LEAD(salary) OVER(PARTITION BY dept_name ORDER BY emp_id DESC) AS prev_emp_salary
FROM employee e;