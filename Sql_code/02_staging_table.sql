--Here we can directly use Insert and stg table because we already know the contents of the table and the table itself.
USE Supply_chain_anal;
GO

-- CATEGORY
BULK INSERT stg.Category
FROM 'C:\SupplyChainData\Category.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- DATE
BULK INSERT stg.Date
FROM 'C:\SupplyChainData\Date.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- MONTH
BULK INSERT stg.Month
FROM 'C:\SupplyChainData\Month.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- MONTHLY TREND
BULK INSERT stg.Monthly_Trend
FROM 'C:\SupplyChainData\Monthly_Trend.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- REGION
BULK INSERT stg.Region
FROM 'C:\SupplyChainData\Region.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- REGION 2
BULK INSERT stg.Region_2
FROM 'C:\SupplyChainData\Region_2.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- SHIPPING
BULK INSERT stg.Shipping
FROM 'C:\SupplyChainData\Shipping.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- SHIPPING MODE
BULK INSERT stg.ShippingMode
FROM 'C:\SupplyChainData\ShippingMode.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

--Validate Import--

USE Supply_chain_anal;
GO

SELECT 'Category' AS Table_Name, COUNT(*) AS Total_Rows FROM stg.Category
UNION ALL
SELECT 'Date', COUNT(*) FROM stg.Date
UNION ALL
SELECT 'Month', COUNT(*) FROM stg.Month
UNION ALL
SELECT 'Monthly_Trend', COUNT(*) FROM stg.Monthly_Trend
UNION ALL
SELECT 'Region', COUNT(*) FROM stg.Region
UNION ALL
SELECT 'Region_2', COUNT(*) FROM stg.Region_2
UNION ALL
SELECT 'Shipping', COUNT(*) FROM stg.Shipping
UNION ALL
SELECT 'ShippingMode', COUNT(*) FROM stg.ShippingMode
UNION ALL
SELECT 'SLA_Heatmap', COUNT(*) FROM stg.SLA_Heatmap
UNION ALL
SELECT 'Summary', COUNT(*) FROM stg.Summary;
GO
--Shows the no of rows--
