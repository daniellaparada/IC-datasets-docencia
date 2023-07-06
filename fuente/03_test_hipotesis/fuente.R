# datasets:
# https://data.buenosaires.gob.ar/dataset/flujo-vehicular-anillo-digital
# https://data.buenosaires.gob.ar/dataset/sube
# https://meteostat.net/es/station/87582?t=2022-01-01/2022-12-31
# https://meteostat.net/es/station/87582?t=2019-01-01/2019-12-31
# https://meteostat.net/es/station/87582?t=2023-01-01/2023-03-31
# http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson

require(ggplot2)
require(tidyverse)
require(ggfortify)
require(plotly)
require(vroom)
require(effsize)
library(sf)
library(osmdata)
library(ggmap)

# importo datos de flujo vehicular 2022 (¡ROTO! Faltan 8 meses aprox)
#colnames(flujo) <- c("fecha","hora","autopista","dispnom","dispub","sentido","displat","displong","veh")
#flujo <- flujo %>% select(c(1:4,6,9))
#flujo$fecha <- as.Date(flujo$fecha,tryFormats = c("%d/%m/%Y"))

# importo datos de flujo vehicular 2019
flujo19 <- vroom("flujo-vehicular-por-radares-2019.csv")
# importo datos de flujo vehicular 2023
flujo23 <- vroom("flujo-vehicular-por-radares-2023.csv")
flujo23$fecha <- as.Date(flujo23$fecha,tryFormats = c("%d/%m/%Y"))

# importo el mapa de CABA
barrios_caba <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson") %>%
  select(BARRIO, COMUNA)

# importo datos de flujo vehicular 2019 y agrupo por radar
flujo19 <- vroom("flujo-vehicular-por-radares-2019.csv") %>%
  group_by(disp_ubicacion) %>% 
  summarise(n = sum(cantidad),
            lat = mean(lat),
            long = mean(long)) %>%
  drop_na() 

paleta <- colorQuantile("YlOrRd", flujo19$n, n=6)

# Radares
leaflet(flujo19) %>% 
  addTiles() %>%
  addCircleMarkers(lng= ~long, 
                   lat= ~lat,
                   fillOpacity=0.9,
                   radius=~100*n/(sum(n)),
                   weight=1,
                   color = ~paleta(n),
                   stroke = FALSE) 

# importo datos de flujo vehicular 2019
flujo19 <- vroom("flujo-vehicular-por-radares-2019.csv")

# Miro los viajes en un sentido en Lugones altura Esma
flujo19 <- flujo19 %>%
  group_by(fecha, disp_nombre, seccion_sentido) %>% 
  summarise(n = sum(cantidad))
flujo19 <- flujo19 %>%
  filter(disp_nombre == "RD171 Esma",
         seccion_sentido == "A")

flujo23 <- flujo23 %>%
  group_by(fecha, disp_nombre, seccion_sentido) %>% 
  summarise(n = sum(cantidad))
flujo23 <- flujo23 %>%
  filter(disp_nombre == "RD171 Esma",
         seccion_sentido == "A")

# Filtro el primer trimestre de 2019
flujo19 <- flujo19 %>%
  filter(fecha >= "2019-01-01" && fecha <= "2019-03-31") %>%
  mutate(dia = weekdays(fecha),
         tipo_dia = ifelse(dia %in% c("sábado", "domingo"), "Fin de semana", "Lunes a viernes")) 

flujo23 <- flujo23 %>%
  mutate(dia = weekdays(fecha),
         tipo_dia = ifelse(dia %in% c("sábado", "domingo"), "Fin de semana", "Lunes a viernes")) 

flujo19$fecha <- format(as.Date(flujo19$fecha,format="%Y-%m-%d"), format = "%m-%d")
flujo23$fecha <- format(as.Date(flujo23$fecha,format="%Y-%m-%d"), format = "%m-%d")

# Juntamos los flujos de ambos años, solo para días hábiles
flujo <- left_join(flujo19, flujo23, by = c("fecha" = "fecha", "tipo_dia" = "tipo_dia")) %>%
  drop_na() %>% 
  select(c(1,4,5,6,9)) %>%
  mutate(n19 = n.x, 
         n23 = n.y) %>%
  select(c(1,6,7))

plot(flujo$n19, flujo$n23, xlim=c(0,140000), ylim=c(0,140000))
abline(a=0,b=1, col="red")

mean(flujo$n19)
sd(flujo$n19)
mean(flujo$n23)
sd(flujo$n23)

# guardo el dataset
write.csv(flujo,
          "G:\\Mi unidad\\_CONICET IC\\_2023\\[Proyecto] Datasets para docencia\\_NuevoEnfoque\\03-Test de hipótesis [final, ver con GS]\\flujo-vehicular.csv", 
          row.names=FALSE, fileEncoding = "UTF-8")

# Removemos posibles atípicos: 9 y 16 ene 2019; 20 y 21 feb 2023
recambios <- c(4,7,20,21)
flujosout <- flujo[-recambios,]

plot(flujosout$n19, flujosout$n23, xlim=c(100000,140000), ylim=c(100000,140000))
abline(a=0,b=1, col="red")

mean(flujosout$n19)
mean(flujosout$n23)

boxplot(flujosout$n19,flujosout$n23)

hist(flujosout$n19)
hist(flujosout$n23)

# Test para diferencia de medias
# Supuestos
shapiro.test(flujosout$n19)
shapiro.test(flujosout$n23)

qqnorm(flujosout$n19, xlab = "", ylab = "",
       main = "2019", col = "firebrick")
qqline(flujosout$n19)

qqnorm(flujosout$n23, xlab = "", ylab = "",
       main = "2023", col = "springgreen4")
qqline(flujosout$n23)

# Test 
t.test(x = flujosout$n19, y = flujosout$n23, alternative = "two.sided",
       mu = 0, paired = TRUE, conf.level = 0.99)

# Effectsize
cohen.d(d = flujosout$n19, f = flujosout$n23, paired = TRUE)

# Gráfico
fl <- data.frame(flujo = c(flujosout$n19,flujosout$n23),
                 dia = c(flujosout$fecha,flujosout$fecha),
                 anio = as.factor(c(rep("2019", length(flujosout$n19)),
                                    rep("2023", length(flujosout$n23))))) 

ggplot(data = fl, aes(x=dia, y=flujo, color=anio)) + 
  labs(x = "Día", y= "Flujo vehicular Lugones (Esma)") + 
  geom_point() + 
  theme_classic()

###########################################################################
# Para hacer clima vs flujo hay un problema.
# No hay info de lluvias en 2019 en Meteostat
# No hay info completa de flujo vehicular en 2022
# No me queda otra que mirar trim 1 2023...

# importo datos de clima para trim 1 año 2023, estación AEP
clima23 <- read_csv("registro_tiempo_aeroparque_2023.csv") %>% 
  select(c(1:5,7:8,10))

# Filtro el primer trimestre de 2023
clima23 <- clima23 %>%
  filter(date >= "2023-01-01" && date <= "2023-03-31") 

clima23$date <- format(as.Date(clima23$date,format="%Y-%m-%d"), format = "%m-%d")

# Juntamos clima y flujo
flujoclima <- left_join(flujo23, clima23, by = c("fecha" = "date")) %>%
  select(c(1,4,7,10,5,6)) 
flujoclima <- flujoclima[,2:7]

# guardo el dataset
write.csv(flujoclima,
          "G:\\Mi unidad\\_CONICET IC\\_2023\\[Proyecto] Datasets para docencia\\_NuevoEnfoque\\03-Test de hipótesis [final, ver con GS]\\flujo-clima.csv", 
          row.names=FALSE, fileEncoding = "UTF-8")

ggplot(data = filter(flujoclima), aes(x=factor(dia, level=c("lunes","martes","miércoles","jueves","viernes","sábado","domingo")), 
                                      y=n, color=tipo_dia)) + 
  labs(x = "Días de la semana", y= "Flujo vehicular Lugones (Esma)") + 
  geom_point(aes(size=prcp)) + 
  theme_classic()

# ¿Hay diferencia en el flujo medio cuando llueve (días hábiles)?
# Días de semana con lluvia: 20 datos
datos1 <- flujoclima %>%
  filter(prcp>0, 
         tipo_dia == "Lunes a viernes")

# Días de semana sin lluvia: 45 datos
datos2 <- flujoclima %>%
  filter(prcp==0, 
         tipo_dia == "Lunes a viernes")

boxplot(datos1$n,datos2$n, col=c("firebrick","springgreen4"),
        names=c("Lluvia", "Sin lluvia"))

# Test para diferencia de medias
# Supuestos
qqnorm(datos1$n, xlab = "", ylab = "",
       main = "Flujo con lluvia", col = "firebrick")
qqline(datos1$n)

qqnorm(datos2$n, xlab = "", ylab = "",
       main = "Flujo sin lluvia", col = "springgreen4")
qqline(datos2$n)

# Test 
t.test(x = datos1$n, y = datos2$n, alternative = "two.sided",
       mu = 0, paired = FALSE, conf.level = 0.95)

# ¿Hay diferencia en el flujo medio entre lunes y miércoles?
# Días de semana con lluvia: 13 datos
datos1 <- flujoclima %>%
  filter(dia == "lunes")

# Días de semana sin lluvia: 13 datos
datos2 <- flujoclima %>%
  filter(dia == "miércoles")

boxplot(datos1$n,datos2$n, col=c("firebrick","springgreen4"),
        names=c("Lunes", "Miércoles"))

# Test para diferencia de medias
t.test(x = datos1$n, y = datos2$n, alternative = "two.sided",
       mu = 0, paired = FALSE, conf.level = 0.95)
mean(datos1$n)
mean(datos2$n)


