-- column : attribute or field
-- row : Instance or record

-- Server : physical storage which stores data which can be accessed through internet
-- SQL tools : mySQL, PL SQL by Oracle, MS SQL by microsoft
-- database : folder or stroage container
--          : create table, insert, update, delete
--          : multiple data objects

--------------------------------------------------------------------------------------------
create database StudentDatabase;
use StudentDatabase;
create table StudentDetails(
   Id int,
   Name char(20),
   Age int,
   Gender char(10)
);

select * from StudentDetails;

insert into StudentDetails values(2, "Ram", 21, 'Male');
insert into StudentDetails values(3, "Sara", 24, 'Female');
insert into StudentDetails values(4, "Jhon", 28, 'Male');

-- it cam take multiple dublicate values
insert into StudentDetails values(5, "Peter", 25, 'Male');
select * from StudentDetails;

insert into StudentDetails values(5, "Peanut", 20, 'Female'), (3, "Sara", 24, 'Female');

-- drop table StudentDetails;
SET SQL_SAFE_UPDATES = 0;
update StudentDetails set Name = "Ram Prasad" where Name = "Ram";
select * from StudentDetails;

delete from StudentDetails  where age > 26;
select * from StudentDetails;

-- delete from StudentDetails  where ID in(2,3,5);
-- deletes id 2,3, and 5

alter table StudentDetails add Location varchar(30);
update StudentDetails set Location = 'India';

select * from StudentDetails;
update StudentDetails set Location = 'US' where Name = "sara";

update StudentDetails set Id = 1 where Name = "Peanut";

insert into StudentDetails (Id, Name, Gender, Location)values(1, "Priya", 'Female', 'UK');
update StudentDetails set Id = 4 where Name = "Priya";

delete from StudentDetails where Id = 3;

insert into StudentDetails values(3, "Sara", 24, 'Female', "US");
insert into StudentDetails values(5, "John", 29, 'Male', "India");

drop table StudentDetails;

-----------------------------------------------------------------------------------------------

create table CourseDetails(
CourseId tinyint primary key,
CourseName varchar(20) not null,
Fee smallint
);

select * from CourseDetails;
insert into CourseDetails values(1,'SQL', 15000);
insert into CourseDetails values(2,null, 15000);
-- above gives error


insert into CourseDetails values(2,"Power BI", 15000);
update CourseDetails set Fee = 12000 where CourseId = 2;


create table StudentDetails(
   StudentId int primary key,
   Name char(20) not null,
   Age tinyint check(Age>18),
   Gender varchar(10) check(Gender = "Male" or Gender = "Female"),
   CourseId tinyint,
   foreign key(CourseId) references CourseDetails(CourseId)
);

select * from StudentDetails;

insert into StudentDetails values(1, "Ram", 16, "Male", 1);
-- age = 16, so check is violated

insert into StudentDetails values(1, "Ram", 21, "Male", 1);
-- not allows duplicate 

insert into StudentDetails values(2, "Peter", 24, "Male", 1);

insert into StudentDetails values(3, "Sanar", 23, "Female",3 );
-- wrong since 3 is not a couse id
insert into StudentDetails values(3, "Sana", 23, "Female",2 );

insert into StudentDetails values(4, "John", 28, "Male",2 );
select * from StudentDetails;

alter table StudentDetails add Location varchar(20);
update StudentDetails set Location = "Bangalore" where StudentId in(1,3);
update StudentDetails set Location = "Hydrabad" where StudentId in(4);
update StudentDetails set Location = "Chennai" where StudentId in(2);

insert into StudentDetails values(5, "Jupiter", 22, "Female",2 , "kolkata");

select StudentId, Name from StudentDetails;
select StudentId, Name from StudentDetails where Location = "Bangalore";
select StudentId, Name from StudentDetails where Gender = "Male" and Location = "Bangalore";

select count(*) from StudentDetails;
-- 
select count(*) as CountOfStudents from StudentDetails;
select count(*) as CountOfStudents from StudentDetails where Location = "Bangalore";

-- Group By : grouping column -> groups and data
select Location, count(*) as CountOfStudents from StudentDetails group by Location;
select Location, count(*) as CountOfStudents from StudentDetails group by Location where count(*)>1;
-- above will give error because count is not a column in table

select Location, count(*) as CountOfStudents from StudentDetails 
         group by Location 
         having count(*)>1;
         
select Location, count(*) as CountOfStudents from StudentDetails 
         group by Location 
         having CountOfStudents>1;
-- where is used for value in table and having for calculated term
-- precedence: where > group by > having > order by > limit
-- order by ASC/DESC

select * from StudentDetails order by Name;
select * from StudentDetails order by Name DESC;

select * from StudentDetails limit 2;
select * from StudentDetails order by Name DESC limit 2;

-- values from multiple tables
-- Joins and Cardinality or relationship between tables

-----------------------------------------------------------------------------------------------

create database BesantBank;
use BesantBank;
create table AccountDetails(
 AccountId int primary key,
 Name varchar(30) not null,
 Age tinyint check(Age > 18),
 AccountType varchar(20),
 CurrentBalance int
);

select * from AccountDetails;

insert into AccountDetails values(1,"Ram",21,"Savings",1000);
insert into AccountDetails values(2,"Raka",22,"Current",8000);

select now();
-- above  gives current date and time

create table TransactionDetails(
TransactionId int primary key auto_increment,
AccountId int,
TransactionType varchar(10) check(TransactionType ='Credit' or TransactionType ='Debit'), 
TransactionAmount int,
TransactionTime datetime default(now()),
foreign key(AccountId) references AccountDetails(AccountId)
);

insert into TransactionDetails(AccountId, TransactionType, TransactionAmount) 
      values(1, "Credit", 1000);
      
select * from TransactionDetails;
insert into TransactionDetails(AccountId, TransactionType, TransactionAmount) 
      values(1, "Debit", 500);
      
-- Cardinality / relationship between tables

-- types of relationships
-- table 1  -   table 2
--  1       -    1
--  1       -    many
--  many    -    1

-- dimension table 
-- fact tables

-- to retrive data from multiples table
-- Two types of join
-- 1. Inner join ( matching Values)
-- 2. Outer Joins
--    a. Left Join (Matched values from both table and unmatched values from left table) eg SD
--    b. Right Join  (Matched values from both table and unmatched values from right table) eg CD
--    c. Full Join   (Matched values from both table and unmatched values from left table)
-- *. miscellanous join
--    a. cross join : cartesian product (gives all comination between tables)
--    b. self join :  join in same table with itself

-----------------------------------------------------------------------------------------
-- matching join or inner join
use StudentDatabase;
insert into CourseDetails values(3, "Python", 10000);

select SD.StudentId, SD.Name, SD.Age, SD.Gender, SD.CourseId, CD.CourseName, CD.Fee, SD.Location 
  from StudentDetails as SD
  join CourseDetails as CD
  on SD.CourseId = CD.CourseId;
  
  --------------------------------------------------------------------------------
  -- outer join
  
  select SD.StudentId, SD.Name, SD.Age, SD.Gender, SD.CourseId, CD.CourseName, CD.Fee, SD.Location 
  from StudentDetails as SD
  left join CourseDetails as CD
  on SD.CourseId = CD.CourseId;
  
  select SD.StudentId, SD.Name, SD.Age, SD.Gender, SD.CourseId, CD.CourseName, CD.Fee, SD.Location 
  from StudentDetails as SD
  right join CourseDetails as CD
  on SD.CourseId = CD.CourseId;
-- see python is in our result

-- ------  full doesn't have a syntax, instead we use union
select SD.StudentId, SD.Name, SD.Age, SD.Gender, SD.CourseId, CD.CourseName, CD.Fee, SD.Location 
  from StudentDetails as SD
  left join CourseDetails as CD
  on SD.CourseId = CD.CourseId
  union
  select SD.StudentId, SD.Name, SD.Age, SD.Gender, SD.CourseId, CD.CourseName, CD.Fee, SD.Location 
  from StudentDetails as SD
  right join CourseDetails as CD
  on SD.CourseId = CD.CourseId;
  
  
  -- cross join or cartesian product
  select * from StudentDetails, CourseDetails;


---------------------------------------------------------------------------------------------
-- example for self join
create table EmpTable(
EmpId tinyint primary key,
EmpName char(20) not null,
ManagerId  tinyint
);
insert into EmpTable values(1, "Bill Gates",  null);
insert into EmpTable values(2, "Ram",  1);
insert into EmpTable values(3, "Sana",  1);
insert into EmpTable values(4, "John",  3);
insert into EmpTable values(5, "Peter",  3);

select * from EmpTable;
select E1.EmpId, E1.EmpName, E2.EmpName as ManagerName from 
   EmpTable as E1
   left join EmpTable as E2
   on E1.ManagerId = E2.EmpId;
---------------------------------------------------------------------
-- back to account and transaction details

use besantbank;
select * from  AccountDetails;
select * from TransactionDetails;

insert into AccountDetails values (3, "Sana", 23, "Current", 500),
                                  (4, "John", 27, "Savings", 1000),
                                  (5, "Peter", 29, "Current", 1500),
                                  (6, "Kiran", 19, "Savings", 5200),
                                  (7, "Priya", 27, "Current", 5500),
                                  (8, "Varun", 21, "Current", 500),
                                  (9, "Sonu", 21, "Savings", 2500),
                                  (10, "Kumar", 26, "Savings", 2000),
                                  (11, "Suma", 25, "Savings", 5000);
                                  
insert into TransactionDetails(AccountId, TransactionType,TransactionAmount)
            values(7,"Credit",1000);
insert into TransactionDetails(AccountId, TransactionType,TransactionAmount)
            values(4,"Credit",1000);
            
            
--------------------------------- Sub Query --------------------------------------------
-- requirement: want account Details of people who did transactions?
select AccountId from TransactionDetails;

-- to get distinct ans
select distinct AccountId from TransactionDetails;

select AccountId from AccountDetails where AccountId in(1,7);

select * from AccountDetails where AccountId in
(select distinct AccountId from TransactionDetails);
-- which is what we need
-- called Sub Query : query within another query
--                    inner query will execute first
--                    use in where/ having clauses only
-- purpose of using sub query: whenever we are printing data from one query but is dependent on 
--                             data from another table ie, table dependency
--                             ( just like example in our above problem)

-- write 5th highest balance or 5 highest balance
-- general case nth highest banlance

select CurrentBalance from AccountDetails
order by CurrentBalance desc limit 5;

select * from AccountDetails
order by CurrentBalance desc limit 5;

-- we just need to find minimum of top 5 ans

select min(CurrentBalance) from AccountDetails where CurrentBalance
  in(select CurrentBalance from AccountDetails order by CurrentBalance desc limit 5);
-- beacuse it doen't supports where with limit in inner query this sub Query

select min(CurrentBalance) from 
(select CurrentBalance from AccountDetails order by CurrentBalance desc limit 5) as Top5thbalance;
-- this is called derived table
-- this table doesn't exsists just is produced because of above query
-- we are writing in some clause

---------------------------------- Derived Table --------------------------------------------
-- output from inner Query will be taken as seperate table which is temorary and wil eaxtract
-- minimum value from these
-- query in query -- SubQuery
-- query in tem table -- Derived Table

select max(CurrentBalance) from AccountDetails where CurrentBalance not in
(select max(CurrentBalance) from AccountDetails);

select * from AccountDetails where CurrentBalance = 
(select max(CurrentBalance) from AccountDetails where CurrentBalance not in
(select max(CurrentBalance) from AccountDetails));

-- third highest query in sub query q(q(q(--)))
select max(CurrentBalance) from AccountDetails where CurrentBalance <
(select max(CurrentBalance) from AccountDetails where CurrentBalance not in
(select max(CurrentBalance) from AccountDetails)) ;


-- what we learnt so far
-- select -> from -> where -> Group by -> having -> Order by -> limit
-- Joins : inner, outer (- left, right, full), cross, self
-- sub Query
-- Derived tables

------------------------------ Query Storing -------------------------------------

----------------------- Views -----------------------
-- database object - store single select Query
-- create view view_name as <query>

-- requirement: want account Details of people who did transactions?(done before)
-- instead of writing it repeatedly we store it it in view

create view  AccountsOfTransactions as
select * from AccountDetails where AccountId in
(select distinct(AccountId) from TransactionDetails);

select * from  AccountsOfTransactions;

insert into TransactionDetails(AccountId, TransactionType,TransactionAmount)
            values(9,"Credit",13000);
            
update AccountsOfTransactions set name = "Ram Prasad" where AccountId = 1;
select * from  AccountsOfTransactions;
select * from  AccountDetails;
-- any changein view is also updated in table

-- views are of two types
-- 1. updateable views : will update the values in base table
-- 2. un updateable views : will not update the values in base table
-- it is updateaable only if all columns in view is same as base column

create view BalanceInBank as
select sum(CurrentBalance) from AccountDetails;

select * from BalanceInBank;
-- Note: above is not update able, since columns are not same
-- can't use in aggregate functions or in join

update BalanceInBank set name = "Ram Kumar Prasad" where AccountId = 1;

-------------------------------------------------------------------------------------------

----------------------------- Indexes ----------------------------------/
-- improves performance of Query
-- Search criteria : BTree, Hash, RTree
-- Data Type: Unique, full Text, spatial
-- column : Clustered, non-Clustered
-- Materialized views/ Indexed views i.e, index on a view

create index view_index on AccountDetails(AccountId);

---------------- Stored Procedures -------------
-- view can store single select query 
-- and cannot store update/delete query
-- no parameters, no variables, no programming

-- so for above limitation of views Stored Procedures is used
-- parameter: single value og specified data type
--            we will fiter data using parameter value

select * from TransactionDetails where AccountId = 1;
-- we can store this query

create view BankStatements as
select * from TransactionDetails where AccountId = 1;
select * from BankStatements;
-- problem it will create only for AccountId = 1
-- so we use "Store Procedure" mainly we define fnc in MySQL
-- variable will store value of fnsBankStatement
-- we can now do all things of a typical language like print, loop, etc
-- eg we defind Stored procedure "BankStatement" in Stored Procedure section

-- one important thing is Database Object
-- now we create a new Stored procedure 

-- addind column ststus on account status
ALTER TABLE AccountDetails DROP COLUMN AccountStatus;
ALTER TABLE AccountDetails add COLUMN AccountStatus char(20) default("Active");

select * from AccountDetails;
set sql_safe_updates = 0;
-- we used AccountStatusUpdater to diff accounts into active or in active
select * from AccountDetails;
-- how to get vertical output

-- now we learn Error Handling / Exception Handling
-- use stored procedure ErrorHandler
-- we use :
-- 1. Error Code: Id for error, SQL developers gave every error they found a code (880 erros)
-- 2. SQL State : Group name
-- 3. SQL Exception : handle All errors (SQL key word)

-----------------------  Indexing  ------------------------
-- improvement over view
-- improves performance of query

-- based on Search criteria, we have three types of indexing which saves times
-- 1. BTree  : Balanced Tree - improve performance 1000 times (default)
--           : single dimensionsal data like int, float
-- 2. Hash : can find value value in sinfle step
--           stores the path of each value / path 
--           but consumes lot of storage space
-- 3. RTree : Random Forest Tree
--          : same as Btree but RTree workd for multidimensional values
--          : 30 degree 30 min 30 sec

-- Based on type of Column, we have two types of indexing
-- 1. clustered index : writing index on primary key
-- 2. non clustered index : writing on non primary values

-- Based on data type, we have two types
-- 1. Unique Index : unique values like int, char, varchar
-- 2. Full Text : long text > 255
-- 3. Spatial : multi dimensional or fractional values

-- creating index
use besantbank;
create index AccountIdIndex on AccountDetails(AccountId);
-- used Btree by default
drop index AccountIdIndex on AccountDetails;

create index AccountIdIndex using hash on AccountDetails(AccountId);
drop index AccountIdIndex on AccountDetails;

create unique index AccountIdIndex on AccountDetails(AccountId);

--------------------------- Triggers ------------------------------------
-- are used to automate the query, will get executed automatically
-- will not print any resultset
-- for example if transaction is debit, amtbal needs to decreased and vice versa
-- time execution before / after transaction

set sql_safe_updates = 0;

use besantbank;
-- delimiter makes sure above chunk work as awhole
-- since it considers semi colon as end
truncate table TransactionDetails;
update AccountDetails set CurrentBalance = 0;

-- -- something is wrong here
-- drop trigger BalanceUpdater;
-- -------------------------------------------------------------------------------
delimiter $$
create trigger BalanceUpdater
after insert on TransactionDetails for each row
begin
    declare Var_LatestTransactionId int;
    declare Var_AccountId int;
    declare Var_TransactionType varchar(20);
    declare Var_TransactionAmount int;
    declare Var_CurrentBalance int;
  
    select max(TransactionId) into Var_LatestTransactionId from TransactionDetails;
    select CurrentBalance into Var_CurrentBalance from AccountDetails
        where AccountId = Var_AccountId;
    select AccountId, TransactionType, TransactionAmount into 
        Var_AccountId, Var_TransactionType, Var_TransactionAmount 
        from TransactionDetails
        where TransactionID = Var_LatestTransactionId;
  
    if Var_TransactionType = "Credit" then
        update AccountDetails set CurrentBalance = CurrentBalance +  Var_TransactionAmount
        where AccountId =  Var_AccountId;
    else
         if Var_TransactionAmount <= Var_CurrentBalance then
	      update AccountDetails set CurrentBalance = CurrentBalance -  Var_TransactionAmount
		  where AccountId =  Var_AccountId;
	  else 
          update AccountDetails set CurrentBalance = CurrentBalance 
          where AccountId =  Var_AccountId;
      end if;
end if;
end

delimiter ;

set sql_safe_updates = 0;
insert into TransactionDetails (AccountId, TransactionType, TransactionAmount) 
values(1,"Credit",1000);

insert into TransactionDetails (AccountId, TransactionType, TransactionAmount) 
values(2,"Debit",1000);
insert into TransactionDetails (AccountId, TransactionType, TransactionAmount) 
values(2,"Credit",1000);

insert into TransactionDetails (AccountId, TransactionType, TransactionAmount) 
values(3,"Credit",15000);

-- ----------------------------------------------------------------
insert into TransactionDetails (AccountId, TransactionType, TransactionAmount) 
values(5,"Credit",1500);
insert into TransactionDetails (AccountId, TransactionType, TransactionAmount) 
values(6,"Credit",150);

select * from transactionDetails;
select * from AccountDetails;

-- --------------------------------------------------------------------------- --
-- 1. Before Trigger : Insert, update, delete. so, DML
-- 2. After Trigger : 

-- Magic Tables: in our case old table

delimiter $$
create trigger CascadingDelete
before delete on accountdetails for each row
begin
    delete from transactiondetails where AccountId = old.AccountId;
end
delimiter ;

drop trigger CascadingDelete;

select * from accountdetails;
select * from transactiondetails;

-- so if we delete accountId 1 in acoountdetail table, it should be deleted in 
-- transactionDetails table

delete from accountdetails where AccountId = 1;

-- ----------------- Servers Types -------------------------------------
-- types of servers
-- OLTP : oniline transaction process, raw data
--      : can contain duplicates, null values, errors, combined values
--      : live data
-- Staging  : ETL i.e, Extract Transform Load
-- OLAP : cleaned data
--      : past data

-- ---------------- Exception / Error handling ------------------------
-- Error code : 880+ error, error code forr each erro
-- SQL state : errors are divided into seperated groups based on error type, these groups are
--             onlr called SQL state
-- SQL Exception : Key word

-- eg of SQL Exception : so we chage stored procedure 
-- Actions : continue and exit (see in StoredProcedure ErrorHandler)
-- instead of each errorcode we can use sqlexception

-- ---------------------- Functions -----------------------------------
-- to do small caculations in SQL
-- Aggregate fns : sum(), max(), min(), Avg(), count(), distinct()
--               : count(distinct())
-- Two types : System defined fnc and user defined fnc
-- why not use stored  procedure? because cant use insert, update, delete, select
-- can use fnc where ever we want

set global log_bin_trust_function_creators =1; 

-- ----- system defined function
-- Aggregate fns : sum(), max(), min(), Avg(), count(), distinct(), count(distinct())
-- Text fuc : concat -> merge/add two text column, 
--          : upper -> upper case, lower
--          : trim -> remove unecessary spaces, LTrim, RTrim 
--          : charIndex ; select charIndex(column_name, " ") from table_name
-- date and time : now()
--               : timestampdiff( format, start_time, end_time)
--               : current_date
--               : year(), month(), day(), MonthName(), dayofweek()
--               : DateAdd(n) -> nth day from today
-- Ranking/ window fncs : Rank -> select name, marks, Rank() over(partition by Subject, 
--                      : order by Marks DESC) from table_name 
--                      : this fnc skips the rank if it is duplicated
--                  : DenseRank ->  continous rank if value is duplicated
--                      : Row_Number 
-- Statistical : lag -> previous value, Lead
--             : select name, salary from emp_table where year = 2021; and just use Lag and Lead

-- DCL read word file
-- set auto_commit = 0 -> turns off auto commit mode

-- if DML queries are done and we want to make them permanent, Commit;
--                                                       else, rollback;(undo)
-- savepoint; : to make permanent till a point

--  delete from AccountDetails where AccountId = 1;
-- rollback;(undos previous command)
-- commit

-- savepoint A;
-- rollback to A;

-- -------------------------------  Cursors  ------------------------------------
-- pointer

-- note: variable can store single values but cursor can store multiple values
--       we can even store value if a table

-- declare var_name data_type;

-- begin
-- declare Account_Details cursors for select * from AccountDetails;
-- open Account_Details;

-- one by one: loop
--     fetch Account_Details into var_AccountId, Var_Name,....
--                                                        ;
--                             leave one by one;
-- end loop one by one
-- end;


-- ----------------  wild Card  ------------------
-- suggestions 

-- select * from AccountDetails where Name like "R % ";
-- -> give names which starts with R

-- select * from AccountDetails where Name like "% R";
-- -> give names which ends with R

-- select * from AccountDetails where Name like "% R %";
-- -> give names which contains R

-- --------------------------------------------- -----------------------------