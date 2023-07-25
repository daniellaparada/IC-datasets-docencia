require(leaflet)
require(tidyverse)

sismos <- read_csv("Downloads/04-Visualización [en proceso]/sismos_all.csv")

## 2000 al azar 
leaflet(sample_n(sismos, 2000)) %>% 
  addTiles() %>%
  addCircleMarkers(lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=0.05,
                   radius=~Magn.,
                   stroke = FALSE) 


## separado por los que se sintieron de San Juan
sismos <- sismos %>% 
  mutate(Ipercibido = !is.na(Intensidad))


# 2000 al azar que no se percibieron
leaflet(sismos %>% 
          filter(Ipercibido==F & Provincia == "SAN JUAN") %>% 
          sample_n(2000)) %>% 
  addTiles() %>%
  addCircleMarkers(lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=0.1,
                   radius=~Magn.,
                   color = "blue",
                   stroke = FALSE) 
# percibidos
leaflet(sismos %>% 
          filter(Ipercibido==T & Provincia == "SAN JUAN")) %>% 
  addTiles() %>%
  addCircleMarkers(lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=0.1,
                   radius=~Magn.,
                   color = "red",
                   stroke = FALSE) 



# profundidad
sismos$km <- as.numeric(gsub("[^0-9.]", "", sismos$Profund.))


