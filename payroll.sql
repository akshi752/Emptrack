create database if not exists db_project_payroll;
use db_project_payroll;
/*drop database db_project_payroll;*/
/*comments are written by us to maintain professional way of working on a project*/
/*table creations*/
create table department(dept_id int primary key,dept_name varchar(100) not null,location varchar(100));
create table designation(desig_id int primary key,grade varchar(10),desig_name varchar(100) not null);
create table employee(emp_id int primary key,first_name varchar(100) not null,last_name varchar(100)
,desig_id int ,dept_id int ,email varchar(100) unique,
hire_date date,gender enum('male','female','other'),status enum('active','inactive') default 'active',
foreign key(dept_id) references department(dept_id) on delete set null,
foreign key(desig_id) references designation(desig_id) on delete set null);

/* meaning-> if department or designation gets deleted then all employees related to that will set their desig_id or dept_id to null..
that means employees are preserved even if department is deleted ..may be those employees can be reassigned to some other department*/

create table employee_contact(emp_id int,contact_no varchar(15), primary key(emp_id,contact_no),
foreign key (emp_id) references employee(emp_id) on delete cascade);

/* meaning-> when employee is deleted all related contacts will automatically delete*/

create table attendance(att_id int primary key auto_increment,emp_id int,att_date date not null,working_hrs decimal(4,2) ,status enum('present','absent','leave')
,foreign key(emp_id) references employee(emp_id) on delete cascade);
create table leave_record(leave_id int primary key auto_increment,emp_id int,start_date date,leave_type enum('casual','sick','earned'),end_date date,
reason varchar(255),status enum('pending','approved','rejected') default 'pending',
foreign key(emp_id) references employee(emp_id) on delete cascade);
create table salary_structure(salary_id int primary key auto_increment,emp_id int unique,basic_pay decimal(10,2),
deductions decimal(10,2),tax decimal(10,2),hra decimal(10,2),da decimal(10,2),
gross_salary decimal(10,2) generated always as (basic_pay+hra+da-deductions-tax) stored,
foreign key(emp_id) references employee(emp_id) on delete cascade);
/*here gross_salary is derived attribute*/ 

create table payroll(payroll_id int primary key auto_increment,emp_id int,present_days int,
generated_date date,total_days int,month varchar(15),net_salary decimal(10,2),foreign key(emp_id) references
employee(emp_id) on delete cascade);
create table admin_log(log_id int auto_increment primary key,emp_id int,action varchar(255),log_time datetime default current_timestamp,
foreign key(emp_id) references employee(emp_id) on delete set null);

/*inserting data now*/

insert into department (dept_id, dept_name, location) values
(1, 'Human Resources', 'Bangalore'),
(2, 'Finance', 'Mumbai'),
(3, 'Software Development', 'Hyderabad'),
(4, 'Administration', 'Pune'),
(5, 'Marketing', 'Delhi'),
(6, 'Data Science', 'Bangalore'),
(7, 'Sales', 'Gurgaon'),
(8, 'IT Support', 'Noida'),
(9, 'Operations', 'Chennai'),
(10, 'Legal', 'Mumbai');

insert into designation (desig_id, grade, desig_name) values
(1, 'A1', 'HR Associate'),
(2, 'A2', 'HR Manager'),
(3, 'B1', 'Junior Accountant'),
(4, 'B2', 'Finance Manager'),
(5, 'C1', 'Software Engineer'),
(6, 'C2', 'Senior Software Engineer'),
(7, 'D1', 'Data Analyst'),
(8, 'D2', 'Data Scientist'),
(9, 'E1', 'Marketing Executive'),
(10, 'E2', 'Marketing Manager'),
(11, 'C3', 'Tech Lead'),
(12, 'C4', 'Project Manager');


insert into employee (emp_id, first_name, last_name, desig_id, dept_id, email, hire_date, gender, status) values
(201, 'Aarav', 'Sharma', 1, 1, 'aarav.sharma@technova.com', '2024-02-12', 'male', 'active'),
(202, 'Ananya', 'Rao', 2, 1, 'ananya.rao@technova.com', '2023-11-18', 'female', 'active'),
(203, 'Ritvik', 'Sen', 3, 2, 'ritvik.sen@technova.com', '2024-03-10', 'male', 'active'),
(204, 'Mahi', 'Chopra', 4, 2, 'mahi.chopra@technova.com', '2023-12-02', 'female', 'active'),
(205, 'Vivaan', 'Khurana', 5, 3, 'vivaan.khurana@technova.com', '2024-01-22', 'male', 'active'),
(206, 'Ishan', 'Verma', 6, 3, 'ishan.verma@technova.com', '2023-10-30', 'male', 'active'),
(207, 'Kiara', 'Mehta', 7, 6, 'kiara.mehta@technova.com', '2024-04-15', 'female', 'active'),
(208, 'Rehan', 'Ali', 8, 6, 'rehan.ali@technova.com', '2024-05-02', 'male', 'active'),
(209, 'Sanya', 'Kapoor', 9, 5, 'sanya.kapoor@technova.com', '2024-03-28', 'female', 'active'),
(210, 'Aayush', 'Narula', 10, 5, 'aayush.narula@technova.com', '2023-11-05', 'male', 'active'),
(211, 'Dev', 'Malhotra', 5, 3, 'dev.malhotra@technova.com', '2024-02-01', 'male', 'active'),
(212, 'Rhea', 'Bajaj', 2, 1, 'rhea.bajaj@technova.com', '2024-01-12', 'female', 'active'),
(213, 'Aditya', 'Singh', 11, 3, 'aditya.singh@technova.com', '2023-09-01', 'male', 'active'),
(214, 'Tanya', 'Arora', 7, 6, 'tanya.arora@technova.com', '2023-08-20', 'female', 'active'),
(215, 'Harsh', 'Goel', 5, 3, 'harsh.goel@technova.com', '2024-04-07', 'male', 'active'),
(216, 'Meera', 'Pillai', 8, 6, 'meera.pillai@technova.com', '2024-05-12', 'female', 'active'),
(217, 'Rohan', 'Saxena', 12, 3, 'rohan.saxena@technova.com', '2023-07-25', 'male', 'active'),
(218, 'Nikita', 'Gupta', 9, 5, 'nikita.gupta@technova.com', '2024-02-20', 'female', 'active'),
(219, 'Zaid', 'Khan', 3, 2, 'zaid.khan@technova.com', '2024-01-10', 'male', 'active'),
(220, 'Avni', 'Shetty', 1, 1, 'avni.shetty@technova.com', '2023-12-15', 'female', 'active');

insert into employee_contact (emp_id, contact_no) values
(201, '9876001122'), (201, '9823445566'),
(202, '9182736654'),
(203, '9988771122'),
(204, '9123456601'),
(205, '9876509087'),
(206, '8899776655'),
(207, '9645891234'),
(208, '9090901234'),
(209, '9876543321'),
(210, '9123499988'),
(211, '9811223344'),
(212, '9123400678'),
(213, '8877665544'),
(214, '9012345678'),
(215, '9099887766'),
(216, '9445566778'),
(217, '9332211099'),
(218, '9001100223'),
(219, '9888002211'),
(220, '9776655432');

insert into salary_structure ( emp_id, basic_pay, hra, da, deductions, tax) values
( 201, 45000, 8000, 5000, 3000, 2500),
( 202, 60000, 12000, 7000, 3500, 4000),
( 203, 40000, 7000, 5000, 2500, 2300),
( 204, 70000, 15000, 8000, 4000, 5500),
(205, 55000, 10000, 6000, 3000, 3200),
( 206, 75000, 15000, 9000, 4500, 6000),
(207, 48000, 9000, 5500, 3200, 2700),
( 208, 90000, 18000, 10000, 5000, 7500),
( 209, 42000, 8000, 5000, 2500, 2400),
( 210, 85000, 17000, 9000, 4800, 7000),
( 211, 56000, 10000, 6000, 2800, 3100),
( 212, 63000, 12000, 7000, 3500, 4000),
( 213, 95000, 20000, 12000, 6000, 9000),
( 214, 52000, 9000, 6000, 3000, 2900),
( 215, 58000, 11000, 7000, 3200, 3300),
( 216, 92000, 18000, 10000, 5000, 8000),
( 217, 105000, 22000, 13000, 6500, 10000),
( 218, 46000, 9000, 5000, 2500, 2700),
( 219, 41000, 8000, 5000, 2400, 2300),
( 220, 47000, 9000, 5500, 2600, 2800);


insert into attendance (emp_id, att_date, working_hrs, status) values
( 201, '2025-10-01', 8, 'absent'),
( 201, '2025-10-02', 7, 'present'),
( 202, '2025-10-01', 8.5, 'present'),
( 202, '2025-10-02', 0, 'leave'),
( 203, '2025-10-01', 9, 'present'),
( 203, '2025-10-02', 7.5, 'present'),
( 204, '2025-10-01', 8, 'present'),
( 204, '2025-10-02', 8, 'present'),
( 205, '2025-10-01', 0, 'leave'),
( 205, '2025-10-02', 8, 'present'),
( 206, '2025-10-01', 8.5, 'present'),
( 206, '2025-10-02', 9, 'present'),
( 207, '2025-10-01', 7, 'present'),
( 207, '2025-10-02', 8, 'present'),
( 208, '2025-10-01', 8, 'present'),
( 208, '2025-10-02', 5.5, 'leave'),
( 209, '2025-10-01', 9, 'present'),
(209, '2025-10-02', 8.5, 'present'),
(210, '2025-10-01', 7.5, 'present'),
( 210, '2025-10-02', 8, 'present'),
( 211, '2025-10-01', 6, 'leave'),
( 211, '2025-10-02', 8, 'present'),
(212, '2025-10-01', 8, 'present'),
( 212, '2025-10-02', 8.5, 'present'),
( 213, '2025-10-01', 9, 'absent'),
( 213, '2025-10-02', 9, 'present'),
( 214, '2025-10-01', 6, 'leave'),
( 214, '2025-10-02', 8, 'present'),
( 215, '2025-10-01', 7, 'present'),
( 215, '2025-10-02', 8, 'present'),
( 216, '2025-10-01', 8.5, 'present'),
( 216, '2025-10-02', 8, 'present'),
( 217, '2025-10-01', 9.5, 'present'),
( 217, '2025-10-02', 9, 'present'),
( 218, '2025-10-01', 7.5, 'present'),
( 218, '2025-10-02', 8, 'present'),
( 219, '2025-10-01', 8, 'present'),
( 219, '2025-10-02', 8, 'present'),
( 220, '2025-10-01', 7, 'present'),
( 220, '2025-10-02', 8, 'present');


insert into leave_record ( emp_id, start_date, end_date, leave_type, reason, status) values
( 201, '2025-11-05', '2025-11-06', 'sick', 'Fever', 'pending'),
(202, '2025-11-02', '2025-11-02', 'casual', 'Family event', 'rejected'),
( 203, '2025-11-01', '2025-11-02', 'sick', 'Migraine', 'approved'),
( 204, '2025-11-10', '2025-11-10', 'casual', 'Personal work', 'pending'),
( 205, '2025-11-03', '2025-11-03', 'sick', 'Viral infection', 'approved'),
( 206, '2025-11-07', '2025-11-07', 'casual', 'Bank work', 'approved'),
( 207, '2025-11-02', '2025-11-02', 'sick', 'Cold', 'approved'),
( 208, '2025-11-04', '2025-11-05', 'casual', 'Family function', 'pending'),
( 209, '2025-11-06', '2025-11-06', 'sick', 'Headache', 'approved'),
( 210, '2025-11-02', '2025-11-03', 'casual', 'Work from home setup', 'pending'),
( 211, '2025-11-01', '2025-11-01', 'sick', 'Throat pain', 'approved'),
( 212, '2025-11-04', '2025-11-04', 'casual', 'Family event', 'approved'),
( 213, '2025-11-08', '2025-11-08', 'casual', 'Project review rest', 'approved'),
( 214, '2025-11-03', '2025-11-03', 'sick', 'Cold & cough', 'pending'),
( 215, '2025-11-07', '2025-11-07', 'casual', 'Travel', 'approved'),
( 216, '2025-11-09', '2025-11-10', 'casual', 'Family visit', 'pending'),
( 217, '2025-11-01', '2025-11-02', 'sick', 'Fatigue', 'approved'),
( 218, '2025-11-05', '2025-11-05', 'casual', 'Home maintenance', 'approved'),
( 219, '2025-11-06', '2025-11-06', 'sick', 'Fever', 'approved'),
( 220, '2025-11-02', '2025-11-02', 'casual', 'Urgent home work', 'approved');


/*stored procedure for payroll_calculations*/
DELIMITER $$
CREATE PROCEDURE generate_payroll(
    IN p_month VARCHAR(15),
    IN total_days INT,
    IN generated_date DATE
)
BEGIN
    DELETE FROM payroll WHERE month = p_month;

    INSERT INTO payroll(emp_id, present_days, generated_date, total_days, month, net_salary)
    SELECT 
        e.emp_id,
        IFNULL(COUNT(a.att_id), 0) AS present_days,
        generated_date,
        total_days,
        p_month,
        ROUND(
            (basic_pay + hra + da - deductions - tax)
            * IFNULL(COUNT(a.att_id), 0) / total_days, 
            2
        ) AS net_salary
    FROM employee e
    JOIN salary_structure s ON e.emp_id = s.emp_id
    LEFT JOIN attendance a 
        ON a.emp_id = e.emp_id 
       AND a.status = 'present'
    GROUP BY e.emp_id;
END$$
DELIMITER ;

/* trigger=>automatic admin_log inserted after payroll generation*/
delimiter ^^
create trigger trg_after_payroll after insert on payroll for each row
begin
insert into admin_log(emp_id,action) values
(new.emp_id,concat('payroll generated for the month ',new.month));
end ^^
delimiter ;

/*trigger=> admin_log tracks the employee addition*/
delimiter **
create trigger trg_after_employee_insert after insert on employee for each row
begin
insert into admin_log(emp_id,action) values
(new.emp_id,concat('new employee added: ',new.first_name,' ',coalesce(new.last_name,'')));
end **
delimiter ;

/*trigger => auto admin_log for leave approval*/
delimiter $$
create trigger trg_leave_approved after update on leave_record for each row
begin 
if new.status='approved' then
insert into admin_log(emp_id,action)
values(new.emp_id,concat('leave approved from ',new.start_date,' to ',new.end_date));
end if;
end $$
delimiter ;
/*trigger=> auto admin_log for leave rejection*/
delimiter $$
create trigger trg_leave_rejected after update on leave_record for each row
begin 
if new.status='rejected' then
insert into admin_log(emp_id,action)
values(new.emp_id,concat('leave rejected from ',new.start_date,' to ',new.end_date));
end if;
end $$
delimiter ;

delimiter $$
create procedure approve_leave(IN leave_id INT)
begin
    update leave_record
    set status = 'approved'
    where leave_record.leave_id = leave_id;
end$$
delimiter ;
delimiter $$
create trigger trg_employee_delete after delete on employee for each row
begin
    insert into admin_log(emp_id, action)
    values(old.emp_id, concat('employee deleted: ', old.first_name, ' ', coalesce(old.last_name,'')));
end $$
delimiter ;
-- when an employee's department changes
delimiter $$
create trigger trg_employee_dept_update after update on employee for each row
begin
    if old.dept_id <> new.dept_id then
        insert into admin_log(emp_id, action)
        values(new.emp_id, concat('department changed from ', old.dept_id, ' to ', new.dept_id));
    end if;
end $$
delimiter ;
delimiter $$
/*as a new employee added default salary structure created*/ 
create trigger trg_after_employee_insert_salary
after insert on employee
for each row
begin
    insert into salary_structure(emp_id, basic_pay, hra, da, deductions, tax)
    values (new.emp_id, 30000, 5000, 2000, 0, 0);
end$$

delimiter ;


