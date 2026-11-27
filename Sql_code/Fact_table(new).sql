
USE Supply_chain_anal;
GO

-- =========================================
-- 1. FACT CATEGORY
-- =========================================

CREATE TABLE dbo.FactCategory (
    CategoryKey INT NOT NULL,
    TotalOrders INT,
    TotalUnits INT,
    TotalRevenue DECIMAL(18,2),
    TotalProfit DECIMAL(18,2),
    MarginPct DECIMAL(8,2),
    OTDRatePct DECIMAL(8,2),
    SLABreachPct DECIMAL(8,2),
    PerfectOrderPct DECIMAL(8,2),

    CONSTRAINT PK_FactCategory
    PRIMARY KEY (CategoryKey),

    CONSTRAINT FK_FactCategory_DimCategory
    FOREIGN KEY (CategoryKey)
    REFERENCES dbo.DimCategory(CategoryKey)
);
GO

-- =========================================
-- 2. FACT MONTHLY TREND
-- =========================================

CREATE TABLE dbo.FactMonthlyTrend (
    MonthKey INT PRIMARY KEY,
    TotalOrders INT,
    TotalRevenue DECIMAL(18,2),
    TotalProfit DECIMAL(18,2),
    OTDRatePct DECIMAL(8,2),
    OTIFRatePct DECIMAL(8,2),
    SLABreachPct DECIMAL(8,2),
    PerfectOrderPct DECIMAL(8,2),
    AvgDaysVariance DECIMAL(8,2),

    CONSTRAINT FK_FactMonthlyTrend_DimMonth
    FOREIGN KEY (MonthKey)
    REFERENCES dbo.DimMonth(MonthKey)
);
GO

-- =========================================
-- 3. FACT REGION PERFORMANCE
-- =========================================

CREATE TABLE dbo.FactRegionPerformance (
    RegionKey INT,
    ShippingKey INT,
    YearKey INT,
    TotalOrders INT,
    TotalRevenue DECIMAL(18,2),
    TotalProfit DECIMAL(18,2),
    OTDRatePct DECIMAL(8,2),
    OTIFRatePct DECIMAL(8,2),
    SLABreachPct DECIMAL(8,2),
    PerfectOrderPct DECIMAL(8,2),
    AvgDaysToShip DECIMAL(8,2),
    AvgDaysVariance DECIMAL(8,2),
    OTDRankWorstFirst INT,

    CONSTRAINT PK_FactRegionPerformance
    PRIMARY KEY (RegionKey, ShippingKey, YearKey),

    CONSTRAINT FK_FactRegion_DimRegion
    FOREIGN KEY (RegionKey)
    REFERENCES dbo.DimRegion(RegionKey),

    CONSTRAINT FK_FactRegion_DimShipping
    FOREIGN KEY (ShippingKey)
    REFERENCES dbo.DimShipping(ShippingKey),

    CONSTRAINT FK_FactRegion_DimYear
    FOREIGN KEY (YearKey)
    REFERENCES dbo.DimYear(YearKey)
);
GO

-- =========================================
-- 4. FACT SHIPPING PERFORMANCE
-- =========================================

CREATE TABLE dbo.FactShippingPerformance (
    ShippingKey INT PRIMARY KEY,
    TotalOrders INT,
    TotalRevenue DECIMAL(18,2),
    OTDRatePct DECIMAL(8,2),
    OTIFRatePct DECIMAL(8,2),
    SLABreachPct DECIMAL(8,2),
    PerfectOrderPct DECIMAL(8,2),
    AvgActualDays DECIMAL(8,2),
    AvgPromisedDays DECIMAL(8,2),
    AvgDaysVariance DECIMAL(8,2),
    PctOfTotalOrders DECIMAL(8,2),

    CONSTRAINT FK_FactShipping_DimShipping
    FOREIGN KEY (ShippingKey)
    REFERENCES dbo.DimShipping(ShippingKey)
);
GO

-- =========================================
-- 5. FACT SLA HEATMAP
-- =========================================

CREATE TABLE dbo.FactSLAHeatmap (
    RegionKey INT,
    ShippingKey INT,
    TotalOrders INT,
    SLABreachPct DECIMAL(8,2),
    OTDRatePct DECIMAL(8,2),
    AvgDaysLate DECIMAL(8,2),
    RiskCategory NVARCHAR(50),

    CONSTRAINT PK_FactSLAHeatmap
    PRIMARY KEY (RegionKey, ShippingKey),

    CONSTRAINT FK_FactSLA_DimRegion
    FOREIGN KEY (RegionKey)
    REFERENCES dbo.DimRegion(RegionKey),

    CONSTRAINT FK_FactSLA_DimShipping
    FOREIGN KEY (ShippingKey)
    REFERENCES dbo.DimShipping(ShippingKey)
);
GO

-- =========================================
-- 6. FACT SUMMARY
-- =========================================

CREATE TABLE dbo.FactSummary (
    SummaryID INT PRIMARY KEY,
    TotalLineItems INT,
    TotalOrders INT,
    TotalUnitsSold INT,
    TotalRevenue DECIMAL(18,2),
    TotalProfit DECIMAL(18,2),
    ProfitMarginPct DECIMAL(8,2),
    OTDRatePct DECIMAL(8,2),
    OTIFRatePct DECIMAL(8,2),
    SLABreachPct DECIMAL(8,2),
    PerfectOrderPct DECIMAL(8,2),
    CompleteOrderPct DECIMAL(8,2),
    AvgDaysToShip DECIMAL(8,2),
    AvgDaysVariance DECIMAL(8,2)
);
GO
--Populate the table--
--Notice the JOIN statements. We use them to retrieve the primary keys from the dimension tables and insert those keys into the fact tables.--

USE Supply_chain_anal;
GO

-- =========================================
-- 1. POPULATE FACT CATEGORY
-- =========================================

INSERT INTO dbo.FactCategory (
    CategoryKey,
    TotalOrders,
    TotalUnits,
    TotalRevenue,
    TotalProfit,
    MarginPct,
    OTDRatePct,
    SLABreachPct,
    PerfectOrderPct
)
SELECT
    D.CategoryKey,
    TRY_CONVERT(INT, S.total_orders),
    TRY_CONVERT(INT, S.total_units),
    TRY_CONVERT(DECIMAL(18,2), S.total_revenue),
    TRY_CONVERT(DECIMAL(18,2), S.total_profit),
    TRY_CONVERT(DECIMAL(8,2), S.margin_pct),
    TRY_CONVERT(DECIMAL(8,2), S.otd_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.sla_breach_pct),
    TRY_CONVERT(DECIMAL(8,2), S.perfect_order_pct)
FROM stg.Category S
INNER JOIN dbo.DimCategory D
    ON S.department_name = D.DepartmentName
    AND S.category_name = D.CategoryName;
GO


-- =========================================
-- 2. POPULATE FACT MONTHLY TREND
-- =========================================

INSERT INTO dbo.FactMonthlyTrend (
    MonthKey,
    TotalOrders,
    TotalRevenue,
    TotalProfit,
    OTDRatePct,
    OTIFRatePct,
    SLABreachPct,
    PerfectOrderPct,
    AvgDaysVariance
)
SELECT
    D.MonthKey,
    TRY_CONVERT(INT, S.total_orders),
    TRY_CONVERT(DECIMAL(18,2), S.total_revenue),
    TRY_CONVERT(DECIMAL(18,2), S.total_profit),
    TRY_CONVERT(DECIMAL(8,2), S.otd_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.otif_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.sla_breach_pct),
    TRY_CONVERT(DECIMAL(8,2), S.perfect_order_pct),
    TRY_CONVERT(DECIMAL(8,2), S.avg_days_variance)
FROM stg.Monthly_Trend S
INNER JOIN dbo.DimMonth D
    ON S.year_month = D.YearMonth;
GO


-- =========================================
-- 3. POPULATE FACT REGION PERFORMANCE
-- =========================================

INSERT INTO dbo.FactRegionPerformance (
    RegionKey,
    ShippingKey,
    YearKey,
    TotalOrders,
    TotalRevenue,
    TotalProfit,
    OTDRatePct,
    OTIFRatePct,
    SLABreachPct,
    PerfectOrderPct,
    AvgDaysToShip,
    AvgDaysVariance,
    OTDRankWorstFirst
)
SELECT
    R.RegionKey,
    SH.ShippingKey,
    Y.YearKey,
    TRY_CONVERT(INT, S.total_orders),
    TRY_CONVERT(DECIMAL(18,2), S.total_revenue),
    TRY_CONVERT(DECIMAL(18,2), S.total_profit),
    TRY_CONVERT(DECIMAL(8,2), S.otd_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.otif_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.sla_breach_pct),
    TRY_CONVERT(DECIMAL(8,2), S.perfect_order_pct),
    TRY_CONVERT(DECIMAL(8,2), S.avg_days_to_ship),
    TRY_CONVERT(DECIMAL(8,2), S.avg_days_variance),
    TRY_CONVERT(INT, S.otd_rank_worst_first)
FROM stg.Region_2 S
INNER JOIN dbo.DimRegion R
    ON S.order_region = R.OrderRegion
    AND S.market = R.Market
INNER JOIN dbo.DimShipping SH
    ON S.shipping_mode = SH.ShippingMode
INNER JOIN dbo.DimYear Y
    ON TRY_CONVERT(INT, S.order_year) = Y.YearValue;
GO


-- =========================================
-- 4. POPULATE FACT SHIPPING PERFORMANCE
-- =========================================

INSERT INTO dbo.FactShippingPerformance (
    ShippingKey,
    TotalOrders,
    TotalRevenue,
    OTDRatePct,
    OTIFRatePct,
    SLABreachPct,
    PerfectOrderPct,
    AvgActualDays,
    AvgPromisedDays,
    AvgDaysVariance,
    PctOfTotalOrders
)
SELECT
    D.ShippingKey,
    TRY_CONVERT(INT, S.total_orders),
    TRY_CONVERT(DECIMAL(18,2), S.total_revenue),
    TRY_CONVERT(DECIMAL(8,2), S.otd_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.otif_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.sla_breach_pct),
    TRY_CONVERT(DECIMAL(8,2), S.perfect_order_pct),
    TRY_CONVERT(DECIMAL(8,2), S.avg_actual_days),
    TRY_CONVERT(DECIMAL(8,2), S.avg_promised_days),
    TRY_CONVERT(DECIMAL(8,2), S.avg_days_variance),
    TRY_CONVERT(DECIMAL(8,2), S.pct_of_total_orders)
FROM stg.ShippingMode S
INNER JOIN dbo.DimShipping D
    ON S.shipping_mode = D.ShippingMode;
GO


-- =========================================
-- 5. POPULATE FACT SLA HEATMAP
-- =========================================

INSERT INTO dbo.FactSLAHeatmap (
    RegionKey,
    ShippingKey,
    TotalOrders,
    SLABreachPct,
    OTDRatePct,
    AvgDaysLate,
    RiskCategory
)
SELECT
    R.RegionKey,
    SH.ShippingKey,
    TRY_CONVERT(INT, S.total_orders),
    TRY_CONVERT(DECIMAL(8,2), S.sla_breach_pct),
    TRY_CONVERT(DECIMAL(8,2), S.otd_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), S.avg_days_late),
    S.risk_category
FROM stg.SLA_Heatmap S
INNER JOIN dbo.DimRegion R
    ON S.order_region = R.OrderRegion
INNER JOIN dbo.DimShipping SH
    ON S.shipping_mode = SH.ShippingMode;
GO


-- =========================================
-- 6. POPULATE FACT SUMMARY
-- =========================================

INSERT INTO dbo.FactSummary (
    SummaryID,
    TotalLineItems,
    TotalOrders,
    TotalUnitsSold,
    TotalRevenue,
    TotalProfit,
    ProfitMarginPct,
    OTDRatePct,
    OTIFRatePct,
    SLABreachPct,
    PerfectOrderPct,
    CompleteOrderPct,
    AvgDaysToShip,
    AvgDaysVariance
)
SELECT
    1,
    TRY_CONVERT(INT, total_line_items),
    TRY_CONVERT(INT, total_orders),
    TRY_CONVERT(INT, total_units_sold),
    TRY_CONVERT(DECIMAL(18,2), total_revenue),
    TRY_CONVERT(DECIMAL(18,2), total_profit),
    TRY_CONVERT(DECIMAL(8,2), profit_margin_pct),
    TRY_CONVERT(DECIMAL(8,2), otd_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), otif_rate_pct),
    TRY_CONVERT(DECIMAL(8,2), sla_breach_pct),
    TRY_CONVERT(DECIMAL(8,2), perfect_order_pct),
    TRY_CONVERT(DECIMAL(8,2), complete_order_pct),
    TRY_CONVERT(DECIMAL(8,2), avg_days_to_ship),
    TRY_CONVERT(DECIMAL(8,2), avg_days_variance)
FROM stg.Summary;
GO
