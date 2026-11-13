# 👥 HR Workforce & Employee Attrition Intelligence Dashboard

[![Power BI](https://img.shields.io/badge/Power_BI_Desktop-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![DAX](https://img.shields.io/badge/DAX-Calculations-blue?style=for-the-badge)](./dax/all_measures.dax)
[![Power Query](https://img.shields.io/badge/Power_Query-M_Code-teal?style=for-the-badge)](./powerquery/etl_transformations.m)
[![Author](https://img.shields.io/badge/Author-Vani_Thummalagunti-purple?style=for-the-badge)](https://github.com/vani-thummalagunti)

An end-to-end Human Resources business intelligence solution developed in **Microsoft Power BI Desktop** to diagnose voluntary turnover, evaluate workforce retention factors, and identify flight risk drivers across 1,470 employee records.

---

## 📌 Executive Summary
* **Total Headcount:** 1,470 Employees
* **Attrition Count:** 464 Departures
* **Attrition Rate:** **31.6%**
* **Active Headcount:** 1,006 Retained Staff
* **Average Monthly Income:** $6,502

---

## 🎯 Key Business Findings
1. **The OverTime Burnout Factor:** Employees working regular overtime experience an alarming **45.2% turnover rate**, compared to **25.4%** for regular hours staff (1.8x flight risk).
2. **Departmental Concentration:** **Research & Development (315 exits)** and **Sales (127 exits)** represent over **95%** of all corporate turnover.
3. **High-Risk Roles:** Entry-level **Sales Representatives (44.8%)** and **Laboratory Technicians (38.2%)** exhibit the highest turnover velocity, requiring targeted retention programs.

---

## 🏗️ Data Architecture & Star Schema
The model uses a clean Star Schema design with one Fact table and two Dimension tables to optimize VertiPaq engine performance:

```
+------------------------------+             +-------------------------------+
|         Dim_Employee         |             |          Dim_JobRole          |
+------------------------------+             +-------------------------------+
| EmployeeID (PK)              |             | JobRole (PK)                  |
| Age                          |             | Department                    |
| Gender                       |             +---------------+---------------+
| MaritalStatus                |                             | (1)
| EducationField               |                             |
+--------------+---------------+                             |
               | (1)                                         |
               |                                             |
               | (*)                                         | (*)
+--------------+---------------------------------------------+---------------+
|                                Fact_Attrition                              |
+----------------------------------------------------------------------------+
| EmployeeID (FK)                                                            |
| JobRole (FK)                                                               |
| MonthlyIncome                                                              |
| OverTime                                                                   |
| JobLevel                                                                   |
| YearsAtCompany                                                             |
| YearsInCurrentRole                                                         |
| YearsSinceLastPromotion                                                    |
| JobSatisfaction                                                            |
| WorkLifeBalance                                                            |
| Attrition (Yes / No)                                                       |
+----------------------------------------------------------------------------+
```

---

## 📐 Core DAX Measures

All measures are centralized within the `_Measures` table:

```dax
// Total Headcount
Total Employees = COUNTROWS(Fact_Attrition)

// Total Attrition Count
Attrition Count = 
CALCULATE(
    COUNTROWS(Fact_Attrition),
    Fact_Attrition[Attrition] = "Yes"
)

// Active Headcount
Active Employees = 
CALCULATE(
    COUNTROWS(Fact_Attrition),
    Fact_Attrition[Attrition] = "No"
)

// Overall Attrition Rate %
Attrition Rate % = 
DIVIDE([Attrition Count], [Total Employees], 0)

// OverTime Attrition Flight Risk %
OverTime Attrition Rate % = 
VAR OT_Attrition = CALCULATE([Attrition Count], Fact_Attrition[OverTime] = "Yes")
VAR OT_Total = CALCULATE([Total Employees], Fact_Attrition[OverTime] = "Yes")
RETURN
    DIVIDE(OT_Attrition, OT_Total, 0)
```

---

## 🛠️ Data Cleaning & Transformations (Power Query M)
* **Standardized Categoricals:** Cleaned casing discrepancies on `Attrition` using `Text.Proper`.
* **Imputed Missing Income:** Imputed missing values in `MonthlyIncome` using category average values.
* **Type Normalization:** Configured numeric and date formats for high-efficiency in-memory compression.

*(See full M-script in [`powerquery/etl_transformations.m`](./powerquery/etl_transformations.m))*

---

## 📁 Repository Structure
```text
├── README.md                      # Project documentation and schema
├── data/
│   ├── hr_attrition_raw.csv       # Source dataset
│   ├── hr_attrition_cleaned.csv   # Normalized dataset
│   ├── fact_attrition.csv         # Star Schema Fact table
│   ├── dim_employee.csv           # Star Schema Dimension table
│   └── dim_jobrole.csv            # Star Schema Dimension table
├── dax/
│   └── all_measures.dax           # Documented DAX measures
├── powerquery/
│   └── etl_transformations.m      # Power Query M code
└── dashboard/
    └── index.html                 # Interactive report layout preview
```

---

## 🚀 How to Run in Microsoft Power BI Desktop
1. Open **Power BI Desktop**.
2. Click **Get Data** > **Text/CSV** and import:
   * `data/dim_employee.csv`
   * `data/dim_jobrole.csv`
   * `data/fact_attrition.csv`
3. In **Model View**, verify the 1-to-many single-direction relationships from Dimensions to Fact.
4. Create a `_Measures` table and copy the formulas from `dax/all_measures.dax`.
5. Build the report visuals:
   * **Cards:** Total Headcount, Attrition Count, Attrition Rate %, Avg Monthly Income.
   * **Clustered Bar Chart:** OverTime vs Attrition Rate %.
   * **Stacked Column Chart:** Attrition by Department.
   * **Horizontal Bar Chart:** Attrition Rate % by Job Role.
   * **Slicers:** Department, OverTime.

---

### Developed by **Vani Thummalagunti**
Connect on [LinkedIn](https://www.linkedin.com) | [GitHub Profile](https://github.com/vani-thummalagunti)
