############################################################################################ #
#'  Script criado para criar o banco de dados (json, mongodb) que alimentará a aplicação
#' 
#'  Autor: Mikael
#'  Data: 29/11/22
############################################################################################ #

# 0. Bibliotecas ----
library(dplyr)
# library(data.table)
# library(dtplyr)

source("R/fct_criar_tabela.R")
source("R/fct_manip_vars.R")

# 1. Dados originais
## Lendo tabelas csv
df_games <- data.table::fread("data-raw/steam-data/db-1/games.csv", sep = ',')

## Manipulando dados e selecionando variáveis
df_games_selected <- func_manip_vars(df_games, debug = F)

## Gerando database, formato json para o mongodb
json_df_games <- func_criar_tabela(df_games_selected, debug = T)

# jsonlite::write_json(json_df_games, "data-raw/dados-manipulados/database.json")
# feather::write_feather(json_df_games, "data-raw/dados-manipulados/database.feather")

### Adicionando dados ao mongoDB

## Dados padrão do mongo
mongo_db_user <- config::get("mongo_db_user", file = "config/config.yml")
mongo_db_password <- config::get("mongo_db_password", file = "config/config.yml")
mongo_db_url_extra <- config::get("mongo_db_url_extra", file = "config/config.yml")
mongo_database <- config::get("mongo_database", file = "config/config.yml")

url_srv <- paste0("mongodb+srv://", mongo_db_user, ":", mongo_db_password, mongo_db_url_extra)

mongo_collection <- config::get("mongo_collection_counts", file = "config/config.yml")
mongo_db <- mongolite::mongo(collection = mongo_collection, db = mongo_database, url = url_srv, verbose = TRUE)

## Banco de dados de contagem
mongo_db$drop()
mongo_db$insert(json_df_games)

## Inserindo os dados no mongoDB, banco de dados completo
mongo_db <- mongolite::mongo(collection = "steamDataFull", db = mongo_database, url = url_srv, verbose = TRUE)
mongo_db$drop()
mongo_db$insert(df_games)


## Inserindo os dados no mongoDB, banco de dados selecionado
mongo_db <- mongolite::mongo(collection = "steamDataPreProc", db = mongo_database, url = url_srv, verbose = TRUE)
mongo_db$drop()
mongo_db$insert(df_games_selected)

