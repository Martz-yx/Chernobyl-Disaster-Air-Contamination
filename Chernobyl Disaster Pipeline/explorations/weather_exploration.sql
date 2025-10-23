-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Weather Exploratory Notebook

-- COMMAND ----------

USE CATALOG `workspace`;
USE SCHEMA `default`;

-- COMMAND ----------

SELECT * from workspace.default.weatherclean
