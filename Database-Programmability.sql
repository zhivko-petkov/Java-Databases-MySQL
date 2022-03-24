--01. Employees with Salary Above 35000
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN 
	SELECT first_name, last_name 
    FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END 

--02. Employees with Salary Above Number
CREATE PROCEDURE usp_get_employees_salary_above(numb DECIMAL(10,4))
BEGIN 
	SELECT first_name, last_name 
    FROM employees
    WHERE salary >= numb
    ORDER BY first_name, last_name, employee_id;
END

--03. Town Names Starting With
CREATE PROCEDURE usp_get_towns_starting_with(text_string CHAR(60))
BEGIN 
	SELECT name
    FROM towns
    WHERE name LIKE CONCAT(text_string, '%')
    ORDER BY name;
END

--04. Employees from Town
CREATE PROCEDURE usp_get_employees_from_town(text_string CHAR(60))
BEGIN 
SELECT e.first_name, e.last_name FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
WHERE t.name = text_string
ORDER BY e.first_name, e.last_name, e.employee_id;
END

--05. Salary Level Function
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19,4))
RETURNS VARCHAR(10)
BEGIN 
	DECLARE salary_level VARCHAR(10);
	IF(salary < 30000)
		THEN SET salary_level:= 'Low';
    ELSEIF(salary >= 30000 AND salary <= 50000) 
		THEN SET salary_level:= 'Average';
    ELSEIF(salary > 50000)
		THEN SET salary_level:='High';
    END IF; 
RETURN salary_level;
END

--06. Employees by Salary Level
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19,4))
RETURNS VARCHAR(10)
BEGIN 
	DECLARE salary_level VARCHAR(10);
	IF(salary < 30000)
		THEN SET salary_level:= 'Low';
    ELSEIF(salary >= 30000 AND salary <= 50000) 
		THEN SET salary_level:= 'Average';
    ELSEIF(salary > 50000)
		THEN SET salary_level:='High';
    END IF; 
RETURN salary_level;
END;

CREATE PROCEDURE usp_get_employees_by_salary_level(levelOfSalary CHAR(60))
BEGIN 
SELECT first_name, last_name FROM employees
WHERE (SELECT ufn_get_salary_level(salary)) = levelOfSalary
ORDER BY first_name DESC, last_name DESC;
END;

--07. Define Function
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
DETERMINISTIC
BEGIN
    DECLARE count_let INT DEFAULT 1;
    DECLARE length INT;
    DECLARE current_char VARCHAR(5);
    SET length = CHAR_LENGTH(word);
 
    iter_word: LOOP
    SET current_char = SUBSTR(word,count_let,1);
    IF LOCATE(current_char,set_of_letters)=0 THEN RETURN 0;
    ELSEIF count_let=length THEN RETURN 1;
    END IF;
    SET count_let = count_let + 1;
    END LOOP iter_word;
END

--08. Find Full Name
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
    SELECT 
        CONCAT_WS(' ', h.first_name, h.last_name) AS 'full_name'
    FROM
        `account_holders` AS h
            JOIN
        (SELECT DISTINCT
            a.account_holder_id
        FROM
            `accounts` AS a) as a ON h.id = a.account_holder_id
    ORDER BY `full_name`;
END

--10. Future Value Function
CREATE FUNCTION ufn_calculate_future_value(
    initial_sum DECIMAL(19, 4), interest_rate DECIMAL(19, 4), years INT)
RETURNS DECIMAL(19, 4)
-- RETURNS DOUBLE(19, 2) -- Judge
BEGIN
    RETURN initial_sum * POW((1 + interest_rate), years);
END

--12. Deposit Money
CREATE PROCEDURE usp_deposit_money(
    account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance + money_amount
        WHERE
            a.id = account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END

--13. Withdraw Money
CREATE PROCEDURE usp_withdraw_money(
    account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance - money_amount
        WHERE
            a.id = account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END

--14. Money Transfer
CREATE PROCEDURE usp_transfer_money(
    from_account_id INT, to_account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 
        AND from_account_id <> to_account_id 
        AND (SELECT a.id 
            FROM `accounts` AS a 
            WHERE a.id = to_account_id) IS NOT NULL
        AND (SELECT a.id 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) IS NOT NULL
        AND (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) >= money_amount
    THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance + money_amount
        WHERE
            a.id = to_account_id;
            
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance - money_amount
        WHERE
            a.id = from_account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END
