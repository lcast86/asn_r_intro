# Pacotes -----------------------------------------------------------------

# Para instalar pacotes

install.packages("tidyverse")
install.packages(c("skimr", "readxl", "writexl",
                   "openxlsx", "DBI", "RSQLite", "dbplyr",
                   "haven"))

# Para carregar pacotes

library(tidyverse)
library(dplyr)

# Também é possível acessar as funções usando ::

dplyr::select()



# Caminhos até o arquivo --------------------------------------------------

# Diretório de trabalho
getwd()
# setwd("dados/")

# Caminhos absolutos
"/home/william/Documents/Curso-R/intro-programacao-em-r-mestre/dados/tb_candidatura.csv"

# Caminhos relativos
"dados/tb_candidatura.csv"

# dica de navegação entre as aspas
""

# Tibbles -----------------------------------------------------------------

data.frame
tibble

airquality
as_tibble(airquality)

# Lendo arquivos de texto -------------------------------------------------

library(tidyverse)
# CSV, separado por ponto e vírgula
tb_candidatura_csv <- read_csv2("dados/tb_candidatura.csv")

# encoding
# Natação UTF8
# NataÃo!Â latin1
tb_candidatura_csv <- read_csv2(
  file = "dados/tb_candidatura.csv",
  locale = locale(encoding = "UTF-8")
)

# read_delim para escolher o delimitador
tb_candidatura_txt <- read_delim(file = "dados/tb_candidatura.csv", delim = ";")

# direto da internet
imdb_csv <- read_csv("https://raw.githubusercontent.com/curso-r/202005-r4ds-1/master/dados/imdb.csv")

# (mostrar navegação de importação do RStudio)

# Lendo arquivos do Excel -------------------------------------------------

library(readxl)

tb_bem_declarado_2018 <- read_excel("dados/tb_bem_declarado_2018.xlsx")



# Outros formatos ---------------------------------------------------------
# https://github.com/curso-r/202005-r4ds-1/tree/master/dados

library(jsonlite)
imdb_json <- read_json("https://raw.githubusercontent.com/curso-r/202005-r4ds-1/master/dados/imdb.json",
                       simplifyVector = TRUE)

library(haven)
imdb_sas <- read_sas("https://github.com/curso-r/202005-r4ds-1/blob/master/dados/imdb.sas7bdat?raw=true")
imdb_spss <- read_sav("https://github.com/curso-r/202005-r4ds-1/blob/master/dados/imdb.sav?raw=true")

# Gravando dados ----------------------------------------------------------

# As funções iniciam com 'write'

# CSV
write.csv(tb_candidatura_csv, file = "tb_candidatura_athos.csv")

# Excel
library(writexl)
write_xlsx(tb_candidatura_csv, path = "dados/tb_candidatura_camila.xlsx")






# O formato rds -----------------------------------------------------------

# .rds são arquivos binários do R
# Você pode salvar qualquer objeto do R em formato .rds

write_rds(tb_candidatura_csv, file = "dados/tb_candidatura.rds")
tb_candidatura_rds <- read_rds("dados/tb_candidatura.rds")




# Conexão com banco de dados SQL ----------------------------------------

library(RSQLite)
library(dplyr)
library(dbplyr)
library(DBI)

# Fazendo conexão com banco de dados
conexao <- dbConnect(SQLite(), "dados/imdb.db")
dbListTables(conexao)

# escrevendo tabelas
copy_to(conexao, imdb_csv, temporary = FALSE)
dbListTables(conexao)

# Criando uma tabela a partir do banco de dados
imdb_sqlite <- tbl(conexao, "imdb")
imdb_sqlite

# Criando uma tabela usando instruções em SQL -------------
instrucao <- sql("SELECT titulo, diretor FROM imdb WHERE ano = 1940")
imdb_select <- tbl(conexao, instrucao)

# O que tem por trás
show_query(imdb_select)

# Trazer para a memória
imdb_no_r <- collect(imdb_sqlite)


# Criando uma tabela usando instruções em R ---------------
imdb_select_r <- imdb_sqlite %>%
  filter(ano == 1940) %>%
  select(titulo, diretor)

# O que tem por trás
show_query(imdb_select_r)

# Trazer para a memória
imdb_select_no_r <- collect(imdb_select)


# Mais informações: db.rstudio.com


















