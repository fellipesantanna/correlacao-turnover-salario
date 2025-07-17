# Definição do Problema

Este projeto investiga a relação entre faixas salariais e taxas de turnover (rotatividade) utilizando dados anonimizados de funcionários.

Seguem os objetivos:
- Identificar padrões de desligamento por nível salarial
- Diferenciar entre saídas voluntárias e involuntárias
- Projetar impactos financeiros com base em literatura especializada

Ferramentas:
- PostgreSQL (análise)

# A Análise

## Metodologia

### Preparação dos Dados

```sql
-- Criação de faixas salariais
SELECT 
  id,
  CASE
    WHEN salary <= 6000 THEN 'Até R$6.000'
    WHEN salary <= 10000 THEN 'R$6.001–10.000'
    ELSE 'Acima de R$10.000'
  END AS salary_range,
  attrition,
  exit_reason
FROM employees
ORDER BY id;
```

### Análise Principal

**Taxa de Turnover por Faixa**

```sql
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
```

**Resultados:**

<img width="1149" height="87" alt="image" src="https://github.com/user-attachments/assets/ff4c0a97-0f20-4dcd-9a75-6938d3c6831c" />


# Principais Descobertas

## Padrões Identificados

- Funcionários com salários ≤ R$6k:
   - 44.4% de turnover (50% voluntário e 50% involuntário)
   - Tempo médio até saída: 39 meses (3 anos e 3 meses)
   - *Interpretação:* Rotatividade equilibrada entre pedidos de demissão e desligamentos feitos pela empresa, após período considerável na empresa
- Funcionários com salários > R$10k:
   - 50% de turnover (66% voluntário e 34% involuntário)
   - Tempo médio até saída: 58 meses (4 anos e 10 meses)
   - *Interpretação:* Rotatividade equilibrada entre pedidos de demissão e demissões, após período considerável na empresa

## Projeção de Impacto Financeiro
*(Baseado em estudos da SHRM - Society of Human Resources Management)*

Fórmula: ``Custo por desligamento = 1.5 x salário mensal``

***Custo Anuais Projetados***

|Faixa Salarial|Saídas|Custo Médio|Total   |
|--------------|------|-----------|--------|
|Até R$6k      |8     |R$9.000    |R$72.000|
|R$6k - R$10k  |7     |R$12.000   |R$60.000|
|Acima de R$10k|6     |R$22.500   |67.500  |
|Total Estimado: R$199.500                 |

## Insights

- **Problema Crítico:**
   - Perda significativa de colaboradores experientes (>R$10k) que pedem demissão após quase 5 anos
   - Possíveis causas:
      - Estagnação na carreira
      - Falta de desafios/progressão
      - Ofertas externas mais atrativas
- **Oportunidade:**
   - Turnover em faixas baixas ocorre após tempo considerável (3+ anos)
   - Sugere que processos de retenção inicial são eficazes

# Recomendações

- Para Alto Turnover Voluntário em Faixas Altas (>R$10k):
   - Programa de Retenção de Talentos Seniores:
      - Revisão de planos de carreira para funcionários com +4 anos
      - Projetos desafiadores e rotatividade de funções
   - Pesquisa de Engajamento:
      - Investigar motivos específicos das saídas voluntárias
      - Foco em: crescimento profissional, reconhecimento, benefícios

- Para Turnover em Faixas Baixas (≤R$6k):
   - Análise de Desempenho:
      - Investigar os 50% de demissões involuntárias
      - Melhorar processos seletivos e onboarding
   - Programa de Progressão:
      - Caminhos claros de promoção em 2-3 anos
      - Aumentos salariais atrelados a metas

# Plano de Ação Prioritário

- Foco Imediato
   - Diagnosticar causas da saída de seniores (entrevistas de desligamento)
   - Criar programa de desenvolvimento para funcionários com +3 anos de casa
- Métricas de Sucesso:
   - Reduzir turnover voluntário em >R$10k para <35% em 12 meses
   - Aumentar tempo médio até saída para >5 anos em faixas altas
 
Esta análise revela que o problema central não está na retenção inicial, mas na incapacidade de reter talentos experientes

# Estrutura do Repositório

```
📁 correlacao-salario-turnover/
├── 📄 README.md               # Este arquivo
├── 📁 data/
│   └── 📄 employees_data.csv  # Dados anonimizados
├── 📁 sql/
│   ├── 📄 setup.sql           # Criação da tabela
│   └── 📄 analysis.sql        # Queries completas
└── 📁 docs/
    └── 📄 references.md       # Fontes teóricas
```

# Como Utilizar

1. Clone o repositório:
```bash
git clone https://github.com/fellipesantanna/correlacao-salario-turnover.git
```
2. Importe os dados para PostgreSQL:
```bash
psql -h localhost -d hr_analytics -f data/employees_data.csv
```
3. Execute as análises
```bash
psql -h localhost -d hr_analytics -f sql/analysis.sql
```
