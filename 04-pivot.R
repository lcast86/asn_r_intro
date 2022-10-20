library(tidyverse)

###############################################
# Exemplo 1

carteira <- tribble(
  ~sigla, ~`jan/20`, ~`fev/20`, ~`mar/20`,
  "ITUB4",       33,        37,        35,
  "VALE3",       18,        19,        20
)

# pivot_longer --------------------------------
carteira %>%
  pivot_longer(matches("[a-z]{3}/20"))

# pivot_wider ---------------------------------
carteira %>%
  pivot_longer(matches("[a-z]{3}/20")) %>%
  pivot_wider()

# Exercícios: 
# a) na tabela IMDB tem 3 colunas com nomes de atores.
# crie uma coluna com a "importancia_do_ator" e o "nome_do_ator"
# usando o pivot_longer() para te ajudar. Guarde a tabela num
# objeto chamado imdb_longer.


# b) a partir da tabela imdb_longer criado no item (a), use
# pivot_wider() para recuperar a tabela imdb original.



###############################################
# Exemplo 2 - Tabela de sumários

# pivot_wider ---------------------------------




###############################################
# (avançado) Exemplo 3 - Gráficos de todas as variáveis

# pivot_longer ---------------------------------
mtcars %>%
  pivot_longer()
