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