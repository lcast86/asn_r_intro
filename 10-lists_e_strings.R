
# Motivação: descobrir a quantos gêneros cada filme pertence ***

library(dplyr)
library(stringr)
library(tidyr)
library(tibble)
f <- glue::glue

imdb <- readr::read_rds("dados/imdb.rds")

imdb  %>%
  select(titulo, generos) %>%
  mutate(
    num_generos = str_count(generos, pattern = "\\|") + 1,
    num_generos_label = f("o filme {titulo} possui {num_generos} generos")
  )

# -------------------------------------------------------------------------

# Motivação: extrair o subtítulos dos filmes ***

imdb %>%
  select(titulo) %>%
  mutate(
    comprimento_do_titulo = str_length(titulo),
    sub_titulo = str_extract(titulo, ": .*"),
    sub_titulo = str_remove(sub_titulo, ": ")
  ) %>%
  filter(!is.na(sub_titulo))

# -------------------------------------------------------------------------

# Motivação: criar uma tabela apenas com filmes cujo
# título comece com um número ***

imdb %>%
  filter(str_detect(titulo, "^[0-9]")) %>%
  View()

# -------------------------------------------------------------------------

# Motivação: qual a idade mínima para ver cada filme? ***

unique(imdb$classificacao)

imdb %>%
  select(classificacao) %>%
  mutate(
    idade_min = str_extract(classificacao, "[0-9]+"),
    idade_min = as.numeric(idade_min),
    idade_min = case_when(
      classificacao == "Livre" ~ 0,
      classificacao == "Outros" ~ NA_real_,
      TRUE ~ idade_min
    )
  )


# -------------------------------------------------------------------------

# Mais funcoes uteis

str_pad(c(1, 10, 100, 1000), width = 4, side = "left", pad = "0")
str_replace_all(c("abba", "athos"), "a", "O")
str_remove_all(c("abba", "athos"), "a")
str_to_lower()
str_to_upper()
str_trim("    espacos sobrando nas extremidades     ")
str_squish("    espacos      sobrando     em todo            lugar     ")
str_sub("abcdef", 2, 5)

# Exercicio --------------------------------------------------------------
# o banco de dados `starwars` tem todos os personagens do Star Wars.
# a coluna skin_color mostra quantas cores o personagem tem, por exemplo: "white, red"
# Objetivo: criar uma coluna com a quantidade de cores que cada personagem tem.



# -------------------------------------------------------------------------

# Motivacao: tem funcoes que retornam listas, como o str_split()

str_split(c("a,b,c", "x,y,z,w"), ",")

# NOVIDADE: list-columns, colunas que sao listas em vez de vetores normais.
imdb %>%
  select(generos) %>%
  mutate(
    generos_splitted = str_split(generos, pattern = "\\|")
  )

# -------------------------------------------------------------------------

# Lists

# lista com nome e cheio de objetos diferentes
minha_lista = list(
  chave1 = "valor1",
  chave2 = "valor2",
  vetor = c(1,2,3),
  dados = mtcars[1:2, 1:2],
  outra_lista = list(a = 1, b = 2)
)

names(minha_lista)


# lista sem nome
lista_sem_nomes = list(
  "a",
  c(1,2,3)
)
names(lista_sem_nomes)

# Usa-se o [[1]] para acessar os elementos da lista.
lista_sem_nomes[[1]]
lista_sem_nomes[[2]]

# se tiver nome, da para usar [["nome"]] ou $nome
minha_lista$chave1
minha_lista$dados
minha_lista[["chave2"]]

# funcoes uteis para list: map()
library(purrr)
map(minha_lista, class)
map(minha_lista, length)

# suponha:     x = [x1, x2, x3, ..., xn]
# map(x, f) faz [f(x1), f(x2), f(x3), ..., f(xn)]


tem_comprimento_um <- function(elemento) {
  length(elemento) == 1
}

map(minha_lista, tem_comprimento_um)




# podemos usar o tal do lambda function
map(minha_lista, ~ length(.x) == 1)
map(minha_lista, \(x) length(x) == 1)




# map_lgl(), map_dbl() e map_chr() ajudam a conseguir um vetor normal novamente.

map_lgl(minha_lista, ~ length(.x) == 1) # isso eh um vetor de booleanos
map_int(minha_lista, length) # isso eh um vetor de inteiros




# a ideia eh usarmos map() e map_*() etc no mutate() para mexer nas list-columns.

tem_genero_action <- function(vetor_de_generos) "Action" %in% vetor_de_generos

imdb_com_list_column <- imdb %>%
  select(generos) %>%
  mutate(
    generos_splitted = str_split(generos, pattern = "\\|"),
    tem_genero_action = map_lgl(generos_splitted, tem_genero_action)
  )

imdb_com_list_column


# Exercicio -------------------------------------------------------------------
# No codigo abaixo, crie uma coluna com a qtd_de_generos usando a
# as funcoes map_int() e length(), e a coluna generos_splitted.

imdb_com_qtd_de_generos <- imdb %>%
  select(generos) %>%
  rownames_to_column() %>%
  mutate(
    generos_splitted = str_split(generos, pattern = "\\|"),
    # escreva seu codigo aqui
  )




# Extra: unnest() ----------------------------------------------------

# unnest(), explodindo uma list-column
imdb_com_qtd_de_generos_unnested <- imdb_com_qtd_de_generos %>%
  unnest(generos_splitted)

imdb_com_qtd_de_generos_unnested




