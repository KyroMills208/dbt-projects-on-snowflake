-- =====================================================
-- Quick Setup for dbt Hands-On Lab
-- =====================================================
-- Run this if you just want to get started quickly
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- Create database and schemas
CREATE DATABASE IF NOT EXISTS tasty_bytes_dbt_db;
USE DATABASE tasty_bytes_dbt_db;

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS dev_analytics;
CREATE SCHEMA IF NOT EXISTS analytics;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS marts;
CREATE SCHEMA IF NOT EXISTS snapshots;

-- Create warehouses
CREATE WAREHOUSE IF NOT EXISTS dbt_dev_wh
WITH WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;

CREATE WAREHOUSE IF NOT EXISTS dbt_prod_wh
WITH WAREHOUSE_SIZE = 'SMALL' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE;

-- Create roles
CREATE ROLE IF NOT EXISTS dbt_developer_role;
CREATE ROLE IF NOT EXISTS dbt_prod_role;
CREATE ROLE IF NOT EXISTS analyst_role;
CREATE ROLE IF NOT EXISTS finance_role;

-- Grant basic privileges
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE dbt_developer_role;
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE dbt_prod_role;
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE analyst_role;
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE finance_role;

GRANT USAGE ON WAREHOUSE dbt_dev_wh TO ROLE dbt_developer_role;
GRANT USAGE ON WAREHOUSE dbt_prod_wh TO ROLE dbt_prod_role;

-- Grant schema usage
GRANT USAGE ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_developer_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_prod_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE analyst_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE finance_role;

-- Grant create privileges
GRANT CREATE TABLE ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_developer_role;
GRANT CREATE TABLE ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_prod_role;
GRANT CREATE VIEW ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_developer_role;
GRANT CREATE VIEW ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_prod_role;

-- Grant future privileges
GRANT SELECT ON FUTURE TABLES IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE TABLES IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE TABLES IN DATABASE tasty_bytes_dbt_db TO ROLE analyst_role;
GRANT SELECT ON FUTURE TABLES IN DATABASE tasty_bytes_dbt_db TO ROLE finance_role;

GRANT SELECT ON FUTURE VIEWS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_developer_role;
GRANT SELECT ON FUTURE VIEWS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_prod_role;
GRANT SELECT ON FUTURE VIEWS IN DATABASE tasty_bytes_dbt_db TO ROLE analyst_role;
GRANT SELECT ON FUTURE VIEWS IN DATABASE tasty_bytes_dbt_db TO ROLE finance_role;

-- Grant roles to current user (replace with your username)
-- GRANT ROLE dbt_developer_role TO USER YOUR_USERNAME;
-- GRANT ROLE analyst_role TO USER YOUR_USERNAME;

SELECT 'Quick setup complete! Remember to grant roles to your user and update profiles.yml' as status;
