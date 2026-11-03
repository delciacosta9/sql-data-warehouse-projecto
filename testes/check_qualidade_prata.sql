/*
===============================================================================
Verificações de Qualidade
===============================================================================
Objetivo do Script:
    Este script realiza várias verificações de qualidade para garantir a
    consistência, precisão e padronização dos dados em toda a camada 'prata'.
    Inclui verificações de:
    - Chaves primárias com valores NULL ou duplicados.
    - Espaços indesejados nos campos de texto.
    - Padronização e consistência dos dados.
    - Intervalos e sequências de datas inválidas.
    - Consistência dos dados entre campos relacionados.

Notas de Utilização:
    - Executar estas verificações após o carregamento dos dados na camada Prata.
    - Investigar e resolver quaisquer discrepâncias encontradas durante as verificações.
===============================================================================
*/

-- ====================================================================
-- Verificação da tabela 'prata.crm_cust_info'
-- ====================================================================
-- Verificar valores NULL ou duplicados na chave primária
-- Resultado esperado: Nenhum resultado
SELECT
    cst_id,
    COUNT(*)
FROM prata.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Verificar a existência de espaços indesejados
-- Resultado esperado: Nenhum resultado
SELECT
    cst_key
FROM prata.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Verificar a padronização e consistência dos dados
SELECT DISTINCT
    cst_marital_status
FROM prata.crm_cust_info;

-- ====================================================================
-- Verificação da tabela 'prata.crm_prd_info'
-- ====================================================================
-- Verificar valores NULL ou duplicados na chave primária
-- Resultado esperado: Nenhum resultado
SELECT
    prd_id,
    COUNT(*)
FROM prata.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Verificar a existência de espaços indesejados
-- Resultado esperado: Nenhum resultado
SELECT
    prd_nm
FROM prata.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Verificar valores NULL ou negativos no custo
-- Resultado esperado: Nenhum resultado
SELECT
    prd_cost
FROM prata.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Verificar a padronização e consistência dos dados
SELECT DISTINCT
    prd_line
FROM prata.crm_prd_info;

-- Verificar sequências de datas inválidas (Data de início > Data de fim)
-- Resultado esperado: Nenhum resultado
SELECT
    *
FROM prata.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Verificação da tabela 'prata.crm_sales_details'
-- ====================================================================
-- Verificar datas inválidas
-- Nota: Esta verificação consulta a camada Bronze, porque na camada Prata
-- estas colunas já estão armazenadas como datas válidas.
-- Resultado esperado: Nenhuma data inválida
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LEN(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- Verificar sequências de datas inválidas (Data da encomenda > Data de envio/prazo de entrega)
-- Resultado esperado: Nenhum resultado
SELECT
    *
FROM prata.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Verificar a consistência dos dados: Vendas = Quantidade * Preço
-- Resultado esperado: Nenhum resultado
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM prata.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Verificação da tabela 'prata.erp_cust_az12'
-- ====================================================================
-- Identificar datas fora do intervalo permitido
-- Resultado esperado: Datas de nascimento entre 1924-01-01 e a data atual
SELECT DISTINCT
    bdate
FROM prata.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Verificar a padronização e consistência dos dados
SELECT DISTINCT
    gen
FROM prata.erp_cust_az12;

-- ====================================================================
-- Verificação da tabela 'prata.erp_loc_a101'
-- ====================================================================
-- Verificar a padronização e consistência dos dados
SELECT DISTINCT
    cntry
FROM prata.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Verificação da tabela 'prata.erp_px_cat_g1v2'
-- ====================================================================
-- Verificar a existência de espaços indesejados
-- Resultado esperado: Nenhum resultado
SELECT
    *
FROM prata.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Verificar a padronização e consistência dos dados
SELECT DISTINCT
    maintenance
FROM prata.erp_px_cat_g1v2;
