########################################################################################## #
#'  Script/Função/módulo criado para filtrar generos do tipo não jogo
#'  que são passados por parâmetro
#'  Também é utilizado outro parâmetro de modo, sendo:
#'  mode == 1, comparação com gêneros
#'  mode == 2, comparação com tags
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 
########################################################################################## #

## 0.1 - Bibliotecas e scripts fontes----

## 1.0 - Script/Função ----
func_filter_not_games <- function(df_selected, notGames_vector, mode){
  if(mode == 1){
    df_selected <- df_selected |> 
      dplyr::filter(!(genres %in% notGames_vector))
  }
  if(mode == 2){
    df_selected <- df_selected |> 
      dplyr::filter(!(tags %in% notGames_vector))
  }
  return(df_selected)
  
  ## Esses eram dois jogos que foram investigados
  ## Eles possuíam categorias Movie e Documentary também, então esses registros foram apagados e os demais foram mantidos
  
  # df_full_search <- df_full |> 
  #   dplyr::filter(Name %in% c("Spacelords", "CAT SUDOKU🐱"))
}
