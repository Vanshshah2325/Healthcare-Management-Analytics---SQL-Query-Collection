create schema healthcare_analytics;
use healthcare_analytics;

-- 1. Show the first 10 rows from the patients table.
SELECT * FROM patients LIMIT 10;

-- 2. Retrieve the full names of the first 20 patients, ordered by last name.
SELECT 
    patient_id, 
    CONCAT(first_name, ' ', last_name) AS full_name
FROM patients
ORDER BY last_name
LIMIT 20;

-- 3. Get the total count of all patients.
SELECT COUNT(*) AS total_patients FROM patients;

-- 4. Count the number of patients for each gender.
SELECT gender, COUNT(*) AS cnt FROM patients GROUP BY gender;

-- 5. Calculate the average age of all patients.
SELECT AVG(age) AS avg_age FROM patients;

-- 6. Count patients per blood group, but only show groups with more than 5 patients.
SELECT blood_group, COUNT(*) FROM patients GROUP BY blood_group HAVING COUNT(*) > 5;

-- 7. Find the 10 most experienced cardiologists, ordered by experience.
SELECT * FROM doctors WHERE specialization = 'Cardiology' ORDER BY experience_years DESC LIMIT 10;

-- 8. List the visit details along with the patient's and doctor's names.
SELECT v.visit_id, v.visit_date, p.first_name, p.last_name, d.doctor_name FROM visits v JOIN patients p ON v.patient_id = p.patient_id JOIN doctors d ON v.doctor_id = d.doctor_id LIMIT 25;

-- 9. Rank patients by the number of visits, including those with no visits.
SELECT p.patient_id, COUNT(v.visit_id) AS visits_count FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id ORDER BY visits_count DESC LIMIT 20;

-- 10. Find the top 10 doctors by total billed amount.
SELECT d.doctor_id, d.doctor_name, SUM(v.bill_amount) AS total_billed FROM doctors d JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.doctor_id, d.doctor_name ORDER BY total_billed DESC LIMIT 10;

-- 11. Calculate the average bill amount and case count for each diagnosis.
SELECT diagnosis, AVG(bill_amount) AS avg_bill, COUNT(*) AS cases FROM visits GROUP BY diagnosis ORDER BY cases DESC;

-- 12. Find patients with a bill amount higher than the overall average bill amount.
SELECT patient_id FROM visits WHERE bill_amount > (SELECT AVG(bill_amount) FROM visits);

-- 13. Use a CTE to count visits in the last year.
SELECT COUNT(*) 
FROM (
    SELECT * 
    FROM visits 
    WHERE visit_date > (CURRENT_DATE - INTERVAL 1 YEAR)
) AS recent_visits;

-- 14. List the medications prescribed for 'Diabetes' visits.
SELECT v.visit_id, m.drug_name FROM visits v JOIN medications m ON v.visit_id = m.visit_id WHERE v.diagnosis = 'Diabetes';

-- 15. Count the frequency of each lab test.
SELECT test_name, COUNT(*) AS test_count FROM lab_tests GROUP BY test_name ORDER BY test_count DESC;

-- 16. Find the date of the last visit for each patient.
SELECT 
    p.patient_id, 
    p.first_name, 
    p.last_name, 
    MAX(v.visit_date) AS last_visit
FROM patients p
LEFT JOIN visits v 
    ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY last_visit IS NULL, last_visit DESC;



-- 17. Find cities with more than 5 unique patients.
SELECT p.city, COUNT(DISTINCT p.patient_id) AS patients FROM patients p GROUP BY p.city HAVING COUNT(*) > 5;

-- 18. Count recent visits (last 6 months) for each doctor using FILTER.
-- Note: This is a PostgreSQL-specific syntax.
SELECT 
    doctor_id, 
    SUM(CASE WHEN visit_date > (CURRENT_DATE - INTERVAL 6 MONTH) THEN 1 ELSE 0 END) AS recent_visits
FROM visits
GROUP BY doctor_id;


-- 19. Find doctors with 5 to 15 years of experience.
SELECT doctor_name, specialization FROM doctors WHERE experience_years BETWEEN 5 AND 15;

-- 20. Find visits with missing bill amounts, showing patient and doctor names.
SELECT v.*, d.doctor_name, p.first_name FROM visits v LEFT JOIN doctors d ON v.doctor_id = d.doctor_id LEFT JOIN patients p ON v.patient_id = p.patient_id WHERE v.bill_amount IS NULL;

-- 21. Find the top 20 patients by total amount spent on visits.
SELECT patient_id, SUM(bill_amount) AS total_spent FROM visits GROUP BY patient_id ORDER BY total_spent DESC LIMIT 20;

-- 22. Find patients who have a 'COVID-19' diagnosis using EXISTS.
SELECT p.patient_id FROM patients p WHERE EXISTS (SELECT 1 FROM visits v WHERE v.patient_id = p.patient_id AND v.diagnosis = 'COVID-19');

-- 23. List medications with a duration of 14 days or more.
SELECT * FROM medications WHERE duration_days >= 14 ORDER BY duration_days DESC LIMIT 30;

-- 24. Find visits where more than one medication was prescribed.
SELECT visit_id, COUNT(*) AS meds_count FROM medications GROUP BY visit_id HAVING COUNT(*) > 1 ORDER BY meds_count DESC;

-- 25. Calculate the average result value for 'Cholesterol Test' on each test date.
SELECT test_date, AVG(result_value) AS avg_result FROM lab_tests WHERE test_name = 'Cholesterol Test' GROUP BY test_date ORDER BY test_date;

-- 26. Calculate the total spending for each patient, handling patients with no visits.
SELECT p.patient_id, p.first_name, p.last_name, COALESCE(SUM(v.bill_amount),0) AS total FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.first_name, p.last_name ORDER BY total DESC;

-- 27. Get a unique list of all doctor specializations.
SELECT DISTINCT specialization FROM doctors ORDER BY specialization;

-- 28. Find all visits that occurred in the year 2024.
SELECT v.* FROM visits v WHERE v.visit_date BETWEEN '2024-01-01' AND '2024-12-31' ORDER BY v.visit_date;

-- 29. Find patients who have had 3 or more visits.
SELECT p.patient_id, COUNT(v.visit_id) AS visits_count FROM patients p JOIN visits v USING (patient_id) GROUP BY p.patient_id HAVING COUNT(*) >= 3;

-- 30. Find the top 10 most frequently prescribed drugs.
SELECT drug_name, COUNT(*) AS times_prescribed FROM medications GROUP BY drug_name ORDER BY times_prescribed DESC LIMIT 10;

-- 31. Categorize patients into 'child', 'adult', and 'senior' age groups.
SELECT p.patient_id, p.age, CASE WHEN p.age < 18 THEN 'child' WHEN p.age BETWEEN 18 AND 65 THEN 'adult' ELSE 'senior' END AS age_group FROM patients p;

-- 32. Find the top 15 doctors by number of visits, showing their hospital name.
SELECT v.doctor_id, d.hospital_name, COUNT(*) AS num_visits FROM visits v JOIN doctors d ON v.doctor_id = d.doctor_id GROUP BY v.doctor_id, d.hospital_name ORDER BY num_visits DESC LIMIT 15;

-- 33. Find patients who registered after their first visit date.
SELECT p.patient_id FROM patients p WHERE p.registration_date > (SELECT MIN(visit_date) FROM visits WHERE visits.patient_id = p.patient_id);

-- 34. List visits for 'Fracture' diagnosis, ordered by visit date.
SELECT p.patient_id, p.first_name, p.last_name, v.visit_date FROM patients p JOIN visits v ON p.patient_id = v.patient_id WHERE v.diagnosis = 'Fracture' ORDER BY v.visit_date DESC;

-- 35. Create a view to show total spending for each patient.
CREATE VIEW patient_spending AS SELECT patient_id, SUM(bill_amount) AS total_spent FROM visits GROUP BY patient_id;

-- 36. Query the newly created view to find patients who spent over 10000.
SELECT * FROM patient_spending WHERE total_spent > 10000;

-- 37. Find the top 10 doctors who have seen the most unique patients.
SELECT doctor_id, COUNT(DISTINCT patient_id) AS unique_patients FROM visits GROUP BY doctor_id ORDER BY unique_patients DESC LIMIT 10;

-- 38. Use ARRAY_AGG to list all diagnoses for each patient.
-- Note: This is a PostgreSQL-specific function.
SELECT 
    p.patient_id, 
    GROUP_CONCAT(DISTINCT v.diagnosis ORDER BY v.diagnosis SEPARATOR ', ') AS diagnoses
FROM patients p
LEFT JOIN visits v 
    ON p.patient_id = v.patient_id
GROUP BY p.patient_id;

-- 39. Find lab tests with a result value greater than 200.
SELECT visit_id, test_name, result_value FROM lab_tests WHERE result_value > 200;

-- 40. Find doctors whose average visit bill amount is greater than 2000.
SELECT d.doctor_name, AVG(v.bill_amount) AS avg_bill FROM doctors d LEFT JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.doctor_name HAVING AVG(v.bill_amount) > 2000;

-- 41. Count visits between patients and doctors from different cities.
SELECT p.city, d.city AS doctor_city, COUNT(*) AS visits_count FROM visits v JOIN patients p ON v.patient_id = p.patient_id JOIN doctors d ON v.doctor_id = d.doctor_id GROUP BY p.city, d.city ORDER BY visits_count DESC LIMIT 20;

-- 42. Use a window function to count visits for each patient.
SELECT patient_id, COUNT(*) OVER (PARTITION BY patient_id) AS visit_rank FROM visits;

-- 43. Rank visits for each patient by date.
SELECT visit_id, ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY visit_date DESC) AS rn FROM visits;

-- 44. Compare the current visit's bill with the previous visit's bill for each patient.
SELECT patient_id, visit_date, bill_amount, LAG(bill_amount) OVER (PARTITION BY patient_id ORDER BY visit_date) AS prev_bill FROM visits;

-- 45. Rank doctors by their total billed amount.
SELECT doctor_id, RANK() OVER (ORDER BY SUM(bill_amount) DESC) AS doctor_rank, SUM(bill_amount) AS total FROM visits GROUP BY doctor_id ORDER BY total DESC;

-- 46. Count visits for each patient in the last year, including those with zero visits.
SELECT 
    p.patient_id, 
    p.first_name, 
    COUNT(v.visit_id) AS visits_last_year
FROM patients p
LEFT JOIN visits v 
    ON p.patient_id = v.patient_id 
   AND v.visit_date >= (CURRENT_DATE - INTERVAL 1 YEAR)
GROUP BY p.patient_id, p.first_name
ORDER BY visits_last_year DESC;

-- 47. Find all visits with a diagnosis containing 'Allergy'.
SELECT * FROM visits WHERE diagnosis LIKE '%Allergy%';

-- 48. Find patients who were prescribed 'Amoxicillin' using a multi-table join.
SELECT DISTINCT p.patient_id FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN medications m ON v.visit_id = m.visit_id WHERE m.drug_name = 'Amoxicillin';

-- 49. Find patients with a total spending of over 5000.
SELECT p.first_name, p.last_name, SUM(v.bill_amount) FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.first_name, p.last_name HAVING SUM(v.bill_amount) > 5000;

-- 50. Find the visit with the highest bill amount using a subquery.
SELECT visit_id FROM visits WHERE bill_amount = (SELECT MAX(bill_amount) FROM visits);

-- 51. Count the number of visits and lab tests for each patient.
SELECT p.patient_id, COUNT(v.visit_id) AS visits, COUNT(lt.test_id) AS tests FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id LEFT JOIN lab_tests lt ON v.visit_id = lt.visit_id GROUP BY p.patient_id ORDER BY visits DESC;

-- 52. Calculate the median bill amount for each doctor.
-- Note: This uses a PostgreSQL-specific function.
SELECT doctor_id,
       AVG(bill_amount) AS median_bill
FROM (
    SELECT 
        doctor_id,
        bill_amount,
        ROW_NUMBER() OVER (PARTITION BY doctor_id ORDER BY bill_amount) AS rn,
        COUNT(*) OVER (PARTITION BY doctor_id) AS cnt
    FROM visits
) t
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
GROUP BY doctor_id;

-- 53. Find patients with a 'Hypertension' diagnosis using `IN`.
SELECT p.patient_id, p.first_name, p.last_name FROM patients p WHERE p.patient_id IN (SELECT patient_id FROM visits WHERE diagnosis = 'Hypertension');

-- 54. List the top 50 patients by visit count, showing their city.
SELECT p.patient_id, p.city, COUNT(v.visit_id) FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.city ORDER BY COUNT(v.visit_id) DESC LIMIT 50;

-- 55. Find visits where no medication was prescribed.
SELECT v.visit_id, m.drug_name FROM visits v LEFT JOIN medications m ON v.visit_id = m.visit_id WHERE m.drug_name IS NULL;

-- 56. List the 50 most recent lab tests.
SELECT * FROM lab_tests ORDER BY test_date DESC LIMIT 50;

-- 57. Calculate the total spending for each patient in the last 6 months.
-- Note: This uses a PostgreSQL-specific `FILTER` clause.
-- SELECT 
--     p.patient_id, 
--     SUM(v.bill_amount) FILTER (
--         WHERE v.visit_date >= CURRENT_DATE - INTERVAL '6 months'
--     ) AS last_6m_spend
-- FROM patients p
-- LEFT JOIN visits v 
--     ON p.patient_id = v.patient_id
-- GROUP BY p.patient_id;

-- 58. Count the number of doctors per specialization.
SELECT specialization, COUNT(*) AS doctors_count FROM doctors GROUP BY specialization ORDER BY doctors_count DESC;

-- 59. Find patients with a diagnosis of either 'Asthma' or 'Allergy'.
SELECT p.patient_id, p.first_name, v.visit_id, v.diagnosis FROM patients p JOIN visits v ON p.patient_id = v.patient_id WHERE v.diagnosis IN ('Asthma', 'Allergy');

-- 60. Find doctors with more than 20 years of experience.
SELECT doctor_id, MAX(experience_years) FROM doctors GROUP BY doctor_id HAVING MAX(experience_years) > 20;

-- 61. Count the number of tests performed on each visit date.
SELECT v.visit_date, COUNT(*) AS tests_on_day FROM lab_tests lt JOIN visits v ON lt.visit_id = v.visit_id GROUP BY v.visit_date ORDER BY tests_on_day DESC;

-- 62. Calculate the bill amount per medication for each visit using a correlated subquery.
SELECT v.visit_id, (v.bill_amount / NULLIF((SELECT COUNT(*) FROM medications m WHERE m.visit_id = v.visit_id),0)) AS bill_per_med FROM visits v;

-- 63. List all specializations a patient has seen using STRING_AGG.
-- Note: This is a PostgreSQL-specific function. Use GROUP_CONCAT in MySQL.
-- SELECT p.patient_id, p.first_name, STRING_AGG(DISTINCT d.specialization, ', ') AS seen_specialties FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN doctors d ON v.doctor_id = d.doctor_id GROUP BY p.patient_id, p.first_name;

-- 64. Count the number of unique patients seen by each doctor.
SELECT doctor_id, COUNT(*) AS num_distinct_patients FROM (SELECT DISTINCT doctor_id, patient_id FROM visits) sub GROUP BY doctor_id ORDER BY num_distinct_patients DESC;

-- 65. Find patients who have never had a visit.
SELECT p.*, v.visit_id FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id WHERE v.visit_date IS NULL;

-- 66. Use a CTE and ROW_NUMBER to find the most recent visit for each patient.
WITH ranked_visits AS ( SELECT *, ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY visit_date DESC) rn FROM visits ) SELECT * FROM ranked_visits WHERE rn = 1;

-- 67. Find patients with lab test results over 150.
SELECT p.patient_id, p.first_name, v.visit_date, lt.test_name, lt.result_value FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN lab_tests lt ON v.visit_id = lt.visit_id WHERE lt.result_value > 150 ORDER BY lt.result_value DESC;

-- 68. Count the number of 'COVID-19' cases for each doctor.
-- Note: This uses a PostgreSQL-specific `FILTER` clause.
SELECT doctor_id, COUNT(*) FILTER (WHERE diagnosis = 'COVID-19') AS covid_cases FROM visits GROUP BY doctor_id ORDER BY covid_cases DESC;

-- 69. Find visits where two or more medications were prescribed.
SELECT v.visit_id, v.diagnosis, COUNT(m.medication_id) AS meds_given FROM visits v LEFT JOIN medications m ON v.visit_id = m.visit_id GROUP BY v.visit_id, v.diagnosis HAVING COUNT(m.medication_id) >= 2;

-- 70. Find patients whose first name has more than 5 characters.
SELECT first_name, last_name FROM patients WHERE LENGTH(first_name) > 5 ORDER BY first_name;

-- 71. Extract the year from a patient's registration date.
SELECT p.patient_id, p.registration_date, EXTRACT(YEAR FROM p.registration_date) AS reg_year FROM patients p GROUP BY p.patient_id, p.registration_date ORDER BY reg_year;

-- 72. List the top 50 visits by bill amount.
SELECT * FROM visits WHERE bill_amount IS NOT NULL ORDER BY bill_amount DESC LIMIT 50;

-- 73. Get a list of all unique patient states.
SELECT DISTINCT p.state FROM patients p WHERE p.state IS NOT NULL;

-- 74. Find doctors whose visit count is greater than the average number of visits per doctor.
SELECT v.doctor_id, COUNT(*) AS visits_count FROM visits v GROUP BY v.doctor_id HAVING COUNT(*) >= (SELECT AVG(visits_per_doc) FROM (SELECT COUNT(*) AS visits_per_doc FROM visits GROUP BY doctor_id) t);

-- 75. Find the top 20 doctors by total revenue and visit count.
SELECT doctor_id, COUNT(*) AS total_visits, SUM(bill_amount) AS revenue FROM visits GROUP BY doctor_id ORDER BY revenue DESC LIMIT 20;

-- 76. Find the top 25 patients by lifetime spending.
SELECT p.patient_id, p.first_name, SUM(v.bill_amount) AS lifetime_spend FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.first_name ORDER BY lifetime_spend DESC LIMIT 25;

-- 77. Find the number of unique patients seen on each visit date.
SELECT visit_date, COUNT(DISTINCT patient_id) AS unique_patients FROM visits GROUP BY visit_date ORDER BY visit_date DESC LIMIT 30;

-- 78. Find medications with 'tablet' in the dosage description.
SELECT v.visit_id, m.drug_name, m.dosage FROM visits v JOIN medications m ON v.visit_id = m.visit_id WHERE m.dosage LIKE '%tablet%';

-- 79. Count the number of lab tests for each patient.
SELECT p.patient_id, COUNT(lt.test_id) AS tests_count FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id LEFT JOIN lab_tests lt ON v.visit_id = lt.visit_id GROUP BY p.patient_id ORDER BY tests_count DESC;

-- 80. Find specializations with an average doctor experience of more than 5 years.
SELECT specialization, AVG(experience_years) AS avg_exp FROM doctors GROUP BY specialization HAVING AVG(experience_years) > 5;

-- 81. Find doctors working at a 'General' hospital.
-- SELECT doctor_name, hospital_name FROM doctors WHERE hospital_name LIKE '%General%';

-- 82. Find the maximum test result value for each patient.
SELECT p.patient_id, MAX(lt.result_value) AS max_test_result FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN lab_tests lt ON v.visit_id = lt.visit_id GROUP BY p.patient_id;

-- 83. Use a window function to show the total visits per patient alongside visit details.
SELECT p.patient_id, v.visit_id, count(*) OVER (PARTITION BY p.patient_id) AS visits_total FROM patients p JOIN visits v ON p.patient_id = v.patient_id ORDER BY visits_total DESC;

-- 84. Calculate min, max, and average result values for each lab test.
SELECT test_name, MIN(result_value), MAX(result_value), AVG(result_value) FROM lab_tests GROUP BY test_name;

-- 85. Find visits that do not have any associated medications using NOT EXISTS.
SELECT v.visit_id FROM visits v WHERE NOT EXISTS (SELECT 1 FROM medications m WHERE m.visit_id = v.visit_id);

-- 86. Calculate the total spending for each patient, grouped by their age.
SELECT 
    p.patient_id, 
    p.age, 
    SUM(v.bill_amount) AS total_spent
FROM patients p
JOIN visits v 
    ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.age
ORDER BY total_spent DESC;

-- 87. Count the number of visits for each patient in the current month.
SELECT patient_id, COUNT(*) AS monthly_visits FROM visits WHERE visit_date >= date_trunc('month', CURRENT_DATE) GROUP BY patient_id;

-- 88. Count the number of unique patients for each specialization.
SELECT d.specialization, COUNT(DISTINCT v.patient_id) AS patients_count FROM doctors d JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.specialization;

-- 89. Find the top 10 patients by visit count using a correlated subquery.
SELECT p.patient_id, p.first_name, (SELECT COUNT(*) FROM visits v WHERE v.patient_id = p.patient_id) AS visit_count FROM patients p ORDER BY visit_count DESC LIMIT 10;

-- 90. List all drugs for each visit as a concatenated string.
-- Note: Uses PostgreSQL-specific function. Use GROUP_CONCAT in MySQL.
SELECT 
    v.*, 
    (SELECT GROUP_CONCAT(m.drug_name SEPARATOR ', ') 
     FROM medications m 
     WHERE m.visit_id = v.visit_id) AS drugs_list
FROM visits v
LIMIT 50;

-- 91. Find visits where the diagnosis is missing or an empty string.
SELECT * FROM visits WHERE diagnosis IS NULL OR diagnosis = '' ;

-- 92. Count the number of visits per year.
SELECT 
    YEAR(visit_date) AS yr, 
    COUNT(*) AS total_visits
FROM visits
GROUP BY YEAR(visit_date)
ORDER BY yr;

-- 93. Replace NULL city values with 'Unknown'.
SELECT p.patient_id, COALESCE(p.city, 'Unknown') AS city FROM patients p LIMIT 20;

-- 94. Find the date of the next visit for each patient.
SELECT v.visit_id, v.visit_date, LEAD(v.visit_date) OVER (PARTITION BY patient_id ORDER BY visit_date) AS next_visit FROM visits v;

-- 95. Count total visits for each doctor, including those who have had no visits.
SELECT d.doctor_id, d.doctor_name, COUNT(v.visit_id) AS visits_count FROM doctors d LEFT JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.doctor_id, d.doctor_name ORDER BY visits_count DESC;

-- 96. Calculate the average duration of each medication.
SELECT m.drug_name, AVG(m.duration_days) AS avg_duration FROM medications m GROUP BY m.drug_name;

-- 97. Find lab tests performed within 7 days of a visit.
SELECT 
    p.patient_id, 
    v.visit_date, 
    lt.test_name
FROM patients p
JOIN visits v 
    ON p.patient_id = v.patient_id
JOIN lab_tests lt 
    ON v.visit_id = lt.visit_id
WHERE lt.test_date > v.visit_date - INTERVAL 7 DAY;

-- 98. Find the total revenue and show each visit's bill amount relative to it.
SELECT v.visit_id, v.bill_amount, SUM(v.bill_amount) OVER () AS total_revenue FROM visits v ORDER BY v.bill_amount DESC LIMIT 20;

-- 99. Find doctors with a total revenue over 50000.
SELECT doctor_id, SUM(bill_amount) AS revenue FROM visits GROUP BY doctor_id HAVING SUM(bill_amount) > 50000;

-- 100. Find patients who have never had a visit using NOT IN.
SELECT p.patient_id, p.first_name FROM patients p WHERE p.patient_id NOT IN (SELECT DISTINCT patient_id FROM visits);

-- 101. Create an index to improve performance for patient visit lookups.
-- CREATE INDEX idx_visits_patient_date 
-- ON visits(patient_id, visit_date);


-- 102. Count the number of visits for patients who have had more than 2 visits.
-- Note: This uses a PostgreSQL-specific function.
-- SELECT p.patient_id, ARRAY_LENGTH(ARRAY_AGG(v.visit_id),1) AS visits FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id HAVING COUNT(v.visit_id) > 2;

-- 103. Count 'Flu' cases for each doctor.
SELECT doctor_name, COUNT(CASE WHEN v.diagnosis = 'Flu' THEN 1 END) AS flu_cases FROM doctors d LEFT JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY doctor_name ORDER BY flu_cases DESC;

-- 104. Count 'COVID-19' visits for each patient.
SELECT 
    p.patient_id, 
    p.first_name, 
    SUM(CASE WHEN v.diagnosis = 'COVID-19' THEN 1 ELSE 0 END) AS covid_visits
FROM patients p
LEFT JOIN visits v 
    ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name
ORDER BY covid_visits DESC;

-- 105. List all prescriptions for each visit as a formatted string.
SELECT v.visit_id, p.first_name, 
       GROUP_CONCAT(CONCAT(m.drug_name, '(', m.dosage, ')') SEPARATOR ', ') AS prescriptions
FROM visits v
LEFT JOIN patients p ON v.patient_id = p.patient_id
LEFT JOIN medications m ON v.visit_id = m.visit_id
GROUP BY v.visit_id, p.first_name;

-- 106. Top 20 patients by number of distinct lab tests.
SELECT p.patient_id, COUNT(DISTINCT lt.test_name) AS different_tests
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
JOIN lab_tests lt ON v.visit_id = lt.visit_id
GROUP BY p.patient_id
ORDER BY different_tests DESC
LIMIT 20;

-- 107. Count high-value visits (bill > 10000) for each specialization.
SELECT d.specialization,
       SUM(CASE WHEN v.bill_amount > 10000 THEN 1 ELSE 0 END) AS high_value_visits
FROM doctors d
JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.specialization;

-- 108. Find doctors whose name starts with 'Dr.' or ends with 'MD'.
SELECT * 
FROM doctors 
WHERE doctor_name LIKE 'Dr.%' OR doctor_name LIKE '%MD';

-- 109. Rank diagnoses by their popularity (uses window function).
SELECT v.visit_id, v.diagnosis,
       COUNT(*) OVER (PARTITION BY v.diagnosis) AS diagnosis_popularity
FROM visits v
ORDER BY diagnosis_popularity DESC
LIMIT 50;

-- 110. Visits per patient in last 30 days.
SELECT patient_id,
       SUM(CASE WHEN visit_date > CURRENT_DATE - INTERVAL 30 DAY THEN 1 ELSE 0 END) AS visits_30d
FROM visits
GROUP BY patient_id
ORDER BY visits_30d DESC;

-- 111. Visits with bill between 1000 and 5000.
SELECT * 
FROM visits 
WHERE bill_amount BETWEEN 1000 AND 5000
ORDER BY bill_amount;

-- 112. Classify patients as 'at_risk' if age >= 60.
SELECT p.patient_id, p.first_name,
       CASE WHEN p.age >= 60 THEN 'at_risk' ELSE 'normal' END AS risk_group
FROM patients p
WHERE p.age IS NOT NULL;

-- 113. Doctor with highest total revenue (using nested subqueries).
SELECT *
FROM (
    SELECT doctor_id, SUM(bill_amount) AS revenue
    FROM visits
    GROUP BY doctor_id
) t
WHERE t.revenue = (
    SELECT MAX(revenue)
    FROM (
        SELECT doctor_id, SUM(bill_amount) AS revenue
        FROM visits
        GROUP BY doctor_id
    ) x
);

-- 114. Count 'Diabetes' visits per day.
SELECT visit_date, COUNT(*) AS diabetes_count
FROM visits
WHERE diagnosis = 'Diabetes'
GROUP BY visit_date
ORDER BY visit_date;

-- 115. Sequence visits for each doctor.
SELECT v.visit_id, d.doctor_name,
       ROW_NUMBER() OVER (PARTITION BY d.doctor_id ORDER BY v.visit_date) AS visit_seq
FROM visits v
JOIN doctors d ON v.doctor_id = d.doctor_id;

-- 116. 11th to 20th patients by total spend.
SELECT patient_id, SUM(bill_amount) AS total_spend
FROM visits
GROUP BY patient_id
ORDER BY total_spend DESC
LIMIT 10 OFFSET 10;

-- 117. Average bill for each patient via correlated subquery.
SELECT p.patient_id, p.first_name,
       COALESCE((SELECT AVG(bill_amount) FROM visits v WHERE v.patient_id = p.patient_id),0) AS avg_bill
FROM patients p
ORDER BY avg_bill DESC
LIMIT 20;

-- 118. Visits with certain diagnoses.
SELECT * 
FROM visits
WHERE diagnosis IN ('Asthma', 'Hypertension', 'Diabetes');

-- 119. Count medications prescribed for each patient.
SELECT p.patient_id, COUNT(*) AS meds_count
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
JOIN medications m ON v.visit_id = m.visit_id
GROUP BY p.patient_id
ORDER BY meds_count DESC;

-- 120. Average test result for each test type in the last 6 months.
SELECT lt.test_name, 
       AVG(CASE WHEN lt.test_date > CURRENT_DATE - INTERVAL 6 MONTH THEN lt.result_value END) AS avg_recent_result
FROM lab_tests lt
GROUP BY lt.test_name;

-- 121. Patients with missing age.
SELECT p.patient_id, p.first_name 
FROM patients p 
WHERE p.age IS NULL;

-- 122. Deviation of each bill from overall avg.
SELECT visit_id, bill_amount, (bill_amount - AVG(bill_amount) OVER ()) AS deviation
FROM visits
ORDER BY deviation DESC
LIMIT 20;

-- 123. Count visits per doctor for the current month.
SELECT doctor_id, COUNT(*) AS visits_this_month
FROM visits
WHERE visit_date >= DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')
GROUP BY doctor_id;

-- 124. Patients with at least one visit bill over 10000.
SELECT p.patient_id, MAX(v.bill_amount) AS max_bill
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id
HAVING MAX(v.bill_amount) > 10000;

-- 125. Count high-value test results (over 200) for each test type.
SELECT lt.test_name,
       SUM(CASE WHEN lt.result_value > 200 THEN 1 ELSE 0 END) AS high_values
FROM lab_tests lt
GROUP BY lt.test_name;

-- 126. Total revenue for each doctor, including those with no visits.
SELECT d.doctor_name, COALESCE(SUM(v.bill_amount),0) AS revenue
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_name
ORDER BY revenue DESC;

-- 127. Patients registered in last 90 days.
SELECT *
FROM patients
WHERE registration_date >= CURRENT_DATE - INTERVAL 90 DAY
ORDER BY registration_date DESC;

-- 128. Total items (medications + lab tests) for each visit.
SELECT x.visit_id, COUNT(*) AS total_items
FROM (
    SELECT visit_id FROM medications
    UNION ALL
    SELECT visit_id FROM lab_tests
) x
GROUP BY x.visit_id
ORDER BY total_items DESC;

-- 129. Patients who have had more than 3 lab tests.
SELECT p.patient_id, p.first_name, COUNT(lt.test_id) AS tests
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
JOIN lab_tests lt ON v.visit_id = lt.visit_id
GROUP BY p.patient_id, p.first_name
HAVING COUNT(lt.test_id) > 3;

-- 130. Use ROLLUP to get counts of doctors by specialization and grand total.
SELECT specialization, COUNT(*) AS cnt
FROM doctors
GROUP BY specialization WITH ROLLUP;

-- 131. Top 50 patients by total lifetime spending.
SELECT p.patient_id, p.first_name, SUM(v.bill_amount) AS total_spend
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name
ORDER BY total_spend DESC
LIMIT 50;

-- 132. List all lab tests for each visit as a concatenated string.
SELECT v.visit_id, 
       (SELECT GROUP_CONCAT(lt.test_name SEPARATOR ', ') FROM lab_tests lt WHERE lt.visit_id = v.visit_id) AS tests
FROM visits v
LIMIT 50;

-- 133. Count distinct patients served by each hospital.
SELECT d.hospital_name, COUNT(DISTINCT v.patient_id) AS patients_served
FROM doctors d
JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.hospital_name
ORDER BY patients_served DESC;

-- 134. Patients with at least one visit > 20000 using EXISTS.
SELECT p.patient_id, p.first_name
FROM patients p
WHERE EXISTS (
    SELECT 1 FROM visits v WHERE v.patient_id = p.patient_id AND v.bill_amount > 20000
);

-- 135. Visits where 'Metformin' was prescribed.
SELECT v.visit_id, v.diagnosis
FROM visits v
WHERE v.visit_id IN (SELECT visit_id FROM medications WHERE drug_name = 'Metformin');

-- 136. CTE to join visit details with medication counts.
WITH med_counts AS (
    SELECT visit_id, COUNT(*) AS cnt FROM medications GROUP BY visit_id
)
SELECT v.visit_id, v.diagnosis, COALESCE(mc.cnt,0) AS med_count
FROM visits v
LEFT JOIN med_counts mc ON v.visit_id = mc.visit_id
ORDER BY mc.cnt DESC;

-- 137. Create a view to show top doctors by revenue.
CREATE OR REPLACE VIEW top_doctors AS
SELECT d.doctor_id, d.doctor_name, SUM(v.bill_amount) AS revenue
FROM doctors d
JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING SUM(v.bill_amount) > 20000;

-- 138. Query the top_doctors view to find top 20.
SELECT * FROM top_doctors ORDER BY revenue DESC LIMIT 20;

-- 139. Count distinct days each patient has visited.
SELECT patient_id, COUNT(DISTINCT visit_date) AS visit_days
FROM visits
GROUP BY patient_id
ORDER BY visit_days DESC;

-- 140. Maximum lab test result value for each patient (correlated subquery).
SELECT p.patient_id, p.first_name,
       COALESCE((SELECT MAX(lt.result_value)
                 FROM lab_tests lt
                 JOIN visits vv ON lt.visit_id = vv.visit_id
                 WHERE vv.patient_id = p.patient_id), 0) AS max_test
FROM patients p;

-- 141. Count fracture cases per doctor specialization.
SELECT d.specialization,
       SUM(CASE WHEN v.diagnosis = 'Fracture' THEN 1 ELSE 0 END) AS fracture_cases
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.specialization
ORDER BY fracture_cases DESC;

-- 142. Top 30 days with highest revenue.
SELECT visit_date, SUM(bill_amount) AS revenue_day
FROM visits
GROUP BY visit_date
ORDER BY revenue_day DESC
LIMIT 30;

-- 143. Aggregate visit and test counts into a JSON object for each patient.
SELECT p.patient_id, p.first_name,
       JSON_OBJECT('visits', COUNT(DISTINCT v.visit_id), 'tests', COUNT(lt.test_id)) AS summary
FROM patients p
LEFT JOIN visits v ON p.patient_id = v.patient_id
LEFT JOIN lab_tests lt ON v.visit_id = lt.visit_id
GROUP BY p.patient_id, p.first_name
LIMIT 20;

-- 144. Count meds and lab tests for each visit using correlated subqueries.
SELECT v.visit_id,
       (SELECT COUNT(*) FROM medications m WHERE m.visit_id = v.visit_id) AS meds_count,
       (SELECT COUNT(*) FROM lab_tests lt WHERE lt.visit_id = v.visit_id) AS tests_count
FROM visits v
ORDER BY meds_count DESC
LIMIT 50;

-- 145. Max and min experience years for each specialization.
SELECT specialization, MAX(experience_years) AS max_exp, MIN(experience_years) AS min_exp
FROM doctors
GROUP BY specialization;

-- 146. Total spending for each patient handling NULL bill_amounts.
SELECT p.patient_id, p.first_name,
       SUM(CASE WHEN v.bill_amount IS NULL THEN 0 ELSE v.bill_amount END) AS total_spend
FROM patients p
LEFT JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name;

-- 147. Count unique patients for each lab test type.
SELECT lt.test_name, COUNT(DISTINCT v.patient_id) AS affected_patients
FROM lab_tests lt
JOIN visits v ON lt.visit_id = v.visit_id
GROUP BY lt.test_name
ORDER BY affected_patients DESC;

-- 148. Visits with diagnosis containing 'covid' (case-insensitive).
SELECT *
FROM visits
WHERE LOWER(diagnosis) LIKE '%covid%';

-- 149. Use NTILE to divide patients into 4 age groups.
SELECT p.patient_id, p.age, NTILE(4) OVER (ORDER BY p.age) AS age_quartile
FROM patients p;

-- 150. Doctor with the most years of experience.
SELECT * FROM doctors WHERE experience_years = (SELECT MAX(experience_years) FROM doctors);

-- 151. Visits to pediatricians by patients under 18.
SELECT v.visit_id, d.doctor_name, p.first_name
FROM visits v
JOIN doctors d ON v.doctor_id = d.doctor_id
JOIN patients p ON v.patient_id = p.patient_id
WHERE d.specialization = 'Pediatrics' AND p.age < 18;

-- 152. Top 100 patients by visit count.
SELECT patient_id, COUNT(*) AS visits_count
FROM visits
GROUP BY patient_id
ORDER BY visits_count DESC
LIMIT 100;

-- 153. Visits where 'Aspirin' was prescribed.
SELECT visit_id,
       SUM(CASE WHEN m.drug_name = 'Aspirin' THEN 1 ELSE 0 END) AS aspirin_flag
FROM medications m
GROUP BY visit_id
HAVING aspirin_flag > 0;

-- 154. Patients with a bill higher than average bill.
SELECT p.patient_id, p.first_name, v.bill_amount
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
WHERE v.bill_amount > (SELECT AVG(bill_amount) FROM visits);

-- 155. Population standard deviation of test results for each test type.
SELECT lt.test_name, STDDEV_POP(lt.result_value) AS stddev_result
FROM lab_tests lt
GROUP BY lt.test_name;

-- 156. Full report of total visits and revenue for each doctor.
SELECT d.doctor_id, d.doctor_name,
       COUNT(v.visit_id) AS total_visits,
       COALESCE(SUM(v.bill_amount),0) AS total_revenue
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY total_revenue DESC;

-- 157. Earliest visit date.
SELECT v.visit_id, v.visit_date
FROM visits v
WHERE v.visit_date = (SELECT MIN(visit_date) FROM visits);

-- 158. Visits by senior patients (age >= 65).
SELECT v.visit_id, d.doctor_name, p.first_name, p.age
FROM visits v
JOIN doctors d ON v.doctor_id = d.doctor_id
JOIN patients p ON v.patient_id = p.patient_id
WHERE p.age >= 65;

-- 159. Number of unique patients prescribed each drug.
SELECT m.drug_name, COUNT(DISTINCT v.patient_id) AS patients_prescribed
FROM medications m
JOIN visits v ON m.visit_id = v.visit_id
GROUP BY m.drug_name
ORDER BY patients_prescribed DESC;

-- 160. Count 'Allergy' visits for each patient.
SELECT p.patient_id,
       SUM(CASE WHEN v.diagnosis = 'Allergy' THEN 1 ELSE 0 END) AS allergy_visits
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id
ORDER BY allergy_visits DESC;

-- 161. Patients with total spending over 20000 (using a derived table).
SELECT * FROM (
    SELECT patient_id, SUM(bill_amount) AS total
    FROM visits
    GROUP BY patient_id
) t WHERE total > 20000;

-- 162. Top 5 doctors with most visits.
SELECT doctor_id, COUNT(*) AS cnt FROM visits GROUP BY doctor_id ORDER BY cnt DESC LIMIT 5;

-- 163. Unique, ordered list of all diagnoses.
SELECT DISTINCT diagnosis FROM visits ORDER BY diagnosis;

-- 164. Count expensive visits (bill > 10000) for each patient.
SELECT p.patient_id,
       SUM(CASE WHEN v.bill_amount > 10000 THEN 1 ELSE 0 END) AS expensive_visits
FROM patients p
LEFT JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id
ORDER BY expensive_visits DESC;

-- 165. Medications with duration >= 21 days.
SELECT v.visit_id, m.drug_name, m.duration_days
FROM visits v
JOIN medications m ON v.visit_id = m.visit_id
WHERE m.duration_days >= 21
ORDER BY m.duration_days DESC;

-- 166. Patients with total spending > 5000.
SELECT p.patient_id, p.first_name, SUM(v.bill_amount) AS total_spend
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name
HAVING SUM(v.bill_amount) > 5000;

-- 167. 50 most recent 'ECG' lab tests.
SELECT * FROM lab_tests WHERE test_name = 'ECG' ORDER BY test_date DESC LIMIT 50;

-- 168. Count number of different specializations each patient has seen.
SELECT p.patient_id, COUNT(DISTINCT d.specialization) AS specialties_seen
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
JOIN doctors d ON v.doctor_id = d.doctor_id
GROUP BY p.patient_id
ORDER BY specialties_seen DESC;

-- 169. Visits that included more than 2 lab tests.
SELECT v.visit_id, v.diagnosis, COUNT(*) AS test_count
FROM lab_tests lt
JOIN visits v ON lt.visit_id = v.visit_id
GROUP BY v.visit_id, v.diagnosis
HAVING COUNT(*) > 2;

-- 170. Top 50 patients by total amount spent.
SELECT p.first_name, p.last_name, SUM(v.bill_amount) AS spent_by_patient
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.first_name, p.last_name
ORDER BY spent_by_patient DESC
LIMIT 50;

-- 171. Visits with skin-related diagnosis.
SELECT * FROM visits WHERE diagnosis LIKE '%skin%' OR diagnosis LIKE '%Rash%';

-- 172. Average bill amount for each doctor specialization.
SELECT d.specialization, AVG(v.bill_amount) AS avg_bill
FROM doctors d
JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.specialization
ORDER BY avg_bill DESC;

-- 173. Recent lab tests (last 30 days) for each patient.
SELECT p.patient_id, COUNT(*) AS recent_tests
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
JOIN lab_tests lt ON v.visit_id = lt.visit_id
WHERE lt.test_date > CURRENT_DATE - INTERVAL 30 DAY
GROUP BY p.patient_id
ORDER BY recent_tests DESC;

-- 174. Cumulative spend for each patient over time (correlated subquery).
SELECT v.visit_id, v.visit_date,
       COALESCE((SELECT SUM(bill_amount) FROM visits vv WHERE vv.patient_id = v.patient_id AND vv.visit_date <= v.visit_date),0) AS cumulative_spend
FROM visits v
ORDER BY v.patient_id, v.visit_date;

-- 175. Doctors with revenue higher than average revenue of all doctors.
SELECT * FROM (
    SELECT doctor_id, SUM(bill_amount) AS revenue
    FROM visits
    GROUP BY doctor_id
) AS dr
WHERE revenue > (
    SELECT AVG(sumrev) FROM (
        SELECT SUM(bill_amount) AS sumrev FROM visits GROUP BY doctor_id
    ) x
);

-- 176. Patients with more than 2 visits, showing city and visit count.
SELECT p.patient_id, p.city, COUNT(v.visit_id) AS visits
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.city
HAVING COUNT(v.visit_id) > 2
ORDER BY visits DESC;

-- 177. Visits where 'Paracetamol' was prescribed.
SELECT visit_id,
       SUM(CASE WHEN drug_name = 'Paracetamol' THEN 1 ELSE 0 END) AS paracetamol_count
FROM medications
GROUP BY visit_id
HAVING paracetamol_count > 0;

-- 178. Clean up first names by removing non-alphabetic characters (MySQL REGEXP_REPLACE available in 8.0+).
SELECT p.patient_id, REGEXP_REPLACE(p.first_name, '[^a-zA-Z]', '') AS name_clean
FROM patients p
LIMIT 20;

-- 179. Top 10 busiest days by visit count.
SELECT visit_date, COUNT(*) AS visits_per_day
FROM visits
GROUP BY visit_date
ORDER BY visits_per_day DESC
LIMIT 10;

-- 180. Aggregate patient's visit details into a JSON array.
SELECT p.patient_id, p.first_name,
       JSON_ARRAYAGG(JSON_OBJECT('visit_id', v.visit_id, 'date', v.visit_date, 'bill', v.bill_amount)) AS visits_json
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name
LIMIT 10;

-- 181. Visits in the last 7 days.
SELECT v.visit_id, d.doctor_name, p.first_name
FROM visits v
JOIN doctors d ON v.doctor_id = d.doctor_id
JOIN patients p ON v.patient_id = p.patient_id
WHERE v.visit_date BETWEEN CURRENT_DATE - INTERVAL 7 DAY AND CURRENT_DATE;

-- 182. Top 50 patients by visit count, then filter to > 3 visits.
SELECT * FROM (
    SELECT patient_id, COUNT(*) AS c
    FROM visits
    GROUP BY patient_id
    ORDER BY c DESC
    LIMIT 50
) t WHERE c > 3;

-- 183. Medications with more than 5 prescriptions, showing average duration.
SELECT m.drug_name, COUNT(*) AS prescribed_count, AVG(m.duration_days) AS avg_duration
FROM medications m
GROUP BY m.drug_name
HAVING COUNT(*) > 5
ORDER BY prescribed_count DESC;

-- 184. Count 'Fracture' cases for each doctor, including zero cases.
SELECT d.doctor_name,
       SUM(CASE WHEN v.diagnosis = 'Fracture' THEN 1 ELSE 0 END) AS fractures
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_name
ORDER BY fractures DESC;

-- 185. Count high-value test results (>100) per patient (correlated subquery).
SELECT p.patient_id, p.first_name,
       (SELECT COUNT(*) FROM lab_tests lt JOIN visits vv ON lt.visit_id = vv.visit_id WHERE vv.patient_id = p.patient_id AND lt.result_value > 100) AS high_tests
FROM patients p
ORDER BY high_tests DESC
LIMIT 20;

-- 186. Patients who have the maximum number of visits.
SELECT patient_id, COUNT(*) AS cnt FROM visits GROUP BY patient_id HAVING COUNT(*) = (
    SELECT MAX(cnt) FROM (SELECT COUNT(*) AS cnt FROM visits GROUP BY patient_id) t
);

-- 187. Total duration of medications prescribed for each visit.
SELECT v.visit_id, v.diagnosis, SUM(COALESCE(m.duration_days,0)) AS total_med_days
FROM visits v
LEFT JOIN medications m ON v.visit_id = m.visit_id
GROUP BY v.visit_id, v.diagnosis
ORDER BY total_med_days DESC;

-- 188. First visit date for each patient.
SELECT p.patient_id, p.first_name, MIN(v.visit_date) AS first_visit
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name
ORDER BY first_visit;

-- 189. 90th percentile of test results for each test type (using window functions).
SELECT test_name, 
       MAX(result_value) AS p90_estimate FROM (
    SELECT lt.test_name, lt.result_value,
           ROW_NUMBER() OVER (PARTITION BY lt.test_name ORDER BY lt.result_value) AS rn,
           COUNT(*) OVER (PARTITION BY lt.test_name) AS cnt
    FROM lab_tests lt
) t
WHERE rn = CEIL(0.9 * cnt)
GROUP BY test_name;

-- 190. Top 50 patients by spending in the last year.
SELECT patient_id, SUM(bill_amount) AS total_spend
FROM visits
WHERE visit_date >= CURRENT_DATE - INTERVAL 365 DAY
GROUP BY patient_id
ORDER BY total_spend DESC
LIMIT 50;

-- 191. Count distinct active days per doctor.
SELECT doctor_id, COUNT(DISTINCT visit_date) AS active_days
FROM visits
GROUP BY doctor_id
ORDER BY active_days DESC;

-- 192. Cumulative visit count for each patient.
SELECT v.visit_id, 
       COUNT(*) OVER (PARTITION BY v.patient_id ORDER BY v.visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_visits
FROM visits v;

-- 193. Total spending for each patient showing full name.
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS name, SUM(v.bill_amount) AS spend
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY spend DESC;

-- 194. Top 10 most common diagnoses.
SELECT diagnosis, COUNT(*) AS occurrences
FROM visits
GROUP BY diagnosis
ORDER BY occurrences DESC
LIMIT 10;

-- 195. Count abnormal tests (result > 150) for each visit.
SELECT v.visit_id, v.diagnosis, 
       (SELECT COUNT(*) FROM lab_tests lt WHERE lt.visit_id = v.visit_id AND lt.result_value > 150) AS abnormal_tests
FROM visits v
ORDER BY abnormal_tests DESC
LIMIT 50;

-- 196. Average bill by patient grouped by age.
SELECT p.patient_id, p.age, AVG(v.bill_amount) AS avg_bill
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.age
ORDER BY avg_bill DESC
LIMIT 30;

-- 197. Visits per doctor in the last 30 days.
SELECT doctor_id,
       SUM(CASE WHEN v.visit_date >= CURRENT_DATE - INTERVAL 30 DAY THEN 1 ELSE 0 END) AS last30_visits
FROM visits v
GROUP BY doctor_id
ORDER BY last30_visits DESC;

-- 198. Combinations of patient and doctor cities for past visits.
SELECT DISTINCT p.city AS patient_city, d.city AS doctor_city
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
JOIN doctors d ON v.doctor_id = d.doctor_id;

-- 199. Visits that included at least one lab test, with patient name and test count.
SELECT v.visit_id, p.patient_id, p.first_name, COUNT(lt.test_id) AS test_count
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id
LEFT JOIN lab_tests lt ON v.visit_id = lt.visit_id
GROUP BY v.visit_id, p.patient_id, p.first_name
HAVING COUNT(lt.test_id) >= 1
ORDER BY test_count DESC;

-- 200. Begin and commit a transaction to ensure atomic execution of two simple count queries.
START TRANSACTION;
SELECT COUNT(*) AS total_patients FROM patients;
SELECT COUNT(*) AS total_doctors FROM doctors;
COMMIT;























































-- 105. List all prescriptions for each visit as a formatted string.
-- Note: Uses PostgreSQL-specific function.
SELECT v.visit_id, p.first_name, STRING_AGG(CONCAT(m.drug_name, '(',m.dosage,')'), ', ') AS prescriptions FROM visits v LEFT JOIN patients p ON v.patient_id = p.patient_id LEFT JOIN medications m ON v.visit_id = m.visit_id GROUP BY v.visit_id, p.first_name;

-- 106. Find the top 20 patients who have had the most different types of lab tests.
SELECT p.patient_id, COUNT(DISTINCT lt.test_name) AS different_tests FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN lab_tests lt ON v.visit_id = lt.visit_id GROUP BY p.patient_id ORDER BY different_tests DESC LIMIT 20;

-- 107. Count high-value visits (bill > 10000) for each specialization.
SELECT specialization, SUM(CASE WHEN v.bill_amount > 10000 THEN 1 ELSE 0 END) AS high_value_visits FROM doctors d JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY specialization;

-- 108. Find doctors whose name starts with 'Dr.' or ends with 'MD'.
SELECT * FROM doctors WHERE doctor_name LIKE 'Dr.%' OR doctor_name LIKE '%MD%';

-- 109. Rank diagnoses by their popularity.
-- Note: This is a window function.
SELECT v.visit_id, v.diagnosis, COUNT(*) OVER (PARTITION BY v.diagnosis) AS diagnosis_popularity FROM visits v ORDER BY diagnosis_popularity DESC LIMIT 50;

-- 110. Find patients by the number of visits in the last 30 days.
-- Note: This uses a PostgreSQL-specific `FILTER` clause.
SELECT patient_id, COUNT(*) FILTER (WHERE visit_date > CURRENT_DATE - INTERVAL '30 days') AS visits_30d FROM visits GROUP BY patient_id ORDER BY visits_30d DESC;

-- 111. Find visits with bill amounts between 1000 and 5000.
SELECT * FROM visits WHERE bill_amount BETWEEN 1000 AND 5000 ORDER BY bill_amount;

-- 112. Classify patients as 'at_risk' if their age is 60 or more.
SELECT p.patient_id, p.first_name, CASE WHEN p.age >= 60 THEN 'at_risk' ELSE 'normal' END AS risk_group FROM patients p WHERE p.age IS NOT NULL;

-- 113. Find the doctor with the highest total revenue using a nested subquery.
SELECT * FROM (SELECT doctor_id, SUM(bill_amount) AS revenue FROM visits GROUP BY doctor_id) t WHERE t.revenue = (SELECT MAX(revenue) FROM (SELECT doctor_id, SUM(bill_amount) AS revenue FROM visits GROUP BY doctor_id) x);

-- 114. Count 'Diabetes' visits per day.
SELECT visit_date, COUNT(*) FROM visits WHERE diagnosis = 'Diabetes' GROUP BY visit_date ORDER BY visit_date;

-- 115. Sequence visits for each doctor.
SELECT v.visit_id, d.doctor_name, ROW_NUMBER() OVER (PARTITION BY d.doctor_id ORDER BY v.visit_date) AS visit_seq FROM visits v JOIN doctors d ON v.doctor_id = d.doctor_id;

-- 116. Find the 11th to 20th patients by total spend.
SELECT patient_id, SUM(bill_amount) AS total_spend FROM visits GROUP BY patient_id ORDER BY total_spend DESC OFFSET 10 LIMIT 10;

-- 117. Calculate the average bill for each patient using a correlated subquery.
SELECT p.patient_id, p.first_name, COALESCE((SELECT AVG(bill_amount) FROM visits v WHERE v.patient_id = p.patient_id),0) AS avg_bill FROM patients p ORDER BY avg_bill DESC LIMIT 20;

-- 118. Find visits with a diagnosis of 'Asthma', 'Hypertension', or 'Diabetes'.
SELECT * FROM visits WHERE diagnosis IN ('Asthma', 'Hypertension', 'Diabetes');

-- 119. Count the number of medications prescribed for each patient.
SELECT p.patient_id, COUNT(*) AS meds_count FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN medications m ON v.visit_id = m.visit_id GROUP BY p.patient_id ORDER BY meds_count DESC;

-- 120. Calculate the average test result for each test type in the last 6 months.
-- Note: This uses a PostgreSQL-specific `FILTER` clause.
SELECT lt.test_name, AVG(lt.result_value) FILTER (WHERE lt.test_date > CURRENT_DATE - INTERVAL '6 months') FROM lab_tests lt GROUP BY lt.test_name;

-- 121. Find patients with a missing age.
SELECT p.patient_id, p.first_name FROM patients p WHERE p.age IS NULL;

-- 122. Calculate the deviation of each bill amount from the overall average.
SELECT visit_id, bill_amount, (bill_amount - AVG(bill_amount) OVER ()) AS deviation FROM visits ORDER BY deviation DESC LIMIT 20;

-- 123. Count visits per doctor for the current month.
SELECT doctor_id, COUNT(*) AS visits_this_month FROM visits WHERE visit_date >= date_trunc('month', CURRENT_DATE) GROUP BY doctor_id;

-- 124. Find patients who have had at least one visit bill over 10000.
SELECT p.patient_id, MAX(v.bill_amount) AS max_bill FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id HAVING MAX(v.bill_amount) > 10000;

-- 125. Count the number of high-value test results (over 200) for each test type.
-- Note: This uses a PostgreSQL-specific `FILTER` clause.
SELECT lt.test_name, COUNT(*) FILTER (WHERE result_value > 200) AS high_values FROM lab_tests lt GROUP BY lt.test_name;

-- 126. Calculate total revenue for each doctor, including those with no visits.
SELECT d.doctor_name, COALESCE(SUM(v.bill_amount),0) AS revenue FROM doctors d LEFT JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.doctor_name ORDER BY revenue DESC;

-- 127. Find patients registered in the last 90 days.
SELECT * FROM patients WHERE registration_date >= CURRENT_DATE - INTERVAL '90 days' ORDER BY registration_date DESC;

-- 128. Count the total number of items (medications + lab tests) for each visit.
SELECT v.visit_id, COUNT(*) AS total_items FROM ( SELECT visit_id FROM medications UNION ALL SELECT visit_id FROM lab_tests ) x GROUP BY visit_id ORDER BY total_items DESC;

-- 129. Find patients who have had more than 3 lab tests.
SELECT p.patient_id, p.first_name, COUNT(lt.test_id) AS tests FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN lab_tests lt ON v.visit_id = lt.visit_id GROUP BY p.patient_id, p.first_name HAVING COUNT(lt.test_id) > 3;

-- 130. Use ROLLUP to get counts of doctors by specialization and a grand total.
-- Note: This is a standard SQL feature.
SELECT specialization, COUNT(*) FROM doctors GROUP BY ROLLUP(specialization);

-- 131. Find the top 50 patients by total lifetime spending.
SELECT p.patient_id, p.first_name, SUM(v.bill_amount) AS total_spend FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.first_name ORDER BY total_spend DESC LIMIT 50;

-- 132. List all lab tests for each visit as a concatenated string.
-- Note: This is a correlated subquery. Uses PostgreSQL-specific STRING_AGG.
SELECT v.visit_id, (SELECT STRING_AGG(test_name, ', ') FROM lab_tests lt WHERE lt.visit_id = v.visit_id) AS tests FROM visits v LIMIT 50;

-- 133. Count the number of unique patients served by each hospital.
SELECT d.hospital_name, COUNT(DISTINCT v.patient_id) AS patients_served FROM doctors d JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.hospital_name ORDER BY patients_served DESC;

-- 134. Find patients who have had at least one visit with a bill over 20000 using EXISTS.
SELECT p.patient_id, p.first_name FROM patients p WHERE EXISTS (SELECT 1 FROM visits v WHERE v.patient_id = p.patient_id AND v.bill_amount > 20000);

-- 135. Find visits where 'Metformin' was prescribed using an IN clause.
SELECT v.visit_id, v.diagnosis FROM visits v WHERE v.visit_id IN (SELECT visit_id FROM medications WHERE drug_name = 'Metformin');

-- 136. Use a CTE to join visit details with medication counts.
WITH med_counts AS ( SELECT visit_id, COUNT(*) AS cnt FROM medications GROUP BY visit_id ) SELECT v.visit_id, v.diagnosis, mc.cnt FROM visits v LEFT JOIN med_counts mc ON v.visit_id = mc.visit_id ORDER BY mc.cnt DESC NULLS LAST;

-- 137. Create a view to show top doctors by revenue.
CREATE VIEW top_doctors AS SELECT d.doctor_id, d.doctor_name, SUM(v.bill_amount) AS revenue FROM doctors d JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.doctor_id, d.doctor_name HAVING SUM(v.bill_amount) > 20000;

-- 138. Query the `top_doctors` view to find the top 20.
SELECT * FROM top_doctors ORDER BY revenue DESC LIMIT 20;

-- 139. Count the number of distinct days each patient has visited.
SELECT patient_id, COUNT(DISTINCT visit_date) AS visit_days FROM visits GROUP BY patient_id ORDER BY visit_days DESC;

-- 140. Find the maximum lab test result value for each patient.
-- Note: This is a correlated subquery.
SELECT p.patient_id, p.first_name, COALESCE((SELECT MAX(result_value) FROM lab_tests lt JOIN visits v ON lt.visit_id = v.visit_id WHERE v.patient_id = p.patient_id),0) AS max_test FROM patients p;

-- 141. Count fracture cases per doctor specialization.
SELECT d.specialization, COUNT(*) FILTER (WHERE v.diagnosis = 'Fracture') AS fracture_cases FROM doctors d JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.specialization;

-- 142. Find the top 30 days with the highest revenue.
SELECT visit_date, SUM(bill_amount) AS revenue_day FROM visits GROUP BY visit_date ORDER BY revenue_day DESC LIMIT 30;

-- 143. Aggregate visit and test counts into a JSON object for each patient.
-- Note: This is a PostgreSQL-specific function.
SELECT p.patient_id, p.first_name, JSON_BUILD_OBJECT('visits', COUNT(v.visit_id), 'tests', COUNT(lt.test_id)) FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id LEFT JOIN lab_tests lt ON v.visit_id = lt.visit_id GROUP BY p.patient_id, p.first_name LIMIT 20;

-- 144. Count medications and lab tests for each visit using correlated subqueries.
SELECT v.visit_id, (SELECT COUNT(*) FROM medications m WHERE m.visit_id = v.visit_id) AS meds_count, (SELECT COUNT(*) FROM lab_tests lt WHERE lt.visit_id = v.visit_id) AS tests_count FROM visits v ORDER BY meds_count DESC NULLS LAST LIMIT 50;

-- 145. Find the maximum and minimum experience years for each specialization.
SELECT specialization, MAX(experience_years) AS max_exp, MIN(experience_years) AS min_exp FROM doctors GROUP BY specialization;

-- 146. Calculate total spending for each patient, handling NULL bill amounts.
SELECT p.patient_id, p.first_name, SUM(CASE WHEN v.bill_amount IS NULL THEN 0 ELSE v.bill_amount END) FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.first_name;

-- 147. Count the number of unique patients for each lab test type.
SELECT lt.test_name, COUNT(DISTINCT v.patient_id) AS affected_patients FROM lab_tests lt JOIN visits v ON lt.visit_id = v.visit_id GROUP BY lt.test_name ORDER BY affected_patients DESC;

-- 148. Find visits with a diagnosis containing 'covid' (case-insensitive).
SELECT * FROM visits WHERE diagnosis ILIKE '%covid%' OR diagnosis ILIKE '%COVID%';

-- 149. Use NTILE to divide patients into 4 age groups.
SELECT p.patient_id, p.age, NTILE(4) OVER (ORDER BY p.age) AS age_quartile FROM patients p;

-- 150. Find the doctor with the most years of experience.
SELECT * FROM doctors WHERE experience_years = (SELECT MAX(experience_years) FROM doctors);

-- 151. Find visits to pediatricians by patients under 18 years old.
SELECT v.visit_id, d.doctor_name, p.first_name FROM visits v JOIN doctors d ON v.doctor_id = d.doctor_id JOIN patients p ON v.patient_id = p.patient_id WHERE d.specialization = 'Pediatrics' AND p.age < 18;

-- 152. Find the top 100 patients by visit count.
SELECT patient_id, COUNT(*) AS visits_count FROM visits GROUP BY patient_id ORDER BY visits_count DESC LIMIT 100;

-- 153. Find visits where 'Aspirin' was prescribed.
SELECT visit_id, SUM(CASE WHEN m.drug_name = 'Aspirin' THEN 1 ELSE 0 END) AS aspirin_flag FROM medications m GROUP BY visit_id HAVING SUM(CASE WHEN m.drug_name = 'Aspirin' THEN 1 ELSE 0 END) > 0;

-- 154. Find patients with a bill amount higher than the average bill amount.
SELECT p.patient_id, p.first_name, v.bill_amount FROM patients p JOIN visits v ON p.patient_id = v.patient_id WHERE v.bill_amount > (SELECT AVG(bill_amount) FROM visits);

-- 155. Calculate the population standard deviation of test results for each test type.
SELECT lt.test_name, STDDEV_POP(result_value) AS stddev_result FROM lab_tests lt GROUP BY lt.test_name;

-- 156. Get a full report of total visits and revenue for each doctor.
SELECT d.doctor_id, d.doctor_name, COUNT(v.visit_id) AS total_visits, SUM(v.bill_amount) AS total_revenue FROM doctors d LEFT JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.doctor_id, d.doctor_name ORDER BY total_revenue DESC;

-- 157. Find the earliest visit date.
SELECT v.visit_id, v.visit_date FROM visits v WHERE v.visit_date = (SELECT MIN(visit_date) FROM visits);

-- 158. Find visits by senior patients (age >= 65).
SELECT v.visit_id, d.doctor_name, p.first_name, p.age FROM visits v JOIN doctors d ON v.doctor_id = d.doctor_id JOIN patients p ON v.patient_id = p.patient_id WHERE p.age >= 65;

-- 159. Count the number of unique patients who were prescribed each drug.
SELECT m.drug_name, COUNT(DISTINCT v.patient_id) AS patients_prescribed FROM medications m JOIN visits v ON m.visit_id = v.visit_id GROUP BY m.drug_name ORDER BY patients_prescribed DESC;

-- 160. Count the number of 'Allergy' visits for each patient.
SELECT p.patient_id, COUNT(*) FILTER (WHERE v.diagnosis = 'Allergy') AS allergy_visits FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id ORDER BY allergy_visits DESC;

-- 161. Use a subquery to find patients with a total spending over 20000.
SELECT * FROM (SELECT patient_id, SUM(bill_amount) OVER (PARTITION BY patient_id) AS total FROM visits) t WHERE total > 20000;

-- 162. Find the top 5 doctors with the most visits.
SELECT doctor_id, COUNT(*) FROM visits GROUP BY doctor_id ORDER BY COUNT(*) DESC LIMIT 5;

-- 163. Get a unique, ordered list of all diagnoses.
SELECT DISTINCT v.diagnosis FROM visits v ORDER BY diagnosis;

-- 164. Count the number of expensive visits (bill > 10000) for each patient.
SELECT p.patient_id, COUNT(CASE WHEN v.bill_amount > 10000 THEN 1 END) AS expensive_visits FROM patients p LEFT JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id ORDER BY expensive_visits DESC;

-- 165. Find medications with a duration of 21 days or more.
SELECT v.visit_id, m.drug_name, m.duration_days FROM visits v JOIN medications m ON v.visit_id = m.visit_id WHERE m.duration_days >= 21 ORDER BY m.duration_days DESC;

-- 166. Find patients with a total spending of over 5000 using `HAVING`.
SELECT p.patient_id, p.first_name, SUM(v.bill_amount) AS total_spend FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.first_name HAVING SUM(v.bill_amount) > 5000;

-- 167. List the 50 most recent 'ECG' lab tests.
SELECT * FROM lab_tests WHERE test_name = 'ECG' ORDER BY test_date DESC LIMIT 50;

-- 168. Count the number of different specializations each patient has seen.
SELECT p.patient_id, COUNT(DISTINCT d.specialization) AS specialties_seen FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN doctors d ON v.doctor_id = d.doctor_id GROUP BY p.patient_id ORDER BY specialties_seen DESC;

-- 169. Find visits that included more than 2 lab tests.
SELECT v.visit_id, v.diagnosis, COUNT(*) FROM lab_tests lt JOIN visits v ON lt.visit_id = v.visit_id GROUP BY v.visit_id, v.diagnosis HAVING COUNT(*) > 2;

-- 170. Find the top 50 patients by total amount spent.
SELECT p.first_name, p.last_name, SUM(v.bill_amount) AS spent_by_patient FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.first_name, p.last_name ORDER BY spent_by_patient DESC LIMIT 50;

-- 171. Find visits with a diagnosis related to skin conditions.
SELECT * FROM visits WHERE diagnosis LIKE '%skin%' OR diagnosis LIKE '%Rash%';

-- 172. Calculate the average bill amount for each doctor specialization.
SELECT d.specialization, AVG(v.bill_amount) AS avg_bill FROM doctors d JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.specialization ORDER BY avg_bill DESC;

-- 173. Count recent lab tests (last 30 days) for each patient.
SELECT p.patient_id, COUNT(*) AS recent_tests FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN lab_tests lt ON v.visit_id = lt.visit_id WHERE lt.test_date > CURRENT_DATE - INTERVAL '30 days' GROUP BY p.patient_id ORDER BY recent_tests DESC;

-- 174. Calculate a cumulative spend for each patient over time.
SELECT v.visit_id, v.visit_date, COALESCE((SELECT SUM(bill_amount) FROM visits vv WHERE vv.patient_id = v.patient_id AND vv.visit_date <= v.visit_date),0) AS cumulative_spend FROM visits v ORDER BY v.patient_id, v.visit_date;

-- 175. Find doctors with revenue higher than the average revenue of all doctors.
SELECT * FROM (SELECT doctor_id, SUM(bill_amount) AS revenue FROM visits GROUP BY doctor_id) AS dr WHERE revenue > (SELECT AVG(sumrev) FROM (SELECT SUM(bill_amount) AS sumrev FROM visits GROUP BY doctor_id) x);

-- 176. Find patients with more than 2 visits, showing their city and visit count.
SELECT p.patient_id, p.city, COUNT(v.visit_id) AS visits FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.city HAVING COUNT(v.visit_id) > 2 ORDER BY visits DESC;

-- 177. Find visits where 'Paracetamol' was prescribed.
SELECT visit_id, SUM(CASE WHEN drug_name = 'Paracetamol' THEN 1 ELSE 0 END) AS paracetamol_count FROM medications GROUP BY visit_id HAVING SUM(CASE WHEN drug_name = 'Paracetamol' THEN 1 ELSE 0 END) > 0;

-- 178. Clean up first names by removing non-alphabetic characters.
-- Note: This is a PostgreSQL-specific function.
SELECT p.patient_id, REGEXP_REPLACE(p.first_name, '[^a-zA-Z]', '', 'g') AS name_clean FROM patients p LIMIT 20;

-- 179. Count visits per day and find the top 10 busiest days.
SELECT visit_date, COUNT(*) AS visits_per_day FROM visits GROUP BY visit_date ORDER BY visits_per_day DESC LIMIT 10;

-- 180. Aggregate patient's visit details into a JSON array.
-- Note: This is a PostgreSQL-specific function.
SELECT p.patient_id, p.first_name, JSON_AGG(JSON_BUILD_OBJECT('visit_id', v.visit_id, 'date', v.visit_date, 'bill', v.bill_amount)) AS visits_json FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.first_name LIMIT 10;

-- 181. Find visits that occurred in the last 7 days.
SELECT v.visit_id, d.doctor_name, p.first_name FROM visits v JOIN doctors d ON v.doctor_id = d.doctor_id JOIN patients p ON v.patient_id = p.patient_id WHERE v.visit_date BETWEEN CURRENT_DATE - INTERVAL '7 days' AND CURRENT_DATE;

-- 182. Find the top 50 patients by visit count and then filter to show only those with more than 3 visits.
SELECT * FROM (SELECT patient_id, COUNT(*) AS c FROM visits GROUP BY patient_id ORDER BY c DESC LIMIT 50) t WHERE c > 3;

-- 183. Find medications with more than 5 prescriptions, showing the average duration.
SELECT m.drug_name, COUNT(*) AS prescribed_count, AVG(m.duration_days) AS avg_duration FROM medications m GROUP BY m.drug_name HAVING COUNT(*) > 5 ORDER BY prescribed_count DESC;

-- 184. Count 'Fracture' cases for each doctor, including those with zero cases.
-- Note: This uses a PostgreSQL-specific `FILTER` clause.
SELECT d.doctor_name, COUNT(*) FILTER (WHERE v.diagnosis = 'Fracture') AS fractures FROM doctors d LEFT JOIN visits v ON d.doctor_id = v.doctor_id GROUP BY d.doctor_name ORDER BY fractures DESC;

-- 185. Count the number of high-value tests (result > 100) for each patient.
SELECT p.patient_id, p.first_name, (SELECT COUNT(*) FROM lab_tests lt JOIN visits vv ON lt.visit_id = vv.visit_id WHERE vv.patient_id = p.patient_id AND lt.result_value > 100) AS high_tests FROM patients p ORDER BY high_tests DESC LIMIT 20;

-- 186. Find patients who have the maximum number of visits.
SELECT patient_id, COUNT(*) FROM visits GROUP BY patient_id HAVING COUNT(*) = (SELECT MAX(cnt) FROM (SELECT COUNT(*) AS cnt FROM visits GROUP BY patient_id) t);

-- 187. Calculate the total duration of medications prescribed for each visit.
SELECT visit_id, v.diagnosis, SUM(COALESCE(m.duration_days,0)) AS total_med_days FROM visits v LEFT JOIN medications m ON v.visit_id = m.visit_id GROUP BY visit_id, v.diagnosis ORDER BY total_med_days DESC;

-- 188. Find the first visit date for each patient.
SELECT p.patient_id, p.first_name, MIN(v.visit_date) AS first_visit FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.first_name ORDER BY first_visit;

-- 189. Calculate the 90th percentile of test results for each test type.
-- Note: This is a PostgreSQL-specific function.
SELECT lt.test_name, PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY lt.result_value) AS p90 FROM lab_tests lt GROUP BY lt.test_name;

-- 190. Find the top 50 patients by spending in the last year.
SELECT patient_id, SUM(bill_amount) AS total_spend FROM visits WHERE visit_date >= CURRENT_DATE - INTERVAL '365 days' GROUP BY patient_id ORDER BY total_spend DESC LIMIT 50;

-- 191. Count the number of distinct days each doctor was active.
SELECT doctor_id, COUNT(DISTINCT visit_date) AS active_days FROM visits GROUP BY doctor_id ORDER BY active_days DESC;

-- 192. Calculate the cumulative visit count for each patient.
SELECT v.visit_id, COUNT(*) OVER (PARTITION BY v.patient_id ORDER BY v.visit_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_visits FROM visits v;

-- 193. List total spending for each patient, showing their full name.
SELECT p.patient_id, CONCAT(first_name, ' ', last_name) AS name, SUM(bill_amount) AS spend FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, first_name, last_name ORDER BY spend DESC;

-- 194. Find the top 10 most common diagnoses.
SELECT diagnosis, COUNT(*) AS occurrences FROM visits GROUP BY diagnosis ORDER BY occurrences DESC LIMIT 10;

-- 195. Count the number of abnormal tests (result > 150) for each visit.
SELECT v.visit_id, v.diagnosis, (SELECT COUNT(*) FROM lab_tests lt WHERE lt.visit_id = v.visit_id AND lt.result_value > 150) AS abnormal_tests FROM visits v ORDER BY abnormal_tests DESC LIMIT 50;

-- 196. Calculate the average bill amount for each patient, grouped by their age.
SELECT p.patient_id, p.age, AVG(v.bill_amount) AS avg_bill FROM patients p JOIN visits v ON p.patient_id = v.patient_id GROUP BY p.patient_id, p.age ORDER BY avg_bill DESC LIMIT 30;

-- 197. Count the number of visits per doctor in the last 30 days.
-- Note: This uses a PostgreSQL-specific `FILTER` clause.
SELECT doctor_id, COUNT(*) FILTER (WHERE v.visit_date >= CURRENT_DATE - INTERVAL '30 days') AS last30_visits FROM visits v GROUP BY doctor_id ORDER BY last30_visits DESC;

-- 198. Find all combinations of patient and doctor cities for past visits.
SELECT DISTINCT p.city, d.city AS doctor_city FROM patients p JOIN visits v ON p.patient_id = v.patient_id JOIN doctors d ON v.doctor_id = d.doctor_id;

-- 199. Find all visits that included at least one lab test, showing the patient name and test count.
SELECT v.visit_id, p.patient_id, p.first_name, COUNT(lt.test_id) AS test_count FROM visits v JOIN patients p ON v.patient_id = p.patient_id LEFT JOIN lab_tests lt ON v.visit_id = lt.visit_id GROUP BY v.visit_id, p.patient_id, p.first_name HAVING COUNT(lt.test_id) >= 1 ORDER BY test_count DESC;

-- 200. Begin and commit a transaction to ensure atomic execution of two simple count queries.
BEGIN TRANSACTION; SELECT COUNT(*) FROM patients; SELECT COUNT(*) FROM doctors; COMMIT;
