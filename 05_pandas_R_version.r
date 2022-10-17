# Databricks notebook source
library(tidyverse)
library(DBI)
library(dbplyr)
library(sparklyr)
sc = spark_connect(method = "databricks")

# COMMAND ----------

tbl_change_db(sc, "silver_olist")
spark_dataframe = tbl(sc, "order_items")
df = collect(spark_dataframe)

# COMMAND ----------

class(df)

# COMMAND ----------

head(df)

# COMMAND ----------

df %>%
filter(vlPrice > 100)

# COMMAND ----------

# Jeito 1 de criar colunas novas
df$log_price = log(df$vlPrice)
df$vlFreightLog = log(df$vlFreight + 1)

# Jeito 2 de criar colunas novas
df = df %>%
  mutate(
    log_price = log(vlPrice),
    vlFreightLog = log(vlFreight + 1)
  )

# Rename
df = df %>%
  rename(
    vlPriceLog = log_price
  )

# COMMAND ----------

hist(
  df$vlPrice, 
  main = "Histograma para Preço de Produto", 
  xlab = "Valores de Produto",
  ylab = "Frequencia",
)

# COMMAND ----------

hist(
  df$vlPriceLog, 
  main = "Histograma para Preço de Produto (log)", 
  xlab = "Valores de Produto em Log",
  ylab = "Frequencia"
)

# COMMAND ----------

ggplot(df) +
  geom_histogram(aes(x = vlPriceLog, fill = "Valores Produto em log"), alpha = 0.5) +
  geom_histogram(aes(x = vlFreightLog, fill = "Valores Frete em log"), alpha = 0.5)

# COMMAND ----------

summary(df[,c('vlPriceLog', 'vlFreightLog')])

# COMMAND ----------

df['vlTotalPrice'] = df['vlPrice'] + df['vlFreight']
df['vlTotalPriceLog'] = log( df['vlPrice'] + df['vlFreight'] )
head(df, 4) %>% display()

# COMMAND ----------

df = df %>%
  arrange(vlTotalPrice)

display(df)

# COMMAND ----------

df %>% 
  select(where(is.numeric)) %>% 
  summary()

# COMMAND ----------

#install.packages("corrplot")
library(corrplot)

df %>% 
  select(where(is.numeric)) %>%
  cor() %>%
  corrplot()

# COMMAND ----------

df

# COMMAND ----------

unlist(df["idOrderItem"])

# COMMAND ----------

df$idOrderItem = as.numeric(df$idOrderItem)  

# COMMAND ----------

# install.packages("jsonlite")
data = jsonlite::fromJSON("https://resultados.tse.jus.br/oficial/ele2022/544/dados-simplificados/br/br-c0001-e000544-r.json")

display(df)

# COMMAND ----------


