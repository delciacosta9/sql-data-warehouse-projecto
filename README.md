# Data Warehouse e Análise de Vendas com SQL Server

### Sobre o Projeto

Este projeto consiste na construção de um Data Warehouse moderno utilizando SQL Server, com o objetivo de integrar, transformar e analisar dados de vendas provenientes de dois sistemas de origem: ERP (Enterprise Resource Planning) e CRM (Customer Relationship Management).

A solução segue a Arquitetura Medallion (Bronze, Silver e Gold), organizando os dados em diferentes camadas de processamento, desde a ingestão dos dados brutos até à disponibilização de dados estruturados e prontos para análises de negócio.

O projeto abrange todo o processo de Engenharia de Dados, incluindo a ingestão, limpeza, transformação, integração e modelagem dos dados, culminando no desenvolvimento de análises SQL para gerar insights sobre clientes, produtos e desempenho das vendas.

---

### Objetivos do Projeto

Construir um Data Warehouse moderno utilizando SQL Server.
Integrar dados provenientes de sistemas ERP e CRM.
Implementar pipelines de ETL (Extract, Transform, Load).
Garantir a qualidade, consistência e fiabilidade dos dados.
Desenvolver um modelo dimensional baseado num esquema estrela (Star Schema).
Criar análises SQL para apoiar a tomada de decisões estratégicas.
Documentar a arquitetura e o modelo de dados para facilitar a compreensão e a manutenção da solução.

---

### Arquitetura de Dados

A arquitetura do projeto segue o modelo Medallion, composto por três camadas principais:
<img width="1352" height="631" alt="Datawarehouse" src="https://github.com/user-attachments/assets/b4acdcca-5caa-4c90-9bfa-306d0f89bbd5" />


#### 🥉 1. Camada Bronze — Dados Brutos

Responsável pela ingestão e armazenamento dos dados originais, provenientes dos sistemas ERP e CRM, disponibilizados em ficheiros CSV. Nesta camada, os dados são carregados para o SQL Server, preservando a estrutura e os valores recebidos das fontes de origem, de forma a manter a rastreabilidade do processo de ingestão.

#### 🥈 2. Camada Prata — Dados Transformados

Esta camada é responsável pela preparação e melhoria da qualidade dos dados antes da sua utilização analítica. São aplicadas regras de transformação para corrigir inconsistências, uniformizar formatos e garantir a integridade dos dados provenientes dos diferentes sistemas.

#### 🥇 3. Camada Ouro — Dados Analíticos

A camada Ouro disponibiliza dados organizados e preparados para responder às necessidades analíticas do negócio. Nesta fase, os dados são estruturados num modelo dimensional baseado num esquema estrela (Star Schema), composto por tabelas de factos e dimensões, facilitando a criação de consultas SQL, relatórios e dashboards.

---

### Pipeline de ETL

O processo de ETL é responsável por transportar os dados desde os sistemas de origem até ao modelo analítico final.

**Extração (Extract)**: leitura e ingestão dos ficheiros CSV provenientes dos sistemas ERP e CRM.
**Transformação (Transform)**: limpeza, padronização, validação e integração dos dados.
**Carregamento (Load)**: armazenamento dos dados nas respetivas camadas do Data Warehouse, disponibilizando informação estruturada para análise.

---

### Modelagem de Dados

O modelo analítico segue a abordagem dimensional, utilizando o esquema estrela para simplificar as consultas e melhorar a compreensão dos dados.

**Tabela de Factos**: concentra os eventos e as métricas quantitativas relacionadas com as vendas.
**Tabelas de Dimensões**: fornecem o contexto necessário para analisar os factos, como clientes, produtos e outras entidades relevantes para o negócio.

Após a construção do Data Warehouse, são desenvolvidas análises com SQL para transformar os dados em informação útil para o negócio.

---

### Principais áreas de análise

#### Comportamento dos Clientes

Análise do comportamento de compra.
Identificação dos clientes com maior contribuição para as vendas.
Avaliação do desempenho dos clientes com base nas métricas disponíveis.

#### Desempenho dos Produtos

Identificação dos produtos com melhor desempenho.
Comparação dos resultados de vendas entre produtos.
Análise da contribuição dos produtos para o desempenho comercial.

#### Tendências de Vendas

Análise do desempenho global das vendas.
Identificação de padrões e tendências nos dados disponíveis.
Comparação de métricas de vendas para apoiar decisões estratégicas.
As análises permitem às partes interessadas acompanhar indicadores relevantes, identificar oportunidades de melhoria e tomar decisões fundamentadas em dados.

#### Tecnologias e Ferramentas

- **SQL Server**: armazenamento e gestão dos dados.
- **SQL**: transformação, validação, modelagem e análise dos dados.
- **CSV**: formato dos ficheiros de origem.
- **ETL**: processo de extração, transformação e carga.
- **Data Warehouse**: centralização e organização dos dados para análise.
- **Arquitetura Medallion**: organização dos dados nas camadas Bronze, Prata e Ouro.
- **Modelagem Dimensional**: estruturação dos dados através do esquema estrela.

---

### O projeto foi concebido para cumprir os seguintes requisitos:

Integração de dados de duas fontes: ERP e CRM.
Tratamento de problemas de qualidade antes da análise.
Consolidação dos dados num modelo analítico único.
Utilização do conjunto de dados mais recente, sem necessidade de historização dos registos.
Documentação da arquitetura e do modelo de dados.
Disponibilização de informação para análises SQL e apoio à decisão.

---

### Documentação do Projeto

A documentação tem como objetivo facilitar a compreensão da solução, tanto para as partes interessadas do negócio como para as equipas técnicas.
Inclui a descrição da arquitetura de dados, das etapas de processamento, das regras de transformação e da estrutura do modelo dimensional.
Para uma visão completa da implementação, consulta os ficheiros e scripts disponibilizados neste repositório.

---

#### Sobre Mim

Olá! Sou a Delcia Costa, estudante de Engenharia Informática, com foco na área de Dados.

Atualmente, trabalho como Analista de Dados numa empresa de construção civil e também desenvolvo projetos freelance para empresas em fase inicial, ajudando-as a compreender melhor o desempenho do negócio através de dashboards, relatórios e análises de dados.

Tenho interesse em transformar dados em informação relevante para apoiar a tomada de decisões, melhorar processos e identificar oportunidades de crescimento.

Este projeto representa uma oportunidade para aprofundar os meus conhecimentos em Engenharia de Dados, SQL, Data Warehousing, modelagem dimensional e Business Intelligence.

#### Créditos e Agradecimentos

Este projeto foi desenvolvido com inspiração nos conteúdos e materiais educativos de Data with Baraa, que contribuíram para a aprendizagem e compreensão dos conceitos de Engenharia de Dados, arquitetura Medallion, construção de Data Warehouses e modelagem dimensional.

Agradeço ao Data with Baraa pela partilha de conhecimento e pelos recursos disponibilizados à comunidade de dados.

**Criadora deste projeto**: Delcia Costa
**Autor de referência**: Data with Baraa
**Tutorial de referência**: Assistir ao tutorial no YouTube
Os créditos relativos aos materiais, conteúdos e recursos originais pertencem aos respetivos autores.

# Contacto

Se tiveres interesse em trocar ideias sobre Engenharia de Dados, Análise de Dados ou Business Intelligence, será um prazer conectar-me com outros profissionais e entusiastas da área.

# GitHub: Explora os meus projetos

# E-mail: delciacorreia@gmail.com

Delcia Costa
Estudante de Engenharia Informática | Analista de Dados | Data Enthusiast

⭐ Se este projeto te for útil, considera deixar uma estrela no repositório!
