---------------------
-- CREATE DATABASE --
---------------------

USE master;
GO

--Drop the Database, If it exist--
    
IF DB_ID('SupplyChainDB') IS NOT NULL
    DROP DATABASE SupplyChainDB;
GO

CREATE DATABASE SupplyChainDB;
GO

USE SupplyChainDB;
GO

--Show Successful completion--
    
PRINT ' SupplyChainDB created successfully';
