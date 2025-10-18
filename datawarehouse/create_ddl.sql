CREATE SCHEMA sales  ; 
GO

IF EXISTS(
    SELECT * FROM sys.sysobjects where name = 'Fact_Sales' 
)
DROP TABLE Fact_Sales;
GO

CREATE TABLE sales.Fact_sales(
        CustomerID VARCHAR(255) NOT NULL,
        ItemID VARCHAR(255) NOT NULL,
        SalesOrderNumber VARCHAR(30),
        SalesOrderLineNumber INT,
        OrderDate DATE,
        Quantity INT,
        TaxAmount FLOAT,
        UnitPrice FLOAT
);
GO


IF EXISTS(
    SELECT * FROM sys.sysobjects where name = 'Dim_Customer' 
)
DROP TABLE Dim_Customer;
GO

CREATE TABLE sales.Dim_Customer(
        CustomerID VARCHAR(255) NOT NULL,
        CustomerName VARCHAR(255) NOT NULL,
        EmailAddress VARCHAR(255) NOT NULL
);
GO

IF EXISTS(
    SELECT * FROM sys.sysobjects where name = 'Dim_Item' 
)
DROP TABLE Dim_Item;
GO

CREATE TABLE sales.Dim_Item(
    ItemID VARCHAR(255) NOT NULL,
    ItemName VARCHAR(255) NOT NULL
);
GO


-- alter statements 
ALTER TABLE Sales.Dim_Customer add CONSTRAINT PK_Dim_Customer PRIMARY KEY NONCLUSTERED (CustomerID) NOT ENFORCED;
GO


ALTER TABLE Sales.Dim_Item add CONSTRAINT PK_Dim_Item PRIMARY KEY NONCLUSTERED (ItemID) NOT ENFORCED ; 
GO
