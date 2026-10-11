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
