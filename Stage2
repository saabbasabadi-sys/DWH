USE [Northwind_Stg];
GO

-- =========================================================================
-- 1. Table: Stg.Categories
-- =========================================================================
CREATE TABLE Stg.Categories (
    Category_ID INT NOT NULL,
    Category_Name NVARCHAR(15) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 2. Table: Stg.Customers
-- =========================================================================
CREATE TABLE Stg.Customers (
    Customer_ID NCHAR(5) NOT NULL,
    Company_Name NVARCHAR(40) NOT NULL,
    Contact_Name NVARCHAR(30) NULL,
    Contact_Title NVARCHAR(30) NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    Country NVARCHAR(15) NULL,
    
    -- Business Intelligence Smart Columns
    Geographic_Continent NVARCHAR(30) NULL,
    Customer_Loyalty_Segment NVARCHAR(30) NULL,  
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 3. Table: Stg.Employees
-- =========================================================================
CREATE TABLE Stg.Employees (
    Employee_ID INT NOT NULL,
    Last_Name NVARCHAR(20) NOT NULL,
    First_Name NVARCHAR(10) NOT NULL,
    Title NVARCHAR(30) NULL,
    Title_Of_Courtesy NVARCHAR(25) NULL,
    Birth_Date DATETIME NULL,
    Hire_Date DATETIME NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    Postal_Code NVARCHAR(10) NULL,
    Country NVARCHAR(15) NULL,
    Home_Phone NVARCHAR(24) NULL,
    Reports_To INT NULL,
    
    -- Business Intelligence Smart Columns
    Age_Group NVARCHAR(20) NULL,
    Tenure_Group NVARCHAR(20) NULL,
    Order_Processing_Efficiency_Tier NVARCHAR(20) NULL, 
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 4. Table: Stg.Order_Details (Grain: Single Line Item)
-- =========================================================================
CREATE TABLE Stg.Order_Details (
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Unit_Price MONEY NOT NULL,
    Quantity SMALLINT NOT NULL,
    Discount REAL NOT NULL,
    
    -- Derived & Calculated Columns
    Gross_Amount MONEY NULL,
    Discount_Amount MONEY NULL,
    Net_Amount MONEY NULL,
    Allocated_Freight MONEY NULL,       -- هزینه باربری سرشکن شده برای تحلیل محصولی هزینه حمل
    Is_Profitable_Discount BIT NULL,    
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 5. Table: Stg.Orders
-- =========================================================================
CREATE TABLE Stg.Orders (
    Order_ID INT NOT NULL,
    Customer_ID NCHAR(5) NULL,
    Employee_ID INT NULL,
    Order_Date DATETIME NULL,
    Required_Date DATETIME NULL,
    Shipped_Date DATETIME NULL,
    Ship_Via INT NULL,
    Freight MONEY NULL,
    Ship_Name NVARCHAR(40) NULL,
    Ship_Address NVARCHAR(60) NULL,
    Ship_City NVARCHAR(15) NULL,
    Ship_Region NVARCHAR(15) NULL,
    Ship_Country NVARCHAR(15) NULL,
    
    -- Derived & Calculated Columns
    Shipping_Duration_Days INT NULL,
    Required_Duration_Days INT NULL,
    Is_Shipped_Late BIT NULL,
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 6. Table: Stg.Products
-- =========================================================================
CREATE TABLE Stg.Products (
    Product_ID INT NOT NULL,
    Product_Name NVARCHAR(40) NOT NULL,
    Supplier_ID INT NULL,
    Category_ID INT NULL,
    Quantity_Per_Unit NVARCHAR(20) NULL,
    Unit_Price MONEY NULL,
    Units_In_Stock SMALLINT NULL,
    Units_On_Order SMALLINT NULL,
    Reorder_Level SMALLINT NULL,
    Discontinued BIT NOT NULL,
    
    -- Business Intelligence Smart Columns
    Price_Tier NVARCHAR(20) NULL,
    Stock_Status NVARCHAR(30) NULL,
    Inventory_Turnover_Velocity NVARCHAR(20) NULL, 
    Safety_Stock_Buffer_Ratio REAL NULL,
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 7. Table: Stg.Region
-- =========================================================================
CREATE TABLE Stg.Region (
    Region_ID INT NOT NULL,
    Region_Description NCHAR(50) NOT NULL,
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 8. Table: Stg.Shippers
-- =========================================================================
CREATE TABLE Stg.Shippers (
    Shipper_ID INT NOT NULL,
    Company_Name NVARCHAR(40) NOT NULL,
    Phone NVARCHAR(24) NULL,
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 9. Table: Stg.Suppliers
-- =========================================================================
CREATE TABLE Stg.Suppliers (
    Supplier_ID INT NOT NULL,
    Company_Name NVARCHAR(40) NOT NULL,
    Contact_Name NVARCHAR(30) NULL,
    Contact_Title NVARCHAR(30) NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    Country NVARCHAR(15) NULL,
    Phone NVARCHAR(24) NULL,
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO

-- =========================================================================
-- 10. Table: Stg.Territories
-- =========================================================================
CREATE TABLE Stg.Territories (
    Territory_ID NVARCHAR(20) NOT NULL,
    Territory_Description NCHAR(50) NOT NULL,
    Region_ID INT NOT NULL,
    
    -- ETL Control Columns
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    Source_System NVARCHAR(50) DEFAULT N'Northwind_Operational_DB'
);
GO
