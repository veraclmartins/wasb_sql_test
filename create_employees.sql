USE memory.default;

CREATE TABLE EMPLOYEE (
 employee_id TINYINT, 
 first_name VARCHAR, 
 last_name VARCHAR, 
 job_title VARCHAR, 
 manager_id TINYINT
)
COMMENT 'Employee table using data from hr/employee_index.csv file';

INSERT INTO EMPLOYEE VALUES
(1,'Ian','James','CEO',4),
(2,'Umberto','Torrielli','CSO',1),
(3,'Alex','Jacobson','MD EMEA',2),
(4,'Darren','Poynton','CFO',2),
(5,'Tim','Beard','MD APAC',2),
(6,'Gemma','Dodd','COS',1),
(7,'Lisa','Platten','CHR',6),
(8,'Stefano','Camisaca','GM Activation',2),
(9,'Andrea','Ghibaudi','MD NAM',2);
