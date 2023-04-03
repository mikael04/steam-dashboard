########################################################################################## #
#'  Script/Função/módulo criado para
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----


## 1.0 - Script/Função ----
func_ajustando_tags <- function(df_diff, debug){
  ## Tags que serão ajustadas na primeira coluna (first)
  pattern_first <- c("1 - ", "Roguelike", "Roguelite", "Base Building", "Football \\(Soccer\\)",
                     "Football (American)", "Puzzle Platformer")
  ## Tags de substituição
  replacement_first <- c("", "Rogue-like", "Rogue-lite", "Base-Building", "Soccer", "Football",
                         "Puzzle-Platformer")
  ## Tags que serão ajustadas na primeira coluna (first)
  pattern_seccond <- c("2 - ", "e-sport")
  ## Tags de substituição
  replacement_seccond <- c("", "eSport")
  
  # word <- "Football (Soccer)"
  # stringi::stri_replace_all_regex(word, "Football \\(Soccer\\)", "Soccer")
  
  df_diff_ <- df_diff |> 
    dplyr::mutate(first = stringi::stri_replace_all_regex(first, pattern_first, replacement_first, vectorize_all = F)) |> 
    dplyr::mutate(seccond = stringi::stri_replace_all_regex(seccond, pattern_seccond, replacement_seccond, vectorize_all = F)) |> 
    dplyr::rowwise() |> 
    dplyr::mutate(add_tags = paste0(union(first, seccond), collapse = ",")) |> 
    dplyr::mutate(add_tags = stringi::stri_replace_all_regex(add_tags, "^,|,$", "", vectorize_all = F))
  
  #### XXXXXXXX ####
  ## Tratar palavras que foram substituídas, mas foram adicionadas em duplicata pelo número de strings
  #### XXXXXXXX ####
  
  df_diff_ <- df_diff_ |> 
    dplyr::mutate(all = paste0(equal, ",", add_tags))
  # df_diff_[] <- lapply(df_diff_, function(x) { attributes(x) <- NULL; x})
  all_ordered <- df_diff_$all |> 
    purrr::map(\(x) stringr::str_sort(stringr::str_split_1(x, pattern = ",")))
  tags <- NULL
  for(i in 1:length(all_ordered)){
    pluck(tags, i) <- paste0(pluck(all_ordered, i), collapse = ",")
  }
  df_diff_$tags <- as.character(tags)
  df_diff_ <- df_diff_ |> 
    dplyr::select(-add_tags, -first, -seccond, -equal, -all) |> 
    dplyr::ungroup()
  
  df_diff_
}