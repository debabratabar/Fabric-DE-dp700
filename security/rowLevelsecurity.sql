-- for row level security we need to create a function and add that function into a security policy 
-- whenever any user query the table it will automatically obey the security policy 

CREATE FUNCTION dbo.fn_department_filter(@username sysname, @dept nvarchar(50))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE @dept = (SELECT Department FROM dbo.Users WHERE UserName = @username);

CREATE SECURITY POLICY DeptRLS
ADD FILTER PREDICATE dbo.fn_department_filter(UserName(), Department)
ON dbo.EmployeeRecords
WITH (STATE = ON);
