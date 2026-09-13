USE [Northwind_DW];
GO

                -- =========================================================================
                -- 1. Table: DW.Dim_Date - ساخت جدول بُعد تاریخ به شمسی
                -- Purpose: Pure Persian (Jalali) Calendar Dimension for localized reporting.
                -- Standard: Camel_Case
                -- =========================================================================
CREATE TABLE DW.Dim_Date (
    Date_SK INT NOT NULL,                     -- کلید جایگزین عددی شمسی (e.g., 14050417)
    Full_Date_Gregorian DATE NOT NULL,        -- تاریخ میلادی متناظر (جهت همگام‌سازی داخلی در ETL)
    Persian_Date_String NCHAR(10) NOT NULL,   -- نمایش متنی تاریخ (e.g., '1405/04/17')
    Persian_Year INT NOT NULL,                -- سال شمسی (e.g., 1405)
    Persian_Month_Number INT NOT NULL,        -- شماره ماه (1 To 12)
    Persian_Month_Name NVARCHAR(20) NOT NULL, -- نام ماه (فروردین، اردیبهشت و...)
    Persian_Day_Of_Month INT NOT NULL,        -- روز در ماه (1 To 31)
    Persian_Quarter INT NOT NULL,             -- فصل سال (1 To 4)
    Persian_Quarter_Name NVARCHAR(20) NOT NULL, -- نام فصل (بهار، تابستان و...)
    Persian_Day_Of_Week_Name NVARCHAR(20) NOT NULL, -- نام روز هفته (شنبه، یکشنبه و...)
    Is_Friday BIT NOT NULL,                   -- پرچم آخر هفته بومی (۱ برای جمعه، ۰ برای سایر روزها)
    
    CONSTRAINT PK_Dim_Date PRIMARY KEY CLUSTERED (Date_SK)
);
GO


USE [Northwind_DW];
GO

-- =========================================================================
-- 2. Table: DW.Dim_Customer جدول بُعد مشتریان
-- =========================================================================
CREATE TABLE DW.Dim_Customer (
    Customer_SK INT IDENTITY(1,1) NOT NULL, 
    Customer_ID NCHAR(5) NOT NULL,          -- Business Key
    
    -- Attributes
    Company_Name NVARCHAR(40) NOT NULL,      -- SCD Type 1
    Contact_Name NVARCHAR(30) NULL,         -- SCD Type 1
    Contact_Title NVARCHAR(30) NULL,        -- SCD Type 1
    Address NVARCHAR(60) NULL,              -- SCD Type 2
    City NVARCHAR(15) NULL,                 -- SCD Type 2
    Region NVARCHAR(15) NULL,               -- SCD Type 2
    Country NVARCHAR(15) NULL,              -- SCD Type 2
    Geographic_Continent NVARCHAR(30) NULL, -- SCD Type 2
    Customer_Loyalty_Segment NVARCHAR(30) NULL, -- SCD Type 1
    
    -- SCD Type 2 Tracking Columns
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NULL,
    Is_Current BIT NOT NULL,
    
    CONSTRAINT PK_Dim_Customer PRIMARY KEY CLUSTERED (Customer_SK)
);
GO

-- =========================================================================
-- 3. Table: DW.Dim_Employee (SCD Type 0 Completely Replaced by SCD Type 1) جدول بُعد کارکنان
-- =========================================================================
CREATE TABLE DW.Dim_Employee (
    Employee_SK INT IDENTITY(1,1) NOT NULL,
    Employee_ID INT NOT NULL,
    
    -- Attributes
    Last_Name NVARCHAR(20) NOT NULL,        -- SCD Type 1
    First_Name NVARCHAR(10) NOT NULL,       -- SCD Type 1
    Title NVARCHAR(30) NULL,                -- SCD Type 2 (حفظ تاریخچه پوزیشن شغلی)
    Title_Of_Courtesy NVARCHAR(25) NULL,    -- SCD Type 1
    
    -- اصلاح استراتژیک بر اساس دستور کاربر: تبدیل به SCD 1 جهت امکان اصلاح خطاهای احتمالی سیستم مبدا
    Birth_Date DATETIME NULL,               -- SCD Type 1 (Overwrite on correction)
    Hire_Date DATETIME NULL,                -- SCD Type 1 (Overwrite on correction)
    
    Address NVARCHAR(60) NULL,              -- SCD Type 2
    City NVARCHAR(15) NULL,                 -- SCD Type 2
    Region NVARCHAR(15) NULL,               -- SCD Type 2
    Postal_Code NVARCHAR(10) NULL,          -- SCD Type 2
    Country NVARCHAR(15) NULL,              -- SCD Type 2
    Home_Phone NVARCHAR(24) NULL,           -- SCD Type 1
    Reports_To_ID INT NULL,                 -- SCD Type 1
    
    -- Smart Attributes
    Age_Group NVARCHAR(20) NULL,            -- SCD Type 1
    Tenure_Group NVARCHAR(20) NULL,         -- SCD Type 1
    Order_Processing_Efficiency_Tier NVARCHAR(20) NULL, -- SCD Type 1
    
    -- SCD Type 2 Tracking Columns
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NULL,
    Is_Current BIT NOT NULL,
    
    CONSTRAINT PK_Dim_Employee PRIMARY KEY CLUSTERED (Employee_SK)
);
GO

-- =========================================================================
-- 4. Table: DW.Dim_Supplier جدول بُعد تأمین کنندگان کالا
-- =========================================================================
CREATE TABLE DW.Dim_Supplier (
    Supplier_SK INT IDENTITY(1,1) NOT NULL,
    Supplier_ID INT NOT NULL,
    
    -- Attributes
    Company_Name NVARCHAR(40) NOT NULL,      -- SCD Type 1
    Contact_Name NVARCHAR(30) NULL,         -- SCD Type 1
    Contact_Title NVARCHAR(30) NULL,        -- SCD Type 1
    Address NVARCHAR(60) NULL,              -- SCD Type 2
    City NVARCHAR(15) NULL,                 -- SCD Type 2
    Region NVARCHAR(15) NULL,               -- SCD Type 2
    Country NVARCHAR(15) NULL,              -- SCD Type 2
    Phone NVARCHAR(24) NULL,                -- SCD Type 1
    
    -- SCD Type 2 Tracking Columns
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NULL,
    Is_Current BIT NOT NULL,
    
    CONSTRAINT PK_Dim_Supplier PRIMARY KEY CLUSTERED (Supplier_SK)
);
GO

-- =========================================================================
-- 5. Table: DW.Dim_Shipper جدول بُعد ارسال کنندگان کالا
-- =========================================================================
CREATE TABLE DW.Dim_Shipper (
    Shipper_SK INT IDENTITY(1,1) NOT NULL,
    Shipper_ID INT NOT NULL,
    
    -- Attributes
    Company_Name NVARCHAR(40) NOT NULL,      -- SCD Type 2
    Phone NVARCHAR(24) NULL,                -- SCD Type 1
    
    -- SCD Type 2 Tracking Columns
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NULL,
    Is_Current BIT NOT NULL,
    
    CONSTRAINT PK_Dim_Shipper PRIMARY KEY CLUSTERED (Shipper_SK)
);
GO

-- =========================================================================
-- 6. Table: DW.Dim_Product (Flattened: Products + Categories) جدول بُعد محصولات 
-- =========================================================================
CREATE TABLE DW.Dim_Product (
    Product_SK INT IDENTITY(1,1) NOT NULL,
    Product_ID INT NOT NULL,
    
    -- Product Attributes
    Product_Name NVARCHAR(40) NOT NULL,     -- SCD Type 2
    Quantity_Per_Unit NVARCHAR(20) NULL,    -- SCD Type 1
    Unit_Price MONEY NULL,                  -- SCD Type 2
    Units_In_Stock SMALLINT NULL,           -- SCD Type 1
    Units_On_Order SMALLINT NULL,           -- SCD Type 1
    Reorder_Level SMALLINT NULL,            -- SCD Type 1
    Discontinued BIT NOT NULL,              -- SCD Type 1
    
    -- Flattened Category Attributes
    Category_ID INT NULL,                   -- SCD Type 1
    Category_Name NVARCHAR(15) NULL,        -- SCD Type 1
    Category_Description NVARCHAR(MAX) NULL, -- SCD Type 1
    
    -- Smart Attributes
    Price_Tier NVARCHAR(20) NULL,           -- SCD Type 1
    Stock_Status NVARCHAR(30) NULL,         -- SCD Type 1
    Inventory_Turnover_Velocity NVARCHAR(20) NULL, -- SCD Type 1
    Safety_Stock_Buffer_Ratio REAL NULL,    -- SCD Type 1
    
    -- SCD Type 2 Tracking Columns
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NULL,
    Is_Current BIT NOT NULL,
    
    CONSTRAINT PK_Dim_Product PRIMARY KEY CLUSTERED (Product_SK)
);
GO

-- =========================================================================
-- 7. Table: DW.Dim_Territory (Flattened: Territories + Region)
-- =========================================================================
CREATE TABLE DW.Dim_Territory (
    Territory_SK INT IDENTITY(1,1) NOT NULL,
    Territory_ID NVARCHAR(20) NOT NULL,
    
    -- Attributes
    Territory_Description NCHAR(50) NOT NULL, -- SCD Type 1
    Region_ID INT NOT NULL,                  -- SCD Type 1
    Region_Description NCHAR(50) NOT NULL,   -- SCD Type 1
    
    -- SCD Type 2 Tracking Columns
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NULL,
    Is_Current BIT NOT NULL,
    
    CONSTRAINT PK_Dim_Territory PRIMARY KEY CLUSTERED (Territory_SK)
);
GO

USE [Northwind_DW];
GO

-- =========================================================================
-- 8. Table: DW.Fact_Sales جدول فکت فروش 
-- Connected strictly to the Persian Dim_Date via Shamsi Integer SKs.
-- =========================================================================
CREATE TABLE DW.Fact_Sales (
    -- Dimensions Surrogate Keys
    Customer_SK INT NOT NULL,
    Employee_SK INT NOT NULL,
    Product_SK INT NOT NULL,
    Supplier_SK INT NOT NULL,
    Shipper_SK INT NOT NULL,
    Territory_SK INT NOT NULL,
    
    -- Role-Playing Date Keys (اتصال ۱۰۰ درصد ساختاری به کلیدهای عددی شمسی)
    Order_Date_SK INT NOT NULL,       -- لینک به بعد تاریخ شمسی (e.g., 14050115)
    Required_Date_SK INT NOT NULL,    -- لینک به بعد تاریخ شمسی
    Shipped_Date_SK INT NULL,         -- لینک به بعد تاریخ شمسی (قابلیت نال‌پذیری در صورت عدم ارسال کالا)
    
    -- Degenerate Dimension
    Order_ID INT NOT NULL,
    
    -- Numeric Measures
    Unit_Price MONEY NOT NULL,
    Quantity SMALLINT NOT NULL,
    Discount REAL NOT NULL,
    Gross_Amount MONEY NOT NULL,
    Discount_Amount MONEY NOT NULL,
    Net_Amount MONEY NOT NULL,
    Allocated_Freight MONEY NOT NULL,       -- باربری سرشکن شده توسعه‌یافته بر اساس خط فاکتور
    Is_Profitable_Discount BIT NOT NULL,    -- پرچم بهینه‌سازی تخفیف
    
    -- ETL Metadata
    Row_Insert_Date DATETIME DEFAULT GETDATE(),
    
    -- Constraints & Foreign Keys
    CONSTRAINT FK_Fact_Sales_Customer FOREIGN KEY (Customer_SK) REFERENCES DW.Dim_Customer(Customer_SK),
    CONSTRAINT FK_Fact_Sales_Employee FOREIGN KEY (Employee_SK) REFERENCES DW.Dim_Employee(Employee_SK),
    CONSTRAINT FK_Fact_Sales_Product FOREIGN KEY (Product_SK) REFERENCES DW.Dim_Product(Product_SK),
    CONSTRAINT FK_Fact_Sales_Supplier FOREIGN KEY (Supplier_SK) REFERENCES DW.Dim_Supplier(Supplier_SK),
    CONSTRAINT FK_Fact_Sales_Shipper FOREIGN KEY (Shipper_SK) REFERENCES DW.Dim_Shipper(Shipper_SK),
    CONSTRAINT FK_Fact_Sales_Territory FOREIGN KEY (Territory_SK) REFERENCES DW.Dim_Territory(Territory_SK),
    CONSTRAINT FK_Fact_Sales_OrderDate FOREIGN KEY (Order_Date_SK) REFERENCES DW.Dim_Date(Date_SK),
    CONSTRAINT FK_Fact_Sales_RequiredDate FOREIGN KEY (Required_Date_SK) REFERENCES DW.Dim_Date(Date_SK),
    CONSTRAINT FK_Fact_Sales_ShippedDate FOREIGN KEY (Shipped_Date_SK) REFERENCES DW.Dim_Date(Date_SK)
);
GO

--توسعه اسکریپت ایندکس‌های پیشرفته کارایی بر مبنای کلیدهای جدید
USE [Northwind_DW];
GO

-- ایندکس‌های کلیدهای خارجی روی جدول واقعیت فروش
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Customer_SK ON DW.Fact_Sales(Customer_SK);
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Employee_SK ON DW.Fact_Sales(Employee_SK);
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Product_SK ON DW.Fact_Sales(Product_SK);
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Supplier_SK ON DW.Fact_Sales(Supplier_SK);
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Shipper_SK ON DW.Fact_Sales(Shipper_SK);
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Territory_SK ON DW.Fact_Sales(Territory_SK);

-- ایندکس‌های بهینه‌سازی فیلترهای زمانی بر اساس کلید عددی شمسی
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Order_Date_SK ON DW.Fact_Sales(Order_Date_SK);
CREATE NONCLUSTERED INDEX IX_Fact_Sales_Shipped_Date_SK ON DW.Fact_Sales(Shipped_Date_SK);

-- ایندکس‌های ترکیبی ابعاد جهت افزایش سرعت لود فیلترهای گزارش (Slicers)
CREATE NONCLUSTERED INDEX IX_Dim_Customer_Geography ON DW.Dim_Customer(Country, City) WHERE Is_Current = 1;
CREATE NONCLUSTERED INDEX IX_Dim_Product_Category_Name ON DW.Dim_Product(Category_Name, Product_Name) WHERE Is_Current = 1;
CREATE NONCLUSTERED INDEX IX_Dim_Employee_SCD1_Dates ON DW.Dim_Employee(Employee_ID) INCLUDE (Birth_Date, Hire_Date) WHERE Is_Current = 1;
GO

USE Northwind_DW;
GO
/*==============================================================================================
وقتی ستونی مانند QuantityPerUnit حاوی مقادیری مثل 10 boxes x 12 pieces یا 12 - 355 ml cans باشد
، از نظر کامپیوتر و موتورهای تحلیلی مثل Power BI، این‌ها فقط «رشته‌های متنی مرده» هستند.
                        .شما نمی‌توانید روی متن عملیات ریاضی انجام دهید
    راهکار این است که این ستون به 4 ستون تقسیم شود و برای این کار اقدامات زیر انجام می شود.
                     گام اول: اصلاح و توسعه ساختار فیزیکی جداول در انبار داده (Northwind_DW)
                            به دلیل تفکیک ستون QuantityPerUnit
==============================================================================================*/
-- ۱. توسعه جدول بعد محصول برای پذیرا شدن اجزای تفکیک‌شده کالا
ALTER TABLE DW.Dim_Product ADD
    Units_Per_Package INT DEFAULT 1,
    Unit_Value DECIMAL(10, 2) DEFAULT 0,
    Unit_Of_Measure NVARCHAR(50),
    Package_Type NVARCHAR(50);
GO

-- ۲. توسعه جدول بعد مشتری برای پذیرا شدن سطح تصمیم‌گیری استراتژیک مخاطب
ALTER TABLE DW.Dim_Customer ADD
    Contact_Decision_Tier NVARCHAR(100);
GO

-- ۳. توسعه جدول بعد تامین‌کننده برای یکسان‌سازی سطح مخاطبان مبدا
ALTER TABLE DW.Dim_Supplier ADD
    Contact_Decision_Tier NVARCHAR(100);
GO

-- ۴. توسعه جدول واقعیت فروش برای اضافه شدن سنجه‌های فیزیکی وزن و حجم در سطح اتمیک فاکتور
ALTER TABLE DW.Fact_Sales ADD
    Line_Total_Weight_KG DECIMAL(12, 3) DEFAULT 0,
    Line_Total_Volume_Liter DECIMAL(12, 3) DEFAULT 0;
GO


/*==============================================================================================
         گام دوم: منطق ترانسفورمیشن و پالایش داده‌ها در لایه استیجینگ (Northwind_Stg)
         ۱. الگوریتم تفکیک و تمیزکاری ستون QuantityPerUnit (جدول محصولات)
عبارات انگلیسی کاملاً حذف شده و واحدهایی مانند cc به «میلی لیتر» و 1k به عدد ۱ با واحد «کیلوگرم» نگاشت می‌شوند:
==============================================================================================*/

-- ایجاد یک ویوی محاسباتی یا کامپوننت ETL در استیج جهت تفکیک دقیق متن آزاد
USE Northwind_Stg;
GO

-- ایجاد یا اصلاح ویو در دیتابیس استیج با آدرس‌دهی دقیق ۳ بخشی
CREATE OR ALTER VIEW Stg.Vw_Clean_Products AS
SELECT 
    ProductID,
    ProductName,
    SupplierID,
    CategoryID,
    UnitPrice,
    QuantityPerUnit,
    
    -- ۱. تعداد در بسته کالا
    CASE 
        WHEN QuantityPerUnit LIKE '%boxes x%' THEN CAST(SUBSTRING(QuantityPerUnit, 1, CHARINDEX(' ', QuantityPerUnit) - 1) AS INT)
        WHEN QuantityPerUnit LIKE '%bags x%' THEN CAST(SUBSTRING(QuantityPerUnit, 1, CHARINDEX(' ', QuantityPerUnit) - 1) AS INT)
        WHEN QuantityPerUnit LIKE '%pkgs. x%' THEN CAST(SUBSTRING(QuantityPerUnit, 1, CHARINDEX(' ', QuantityPerUnit) - 1) AS INT)
        WHEN QuantityPerUnit LIKE '%-%' THEN CAST(SUBSTRING(QuantityPerUnit, 1, CHARINDEX('-', QuantityPerUnit) - 1) AS INT)
        ELSE 1 
    END AS Units_Per_Package,

    -- ۲. مقدار عددی واحد کالا
    CASE 
        WHEN QuantityPerUnit LIKE '%boxes x%' THEN CAST(SUBSTRING(QuantityPerUnit, CHARINDEX('x', QuantityPerUnit) + 2, CHARINDEX(' ', QuantityPerUnit, CHARINDEX('x', QuantityPerUnit) + 2) - (CHARINDEX('x', QuantityPerUnit) + 2)) AS DECIMAL(10,2))
        WHEN QuantityPerUnit LIKE '%bags x%' THEN CAST(SUBSTRING(QuantityPerUnit, CHARINDEX('x', QuantityPerUnit) + 2, CHARINDEX(' ', QuantityPerUnit, CHARINDEX('x', QuantityPerUnit) + 2) - (CHARINDEX('x', QuantityPerUnit) + 2)) AS DECIMAL(10,2))
        WHEN QuantityPerUnit LIKE '%pkgs. x%' THEN CAST(SUBSTRING(QuantityPerUnit, CHARINDEX('x', QuantityPerUnit) + 2, CHARINDEX(' ', QuantityPerUnit, CHARINDEX('x', QuantityPerUnit) + 2) - (CHARINDEX('x', QuantityPerUnit) + 2)) AS DECIMAL(10,2))
        WHEN QuantityPerUnit LIKE '%-%' THEN 
            CASE 
                WHEN PATINDEX('%[0-9]%', SUBSTRING(QuantityPerUnit, CHARINDEX('-', QuantityPerUnit) + 1, LEN(QuantityPerUnit))) > 0
                THEN CAST(SUBSTRING(QuantityPerUnit, CHARINDEX('-', QuantityPerUnit) + PATINDEX('%[0-9]%', SUBSTRING(QuantityPerUnit, CHARINDEX('-', QuantityPerUnit) + 1, LEN(QuantityPerUnit))), CHARINDEX(' ', QuantityPerUnit, CHARINDEX('-', QuantityPerUnit) + 2) - (CHARINDEX('-', QuantityPerUnit) + PATINDEX('%[0-9]%', SUBSTRING(QuantityPerUnit, CHARINDEX('-', QuantityPerUnit) + 1, LEN(QuantityPerUnit))))) AS DECIMAL(10,2))
                ELSE 1
            END
        WHEN QuantityPerUnit LIKE '%k pkg%' THEN 1.00
        WHEN PATINDEX('%[0-9]%', QuantityPerUnit) > 0 THEN CAST(SUBSTRING(QuantityPerUnit, PATINDEX('%[0-9]%', QuantityPerUnit), CHARINDEX(' ', QuantityPerUnit + ' ', PATINDEX('%[0-9]%', QuantityPerUnit)) - PATINDEX('%[0-9]%', QuantityPerUnit)) AS DECIMAL(10,2))
        ELSE 1.00
    END AS Unit_Value,

    -- ۳. واحد سنجش استاندارد (فارسی خالص - بدون عبارات انگلیسی داخل پرانتز)
    CASE 
        WHEN QuantityPerUnit LIKE '%g %' OR QuantityPerUnit LIKE '%g' THEN N'گرم'
        WHEN QuantityPerUnit LIKE '%kg%' OR QuantityPerUnit LIKE '%k pkg%' THEN N'کیلوگرم'
        WHEN QuantityPerUnit LIKE '%ml%' OR QuantityPerUnit LIKE '%cc%' THEN N'میلی لیتر'
        WHEN QuantityPerUnit LIKE '% l %' OR QuantityPerUnit LIKE '% l' OR QuantityPerUnit LIKE '%liter%' THEN N'لیتر'
        WHEN QuantityPerUnit LIKE '%oz%' THEN N'اونس'
        WHEN QuantityPerUnit LIKE '%lb%' THEN N'پوند'
        WHEN QuantityPerUnit LIKE '%pieces%' THEN N'عدد'
        WHEN QuantityPerUnit LIKE '%bags%' THEN N'بسته'
        WHEN QuantityPerUnit LIKE '%boxes%' THEN N'جعبه'
        ELSE N'عدد'
    END AS Unit_Of_Measure,

    -- ۴. نوع بسته‌بندی فیزیکی به زبان فارسی
    CASE 
        WHEN QuantityPerUnit LIKE '%glass%' THEN N'شیشه'
        WHEN QuantityPerUnit LIKE '%can%' THEN N'قوطی'
        WHEN QuantityPerUnit LIKE '%bottle%' THEN N'بطری'
        WHEN QuantityPerUnit LIKE '%box%' OR QuantityPerUnit LIKE '%boxes%' THEN N'جعبه'
        WHEN QuantityPerUnit LIKE '%bag%' OR QuantityPerUnit LIKE '%bags%' THEN N'کیسه'
        WHEN QuantityPerUnit LIKE '%pkg%' OR QuantityPerUnit LIKE '%pkgs%' THEN N'بسته'
        WHEN QuantityPerUnit LIKE '%jar%' OR QuantityPerUnit LIKE '%jars%' THEN N'جار'
        WHEN QuantityPerUnit LIKE '%tin%' OR QuantityPerUnit LIKE '%tins%' THEN N'حلبی'
        WHEN QuantityPerUnit LIKE '%pie%' OR QuantityPerUnit LIKE '%pies%' THEN N'پای'
        ELSE N'تکی'
    END AS Package_Type

-- اصلاح اصلی: فراخوانی مستقیم و امن از دیتابیس تراکنشی با آدرس‌دهی سه بخشی
FROM Northwind.dbo.Products;
GO


/*==============================================================================================
                ۲. الگوریتم تمیزکاری و یکسان‌سازی ستون منطقه جغرافیایی (Region)
        این اسکریپت با بررسی فیلد کشور، مقادیر مبهم یا تهی (NULL) را به بخش‌های استاندارد قاره‌ای و 
                            منطقه‌ای هدایت می‌کند تا شکستگی ساختار جغرافیا در ابعاد مشتریان،
                                            کارمندان و تامین‌کنندگان برطرف شود:
==============================================================================================*/

-- این منطق درون پروسه بارگذاری ابعاد انبار داده تعبیه می‌شود
CREATE OR ALTER VIEW Stg.Vw_Clean_Geography AS
SELECT 
    CustomerID,
    City,
    Country,
    CASE 
        WHEN Region IS NOT NULL THEN Region
        WHEN Country IN ('Germany', 'France', 'Netherlands', 'Belgium', 'Austria', 'Switzerland') THEN N'اروپای غربی'
        WHEN Country IN ('UK', 'Ireland') THEN N'جزایر بریتانیا'
        WHEN Country IN ('Sweden', 'Norway', 'Denmark', 'Finland') THEN N'اروپای شمالی'
        WHEN Country IN ('Italy', 'Spain', 'Portugal', 'Greece') THEN N'اروپای جنوبی'
        WHEN Country IN ('Brazil', 'Argentina', 'Venezuela') THEN N'امریکای جنوبی'
        WHEN Country IN ('Mexico') THEN N'امریکای مرکزی'
        ELSE N'نامشخص'
    END AS Clean_Region
FROM Northwind.dbo.Customers;
GO

/*==============================================================================================
                ۳. الگوریتم لایه‌بندی استراتژیک عناوین شغلی مخاطبان (ContactTitle)
                پراکندگی‌های متنی فیلد مخاطبان به سه سطح کلان مدیریتی و تصمیمی تفکیک می‌شوند:
==============================================================================================*/
CREATE OR ALTER VIEW Stg.Vw_Clean_ContactTitles AS
SELECT 
    CustomerID,
    ContactName,
    ContactTitle,
    CASE 
        WHEN ContactTitle IN ('Owner', 'CEO', 'Vice President', 'President') THEN N'مدیریت کلان استراتژیک'
        WHEN ContactTitle LIKE '%Manager%' OR ContactTitle LIKE '%Head%' OR ContactTitle = 'Accounting Manager' THEN N'مدیریت میانی تاکتیکی'
        ELSE N'لایه عملیاتی اجرایی'
    END AS Contact_Decision_Tier
FROM Northwind.dbo.Customers;
GO

/*==============================================================================================
                     گام چهارم: بازنویسی کامل ویوی گزارش‌گیری نهایی (Report.Vw_Main_Sales)
 ==============================================================================================*/
 USE Northwind_DW;
GO

CREATE OR ALTER VIEW Report.Vw_Main_Sales AS
SELECT 
    -- ۱. کانتکست زمانی (کلیدهای شمسی‌سازی شده)
    F.Order_Date_SK AS [کد تاریخ فاکتور],
    D.Persian_Year AS [سال سفارش],
    D.Persian_Month_Name AS [ماه سفارش],
    D.Persian_Day_Of_Month AS [روز سفارش],

    -- ۲. اطلاعات پالایش‌شده مشتری و لایه‌بندی شغلی نوظهور
    C.Customer_ID AS [کد مشتری],
    C.Company_Name AS [نام شرکت مشتری],
    C.Contact_Name AS [نام مخاطب مشتری],
    C.Contact_Decision_Tier AS [سطح تصمیم گیری مخاطب مشتری],
    C.City AS [شهر مشتری],
    C.Region AS [منطقه جغرافیایی مشتری], -- مقدار اصلاح شده و فاقد NULL
    C.Country AS [کشور مشتری],

    -- ۳. اطلاعات کارمند فروش
    E.Employee_ID AS [کد کارمند],
    (E.First_Name + ' ' + E.Last_Name) AS [نام کارمند فروش],

    -- ۴. کالبدشکافی ساختاری محصول و فیلدهای مهندسی شده جدید
    P.Product_ID AS [کد محصول],
    P.Product_Name AS [نام محصول],
    P.Category_Name AS [دسته بندی محصول],
    P.Units_Per_Package AS [تعداد در بسته کالا],
    P.Unit_Value AS [مقدار عددی واحد کالا],
    P.Unit_Of_Measure AS [واحد سنجش],          -- فارسی خالص (مثال: گرم، کیلوگرم)
    P.Package_Type AS [نوع بسته بندی کالا],      -- فارسی خالص (مثال: قوطی، بطری)

    -- ۵. سنجه‌های مالی و محاسباتی اتمیک فاکتور
    F.Quantity AS [تعداد فروش رفته],
    F.Unit_Price AS [قیمت واحد فروش],
    F.Gross_Amount AS [مبلغ ناخالص فروش],
    F.Discount_Amount AS [مبلغ تخفیف اعمال شده],
    F.Net_Amount AS [مبلغ خالص دریافتی],
    F.Allocated_Freight AS [هزینه حمل سرشکن شده],

    -- ۶. سنجه‌های فیزیکی جدید حاصل از مهندسی داده‌ها
    F.Line_Total_Weight_KG AS [وزن کل سطر به کیلوگرم],
    F.Line_Total_Volume_Liter AS [حجم کل سطر به لیتر]

FROM DW.Fact_Sales F
INNER JOIN DW.Dim_Date D ON F.Order_Date_SK = D.Date_SK
INNER JOIN DW.Dim_Customer C ON F.Customer_SK = C.Customer_SK
INNER JOIN DW.Dim_Employee E ON F.Employee_SK = E.Employee_SK
INNER JOIN DW.Dim_Product P ON F.Product_SK = P.Product_SK;
GO

