# Databricks notebook source
library(sparklyr)
library(dplyr)
sc <- spark_connect(method = "databricks")
options(repr.plot.height = 600)

# COMMAND ----------

tbl_change_db(sc, "silver_olist") # database default
order_items = spark_read_table(sc, "order_items")
products = spark_read_table(sc, "products")

# COMMAND ----------

glimpse(order_items)

# COMMAND ----------

glimpse(products)

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC # Exercicio 1
# MAGIC 
# MAGIC Traduzir o codigo SQL abaixo para R
# MAGIC 
# MAGIC ```
# MAGIC create table order_items_preabt as
# MAGIC select
# MAGIC     idSeller,
# MAGIC     idOrder,
# MAGIC     idProduct,
# MAGIC     count(idOrderItem) as qt_itens,
# MAGIC     sum(vlPrice) as value_price,
# MAGIC     sum(vlFreight) as value_freight
# MAGIC from order_items
# MAGIC group by
# MAGIC     idOrder,
# MAGIC     idProduct,
# MAGIC     idSeller;
# MAGIC ```
# MAGIC 
# MAGIC vocabularios: group_by(), summarise(), n(), n_distinct(), sum()

# COMMAND ----------

order_items_preabt = 

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC # Exercicio 2
# MAGIC 
# MAGIC Traduzir o codigo SQL abaixo para R.
# MAGIC 
# MAGIC ```
# MAGIC CREATE TABLE olist_products_preabt as
# MAGIC SELECT 
# MAGIC   idSeller,
# MAGIC   count(idProduct) as qtd_produtos_vendendo,
# MAGIC   1.0*sum(nrPhotos)/count(idProduct) as media_num_fotos_por_produto
# MAGIC FROM (
# MAGIC   SELECT 
# MAGIC     distinct oit.idSeller, 
# MAGIC     prd.* 
# MAGIC   FROM order_items_preabt oit
# MAGIC   INNER JOIN products prd
# MAGIC   ON oit.idProduct = prd.idProduct
# MAGIC ) selprod
# MAGIC GROUP BY idSeller;
# MAGIC ```
# MAGIC 
# MAGIC vocabularios: group_by(), summarise(), n(), n_distinct(), sum()

# COMMAND ----------

subquery = 


olist_products_preabt = 

# COMMAND ----------

olist_products_preabt

# COMMAND ----------


