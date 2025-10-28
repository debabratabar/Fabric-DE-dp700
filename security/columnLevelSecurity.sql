--1. using grant/deny 

grant select on dbo.sales (salesPrice ) to [userName];
Deny select on dbo.sales (salesPrice ) to [userName];


-- 2. using view 
-- Only allow access to Name and City, not Salary
CREATE VIEW dbo.Employee_Public AS
SELECT Name, City
FROM dbo.Employee;

GRANT SELECT ON dbo.Employee_Public TO [UserOrRole];
DENY SELECT ON dbo.Employee TO [UserOrRole];


--3. using DDM check security/dynamicDataMasking.sql
