# Databricks notebook source
library(sparklyr)
library(dplyr)
sc <- spark_connect(method = "databricks")
options(repr.plot.height = 600)

# COMMAND ----------

tbl_change_db(sc, "silver_olist") # database default
order_payment = spark_read_table(sc, "order_payment")

# COMMAND ----------

glimpse(order_payment)

# COMMAND ----------

order_payment %>% count(descType)

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC # Exercicio 1
# MAGIC 
# MAGIC Traduzir o codigo SQL abaixo para R
# MAGIC 
# MAGIC ```
# MAGIC CREATE TABLE order_payment_preabt as
# MAGIC SELECT
# MAGIC     idOrder,
# MAGIC     count(nrSequential) as qt_payments,
# MAGIC     count(distinct descType) as qt_payment_types,
# MAGIC     sum(case when descType = 'boleto' then vlPayment else 0 end) as value_boleto,
# MAGIC     sum(case when descType = 'credit_card' then vlPayment else 0 end) as value_credit_card,
# MAGIC     sum(case when descType = 'voucher' then vlPayment else 0 end) as value_voucher,
# MAGIC     sum(case when descType = 'debit_card' then vlPayment else 0 end) as value_debit_card
# MAGIC FROM order_payment
# MAGIC GROUP BY idOrder;
# MAGIC ```
# MAGIC 
# MAGIC vocabularios: group_by, summarise, n(), n_distinct(), sum(), if_else()

# COMMAND ----------

order_payment_preabt = 

# COMMAND ----------

glimpse(order_payment_preabt)

# COMMAND ----------

# spark_write_table(order_payment_preabt, "temp_athos.order_payment_preabt")
