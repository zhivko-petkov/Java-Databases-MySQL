--01. Employee Address
SELECT e.employee_id, e.job_title, e.address_id, a.address_text 
FROM employees e JOIN addresses a
ON e.address_id = a.address_id
ORDER BY e.address_id LIMIT 5;

--02. Addresses with Towns
SELECT e.first_name, e.last_name, t.name AS town, a.address_text
FROM employees e JOIN addresses a
ON e.address_id = a.address_id 
JOIN towns t 
ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name LIMIT 5;

--03. Sales Employee
SELECT e.employee_id, e.first_name, e.last_name, d.name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

--04. Employee Departments
SELECT e.employee_id, e.first_name, e.salary, d.name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC LIMIT 5;

--05. Employees Without Project
SELECT e.employee_id, e.first_name
FROM employees e LEFT JOIN employees_projects ep
ON e.employee_id = ep.employee_id
WHERE ep.project_id is NULL
ORDER BY e.employee_id DESC LIMIT 3; 

--06. Employees Hired After
SELECT e.first_name, e.last_name, e.hire_date, d.name as dept_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE e.hire_date > '1999-1-1' AND (d.name = 'Sales' OR d.name = 'Finance')
ORDER BY e.hire_date;

--07. Employees with Project
SELECT e.employee_id, e.first_name, p.name AS project_name
FROM employees e 
JOIN employees_projects ep
ON e.employee_id = ep.employee_id
JOIN projects p 
ON ep.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name, p.name LIMIT 5;

--08. Employee 24
SELECT e.employee_id, e.first_name, IF(YEAR(p.start_date) >= '2005', NULL, p.name) AS project_name
FROM employees e 
JOIN employees_projects ep
ON e.employee_id = ep.employee_id
JOIN projects p 
ON ep.project_id = p.project_id
WHERE e.employee_id = 24 
ORDER BY p.name;

--09. Employee Manager
SELECT employee_id, first_name, manager_id, 
(SELECT first_name FROM employees WHERE employee_id = e.manager_id) AS manager_name
FROM employees e 
WHERE manager_id = 3 OR manager_id = 7
ORDER BY first_name;

--10. Employee Summary
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
(SELECT CONCAT(first_name, ' ', last_name) FROM employees WHERE employee_id = e.manager_id) AS manager_name,
(SELECT name FROM departments WHERE department_id = e.department_id) AS department_name
FROM employees e 
WHERE e.manager_id IS NOT NULL
ORDER BY e.employee_id LIMIT 5;

--11. Min Average Salary
CREATE VIEW sal AS
SELECT AVG(salary) AS average_salary
FROM employees
GROUP BY department_id; 

SELECT MIN(average_salary) AS min_average_salary
FROM sal;

--12. Highest Peaks in Bulgaria
SELECT country_code, mountain_range, peak_name, elevation
FROM mountains_countries mc JOIN mountains m
ON mc.mountain_id = m.id
JOIN peaks p 
ON m.id = p.mountain_id
WHERE country_code = 'BG' AND elevation > 2835
ORDER BY elevation DESC;

--13. Count Mountain Ranges
SELECT country_code, COUNT(mountain_id) AS mountain_range
FROM mountains_countries
WHERE country_code = 'US' OR country_code = 'RU' OR country_code = 'BG'
GROUP BY country_code
ORDER BY mountain_range DESC;

--14. Countries with Rivers
SELECT c.country_name, r.river_name
FROM 
	countries c
		LEFT JOIN
	countries_rivers cr ON c.country_code = cr.country_code
		LEFT JOIN
	rivers r ON r.id = cr.river_id
		JOIN 
	continents con ON con.continent_code = c.continent_code
WHERE con.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

--16. Countries without any Mountains
SELECT 
    COUNT(*) AS country_count
FROM
    (SELECT 
        mc.country_code AS 'mc_country_code'
    FROM
        mountains_countries AS mc
    GROUP BY mc.country_code) AS d
        RIGHT JOIN
    countries AS c ON c.country_code = d.mc_country_code
WHERE
    d.mc_country_code IS NULL;
    
 --17. Highest Peak and Longest River by Country
 SELECT 
    c.country_name,
    MAX(p.elevation) AS 'highest_peak_elevation',
    MAX(r.length) AS 'longest_river_length'
FROM
    countries AS c
        LEFT JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        LEFT JOIN
    peaks AS p ON mc.mountain_id = p.mountain_id
        LEFT JOIN
    countries_rivers AS cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers AS r ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC , longest_river_length DESC , c.country_name
LIMIT 5;
