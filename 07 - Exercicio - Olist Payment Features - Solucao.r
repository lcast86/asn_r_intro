# Databricks notebook source
library(sparklyr)
library(dplyr)
library(dbplyr)
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

order_payment_preabt = order_payment %>%
  group_by(idOrder) %>%
  summarise(
    qt_payments = n(),
    qt_payment_types = n_distinct(descType),
    value_boleto = sum(if_else(descType == 'boleto', vlPayment, 0)),
    value_credit_card = sum(if_else(descType == 'credit_card', vlPayment, 0)),
    value_voucher = sum(if_else(descType == 'voucher', vlPayment, 0)),
    value_debit_card = sum(if_else(descType == 'debit_card', vlPayment, 0)),
    .groups = "keep"
  )

# COMMAND ----------

order_payment_preabt

# COMMAND ----------

# versao com pivot_wider()
order_payment_preabt_2 = order_payment %>%
  group_by(idOrder, descType) %>%
  summarise(
    value = sum(vlPayment),
    .groups = "keep"
  ) %>%
  ungroup() %>%
  pivot_wider(names_from = "descType", values_from = "value", names_prefix = "value_", values_fill = 0)

# COMMAND ----------

order_payment_preabt_2

# COMMAND ----------

spark_write_table(order_payment_preabt_2, "temp_athos.order_payment_preabt_2")

# COMMAND ----------


