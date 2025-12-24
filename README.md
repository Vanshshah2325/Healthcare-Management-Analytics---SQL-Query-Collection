
# Healthcare Management Analytics System 🏥

A robust SQL-based clinical analytics system for hospital management and patient data analysis, featuring **140+ production-ready queries** (from `ftn_141-280.sql`) across advanced SQL topics.

---

## 🎯 Project Overview

This project demonstrates advanced SQL techniques applied to a real-world healthcare environment. It covers the full lifecycle of patient care—from registration and doctor consultation to lab diagnostics and medication management—providing deep insights into clinical operations and patient outcomes.

## 📁 Database Schema

The system is built on 5 interconnected datasets:

- **Patients** (`patients.csv`) – Demographics, blood groups, and registration history.
- **Doctors** (`doctors.csv`) – Specialist profiles, experience levels, and hospital affiliations.
- **Visits** (`visits.csv`) – The core transactional table linking patients to doctors, diagnoses, and billing.
- **Lab Tests** (`lab_tests.csv`) – Diagnostic results with reference ranges and unit tracking.
- **Medications** (`medications.csv`) – Prescription records, dosage instructions, and treatment duration.

## 🚀 Features

### Query Categories (140+ Queries)

1. Foundational Analysis – Basic SELECTs, sorting, and row filtering.
2. Clinical Aggregations – Statistical summaries of age, billing, and patient volume.
3. Relational Joins – Complex multi-table connections between clinical results and patient profiles.
4. Advanced Filtering – Pattern matching for diagnoses and specialized WHERE conditions.
5. Window Functions – Ranking doctors by revenue, patient visit frequency, and moving averages.
6. CTEs (Common Table Expressions) – Modular query logic for high-risk patient identification.
7. Performance Optimization – Efficiently handling joins across thousands of clinical records.

## 💡 Key Use Cases

- Revenue Intelligence – Identify top-earning departments and average bill amounts per diagnosis.
- Patient Demographics – Analyze blood group distribution and age-based health trends.
- Provider Performance – Track doctor workload and patient-to-doctor ratios.
- Clinical Tracking – Monitor the most common diagnoses (e.g., COVID-19, Fracture, Diabetes).
- Pharmacy Insights – Analyze medication patterns and dosage frequency.

## 🛠️ Technologies Used

- Database: PostgreSQL / MySQL
- Language: SQL (Standard & Advanced)
- Concepts: Relational Schema Design, Window Functions, Data Analysis

## 📊 Sample Insights

- Top Specializations: Identify which fields generate the highest bill amounts.
- Age-Based Care: Calculate the average bill amount for each patient grouped by their age.
- Lab Analytics: Identify visits where lab results exceeded normal reference ranges.

## 🔧 Setup Instructions

### 1. Create Database
```sql
CREATE DATABASE healthcare_analytics;
USE healthcare_analytics;
```

### 2. Run Schema & Data Import
Import the provided CSV files using your SQL GUI (e.g., MySQL Workbench, DBeaver) or the LOAD DATA command.

### 3. Execute Analytics Script
```bash
mysql -u username -p healthcare_analytics < ftn_141-280.sql
```

## 📂 Project Structure

```text
healthcare-analytics-system/
├── README.md
├── ftn_141-280.sql
├── data/
│   ├── patients.csv
│   ├── doctors.csv
│   ├── visits.csv
│   ├── lab_tests.csv
│   └── medications.csv
```

## 🎓 Learning Outcomes

- Constructing complex multi-table JOINs.
- Implementing business logic using SQL CASE statements and CTEs.
- Performing time-series analysis on patient visit dates.
- Advanced data aggregation for executive-level reporting.

## 👤 Author

**Vansh Shah**

- LinkedIn: https://www.linkedin.com/in/vansh-shah-632757244/
- GitHub: https://github.com/Vanshshah2325
- Email: vanshshah2325@gmail.com

---

⭐ If you find this healthcare analytics system useful, please give it a star!
