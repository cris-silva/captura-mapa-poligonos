# Función para extraer el WKT del polígono dibujado:

convertir_wkt_poligono <- function(lista_geometria) {
  
  matriz_coordenadas <- as.matrix(lista_geometria)
  lista_coordenadas <- c(numeric(), numeric())
  
  for(i in 1:length(matriz_coordenadas)){
    lista_coordenadas <- rbind(lista_coordenadas,
                               c(matriz_coordenadas[[i]][[1]], matriz_coordenadas[[i]][[2]]))
  }
  
  wkt_poligono <- 
    list(lista_coordenadas) %>% 
    st_polygon() %>% 
    st_as_text()
  
  return(wkt_poligono)
  
}

shinyServer(function(input, output) {
  
  mapa <-
    leaflet() %>% 
    addProviderTiles(provider = "CartoDB.Positron") %>% 
    setView(lng = -99.218194,
            lat = 19.310414,
            zoom = 15) %>% 
    # Habilitar únicamente el dibujo de un polígono a la vez:
    addDrawToolbar(polylineOptions = FALSE,
                   circleOptions = FALSE,
                   rectangleOptions = FALSE,
                   markerOptions = FALSE,
                   circleMarkerOptions = FALSE,
                   singleFeature = TRUE)
  
  output$mapa <- renderLeaflet({
    
    mapa
    
  })
  
  output$salida_wkt <- renderPrint({
    
    validate(
      need(input$mapa_draw_new_feature,
           message = "Dibuja un polígono para obtener su WKT.")
    )
    
    input$mapa_draw_new_feature$geometry$coordinates[[1]] %>% 
      convertir_wkt_poligono()
    
  })
  
  observeEvent(input$mapa_draw_new_feature,{
    
    # input$mapa_draw_new_feature %>%
    #   write_rds("poligono.rds")
    
  })
  
})
