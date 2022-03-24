--01. One-To-One Relationship
CREATE TABLE `passports` (
`passport_id` INT UNIQUE NOT NULL, 
`passport_number` VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE `people` (
`person_id` INT NOT NULL, 
`first_name` VARCHAR(30) NOT NULL, 
`salary` DECIMAL(10, 2) NOT NULL, 
`passport_id` INT UNIQUE NOT NULL
);

INSERT INTO `people` 
VALUES (1, 'Roberto', 43300, 102),
(2, 'Tom', 56100, 103), 
(3, 'Yana', 60200, 101);


INSERT INTO `passports`
VALUES (101, 'N34FG21B'),
(102, 'K65LO4R7'), 
(103, 'ZE657QP2'); 

ALTER TABLE `people` 
ADD PRIMARY KEY(`person_id`);

ALTER TABLE `people`
ADD  CONSTRAINT `fk_passports_people` FOREIGN KEY (`passport_id`)
REFERENCES `passports`(`passport_id`);

--02. One-To-Many Relationship
CREATE TABLE `manufacturers` (
`manufacturer_id` INT NOT NULL,
`name` VARCHAR(30) NOT NULL, 
`established_on` DATE NOT NULL
);

CREATE TABLE `models` (
`model_id` INT NOT NULL, 
`name` VARCHAR(30) NOT NULL,
`manufacturer_id` INT NOT NULL
);

INSERT INTO `manufacturers`
VALUES (1, 'BMW' ,'1916-03-01'),
(2, 'Tesla' ,'2003-01-01'),
(3, 'Lada' ,'1966-05-01');

INSERT INTO `models` 
VALUES (101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2), 
(106, 'Nova', 3);

ALTER TABLE `manufacturers`
ADD PRIMARY KEY (`manufacturer_id`); 

ALTER TABLE `models`
ADD PRIMARY KEY (`model_id`); 

ALTER TABLE `models`
ADD FOREIGN KEY (`manufacturer_id`)
REFERENCES `manufacturers`(`manufacturer_id`);

--03. Many-To-Many Relationship
CREATE TABLE `students`(
`student_id` INT NOT NULL PRIMARY KEY, 
`name` VARCHAR(30) NOT NULL
);

CREATE TABLE `exams`(
`exam_id` INT NOT NULL PRIMARY KEY, 
`name` VARCHAR(30) NOT NULL
);

INSERT INTO `students`
VALUES
(1, 'Mila'),                                      
(2, 'Toni'),
(3, 'Ron');

INSERT INTO `exams`
VALUES
(101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');



CREATE TABLE `students_exams`(
`student_id` INT NOT NULL, 
`exam_id` INT NOT NULL, 
CONSTRAINT pk_students_exams
PRIMARY KEY(student_id, exam_id),
CONSTRAINT fk_students_exams_students
FOREIGN KEY (student_id)
REFERENCES students(student_id),
CONSTRAINT fk_students_exams_exams
FOREIGN KEY (exam_id)
REFERENCES exams(exam_id)
);

INSERT INTO `students_exams`
VALUES 
(1, 101),
(1, 102),
(2,	101),
(3,	103),
(2,	102),
(2,	103);

--04. Self-Referencing
CREATE TABLE `teachers`(
`teacher_id` INT NOT NULL, 
`name` VARCHAR(30), 
`manager_id` INT
);


INSERT INTO `teachers`
VALUES 
(101, 'John', null),	
(102, 'Maya', 106), 
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101), 
(106, 'Greta', 101);

ALTER TABLE `teachers`
ADD PRIMARY KEY (`teacher_id`); 

ALTER TABLE `teachers`
ADD CONSTRAINT fk_teacher_manager_teacher
FOREIGN KEY (manager_id)
REFERENCES `teachers`(teacher_id);

--05. Online Store Database
CREATE TABLE `cities`(
`city_id` INT(11) NOT NULL PRIMARY KEY, 
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE `customers`(
`customer_id` INT(11) NOT NULL PRIMARY KEY, 
`name` VARCHAR(50) NOT NULL, 
`birthday` DATE NOT NULL,
`city_id` INT(11) NOT NULL
);

ALTER TABLE `customers`
ADD CONSTRAINT fk_cities_customers
FOREIGN KEY (city_id)
REFERENCES `cities`(`city_id`);

CREATE TABLE `orders`(
`order_id` INT(11) NOT NULL PRIMARY KEY, 
`customer_id` INT(11) NOT NULL
);

ALTER TABLE `orders`
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES `customers`(`customer_id`);

CREATE TABLE `order_items`(
`order_id` INT(11) NOT NULL, 
`item_id` INT(11) NOT NULL
);

CREATE TABLE `items`(
`item_id` INT(11) NOT NULL PRIMARY KEY,
`name` VARCHAR(50) NOT NULL, 
`item_type_id` INT(11) NOT NULL
);

CREATE TABLE `item_types`(
`item_type_id` INT(11) NOT NULL PRIMARY KEY,
`name` VARCHAR(50) NOT NULL
);

ALTER TABLE `items`
ADD CONSTRAINT fk_items_item_type
FOREIGN KEY (item_type_id)
REFERENCES item_types(item_type_id);

ALTER TABLE `order_items`
ADD PRIMARY KEY(order_id, item_id); 

ALTER TABLE `order_items`
ADD CONSTRAINT order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE `order_items`
ADD CONSTRAINT order_items_items
FOREIGN KEY (item_id)
REFERENCES items(item_id);

--06. University Database
CREATE TABLE `majors`(
`major_id` INT(11) NOT NULL PRIMARY KEY,
`name` VARCHAR(50) NOT NULL);

CREATE TABLE `students`
(
`student_id` INT(11) NOT NULL PRIMARY KEY, 
`student_number` VARCHAR(12) NOT NULL, 
`student_name` VARCHAR(50) NOT NULL,
`major_id` INT(11) NOT NULL
);

CREATE TABLE `payments`
(
`payment_id` INT(11) NOT NULL PRIMARY KEY,
`payment_date` DATE NOT NULL, 
`payment_amount` DECIMAL(8,2) NOT NULL,
`student_id` INT(11) NOT NULL
);

CREATE TABLE `agenda`(
`student_id` INT(11) NOT NULL, 
`subject_id` INT(11) NOT NULL, 
PRIMARY KEY(student_id, subject_id)
);

CREATE TABLE `subjects`(
`subject_id` INT(11) NOT NULL PRIMARY KEY,
`subject_name` VARCHAR(50) NOT NULL
);

ALTER TABLE `students`
ADD CONSTRAINT fk_students_majors
FOREIGN KEY (major_id)
REFERENCES majors(major_id); 

ALTER TABLE `payments`
ADD CONSTRAINT fk_students_payments
FOREIGN KEY (student_id)
REFERENCES students(student_id);

ALTER TABLE `agenda`
ADD CONSTRAINT fk_subjects_agenda
FOREIGN KEY (subject_id)
REFERENCES subjects(subject_id); 

ALTER TABLE `agenda`
ADD CONSTRAINT fk_students_agenda
FOREIGN KEY (student_id)
REFERENCES students(student_id); 

--09. Peaks in Rila
SELECT m.`mountain_range`, p.`peak_name`, p.`elevation` AS peak_elevation
FROM mountains as m JOIN peaks as p 
ON m.id = p.mountain_id
HAVING mountain_range = 'Rila'
ORDER BY p.`elevation`DESC; 


