--adding DDM while creating table 
CREATE TABLE dbo.empdata (
    EmployeeID INT
    ,FirstName VARCHAR(50) MASKED WITH (FUNCTION = 'partial(1,"-",2)') NULL
    ,LastName VARCHAR(50) MASKED WITH (FUNCTION = 'default()') NULL
    ,SSN CHAR(11) MASKED WITH (FUNCTION = 'partial(0,"XXX-XX-",4)') NULL
    ,email VARCHAR(256) NULL
    );
GO
INSERT INTO dbo.empdata
    VALUES (1, 'TestFirstName', 'TestLastName', '123-45-6789','email@youremail.com');
GO
INSERT INTO dbo.empdata
    VALUES (2, 'First_Name', 'Last_Name', '000-00-0000','email2@youremail2.com');
GO

--removing  DDM after creating table 
alter table dbo.empdata
ALTER column FirstName drop MASKED;

--adding DDM after creating table 
alter TABLE dbo.empdata
alter COLUMN FirstName  add  MASKED WITH (FUNCTION = 'partial(1,"-",2)') ;

-- granting / revoking unmusk for particular user 


GRANT unmask on dbo.empdata to [username ] ; 
REVOKE unmask on dbo.empdata to [username ] ; 
