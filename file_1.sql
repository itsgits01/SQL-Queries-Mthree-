-- CREATE DATABASE testdb;
-- USE testdb;

-- CREATE TABLE IF NOT EXISTS test_table (
--     id INT PRIMARY KEY,
--     value VARCHAR(255)
-- );

-- select count(*) from test_table;
select * from test_table;


show databases;

use testdb;

show tables;

select * from key_value_table;
rename table test_table To key_value_table;

alter table key_value_table rename to key_value_pair;
select * from key_value_pair;

insert into key_value_pair values(1,'asgdjhasd');

select * into key_val_pair from key_value_pair;

show create table key_value_pair;


CREATE TABLE `key_val_pair` (
   `id` int NOT NULL,
   `value` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
Truncate key_value_pair;

select * from key_val_pair;

select * into key_val_pair from key_value_pair;


select * from key_value_pair LIMIT 1;
SELECT MIN(ID) FROM key_value_pair;
SELECT Max(ID) FROM key_value_pair;

select count(id) from key_value_pair;
select sum(id) from key_value_pair;

select avg(id) from key_value_pair;

select * from key_value_pair where value like '%j%';
select * from key_value_pair where value like '__g%';

select * from key_value_pair where value in('asgdjhasd')
select * from key_value_pair where id between 1 and 100;

select * from key_value_pair as table_value;
select * into key_val_pair from key_value_pair;
