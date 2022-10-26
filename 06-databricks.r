# Databricks notebook source
# fonte: https://docs.databricks.com/sparkr/sparklyr.html

library(sparklyr)
library(dplyr)
library(dbplyr)
library(DBI)
sc <- spark_connect(method = "databricks")
options(repr.plot.height = 600)

# COMMAND ----------

# o database padrao eh o 'default' (e esta vazio)
src_tbls(sc) 

# COMMAND ----------

# lista os databases que tem
src_databases(sc)

# COMMAND ----------

# escollhe um database padrao
tbl_change_db(sc, "temp_athos")

# copia a tabela iris_cinco_linhas na memoria do Spark
iris_spark = copy_to(sc, iris)

# COMMAND ----------

# salva a tabela no database
spark_write_table(iris_spark, "iris")

# COMMAND ----------

# le a tabela no database (para a memoria do Spark)
iris_do_database_spark = spark_read_table(sc, "iris") # ou tbl(sc, "iris")
iris_do_database_spark

# COMMAND ----------

spark_write_csv(iris_spark, "iris_spark.csv")

# COMMAND ----------

# traz a tabela para a memoria do R
iris_do_database_r = collect(iris_do_database_spark)
display(iris_do_database_r)

# COMMAND ----------

iris_do_database_r

# COMMAND ----------

# agora temos tabelas dentro do database temp_athos
src_tbls(sc)

# COMMAND ----------

# codigo em R, rodando no spark
iris_do_database_spark %>% count()

# COMMAND ----------

iris_do_database_spark %>% count %>% show_query()

# COMMAND ----------

iris_summary <- iris_do_database_spark %>% 
  mutate(Sepal_Width = ROUND(Sepal_Width * 2) / 2) %>% # categorizando Sepal_Width
  group_by(Species, Sepal_Width) %>% 
  summarize(
    count = n(), 
    Sepal_Length_Mean = mean(Sepal_Length, na.rm = TRUE), 
    stdev = sd(Sepal_Length, na.rm = TRUE),
    .groups = "keep"
  )

# COMMAND ----------

iris_summary

# COMMAND ----------

iris_summary %>% show_query()

# COMMAND ----------

iris_summary %>%
  ggplot(aes(x = Sepal_Width, y = Sepal_Length_Mean, color = Species)) + 
  geom_line(size = 1.2) +
  geom_errorbar(aes(ymin = Sepal_Length_Mean - stdev, ymax = Sepal_Length_Mean + stdev), width = 0.05) +
  geom_text(aes(label = count), vjust = -0.2, hjust = 1.2, color = "black") +
  theme(legend.position="top")

# COMMAND ----------


