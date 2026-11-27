
USE Supply_chain_anal;
GO

-- =========================================
-- 1. DIMENSION TABLE: DATE
-- =========================================

CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Quarter INT,
    MonthNumber INT,
    MonthName NVARCHAR(30),
    WeekNumber INT,
    DayOfMonth INT,
    DayName NVARCHAR(30),
    IsWeekend BIT,
    IsFullYear BIT,
    YearMonth CHAR(7)
);
GO

-- =========================================
-- 2. DIMENSION TABLE: MONTH
-- =========================================

CREATE TABLE dbo.DimMonth (
    MonthKey INT IDENTITY(1,1) PRIMARY KEY,
    YearMonth CHAR(7) UNIQUE,
    OrderYear INT,
    OrderMonth INT,
    OrderQuarter INT,
    MonthName NVARCHAR(30),
    MonthSortKey INT
);
GO

-- =========================================
-- 3. DIMENSION TABLE: REGION
-- =========================================

CREATE TABLE dbo.DimRegion (
    RegionKey INT PRIMARY KEY,
    OrderRegion NVARCHAR(100),
    Market NVARCHAR(100)
);
GO

-- =========================================
-- 4. DIMENSION TABLE: SHIPPING
-- =========================================

CREATE TABLE dbo.DimShipping (
    ShippingKey INT PRIMARY KEY,
    ShippingMode NVARCHAR(100) UNIQUE
);
GO

-- =========================================
-- 5. DIMENSION TABLE: CATEGORY
-- =========================================

CREATE TABLE dbo.DimCategory (
    CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100),
    CategoryName NVARCHAR(150),

    CONSTRAINT UQ_DimCategory
    UNIQUE (DepartmentName, CategoryName)
);
GO

-- =========================================
-- 6. DIMENSION TABLE: YEAR
-- =========================================

CREATE TABLE dbo.DimYear (
    YearKey INT IDENTITY(1,1) PRIMARY KEY,
    YearValue INT UNIQUE
);
GO
---------------------------------------------------------------------------------------------------
--This is where we transfer the descriptive data from the staging layer into the dimension layer.--
---------------------------------------------------------------------------------------------------
USE Supply_chain_anal;
GO

-- DIM DATE
INSERT INTO dbo.DimDate
SELECT
    TRY_CONVERT(INT, date_key),
    TRY_CONVERT(DATE, full_date),
    TRY_CONVERT(INT, [year]),
    TRY_CONVERT(INT, [quarter]),
    TRY_CONVERT(INT, [month]),
    month_name,
    TRY_CONVERT(INT, [week]),
    TRY_CONVERT(INT, day_of_month),
    day_name,
    TRY_CONVERT(BIT, is_weekend),
    TRY_CONVERT(BIT, is_full_year),
    year_month
FROM stg.Date;
GO

-- DIM MONTH
INSERT INTO dbo.DimMonth (
    YearMonth, OrderYear, OrderMonth,
    OrderQuarter, MonthName, MonthSortKey
)
SELECT DISTINCT
    year_month,
    TRY_CONVERT(INT, order_year),
    TRY_CONVERT(INT, order_month),
    TRY_CONVERT(INT, order_quarter),
    month_name,
    TRY_CONVERT(INT, month_sort_key)
FROM stg.Month;
GO

-- DIM REGION
INSERT INTO dbo.DimRegion (
    RegionKey, OrderRegion, Market
)
SELECT
    TRY_CONVERT(INT, region_key),
    order_region,
    market
FROM stg.Region;
GO

-- DIM SHIPPING
INSERT INTO dbo.DimShipping (
    ShippingKey, ShippingMode
)
SELECT
    TRY_CONVERT(INT, shipping_key),
    shipping_mode
FROM stg.Shipping;
GO

-- DIM CATEGORY
INSERT INTO dbo.DimCategory (
    DepartmentName, CategoryName
)
SELECT DISTINCT
    department_name,
    category_name
FROM stg.Category;
GO

-- DIM YEAR
INSERT INTO dbo.DimYear (YearValue)
SELECT DISTINCT TRY_CONVERT(INT, order_year)
FROM stg.Region_2
WHERE TRY_CONVERT(INT, order_year) IS NOT NULL;
GO


