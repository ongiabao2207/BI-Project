## Project Description

This project focuses on building a **Data Warehouse (DW) system** for the **aviation domain**, using data provided from source files such as **Airports**, **Airlines**, and **Flights**.  
The goal is to design and implement a complete data warehousing pipeline that supports analysis, reporting, and knowledge discovery.

---

## Project Scope and Implementation Steps

### 1. Data Warehouse Analysis & Schema Design
- Analyze business requirements and analytical needs in the aviation domain.
- Identify **fact tables** and **dimension tables** based on flight operations.
- Design the Data Warehouse schema (**Star Schema**) to support efficient analytical queries.

### 2. ETL (Extract, Transform, Load) Process
- Use **SQL Server Integration Services (SSIS)** to:
  - Extract data from source files (Airports, Airlines, Flights).
  - Clean, transform, and standardize data (data types, missing values, consistency).
  - Load and update data into the Data Warehouse.
- Implement incremental loading where applicable.

### 3. Data Querying & OLAP Analysis
- Build an OLAP cube using **SQL Server Analysis Services (SSAS)**.
- Define measures, dimensions, and hierarchies for analysis.
- Enable OLAP operations such as **slice, dice, roll-up, and drill-down** to support multidimensional analysis.

### 4. Dashboard and Data Visualization
- Use **Power BI** to connect to the Data Warehouse or SSAS cube.
- Design interactive dashboards and reports.
- Visualize key metrics and trends related to flights, airlines, and airports for better decision-making.

### 5. Data Mining and Knowledge Discovery
- Apply **Data Mining and Machine Learning techniques** to aviation data.
- Build predictive models to:
  - Predict whether a flight will be delayed
  - Estimate the number of delay minutes
- Evaluate model performance and interpret results to support operational insights and decision-making.