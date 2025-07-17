SELECT 
  CASE
    WHEN salary <= 6000 THEN 'Até R$6.000'
    WHEN salary <= 10000 THEN 'R$6.001–10.000'
    ELSE 'Acima de R$10.000'
  END AS salary_range,
  COUNT(*) AS total,
  SUM(CASE WHEN attrition THEN 1 ELSE 0 END) AS saidas,
  SUM(CASE WHEN attrition = true AND exit_reason = 'voluntario' THEN 1 ELSE 0 END) AS desligamentos_voluntarios,
  SUM(CASE WHEN attrition = true AND exit_reason = 'involuntario' THEN 1 ELSE 0 END) AS desligamentos_involuntarios,
  ROUND(AVG((exit_date - join_date) / 30.0), 1) AS meses_ate_saida,
  COUNT(*) AS total_saidas,
  ROUND(100.0 * SUM(CASE WHEN attrition THEN 1 ELSE 0 END) / COUNT(*), 1) || '%' AS taxa_turnover
FROM employees
GROUP BY salary_range;
