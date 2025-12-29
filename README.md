# World Life Expectancy (SQL Project)

## Table of Content
* [Project Overview](#project-overview)
* [Dataset Overview](#dataset-overview)
* [Sample Data Overview](#sample-data-overview)
* [Data Cleaning Process](#data-cleaning-process)
* [Exploratory Data Analysis](#exploratory-data-analysis)
* [Key Insights](#key-insights)
* [Recommendations](#recommendations)
* [Data Source](#data-source)

### Project Overview
This project analyzes global life expectancy data to identify trends, inconsistencies, and key health indicators across countries and years. Using SQL, the dataset was cleaned, explored, and analyzed to uncover insights related to life expectancy, infant mortality, and country-level health improvements over time.
The goal of this project is to demonstrate data cleaning, exploratory data analysis (EDA), and insight generation using SQL on a real-world public health dataset.

### Tools and Technologies
* SQL (MySQL-compatible syntax)
* Relational database concepts
* Aggregate functions, joins, grouping, and filtering

### Dataset Overview
* Dataset Name: World Life Expectancy

* Granularity: Country–Year level

* Key Fields:

Country

Year

Life expectancy

Status (Developed / Developing)

Adult Mortality

Infant deaths

BMI

GDP

Schooling

Row_id

HIV/AIDS

The dataset captures health, economic, and demographic indicators across multiple countries over several years.

### Sample Data Overview
<img width="1274" height="203" alt="image" src="https://github.com/user-attachments/assets/a7a97a4b-7280-47f5-9da0-afabdc48843b" />

### Data Cleaning Process
1. Identifying duplicates
2. Further inspection was done to ensure:
   * Each country has only one record per year
   * Numerical columns were suitable for aggregation and comparison
   * No logical inconsistencies across time-based comparisons

### Exploratory Data Analysis 
#### Infant Mortality Reduction Analysis
```SQL
SELECT 
    W1.Country,
    (W1.`infant deaths` - W2.`infant deaths`) AS Reduction
FROM world_life_expectancy W1
JOIN world_life_expectancy W2
    ON W1.Country = W2.Country
   AND W1.Year = 2007
   AND W2.Year = 2015
ORDER BY Reduction DESC
LIMIT 5;
```
This analysis highlights countries that made significant progress in reducing infant mortality over time.

#### Average Life Expectancy by Country
```SQL
SELECT 
    Country,
    ROUND(AVG(`Life expectancy`), 1) AS Avg_Life_Expectancy
FROM world_life_expectancy
GROUP BY Country
ORDER BY Avg_Life_Expectancy DESC;
```
What This Explores:
* Countries with consistently high or low life expectancy
* Highlights long-term health outcomes rather than single-year values

#### Life Expectancy Trend Over Time (Global View)
```SQL
SELECT 
    Year,
    ROUND(AVG(`Life expectancy`), 1) AS Avg_Life_Expectancy
FROM world_life_expectancy
GROUP BY Year
ORDER BY Year;
```
What This Explores
* Overall improvement or stagnation in global life expectancy
* Identifies years where progress slowed or accelerated

#### Comparing Developed vs Developing Countries
```SQL
SELECT 
    Status,
    ROUND(AVG(`Life expectancy`), 1) AS Avg_Life_Expectancy
FROM world_life_expectancy
GROUP BY Status;
```
What This Explores
* Developed countries generally have higher life expectancy
* Highlights global health inequality tied to economic development

### Key Insights
* Some countries show substantial reductions in infant deaths over the selected period, indicating improvements in healthcare access and maternal health.
* Duplicate country–year records exist and must be addressed to avoid skewed results.
* Time-based comparisons using self-joins are effective for tracking health progress across years.
* Infant mortality remains a strong indicator of overall life expectancy improvements.

### Recommendations
#### 1. Improve Data Quality Through Enforced Uniqueness Constraints

Duplicate country–year records were identified in the dataset. Implementing enforced uniqueness constraints on the combination of Country and Year would prevent duplicate entries and ensure more reliable time-series analysis.

#### 2. Prioritize Countries With Minimal Infant Mortality Reduction

While some countries show significant reductions in infant deaths over time, others show limited improvement. Public health interventions and resource allocation should focus on countries with persistently high infant mortality to reduce global health disparities.

#### 3. Use Infant Mortality as a Core Indicator for Health Policy Evaluation

The dataset shows that changes in infant mortality are a strong signal of broader healthcare improvements. Policymakers should continue using infant mortality trends alongside life expectancy to assess the effectiveness of maternal and child health programs.

#### 4. Integrate Socioeconomic Indicators More Consistently

To better explain variations in life expectancy, future versions of the dataset should ensure complete and consistent reporting of socioeconomic variables such as education, income, and healthcare access across all countries and years.

#### 5. Support Targeted Global Health Investments

Countries demonstrating strong improvements can serve as benchmarks. Analyzing and replicating successful healthcare strategies from high-performing countries may help accelerate improvements in regions with slower progress.

### Data Source
[Download here](https://prod-cdn.analystbuilder.com/courses/7df6c1fb-b535-4047-b52c-4da03cb46380/lessons/7de487e2-b237-4c27-80e3-501cc4cc167d/WorldLifeExpectancy.csv)
