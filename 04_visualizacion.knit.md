Presentamos un ejemplo para XXX.

![Cómo *MidJourney* imagina que se ilustra este problema bajo el *prompt*: */imagine a stunning illustration capturing seismic data visualization near the mountains in San Juan. Abstract seismic waves emanate from the mountains, indicating seismic energy, and seismograph traces overlay the landscape, displaying earthquake intensity. Data points scattered around signify seismic events of various magnitudes and depths.*](./fuente/04_visualizacion/apertura.png){fig-align="center"}

# Visualización

A continuación, se muestran algunos posibles análisis para datos de XXX.


::: {.cell}

```{.r .cell-code}
# Librerías necesarias
require(ggplot2)
require(tidyverse)
require(ggfortify)
require(plotly)
require(vroom)
require(effsize)
require(sf)
require(osmdata)
require(ggmap)
require(leaflet)
```
:::


## Exploración inicial

Los datos de XXX

Para lo que sigue, trabajamos con el *dataset* reducido `flujo-vehicular.csv` en el que se incluyen datos del flujo vehicular de los días hábiles del primer trimestre de 2019 y de 2023 para el radar RD 171 ubicado en la Autopista Lugones, altura ESMA, sentido A.

El dataset `flujo-vehicular.csv` se encuentra [acá](https://www.dropbox.com/). A continuación, se muestran 10 datos de dicho conjunto.


# Acerca de los datos

A continuación, se detallan aspectos de los datasets que conformaron el *dataset* reducido para el desarrollo del ejemplo, a la vez que se incluyen las fuentes de los datos y el código utilizado para pre-procesarlo con la sintaxis de `tidyverse`. De esta forma, puede fácilmente replicarse y/o adaptarse si así se lo desea.

También se incluye el enlace de descarga al dataset reducido, `XXX.csv`, con el que se desarrolló el ejemplo.

## Sobre el *dataset* de clima

Los datos de este ejemplo corresponden a XXX y se dispone de las siguientes variables.

-   `fecha`: fecha, en el formato mes-día.
-   `n`: flujo vehicular de la fecha indicada.
-   `tavg`: temperatura media (°C) registrada en esa fecha.
-   `prcp`: precipitaciones (mm) registrada en esa fecha.
-   `dia`: día de la semana de la fecha indicada.
-   `tipo_dia`: tipo de día (Fin de semana o Lunes a viernes) de la fecha indicada.


# Librerías

Las librerías usadas para el desarrollo de este ejemplo, así como la información de la sesión de `R`, se muestran en el código que sigue.


::: {.cell}

```{.r .cell-code}
require(ggplot2)
require(tidyverse)
require(ggfortify)
require(plotly)
require(vroom)
require(effsize)
require(sf)
require(osmdata)
require(ggmap)
require(leaflet)
```
:::

::: {.cell}

```{.r .cell-code}
sessionInfo()
```

::: {.cell-output .cell-output-stdout}
```
R version 4.2.3 (2023-03-15 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 22621)

Matrix products: default

locale:
[1] LC_COLLATE=Spanish_Argentina.utf8  LC_CTYPE=Spanish_Argentina.utf8   
[3] LC_MONETARY=Spanish_Argentina.utf8 LC_NUMERIC=C                      
[5] LC_TIME=Spanish_Argentina.utf8    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] leaflet_2.1.2    ggmap_3.0.2      osmdata_0.2.3    sf_1.0-13       
 [5] effsize_0.8.1    vroom_1.6.1      plotly_4.10.1    ggfortify_0.4.16
 [9] lubridate_1.9.2  forcats_1.0.0    stringr_1.5.0    dplyr_1.1.2     
[13] purrr_1.0.1      readr_2.1.4      tidyr_1.3.0      tibble_3.2.1    
[17] tidyverse_2.0.0  ggplot2_3.4.2   

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.10         lattice_0.21-8      png_0.1-8          
 [4] class_7.3-21        digest_0.6.31       utf8_1.2.3         
 [7] plyr_1.8.8          R6_2.5.1            evaluate_0.20      
[10] e1071_1.7-13        httr_1.4.5          pillar_1.9.0       
[13] RgoogleMaps_1.4.5.3 rlang_1.1.0         lazyeval_0.2.2     
[16] rstudioapi_0.14     data.table_1.14.8   rmarkdown_2.21     
[19] htmlwidgets_1.6.2   bit_4.0.5           munsell_0.5.0      
[22] proxy_0.4-27        compiler_4.2.3      xfun_0.39          
[25] pkgconfig_2.0.3     htmltools_0.5.5     tidyselect_1.2.0   
[28] gridExtra_2.3       fansi_1.0.4         viridisLite_0.4.2  
[31] crayon_1.5.2        tzdb_0.3.0          withr_2.5.0        
[34] bitops_1.0-7        grid_4.2.3          jsonlite_1.8.4     
[37] gtable_0.3.3        lifecycle_1.0.3     DBI_1.1.3          
[40] magrittr_2.0.3      units_0.8-2         scales_1.2.1       
[43] KernSmooth_2.23-20  cli_3.6.1           stringi_1.7.12     
[46] sp_1.6-1            generics_0.1.3      vctrs_0.6.1        
[49] tools_4.2.3         bit64_4.0.5         glue_1.6.2         
[52] crosstalk_1.2.0     jpeg_0.1-10         hms_1.1.3          
[55] fastmap_1.1.1       timechange_0.2.0    colorspace_2.1-0   
[58] classInt_0.4-9      knitr_1.42         
```
:::
:::


# Referencias

-   XXX
