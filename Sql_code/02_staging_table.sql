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
