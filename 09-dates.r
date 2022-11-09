# Databricks notebook source
# fonte: https://r4ds.had.co.nz/dates-and-times.html
install.packages("nycflights13")

# COMMAND ----------

library(nycflights13)
library(tidyverse, warn.conflicts=FALSE)
library(lubridate)
library(sparklyr)
library(dbplyr)

sc <- spark_connect(method = "databricks")
options(repr.plot.height = 600)

# COMMAND ----------

glimpse(flights)

# COMMAND ----------

display(flights)

# COMMAND ----------

# POSIXct eh o mesmo que datetime
class(flights$time_hour)

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC # Funções

# COMMAND ----------

# MAGIC %md
# MAGIC ## Criando datas

# COMMAND ----------

# date
today()

# COMMAND ----------

# datetime
now()

# COMMAND ----------

ymd("2017-01-31")

# COMMAND ----------

mdy("January 31st, 2017")

# COMMAND ----------

dmy("31-Jan-2017")

# COMMAND ----------

ymd(20170131)

# COMMAND ----------

ymd_hms("2017-01-31 20:11:59")

# COMMAND ----------

mdy_hm("01/31/2017 08:01")

# COMMAND ----------

# cuidado com datas que nao existem! Fevereiro soh tem 29 em ano bissexto, por exemplo.
ymd("2021-02-29") 

# COMMAND ----------

seq(ymd("2021-01-01"), ymd("2021-03-01"), "4 days")

# COMMAND ----------

quatro_em_quatro_dias = tibble(
  dia = seq(ymd("2021-01-01"), ymd("2021-03-01"), "4 days"),
  valor = runif(length(dia))
)

quatro_em_quatro_dias

# COMMAND ----------

# MAGIC %md
# MAGIC ## Convertendo para date e datetime
# MAGIC 
# MAGIC as_date() e as_datetime()

# COMMAND ----------

as_datetime(today())

# COMMAND ----------

as_date(now())

# COMMAND ----------

as_datetime(c(1, 60 * 60 * 10))

# COMMAND ----------

as_date(c(1, 365 * 10 + 2))

# COMMAND ----------

# Exercicio: use a funcao correta para parsear as seguintes datas.
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ## Componentes das datas

# COMMAND ----------

datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)

# COMMAND ----------

month(datetime)

# COMMAND ----------

mday(datetime)

# COMMAND ----------

yday(datetime)

# COMMAND ----------

wday(datetime)

# COMMAND ----------

set.seed(42)
flights %>%
  select(time_hour) %>%
  sample_n(10) %>%
  mutate(
    year = year(time_hour),
    month = month(time_hour),
    mday = mday(time_hour),
    yday = yday(time_hour),
    wday = wday(time_hour),
    hour = hour(time_hour),
    minute = minute(time_hour)
  ) %>%
  display()

# COMMAND ----------

# MAGIC %md
# MAGIC ## Arrendondamentos de datas
# MAGIC 
# MAGIC floor_date()

# COMMAND ----------

flights_floor_date <- flights %>%
  select(time_hour) %>%
  mutate(
    year = floor_date(time_hour, "year"),
    month = floor_date(time_hour, "month"),
    quarter = floor_date(time_hour, "3 months"),
    day = floor_date(time_hour, "day")
  ) 

# COMMAND ----------

set.seed(42)
flights_floor_date %>%
  sample_n(5) %>%
  display()

# COMMAND ----------

flights_floor_date %>% count(year)

# COMMAND ----------

flights_floor_date %>% count(quarter)

# COMMAND ----------

flights_floor_date %>% count(month)

# COMMAND ----------

# Exercicio: faça a contagem de vôos a cada duas semanas.
flights_duas_semanas <- flights %>%
  select(time_hour) %>%
  mutate(
    #preencha aqui
  ) 

flights_duas_semanas %>% count(#preencha aqui)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Operações aritméticas com datas

# COMMAND ----------

ymd("2020-01-01") + days(12)

# COMMAND ----------

set.seed(42)
flights %>%
  select(time_hour) %>%
  sample_n(10) %>%
  mutate(
    add_days = time_hour + seconds(33) + minutes(15) + days(10) + weeks(4) - years(1),
    time_hour_diff = time_hour - add_days,
    time_hour_diff_as_num = as.numeric(time_hour - add_days)
  ) 

# COMMAND ----------

date_ref <- ymd("2013-10-01")

flights %>% filter(time_hour < date_ref)
flights %>% filter(time_hour < date_ref, time_hour >= date_ref - weeks(3))

# COMMAND ----------

date_ref <- ymd("2013-10-01")

flights %>% filter(time_hour < date_ref) %>% summarise(range(time_hour))

# COMMAND ----------

flights %>% filter(time_hour < date_ref, time_hour >= date_ref - weeks(3)) %>% summarise(range(time_hour))

# COMMAND ----------

flights %>% dplyr::filter(time_hour %>% between(date_ref, date_ref - weeks(3))) %>% summarise(range(time_hour))

# COMMAND ----------

# MAGIC %md
# MAGIC ## Limitacoes entre lubridate e Sparklyr
# MAGIC 
# MAGIC referencia: https://sparkbyexamples.com/spark/spark-sql-date-and-time-functions/

# COMMAND ----------

orders = tbl(sc, in_schema("silver_olist", "orders"))

# COMMAND ----------

# as funcoes unix_timestamp() e date_trunc() sao funcoes exclusivas do Spark SQL
orders_exemplo <- orders %>%
  sample_n(10) %>%
  select(dtPurchase, dtApproved) %>%
  mutate(
    time_to_approval = unix_timestamp(dtApproved) - unix_timestamp(dtPurchase),
    year = date_trunc("year", dtPurchase),
    month = date_trunc("month", dtPurchase),
    quarter = date_trunc("3 months", dtPurchase),
    day = date_trunc("day", dtPurchase)
  ) 

# COMMAND ----------

orders_exemplo %>%
  collect() %>%
  display()

# COMMAND ----------

show_query(orders_exemplo)

# COMMAND ----------


