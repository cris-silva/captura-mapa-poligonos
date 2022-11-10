shinyUI(fluidPage(

    titlePanel("Captura de polígonos"),

    leafletOutput("mapa"),
    
    verbatimTextOutput("salida_wkt")
    
))
