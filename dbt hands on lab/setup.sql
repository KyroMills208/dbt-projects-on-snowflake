-- =====================================================
-- dbt Projects on Snowflake - Hands-On Lab Setup
-- =====================================================
-- This script creates all necessary Snowflake resources
-- for the dbt hands-on lab demo
-- =====================================================

-- Set context
USE ROLE ACCOUNTADMIN;

-- =====================================================
-- 1. CREATE DATABASES
-- =====================================================

-- Main database for the demo
CREATE DATABASE IF NOT EXISTS tasty_bytes_dbt_db
COMMENT = 'Database for dbt Projects on Snowflake hands-on lab';

-- Create schemas within the database
USE DATABASE tasty_bytes_dbt_db;

CREATE SCHEMA IF NOT EXISTS raw
COMMENT = 'Raw data from source systems';

CREATE SCHEMA IF NOT EXISTS dev_analytics
COMMENT = 'Development analytics schema for dbt models';

CREATE SCHEMA IF NOT EXISTS analytics
COMMENT = 'Production analytics schema for dbt models';

CREATE SCHEMA IF NOT EXISTS staging
COMMENT = 'Staging layer for cleaned and standardized data';

CREATE SCHEMA IF NOT EXISTS marts
COMMENT = 'Marts layer for final analytics models';

CREATE SCHEMA IF NOT EXISTS snapshots
COMMENT = 'Snapshots for slowly changing dimensions';

-- =====================================================
-- 2. CREATE WAREHOUSES
-- =====================================================

-- Development warehouse
CREATE WAREHOUSE IF NOT EXISTS dbt_dev_wh
WITH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Development warehouse for dbt hands-on lab';

-- Production warehouse
CREATE WAREHOUSE IF NOT EXISTS dbt_prod_wh
WITH
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Production warehouse for dbt hands-on lab';

-- =====================================================
-- 3. CREATE ROLES
-- =====================================================

-- Developer role
CREATE ROLE IF NOT EXISTS dbt_developer_role
COMMENT = 'Role for dbt developers in hands-on lab';

-- Production role
CREATE ROLE IF NOT EXISTS dbt_prod_role
COMMENT = 'Role for dbt production operations in hands-on lab';

-- Analyst role (for secure views)
CREATE ROLE IF NOT EXISTS analyst_role
COMMENT = 'Role for analysts consuming dbt models';

-- Finance role (for secure views)
CREATE ROLE IF NOT EXISTS finance_role
COMMENT = 'Role for finance team with access to detailed revenue data';

-- =====================================================
-- 4. GRANT PRIVILEGES TO ROLES
-- =====================================================

-- Grant database privileges
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE dbt_developer_role;
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE dbt_prod_role;
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE analyst_role;
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE finance_role;

-- Grant schema privileges
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.raw TO ROLE dbt_developer_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.raw TO ROLE dbt_prod_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.raw TO ROLE analyst_role;

GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE dbt_developer_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE analyst_role;

GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.analytics TO ROLE dbt_prod_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.analytics TO ROLE analyst_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.analytics TO ROLE finance_role;

GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_developer_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_prod_role;

GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_developer_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_prod_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE analyst_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE finance_role;

GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.snapshots TO ROLE dbt_developer_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.snapshots TO ROLE dbt_prod_role;

-- Grant warehouse privileges
GRANT USAGE ON WAREHOUSE dbt_dev_wh TO ROLE dbt_developer_role;
GRANT USAGE ON WAREHOUSE dbt_prod_wh TO ROLE dbt_prod_role;

-- Grant future privileges on tables and views
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.raw TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.raw TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.raw TO ROLE analyst_role;

GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE analyst_role;

GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.analytics TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.analytics TO ROLE analyst_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.analytics TO ROLE finance_role;

GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_prod_role;

GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE analyst_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE finance_role;

GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.snapshots TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.snapshots TO ROLE dbt_prod_role;

-- Grant future privileges on views
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.raw TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.raw TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.raw TO ROLE analyst_role;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE analyst_role;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.analytics TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.analytics TO ROLE analyst_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.analytics TO ROLE finance_role;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_prod_role;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE analyst_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.marts TO ROLE finance_role;

-- Grant create privileges for dbt operations
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE dbt_developer_role;
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.analytics TO ROLE dbt_prod_role;
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_developer_role;
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_prod_role;
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_developer_role;
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_prod_role;
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.snapshots TO ROLE dbt_developer_role;
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.snapshots TO ROLE dbt_prod_role;

GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.dev_analytics TO ROLE dbt_developer_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.analytics TO ROLE dbt_prod_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_developer_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.staging TO ROLE dbt_prod_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_developer_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.marts TO ROLE dbt_prod_role;

-- =====================================================
-- 5. CREATE SAMPLE DATA TABLES 
-- =====================================================


-- Create sample raw data tables
USE SCHEMA tasty_bytes_dbt_db.raw;

-- Sample order header data
CREATE OR REPLACE TABLE raw_pos_order_header (
    order_id NUMBER,
    truck_id NUMBER,
    order_ts TIMESTAMP_NTZ,
    customer_id NUMBER,
    order_total NUMBER(10,2),
    order_discount NUMBER(10,2),
    order_tax NUMBER(10,2),
    order_net_total NUMBER(10,2),
    _fivetran_synced TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Sample order detail data
CREATE OR REPLACE TABLE raw_pos_order_detail (
    order_id NUMBER,
    menu_item_id NUMBER,
    quantity NUMBER,
    price NUMBER(10,2),
    _fivetran_synced TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Sample menu data
CREATE OR REPLACE TABLE raw_pos_menu (
    menu_item_id NUMBER,
    menu_type VARCHAR(50),
    truck_brand_name VARCHAR(100),
    item_category VARCHAR(50),
    item_name VARCHAR(100),
    _fivetran_synced TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert sample data
INSERT INTO raw_pos_order_header VALUES
(1, 101, '2024-01-15 10:30:00', 1001, 25.50, 2.50, 1.84, 24.84, CURRENT_TIMESTAMP()),
(2, 102, '2024-01-15 11:15:00', 1002, 18.75, 0.00, 1.35, 20.10, CURRENT_TIMESTAMP()),
(3, 101, '2024-01-15 12:00:00', 1003, 32.25, 5.00, 1.96, 29.21, CURRENT_TIMESTAMP());

INSERT INTO raw_pos_order_detail VALUES
(1, 201, 2, 12.75, CURRENT_TIMESTAMP()),
(1, 202, 1, 12.75, CURRENT_TIMESTAMP()),
(2, 203, 3, 6.25, CURRENT_TIMESTAMP()),
(3, 201, 1, 12.75, CURRENT_TIMESTAMP()),
(3, 204, 2, 9.75, CURRENT_TIMESTAMP());

INSERT INTO raw_pos_menu VALUES
(201, 'Tacos', 'Guac n Roll', 'Main', 'Chicken Tacos', CURRENT_TIMESTAMP()),
(202, 'Tacos', 'Guac n Roll', 'Main', 'Beef Tacos', CURRENT_TIMESTAMP()),
(203, 'Ice Cream', 'Freezing Point', 'Dessert', 'Vanilla Cone', CURRENT_TIMESTAMP()),
(204, 'Ice Cream', 'Freezing Point', 'Dessert', 'Chocolate Sundae', CURRENT_TIMESTAMP());


-- =====================================================
-- 6. GRANT ROLES TO USERS
-- =====================================================
-- Replace 'YOUR_USERNAME' with your actual Snowflake username

GRANT ROLE dbt_developer_role TO USER YOUR_USERNAME;
GRANT ROLE analyst_role TO USER YOUR_USERNAME;
GRANT ROLE finance_role TO USER YOUR_USERNAME;

-- =====================================================
-- 7. VERIFICATION QUERIES
-- =====================================================

-- Verify databases and schemas
SHOW DATABASES LIKE 'tasty_bytes_dbt_db';
SHOW SCHEMAS IN DATABASE tasty_bytes_dbt_db;

-- Verify warehouses
SHOW WAREHOUSES LIKE 'dbt_%';

-- Verify roles
SHOW ROLES LIKE 'dbt_%';
SHOW ROLES LIKE 'analyst_role';
SHOW ROLES LIKE 'finance_role';
