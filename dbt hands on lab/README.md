# dbt Projects on Snowflake - Advanced Hands-On Lab

## Overview

This comprehensive demo showcases advanced dbt capabilities on Snowflake, including sophisticated data modeling, testing, performance optimization, and production-ready patterns. Built specifically for technical audiences ranging from dbt beginners to experienced practitioners.

## 🚀 Key Features Demonstrated

### Data Quality & Testing
- **Comprehensive source testing** with freshness checks and data contracts
- **Generic tests** (not_null, unique, relationships, accepted_values)
- **Custom tests** using dbt_utils (row counts, value ranges, expressions)
- **Business logic tests** for revenue consistency and customer lifecycle validation
- **Data quality monitoring** with automated alerts

### Advanced Data Modeling
- **Staging layer** with business logic and data cleaning
- **Intermediate models** using ephemeral materialization
- **Marts layer** with customer analytics and truck performance models
- **Jinja templating** for dynamic SQL generation
- **Surrogate keys** and business keys for data integrity

### Performance Optimization
- **Incremental models** with merge strategies and merge_update_columns
- **Dynamic tables** for real-time data processing
- **Clustering** for query performance optimization
- **Query tags** for cost tracking and monitoring
- **Materialization strategies** optimized for different use cases

### Documentation & Lineage
- **Comprehensive model documentation** with business context
- **Column-level descriptions** and data types
- **DAG visualization** showing data flow
- **Business logic explanations** for complex calculations

### CI/CD & Environment Management
- **GitHub Actions workflows** for automated testing
- **Multi-environment setup** (dev, prod) with proper separation
- **Automated deployment** with quality gates
- **Environment-specific configurations**

### Advanced Snowflake Integration
- **Secure views** for data sharing and governance
- **Row access policies** for fine-grained access control
- **Query monitoring** and cost optimization
- **Native Snowflake features** integration

## 📁 Repository Structure

```
dbt_snowflake_hol/
├── .github/
│   └── workflows/
│       └── dbt_ci.yml
├── analyses/
│   ├── customer_retention_analysis.sql
│   └── truck_performance_analysis.sql
├── macros/
│   └── apply_row_access_policy.sql
├── models/
│   ├── staging/
│   │   ├── __sources.yml
│   │   ├── schema.yml
│   │   ├── stg_customers.sql
│   │   ├── stg_menu.sql
│   │   ├── stg_order_details.sql
│   │   ├── stg_order_header.sql
│   │   └── stg_trucks.sql
│   ├── intermediate/
│   │   └── int_order_items.sql
│   ├── marts/
│   │   ├── customer_analytics.sql
│   │   ├── sales_data_by_truck.sql
│   │   ├── sales_dynamic.sql
│   │   ├── sales_incremental.sql
│   │   ├── sales_secure.sql
│   │   ├── schema.yml
│   │   └── truck_performance.sql
│   └── overview.md
├── tests/
│   ├── assert_customer_lifecycle.sql
│   ├── assert_revenue_consistency.sql
│   └── assert_truck_performance_tiers.sql
├── dbt_project.yml
├── packages.yml
├── profiles.yml
├── setup.sql
├── quick_setup.sql
└── README.md
```

## 🛠️ Setup Instructions

### Prerequisites
- Snowflake account with ACCOUNTADMIN privileges
- dbt CLI installed (`pip install dbt-snowflake`)
- Git (for version control)

### 1. Snowflake Setup

**Quick Setup (Recommended for demos):**
```sql
-- Run this in Snowflake SQL editor
-- File: quick_setup.sql
```

**Complete Setup (For production-like environments):**
```sql
-- Run this in Snowflake SQL editor
-- File: setup.sql
```

### 2. Configure dbt Profile

Update `profiles.yml` with your Snowflake connection details:

```yaml
tasty_bytes_dbt_demo:
  outputs:
    dev:
      type: snowflake
      account: "your-account.snowflakecomputing.com"
      user: "your-username"
      password: "your-password"
      database: tasty_bytes_dbt_db
      schema: dev_analytics
      warehouse: dbt_dev_wh
      role: dbt_developer_role
      
    prod:
      type: snowflake
      account: "your-account.snowflakecomputing.com"
      user: "your-username"
      password: "your-password"
      database: tasty_bytes_dbt_db
      schema: analytics
      warehouse: dbt_prod_wh
      role: dbt_prod_role
      threads: 8
      query_tag: dbt_production
      
  target: dev
```

### 3. Grant Roles to Your User

In Snowflake, run:
```sql
GRANT ROLE dbt_developer_role TO USER YOUR_USERNAME;
GRANT ROLE analyst_role TO USER YOUR_USERNAME;
```

### 4. Install Dependencies and Run

```bash
# Install dependencies
dbt deps

# Test connection
dbt debug

# Run the project
dbt build

# Run specific models
dbt run --select staging
dbt run --select marts
dbt run --select intermediate

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

## 🎯 Demo Sections

### Section 1: Data Quality & Testing (15 minutes)
- Review staging models and business logic
- Demonstrate comprehensive testing framework
- Show custom tests and data quality validation
- Run `dbt test` and explain results

### Section 2: Performance & Optimization (15 minutes)
- Showcase incremental models with merge strategies
- Demonstrate dynamic tables for real-time processing
- Explain clustering and query optimization
- Show query tags and cost monitoring

### Section 3: Advanced Data Modeling (10 minutes)
- Walk through intermediate models and ephemeral materialization
- Show customer analytics and truck performance models
- Demonstrate Jinja templating and dynamic SQL
- Explain business logic and calculations

### Section 4: Documentation & Analysis (10 minutes)
- Generate and explore dbt docs
- Show DAG visualization and lineage
- Demonstrate analysis files for ad-hoc queries
- Explain documentation best practices

### Section 5: CI/CD & Production (10 minutes)
- Show GitHub Actions workflow
- Demonstrate multi-environment setup
- Explain deployment strategies
- Show monitoring and alerting

## 🔍 Key Models Explained

### Staging Models
- **stg_customers**: Customer data with value tier classification
- **stg_trucks**: Truck metadata with geographic regions
- **stg_menu**: Menu items with business categorization
- **stg_order_header**: Order data with business logic
- **stg_order_details**: Line items with validation

### Intermediate Models
- **int_order_items**: Comprehensive order context with all dimensions

### Marts Models
- **customer_analytics**: Customer segmentation and lifecycle analysis
- **truck_performance**: Operational metrics and performance tiers
- **sales_incremental**: Incremental sales with merge strategies
- **sales_dynamic**: Real-time metrics using dynamic tables
- **sales_secure**: Secure view with data masking

## 🧪 Testing Strategy

### Generic Tests
- Data type validation
- Null value checks
- Unique constraints
- Referential integrity
- Value range validation

### Custom Tests
- Revenue consistency validation
- Customer lifecycle logic
- Performance tier assignments
- Business rule enforcement

### Data Quality Monitoring
- Source freshness checks
- Data contract validation
- Automated alerting
- Quality score tracking

## 📊 Analysis Files

### Customer Retention Analysis
- Cohort analysis by customer segment
- Retention rate calculations
- Customer lifetime value metrics
- Churn prediction indicators

### Truck Performance Analysis
- Regional performance rankings
- Efficiency metrics comparison
- Brand performance analysis
- Operational insights

## 🚀 Advanced Features

### Snowflake-Specific Optimizations
- Dynamic tables for real-time processing
- Clustering for query performance
- Query tags for cost tracking
- Secure views for data sharing

### Production-Ready Patterns
- Incremental processing
- Error handling and logging
- Environment management
- Automated testing

### Data Governance
- Row access policies
- Data masking
- Audit trails
- Compliance reporting

## 🔧 Troubleshooting

### Common Issues
1. **Role permissions**: Ensure proper roles are granted
2. **Warehouse access**: Check warehouse permissions
3. **Schema access**: Verify schema-level permissions
4. **Test failures**: Review data quality and adjust tests

### Getting Help
- Check dbt logs: `dbt run --log-level debug`
- Verify Snowflake connection: `dbt debug`
- Review test results: `dbt test --store-failures`
- Check documentation: `dbt docs serve`

## 📈 Next Steps

After completing this demo, consider:
1. Implementing in your own environment
2. Adding more complex business logic
3. Setting up production deployment pipelines
4. Exploring additional dbt packages
5. Integrating with BI tools
6. Building data quality dashboards

## 📚 Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [dbt Community](https://getdbt.com/community/)
- [dbt Slack](https://www.getdbt.com/community/)
- [Snowflake Labs](https://github.com/Snowflake-Labs)

## 🤝 Contributing

This demo is designed to be extended and customized. Feel free to:
- Add new models and tests
- Enhance business logic
- Improve documentation
- Add new analysis files
- Share your improvements

---

**Happy modeling! 🎉**
