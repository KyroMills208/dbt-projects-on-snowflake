# dbt Projects on Snowflake - Hands-On Lab

## Overview

This repository contains an extended demo of dbt Projects on Snowflake, showcasing data quality testing, performance optimization, documentation, CI/CD workflows, and advanced Snowflake integration features.

## Repository Structure

```
dbt_snowflake_hol/
├── .github/
│   └── workflows/
│       └── dbt_ci.yml
├── macros/
│   └── apply_row_access_policy.sql (optional)
├── models/
│   ├── staging/
│   │   ├── _sources.yml
│   │   ├── schema.yml
│   │   ├── stg_order_details.sql
│   │   └── stg_order_header.sql
│   ├── marts/
│   │   ├── sales_data_by_truck.sql (existing)
│   │   ├── sales_incremental.sql
│   │   ├── sales_dynamic.sql
│   │   ├── sales_secure.sql
│   │   └── schema.yml
├── dbt_project.yml
├── profiles.yml
├── packages.yml
└── README.md
```

## Demo Sections

### Section 1: Data Quality & Testing (15 minutes)

**Key Topics:**
- Review existing model structure
- Create staging models for better organization
- Implement generic tests (not_null, unique, relationships)
- Add custom tests using dbt_utils (row counts, value ranges)
- Demonstrate Jinja templating
- Show compiled SQL output with `dbt compile`
- View and discuss the DAG

**Commands to run:**
```bash
# Install dependencies
dbt deps

# Compile models to see generated SQL
dbt compile

# Run tests
dbt test

# Build all models
dbt build
```

**Talking Points:**
- Explain the staging layer pattern
- Show how tests catch data quality issues
- Demonstrate Jinja templating in action
- Walk through the DAG visualization

### Section 2: Performance & Optimization (15 minutes)

**Key Topics:**
- Dynamic tables for continuous updates
- Incremental models with merge strategies
- Query tags for cost tracking
- Clustering and performance optimization

**Commands to run:**
```bash
# Run incremental model
dbt run --select sales_incremental

# Run dynamic table
dbt run --select sales_dynamic

# Check query tags in Snowflake
```

**Talking Points:**
- Explain incremental strategy benefits
- Show merge_update_columns configuration
- Demonstrate dynamic table refresh behavior
- Discuss query tag benefits for cost tracking

### Section 3: Documentation & Macros (10 minutes)

**Key Topics:**
- Generate dbt docs
- DAG visualization
- Optional: Custom macros for data masking

**Commands to run:**
```bash
# Generate documentation
dbt docs generate

# Serve docs locally
dbt docs serve
```

**Talking Points:**
- Show documentation features
- Navigate the DAG
- Explain macro reusability

### Section 4: CI/CD & Environment Management (10 minutes)

**Key Topics:**
- GitHub Actions workflow
- Multi-environment setup (dev/prod)
- Automated testing

**Talking Points:**
- Show GitHub Actions workflow
- Explain environment separation
- Discuss automated testing benefits

### Section 5: Advanced Snowflake Integration (10 minutes)

**Key Topics:**
- Secure views for data sharing
- Row access policies
- Query tags and monitoring

**Commands to run:**
```bash
# Run secure view
dbt run --select sales_secure

# Check in Snowflake UI
```

**Talking Points:**
- Show secure view capabilities
- Explain row access policies
- Demonstrate Snowflake-specific features

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd dbt_snowflake_hol
   ```

2. **Configure your profiles.yml:**
   - Update account, user, database, and warehouse information
   - Ensure you have appropriate roles and permissions

3. **Install dependencies:**
   ```bash
   dbt deps
   ```

4. **Run the demo:**
   ```bash
   dbt build
   ```

## Key Features Demonstrated

### Data Quality & Testing
- Generic tests (not_null, unique, relationships, accepted_values)
- Custom tests using dbt_utils (row counts, value ranges, expressions)
- Source freshness checks
- Data contracts and constraints

### Performance Optimization
- Incremental models with merge strategies
- Dynamic tables for real-time updates
- Query tags for cost attribution
- Clustering for performance

### Documentation
- Comprehensive model documentation
- DAG visualization
- Column-level descriptions
- Business logic explanations

### CI/CD Integration
- GitHub Actions workflow
- Multi-environment configuration
- Automated testing
- Deployment strategies

### Advanced Snowflake Features
- Secure views for data sharing
- Row access policies for governance
- Query tags for monitoring
- Native Snowflake integration

## Hands-On Exercises

### Exercise 1: Add a Test
Add a new test to the `sales_data_by_truck` model to ensure revenue is always positive.

### Exercise 2: Create an Incremental Model
Convert the existing `sales_data_by_truck` model to use incremental materialization.

### Exercise 3: Add Documentation
Add comprehensive documentation to a model including column descriptions and business logic.

## Troubleshooting

### Common Issues
1. **Profile configuration errors:** Ensure your profiles.yml is correctly configured
2. **Permission errors:** Verify you have appropriate roles and warehouse access
3. **Test failures:** Check data quality and adjust tests as needed

### Getting Help
- dbt documentation: https://docs.getdbt.com/
- Snowflake documentation: https://docs.snowflake.com/
- dbt Community: https://getdbt.com/community/

## Next Steps

After completing this demo, consider:
1. Implementing in your own environment
2. Adding more complex business logic
3. Setting up production deployment pipelines
4. Exploring additional dbt packages
5. Integrating with BI tools

## Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [dbt Community](https://getdbt.com/community/)
- [dbt Slack](https://www.getdbt.com/community/)
