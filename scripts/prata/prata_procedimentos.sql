/*
===============================================================================
Procedimento Armazenado: Carregar Camada Prata (Bronze -> Prata)
===============================================================================
Objetivo do Script:
    Este procedimento armazenado executa o processo ETL (Extração, Transformação
    e Carregamento) para preencher as tabelas do esquema 'prata' a partir
    do esquema 'bronze'.
    Ações Executadas:
        - Limpa as tabelas da camada Prata.
        - Insere dados transformados e tratados da camada Bronze nas tabelas
          da camada Prata.

Parâmetros:
    Nenhum.
      Este procedimento armazenado não aceita parâmetros nem retorna valores.
===============================================================================
*/

CREATE OR ALTER PROCEDURE prata.load_prata AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'A Carregar a Camada Prata';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'A Carregar Tabelas CRM';
        PRINT '------------------------------------------------';

        -- A carregar prata.crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>> A Limpar a Tabela: prata.crm_cust_info';
        TRUNCATE TABLE prata.crm_cust_info;
        PRINT '>> A Inserir Dados Na Tabela: prata.crm_cust_info';
        INSERT INTO prata.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_lastname)  AS cst_lastname,
            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END AS cst_marital_status, -- Normalizar os valores do estado civil para um formato legível
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END                           AS cst_gndr, -- Normalizar os valores do género para um formato legível
            cst_create_date
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1; -- Selecionar o registo mais recente de cada cliente
        SET @end_time = GETDATE();
        PRINT '>> Duração do Carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- A carregar prata.crm_prd_info
        SET @start_time = GETDATE();
        PRINT '>> A Limpar a Tabela: prata.crm_prd_info';
        TRUNCATE TABLE prata.crm_prd_info;
        PRINT '>> A Inserir Dados Na Tabela: prata.crm_prd_info';
        INSERT INTO prata.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extrair o identificador da categoria
            SUBSTRING(prd_key, 7, LEN(prd_key))         AS prd_key, -- Extrair o identificador do produto
            prd_nm,
            ISNULL(prd_cost, 0)                         AS prd_cost,
            CASE
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END                                         AS prd_line, -- Converter os códigos das linhas de produtos em valores descritivos
            CAST(prd_start_dt AS DATE)                  AS prd_start_dt,
            CAST(
                LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
                AS DATE
            ) AS prd_end_dt -- Calcular a data de fim como um dia antes da próxima data de início
        FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>> Duração do Carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- A carregar crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>> A Limpar a Tabela: prata.crm_sales_details';
        TRUNCATE TABLE prata.crm_sales_details;
        PRINT '>> A Inserir Dados Na Tabela: prata.crm_sales_details';
        INSERT INTO prata.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
            END AS sls_order_dt,
            CASE
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
            END AS sls_ship_dt,
            CASE
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
            END AS sls_due_dt,
            CASE
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales, -- Recalcular as vendas quando o valor original estiver em falta ou incorreto
            sls_quantity,
            CASE
                WHEN sls_price IS NULL OR sls_price <= 0
                    THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price  -- Calcular o preço quando o valor original for inválido
            END AS sls_price
        FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Duração do Carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        PRINT '------------------------------------------------';
        PRINT 'A Carregar Tabelas ERP';
        PRINT '------------------------------------------------';

        -- A carregar erp_cust_az12
        SET @start_time = GETDATE();
        PRINT '>> A Limpar a Tabela: prata.erp_cust_az12';
        TRUNCATE TABLE prata.erp_cust_az12;
        PRINT '>> A Inserir Dados Na Tabela: prata.erp_cust_az12';
        INSERT INTO prata.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            CASE
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Remover o prefixo 'NAS' caso esteja presente
                ELSE cid
            END AS cid,
            CASE
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate, -- Definir como NULL as datas de nascimento futuras
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS gen    -- Normalizar os valores do género e tratar os casos desconhecidos
        FROM bronze.erp_cust_az12;
        SET @end_time = GETDATE();
        PRINT '>> Duração do Carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- A carregar erp_loc_a101
        SET @start_time = GETDATE();
        PRINT '>> A Limpar a Tabela: prata.erp_loc_a101';
        TRUNCATE TABLE prata.erp_loc_a101;
        PRINT '>> A Inserir Dados Na Tabela: prata.erp_loc_a101';
        INSERT INTO prata.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT
            REPLACE(cid, '-', '') AS cid,
            CASE
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry)
            END                   AS cntry -- Normalizar e tratar os códigos de países em falta ou vazios
        FROM bronze.erp_loc_a101;
        SET @end_time = GETDATE();
        PRINT '>> Duração do Carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- A carregar erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT '>> A Limpar a Tabela: prata.erp_px_cat_g1v2';
        TRUNCATE TABLE prata.erp_px_cat_g1v2;
        PRINT '>> A Inserir Dados Na Tabela: prata.erp_px_cat_g1v2';
        INSERT INTO prata.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2;
        SET @end_time = GETDATE();
        PRINT '>> Duração do Carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'O Carregamento da Camada Prata Foi Concluído';
        PRINT '   - Duração Total do Carregamento: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' segundos';
        PRINT '=========================================='

    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'OCORREU UM ERRO DURANTE O CARREGAMENTO DA CAMADA PRATA'
        PRINT 'Mensagem de Erro: ' + ERROR_MESSAGE();
        PRINT 'Número do Erro: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Estado do Erro: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END
