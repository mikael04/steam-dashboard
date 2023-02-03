#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  
  
  # db_collect <- mongo_db |> 
  #   dplyr::collect()
  
  mongo_db$count()
  
  my_collection = mongolite::mongo(collection = "gamesInfo", db = "Steam", url = url_srv) # create connection, database and collection
  my_collection$insert(steam_db)
  
  vars <- my_collection$distinct("variavel")
  years <- my_collection$distinct("release_year")
  languages <- my_collection$distinct("language")
  
  df_lang <- as.data.frame(languages)
}
