

-- creating the load script 

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = 'sales'
    AND SPECIFIC_NAME = 'LoadDataFromStaging'
)
DROP PROCEDURE sales.LoadDataFromStaging
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE sales.LoadDataFromStaging
    @sales_year int /*datatype_for_param1*/ = 0, 
-- add more stored procedure parameters here
AS
BEGIN
    
    -- customer insert
    INSERT into sales.Dim_Customer(CustomerName , EmailAddress )
    SELECT Distinct CustomerName , EmailAddress
    FROM [LS_01].[dbo].[staging_sales] WHERE 
    YEAR(OrderDate) = @sales_year
    AND not exists
    (
    SELECT 1 FROM sales.Dim_Customer
    WHERE 	sales.Dim_Customer.CustomerName = [LS_01].[dbo].[staging_sales].CustomerName AND
    sales.Dim_Customer.EmailAddress = [LS_01].[dbo].[staging_sales].EmailAddress
   );


     -- item insert
    INSERT into sales.Dim_Item(ItemName )
    SELECT Distinct string_split(Item,',',1) as ItemName
    FROM [LS_01].[dbo].[staging_sales] WHERE 
    YEAR(OrderDate) = @sales_year
    AND not exists
    (
    SELECT 1 FROM sales.Dim_Item
    WHERE 	sales.Dim_Item.ItemName = string_split([LS_01].[dbo].[staging_sales].Item,',',1)    );

-- CustomerID VARCHAR(255) NOT NULL,
--         ItemID VARCHAR(255) NOT NULL,
--         SalesOrderNumber VARCHAR(30),
--         SalesOrderLineNumber INT,
--         OrderDate DATE,
--         Quantity INT,
--         TaxAmount FLOAT,
--         UnitPrice FLOAT

    --insert factsales
    INSERT into sales.Fact_sales(ItemName )
    SELECT Distinct string_split(Item,',',1) as ItemName
    FROM [LS_01].[dbo].[staging_sales] WHERE 
    YEAR(OrderDate) = @sales_year
    AND not exists
    (
    SELECT 1 FROM sales.Dim_Item
    WHERE 	sales.Dim_Item.ItemName = string_split([LS_01].[dbo].[staging_sales].Item,',',1)    );

END



-- example to execute the stored procedure we just created
EXECUTE SchemaName.StoredProcedureName 2019
GO