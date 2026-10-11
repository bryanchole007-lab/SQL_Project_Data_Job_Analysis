# Introduction
This project explores the Data Analyst job market in Singapore using SQL. The goal is to identify the highest-paying Data Analyst jobs, understand which skills employers demand, and investigate which skills are associated with higher average salaries.

By analyzing job postings, I aim to better understand the skills that may help aspiring Data Analysts prepare for opportunities in Singapore's job market.

Check out my queries here: [project_sql](/project_sql/)
# Background

As someone pursuing a career in data analytics, I wanted to better understand the skills and qualifications employers look for when hiring Data Analysts in Singapore.

I used job posting data to investigate three main areas:

- **Job Salaries:** Identify the highest-paying Data Analyst job opportunities in Singapore.
- **Skill Demand:** Find the skills most frequently requested by employers.
- **Salary and Skills:** Explore which skills are associated with higher average salaries.

Through this project, I aim to use SQL to turn raw job posting data into meaningful insights and identify skills that may help me prepare for a career as a Data Analyst.
# Tools I used

- **SQL:** Used to query and analyze job posting data, filter Data Analyst roles in Singapore, join tables, calculate average salaries, and identify in-demand skills.
- **PostgreSQL:** Used to store and query the job market dataset.
- **Visual Studio Code (VS Code):** Used to write, edit, and organize the SQL queries.
- **Git:** Used for version control to track changes to project files and manage commits.
- **GitHub:** Used to host the project repository online and share the SQL queries and analysis with others.
# The analysis

## 1. What Are the Top-Paying Jobs for a Data Analyst?

I filtered job postings to identify the 10 highest-paying Data Analyst positions in Singapore with disclosed annual salaries. I joined the job postings table with the company table to include company names and sorted the results by annual salary in descending order.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short ='Data Analyst' AND
    job_country = 'Singapore' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
![Top paying roles](assets\1_top_paying_jobs.png)


## 2. What Skills Are Required for the Top-Paying Jobs?

I identified the 10 highest-paying Data Analyst job postings in Singapore and joined them with the skills tables to find the skills associated with each position. This helps me explore the skills listed in higher-paying opportunities.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        name,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short ='Data Analyst' AND
        job_country = 'Singapore' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10)
SELECT
    top_paying_jobs.name,
    top_paying_jobs.job_title,
    skills.skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN
    skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;
```
![Skills required for top paying roles](assets\2_skills_for_top_paying_jobs.png)
## 3. What Are the Most-Demanded Skills?

I counted how frequently each skill appeared in Singapore Data Analyst job postings and ranked the skills by frequency to identify the five most frequently listed skills.
```sql
SELECT
    skills.skills,
    COUNT(jobs.job_id) AS skill_count
FROM
    job_postings_fact AS jobs
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = jobs.job_id
INNER JOIN
    skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
WHERE
    jobs.job_country = 'Singapore' AND
    jobs.job_title_short = 'Data Analyst'
GROUP BY
    skills.skills
ORDER BY
    skill_count DESC
LIMIT 5;
```
![Most demanded sklls](assets\3_most_demanded_skills.png)
## 4. Which Skills Have the Highest Average Salaries?

I calculated the average annual salary associated with each skill across Singapore Data Analyst job postings with disclosed salaries. I then ranked the skills by average salary and selected the top 10.
```sql
SELECT
    s.skills,
    ROUND(AVG(jobs.salary_year_avg),2) AS avg_salary
FROM
    job_postings_fact AS jobs
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = jobs.job_id
INNER JOIN
    skills_dim AS s ON s.skill_id = skills_job_dim.skill_id
WHERE
    jobs.salary_year_avg IS NOT NULL AND
    jobs.job_title_short = 'Data Analyst' AND
    jobs.job_country = 'Singapore'
GROUP BY
    s.skills
ORDER BY
    avg_salary DESC
LIMIT 10;
```
![Top skills to learn based on salary](assets\4_top_skills_based_on_salary.png)
## 5. What Are the Optimal Skills to Learn?

I combined skill-demand counts and average salary data for Singapore Data Analyst job postings with disclosed salaries. I sorted the results by skill demand first and average salary second to help identify skills worth investigating for my learning plan.
```sql
WITH demanded_skills AS (
    SELECT
        skills.skill_id,
        skills.skills,
        COUNT(jobs.job_id) AS skill_count
    FROM
        job_postings_fact AS jobs
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id = jobs.job_id
    INNER JOIN
        skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
    WHERE
        jobs.salary_year_avg IS NOT NULL AND
        jobs.job_country = 'Singapore' AND
        jobs.job_title_short = 'Data Analyst'
    GROUP BY
        skills.skill_id, skills.skills
),
avg_salary AS (
    SELECT
        s.skill_id,
        s.skills,
        ROUND(AVG(jobs.salary_year_avg),2) AS avg_salary
    FROM
        job_postings_fact AS jobs
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id = jobs.job_id
    INNER JOIN
        skills_dim AS s ON s.skill_id = skills_job_dim.skill_id
    WHERE
        jobs.salary_year_avg IS NOT NULL AND
        jobs.job_title_short = 'Data Analyst' AND
        jobs.job_country = 'Singapore'
    GROUP BY
        s.skill_id, s.skills
)

SELECT
    demanded_skills.skills,
    demanded_skills.skill_count,
    avg_salary.avg_salary
FROM
    demanded_skills
INNER JOIN
    avg_salary ON demanded_skills.skill_id = avg_salary.skill_id
ORDER BY   
    demanded_skills.skill_count DESC,
    avg_salary.avg_salary DESC;
```
![Optimal skills to learn](assets\5_optimal_skills_to_learn.png)
# What I learned

Through this project, I strengthened my SQL skills by working with real-world job posting data. I practiced using joins to combine tables, common table expressions (CTEs) to organize queries, and aggregate functions to analyze skill demand and salary data.

I also learned how to approach business questions with data, compare different metrics, and recognize that skills associated with higher salaries do not necessarily cause those higher salaries.

Finally, I gained experience organizing a SQL project in VS Code and using Git and GitHub to track changes and share my work.
# Conclusions

This project used SQL to explore the Data Analyst job market in Singapore, focusing on top-paying jobs, in-demand skills, and skills associated with higher average salaries.

The analysis provides useful insights into the skills employers request and the skills worth considering for further learning. However, higher salary does not necessarily mean a skill directly causes higher pay, and demand and salary should both be considered when choosing which skills to learn.

Overall, this project strengthened my SQL skills and helped me use data to explore career opportunities as an aspiring Data Analyst.
