-- =====================================================
-- Sample Data Setup for dbt Hands-On Lab
-- =====================================================
-- This creates sample data in the raw tables
-- =====================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE tasty_bytes_dbt_db;
USE SCHEMA raw;

-- Create sample order header data
CREATE OR REPLACE TABLE raw_pos_order_header (
    order_id NUMBER,
    truck_id NUMBER,
    order_ts TIMESTAMP_NTZ,
    customer_id NUMBER,
    order_amount NUMBER(10,2),
    order_discount NUMBER(10,2),
    order_tax NUMBER(10,2),
    order_net_total NUMBER(10,2),
    _fivetran_synced TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Create sample order detail data
CREATE OR REPLACE TABLE raw_pos_order_detail (
    order_id NUMBER,
    menu_item_id NUMBER,
    quantity NUMBER,
    price NUMBER(10,2),
    line_total NUMBER(10,2),
    _fivetran_synced TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Create sample menu data
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
(3, 101, '2024-01-15 12:00:00', 1003, 32.25, 5.00, 1.96, 29.21, CURRENT_TIMESTAMP()),
(4, 103, '2024-01-15 13:30:00', 1004, 45.00, 5.00, 2.88, 42.88, CURRENT_TIMESTAMP()),
(5, 102, '2024-01-15 14:15:00', 1005, 22.50, 0.00, 1.62, 24.12, CURRENT_TIMESTAMP());

INSERT INTO raw_pos_order_detail VALUES
(1, 201, 2, 12.75, 25.50, CURRENT_TIMESTAMP()),
(2, 202, 3, 6.25, 18.75, CURRENT_TIMESTAMP()),
(3, 201, 1, 12.75, 12.75, CURRENT_TIMESTAMP()),
(3, 203, 2, 9.75, 19.50, CURRENT_TIMESTAMP()),
(4, 204, 4, 11.25, 45.00, CURRENT_TIMESTAMP()),
(5, 202, 2, 6.25, 12.50, CURRENT_TIMESTAMP()),
(5, 205, 1, 10.00, 10.00, CURRENT_TIMESTAMP());

INSERT INTO raw_pos_menu VALUES
(201, 'Tacos', 'Guac n Roll', 'Main', 'Chicken Tacos', CURRENT_TIMESTAMP()),
(202, 'Ice Cream', 'Freezing Point', 'Dessert', 'Vanilla Cone', CURRENT_TIMESTAMP()),
(203, 'Tacos', 'Guac n Roll', 'Main', 'Beef Tacos', CURRENT_TIMESTAMP()),
(204, 'Ice Cream', 'Freezing Point', 'Dessert', 'Chocolate Sundae', CURRENT_TIMESTAMP()),
(205, 'Burgers', 'The Mac Shack', 'Main', 'Cheeseburger', CURRENT_TIMESTAMP());

-- Verify data was inserted
SELECT 'Sample data setup complete!' as status;
SELECT COUNT(*) as order_count FROM raw_pos_order_header;
SELECT COUNT(*) as detail_count FROM raw_pos_order_detail;
SELECT COUNT(*) as menu_count FROM raw_pos_menu;
