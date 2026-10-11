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