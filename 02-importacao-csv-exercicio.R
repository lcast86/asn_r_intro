library(tidyverse)

# O objetivo desse exercício é construir um script em R para ler a base 
# imdb_nao_estruturada.csv. código inicial:
download.file(
  url = "https://raw.githubusercontent.com/curso-r/202005-r4ds-1/master/dados/imdb_nao_estruturada.csv",
  destfile = "imdb_nao_estruturada.csv"
)
imdb <- read_csv2("imdb_nao_estruturada.csv")

# Essa base não está bem estruturada, então você não conseguir importá-la para o
# R apenas passando o argumento path. Explore os argumentos skip =, na = etc. 
# Filtre com filter() depois de carregar se necessário. 
# A base final tem 8 linhas e 5 colunas.

# Você deve entregar apenas o script em R, não é preciso fazer o upload do arquivo.