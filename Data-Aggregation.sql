--01. Records’ Count
SELECT COUNT(`id`) AS 'count'
FROM wizzard_deposits;

--02. Longest Magic Wand
SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM wizzard_deposits;

--03. Longest Magic Wand per Deposit Groups
SELECT `deposit_group`, MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM wizzard_deposits
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand`, `deposit_group`;

--04. Smallest Deposit Group per Magic Wand Size
SELECT `deposit_group`
FROM wizzard_deposits
GROUP BY `deposit_group`
ORDER BY MIN(`magic_wand_size`)
LIMIT 1;

--05. Deposits Sum
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM wizzard_deposits
GROUP BY `deposit_group`
ORDER BY `total_sum`;

--06. Deposits Sum for Ollivander Family
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM wizzard_deposits
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

--07. Deposits Filter
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM wizzard_deposits
WHERE `magic_wand_creator` = 'Ollivander family' 
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

--08. Deposit Charge
SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS 'min_deposit_charge'
FROM wizzard_deposits
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator`, `deposit_group`;

--09. Age Groups
CREATE VIEW agee AS
SELECT CASE
WHEN `age` >= 0 AND `age` <= 10 THEN '[0-10]'
WHEN `age` >= 11 AND `age` <= 20 THEN '[11-20]'
WHEN `age` >= 21 AND `age` <= 30 THEN '[21-30]'
WHEN `age` >= 31 AND `age` <= 40 THEN '[31-40]'
WHEN `age` >= 41 AND `age` <= 50 THEN '[41-50]'
WHEN `age` >= 51 AND `age` <= 60 THEN '[51-60]'
WHEN `age` >= 61  THEN '[61+]'
END AS 'age_group'
FROM `wizzard_deposits`;


SELECT `age_group`, COUNT(`age_group`) AS 'wizard_count' 
FROM `agee`
GROUP BY `age_group`
ORDER BY `age_group`;

--10. First Letter
SELECT SUBSTRING(`first_name`, 1, 1) AS 'first_letter' 
FROM wizzard_deposits
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;

--11. Average Interest
SELECT `deposit_group`, `is_deposit_expired`, AVG(`deposit_interest`) AS 'average_interest'
FROM wizzard_deposits
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY `deposit_group` DESC, `is_deposit_expired` ASC;  

--12. Employees Minimum Salaries
SELECT `department_id`, MIN(`salary`) AS 'minimum_salary'
FROM employees
WHERE hire_date > '2000-01-01'
GROUP BY `department_id`
HAVING `department_id` = 2 OR `department_id` = 5 OR `department_id` = 7
ORDER BY `department_id` ASC;

--13. Employees Average Salaries
CREATE TABLE `newTable` (
`employee_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
`first_name` VARCHAR(50), 
`last_name` VARCHAR(50),
`middle_name` VARCHAR(50),
`job_title` VARCHAR(50),
`department_id` INT,
`manager_id` INT,
`hire_date` TIMESTAMP(6), 
`salary` DECIMAL(19, 4),
`address_id` INT
);

INSERT INTO newTable
SELECT * FROM employees
WHERE `salary` > 30000;


DELETE FROM newTable
WHERE `manager_id` = 42;

UPDATE newTable
SET `salary` = `salary` + 5000
WHERE `department_id` = 1; 


SELECT `department_id`, AVG(`salary`) AS 'avg_salary' 
FROM newTable
GROUP BY `department_id`
ORDER BY `department_id`;

--14. Employees Maximum Salaries
SELECT `department_id`, MAX(`salary`) AS 'max_salary'
FROM employees
GROUP BY `department_id`
HAVING `max_salary` < 30000 OR `max_salary` > 70000
ORDER BY `department_id`;

--15. Employees Count Salaries
SELECT COUNT('salary') AS ''
FROM employees
WHERE `manager_id` IS null; 

--16. 3rd Highest Salary
SELECT e.`department_id`, 
(
	SELECT DISTINCT `salary` FROM employees AS e2
    WHERE e2.`department_id` = e.`department_id`
    ORDER BY e2.`salary` DESC
    LIMIT 1 OFFSET 2 
) AS 'third_highest_salary'
FROM employees AS e
GROUP BY e.`department_id`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY e.`department_id`; 

--17. Salary Challenge
SELECT `first_name`, `last_name`, `department_id`
FROM `employees` AS `e`
WHERE `salary` > (SELECT AVG(`salary`) FROM `employees`
				  WHERE `department_id` = e.`department_id`)
ORDER BY `department_id`, `employee_id`
LIMIT 10;
