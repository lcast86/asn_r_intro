# Databricks notebook source
library(tidyverse)
library(DBI)
library(dbplyr)
library(sparklyr)
sc = spark_connect(method = "databricks")
options(repr.plot.height = 600)

# COMMAND ----------

# codigo do teo em py: 
#
# spark_dataframe = spark.table("silver_olist.order_items")
# df = spark_dataframe.toPandas()

tbl_change_db(sc, "silver_olist")
spark_dataframe = 
df = 

# COMMAND ----------

# type(df)

class(df)

# COMMAND ----------

# df.head()



# COMMAND ----------

# df[ df['vlPrice'] > 100 ]



# COMMAND ----------

# df['log_price'] = np.log( df['vlPrice'] )
# df['vlFreightLog'] = np.log( df['vlFreight']+1 )
#

# Jeito 1 de criar colunas novas

# Jeito 2 de criar colunas novas


# COMMAND ----------

# plt.hist( df['vlPrice'])
# plt.grid(True)
# plt.title("Histograma para Preço de Produto")
# plt.xlabel("Valores de Produto")
# plt.ylabel("Frequencia")
# plt.show()

hist(
  df$vlPrice, 
  main = "Histograma para Preço de Produto", 
  xlab = "Valores de Produto",
  ylab = "Frequencia",
)

# COMMAND ----------

# plt.hist( df['vlPriceLog'])
# plt.grid(True)
# plt.title("Histograma para Preço de Produto (log)")
# plt.xlabel("Valores de Produto em Log")
# plt.ylabel("Frequencia")
# plt.legend(["Valores em log"])
# plt.show()

hist(
  df$vlPriceLog, 
  main = "Histograma para Preço de Produto (log)", 
  xlab = "Valores de Produto em Log",
  ylab = "Frequencia"
)

# COMMAND ----------

# plt.hist( df['vlPriceLog'], density=True, alpha=0.5, color='royalblue')
# plt.hist( df['vlFreightLog'], density=True, alpha=0.5, color='tomato')
# plt.grid(True)
# plt.title("Histograma para Preço de Produto (log)")
# plt.xlabel("Valores de Produto em Log")
# plt.ylabel("Frequencia")
# plt.legend(["Valores Produto em log", "Valores Frete em Log"])
# plt.show()

ggplot(df) +
  geom_histogram(aes(x = vlPriceLog, fill = "Valores Produto em log"), alpha = 0.5) +
  geom_histogram(aes(x = vlFreightLog, fill = "Valores Frete em log"), alpha = 0.5)

# COMMAND ----------

# df[['vlPriceLog', 'vlFreightLog']].describe()

summary(df[,c('vlPriceLog', 'vlFreightLog')])

# COMMAND ----------

# df['vlTotalPrice'] = df['vlPrice'] + df['vlFreight']
# df['vlTotalPriceLog'] = np.log( df['vlPrice'] + df['vlFreight'] )
# df.head(4)



# COMMAND ----------

# df = (df.sort_values(by='vlTotalPrice')  # Aqui ordenamos
#         .reset_index(drop=True))         # Aqui resetamos os inidices
# df.head()

#PS: no R nao tem reset_index!





# COMMAND ----------

# condicao_numerico = (df.dtypes ==  'int64') | (df.dtypes ==  'float32') # uma serie booleana

# var_nums = df.dtypes[condicao_numerico].index.tolist()
# df[var_nums].describe()

df %>% 
  select(where(is.numeric)) %>% 
  summary()

# COMMAND ----------

# import seaborn as sn

# correlacao = df[var_nums].corr()
# sn.heatmap(correlacao)

#install.packages("corrplot")
library(corrplot)

df %>% 
  select(where(is.numeric)) %>%
  cor() %>%
  corrplot()

# COMMAND ----------

df

# COMMAND ----------

# df['idOrderItem'] = df['idOrderItem'].astype('float')
# df.dtypes



# COMMAND ----------

# install.packages("jsonlite")
data = jsonlite::fromJSON("https://resultados.tse.jus.br/oficial/ele2022/544/dados-simplificados/br/br-c0001-e000544-r.json")

display(data$cand)
