-- Database: benefit_management_system
-- -----------------------------------------------------
-- Schema benefit_management_system
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `benefit_management_system` DEFAULT CHARACTER SET utf8 ;
USE `benefit_management_system` ;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_users_roles_idx` (`role_id` ASC),
  CONSTRAINT `fk_users_roles`
    FOREIGN KEY (`role_id`)
    REFERENCES `benefit_management_system`.`roles` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `hire_date` DATE NOT NULL,
  `job_title` VARCHAR(100) NOT NULL,
  `department` VARCHAR(100) NOT NULL,
  `supervisor_id` INT NULL, -- Self-referencing for supervisor hierarchy
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_employees_users_idx` (`user_id` ASC),
  INDEX `fk_employees_employees_idx` (`supervisor_id` ASC),
  CONSTRAINT `fk_employees_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `benefit_management_system`.`users` (`id`)
    ON DELETE CASCADE -- If a user is deleted, delete the employee record
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_employees_employees`
    FOREIGN KEY (`supervisor_id`)
    REFERENCES `benefit_management_system`.`employees` (`id`)
    ON DELETE SET NULL -- If a supervisor is deleted, set supervisor_id to NULL
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`leave_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`leave_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  `max_days` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`leaves`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`leaves` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `leave_type_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `status` ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  `reason` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_leaves_employees_idx` (`employee_id` ASC),
  INDEX `fk_leaves_leave_types_idx` (`leave_type_id` ASC),
  CONSTRAINT `fk_leaves_employees`
    FOREIGN KEY (`employee_id`)
    REFERENCES `benefit_management_system`.`employees` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_leaves_leave_types`
    FOREIGN KEY (`leave_type_id`)
    REFERENCES `benefit_management_system`.`leave_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`projects` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `status` ENUM('not started', 'in progress', 'completed', 'on hold') NOT NULL DEFAULT 'not started',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`employee_projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`employee_projects` (
  `employee_id` INT NOT NULL,
  `project_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `role` VARCHAR(100) NOT NULL, -- e.g., 'Team Lead', 'Developer', 'Tester'
  PRIMARY KEY (`employee_id`, `project_id`),
  INDEX `fk_employee_projects_projects_idx` (`project_id` ASC),
  CONSTRAINT `fk_employee_projects_employees`
    FOREIGN KEY (`employee_id`)
    REFERENCES `benefit_management_system`.`employees` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_employee_projects_projects`
    FOREIGN KEY (`project_id`)
    REFERENCES `benefit_management_system`.`projects` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`payroll`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`payroll` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `pay_period_start` DATE NOT NULL,
  `pay_period_end` DATE NOT NULL,
  `basic_salary` DECIMAL(10,2) NOT NULL,
  `allowances` DECIMAL(10,2) DEFAULT 0.00,
  `deductions` DECIMAL(10,2) DEFAULT 0.00,
  `net_pay` DECIMAL(10,2) NOT NULL,
  `payment_date` DATE NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_payroll_employees_idx` (`employee_id` ASC),
  CONSTRAINT `fk_payroll_employees`
    FOREIGN KEY (`employee_id`)
    REFERENCES `benefit_management_system`.`employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`financial_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`financial_records` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `record_date` DATE NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `type` ENUM('income', 'expense') NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `benefit_management_system`.`employee_leave_balances`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benefit_management_system`.`employee_leave_balances` (
  `employee_id` INT NOT NULL,
  `leave_type_id` INT NOT NULL,
  `balance` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_id`, `leave_type_id`),
  INDEX `fk_employee_leave_balances_leave_types_idx` (`leave_type_id` ASC),
  CONSTRAINT `fk_employee_leave_balances_employees`
    FOREIGN KEY (`employee_id`)
    REFERENCES `benefit_management_system`.`employees` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_employee_leave_balances_leave_types`
    FOREIGN KEY (`leave_type_id`)
    REFERENCES `benefit_management_system`.`leave_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Triggers to maintain employee_leave_balances
-- -----------------------------------------------------

-- Trigger to update leave balance when a leave is approved
DELIMITER $$

CREATE TRIGGER update_leave_balance_on_approval
AFTER UPDATE ON leaves
FOR EACH ROW
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE employee_leave_balances
    SET balance = balance - (DATEDIFF(NEW.end_date, NEW.start_date) + 1)
    WHERE employee_id = NEW.employee_id
    AND leave_type_id = NEW.leave_type_id;
  END IF;
END$$

DELIMITER ;


-- Trigger to create initial leave balance for new employees.  This assumes
-- you have a default leave balance defined in your leave_types table.
DELIMITER $$

CREATE TRIGGER create_leave_balance_on_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_leave_balances (employee_id, leave_type_id, balance)
  SELECT
    NEW.id,
    lt.id,
    lt.max_days
  FROM leave_types lt;
END$$

DELIMITER ;




-- -----------------------------------------------------
--  View for uncompleted projects
-- -----------------------------------------------------
CREATE VIEW `uncompleted_projects_view` AS
SELECT
    p.id AS project_id,
    p.name AS project_name,
    p.start_date,
    p.end_date,
    p.status
FROM
    `benefit_management_system`.`projects` p
WHERE
    p.status != 'completed';

-- -----------------------------------------------------
--  View for Profit and Loss
-- -----------------------------------------------------
CREATE VIEW `profit_loss_view` AS
SELECT
    SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) AS total_expense,
    (SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) - SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END)) AS net_profit_loss
FROM
    `benefit_management_system`.`financial_records`;

-- -----------------------------------------------------
-- Dummy Data for Initial Setup
-- -----------------------------------------------------

-- Insert Roles
INSERT INTO `roles` (`name`, `description`) VALUES
('admin', 'Administrator - has full control'),
('manager', 'Manager - manages employees and projects'),
('employee', 'Regular employee');

-- Insert a default admin user.  You'll want to change this password.
INSERT INTO `users` (`username`, `email`, `password`, `role_id`) VALUES
('admin', 'admin@example.com', '$2a$10$Wq7jN9Cpj6zWj3.9n72c.eXvWwFjO/tL9OB6J9e6mFeYtFqKjVu', 1); -- Password is 'password' (for demonstration only - CHANGE THIS)

-- Insert Leave Types
INSERT INTO `leave_types` (`name`, `description`, `max_days`) VALUES
('Annual Leave', 'Paid time off for vacation', 20),
('Sick Leave', 'Time off for illness', 10),
('Maternity Leave', 'Leave for new mothers', 90),
('Paternity Leave', 'Leave for new fathers', 14),
('Bereavement Leave', 'Leave for the death of a close family member', 5);

-- Insert sample employee
INSERT INTO `users` (`username`, `email`, `password`, `role_id`) VALUES ('john_doe', 'john.doe@example.com', '$2a$10$Wq7jN9Cpj6zWj3.9n72c.eXvWwFjO/tL9OB6J9e6mFeYtFqKjVu', 3);
INSERT INTO `employees` (`user_id`, `first_name`, `last_name`, `hire_date`, `job_title`, `department`) VALUES
(LAST_INSERT_ID(), 'John', 'Doe', '2023-01-15', 'Software Engineer', 'Engineering');

-- Insert sample project
INSERT INTO `projects` (`name`, `description`, `start_date`, `end_date`, `status`) VALUES
('Project Phoenix', 'Develop new HR system', '2024-01-01', '2024-12-31', 'in progress');
