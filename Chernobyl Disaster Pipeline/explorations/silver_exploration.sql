-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Weather Exploratory Notebook

-- COMMAND ----------

USE CATALOG `workspace`;
USE SCHEMA `default`;

-- COMMAND ----------

DESCRIBE TABLE weatherclean;
SELECT * FROM weatherclean;

-- COMMAND ----------

SELECT DISTINCT SNOW FROM weatherclean

-- COMMAND ----------

SELECT DISTINCT NAME FROM weatherclean;

-- COMMAND ----------

SELECT DISTINCT Country FROM weatherclean

-- COMMAND ----------

SELECT wc.Country, wc.City,cc.Country as chernoCountry, cc.City as chernoCity
FROM (
  SELECT Country, City
  FROM chernoclean
  GROUP BY Country, City
) cc
INNER JOIN (
  SELECT Country, City
  FROM weatherclean
  GROUP BY Country, City
) wc
ON cc.Country = wc.Country AND cc.City = wc.City

-- COMMAND ----------

SELECT DISTINCT City FROM chernoclean
WHERE City like '%BERLIN%'


-- COMMAND ----------

SELECT * FROM weatherclean
WHERE Precipitation IS NOT NULL
AND DATE BETWEEN ("1986-04-26") AND ("1986-04-29")
