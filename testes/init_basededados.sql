
/*
=============================================================
Criação da Base de Dados e dos Esquemas
=============================================================

Objetivo do Script:
    Este script cria uma nova base de dados chamada
    'DataWarehouse', verificando previamente se ela já existe.

    Caso a base de dados exista, ela será eliminada e criada
    novamente. Em seguida, serão criados três esquemas para
    organizar os dados de acordo com as camadas da arquitetura
    de um Data Warehouse: Bronze, Prata e Ouro.

Atenção:
    A execução deste script eliminará permanentemente a base
    de dados 'DataWarehouse', caso ela já exista, incluindo
    todas as tabelas, os dados e os demais objetos armazenados.

    Certifique-se de que possui cópias de segurança (backups)
    antes de executar este script.

=============================================================
*/

USE master;
GO

-- Elimina a base de dados existente, caso seja encontrada.
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Cria a base de dados 'DataWarehouse'.
CREATE DATABASE DataWarehouse;
GO

-- Seleciona a base de dados 'DataWarehouse' para utilização.
USE DataWarehouse;
GO

-- Cria os esquemas correspondentes às três camadas do Data Warehouse.

-- Camada Bronze: armazena os dados brutos, conforme são recebidos das fontes.
CREATE SCHEMA bronze;
GO

-- Camada Prata: armazena os dados limpos, tratados e padronizados.
CREATE SCHEMA prata;
GO

-- Camada Ouro: armazena os dados preparados para análises e relatórios.
CREATE SCHEMA ouro;
GO
