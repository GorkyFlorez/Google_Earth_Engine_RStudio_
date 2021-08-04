# Instalar librerias ------------------------------------------------------------
# install.packages("googledrive")
# install.packages("rgee")
library(googledrive)
library(rgee)
library(mapedit)
library(tibble)
library(sf)
library(cptcity)
# Instalar rtools---------------------------------------------------------
# rtools
Sys.which("make")
# Paquete de rgee
#ee_install()

# Nos pedira si queremos instalar miniconda dareos Y
# Creara un nuevo entorn Python
# Nos pedira reiniciar la consola daremos 1
# Instalar rtools---------------------------------------------------------
# Iniciamos nuestra cuenta de Rgee
ee_Initialize("gflorezc", drive = T)

#  https://developers.google.com/earth-engine/datasets/catalog/LANDSAT_LT05_C01_T1_SR

coll <- ee$ImageCollection("LANDSAT/LC08/C01/T1_TOA")$                # Seleccionamos el satelite
           filterDate("2019-04-01", "2020-06-30")$                    # Filtramos por fecha
           filterBounds(ee$Geometry$Point(-76.68, -8.65))$            # Filtramos mediante puntos
           filterMetadata("CLOUD_COVER", "less_than", 10)             # Filtramos por nueves
ee_get_date_ic(coll)                                                  # Leemos las imagenes disponibles
# Cargamos la imgamen a escojer 
L8   <- 'LANDSAT/LC08/C01/T1_TOA/LC08_008066_20200610'%>%             # Cargamos la imagen a descargar 
           ee$Image() %>%                                             # La naturaleza
           ee$Image$select(c("B6","B5", "B4"))                        # Realizamos una conbinacion de bandas
# Llamamos al objeto creado
Map$centerObject(L8)                                                  # Centramos el mapa para vizualizacion
Map$addLayer(L8)                                                      # Llamamos el objeto 

Yungay<- st_read ("SHP/Yungay.shp")%>%                                # Subimos de nuestro repositorio al shp de yungay
           sf_as_ee()                                                 # Lo convertimos en Sf pero de ee

Map$addLayer(Yungay)                                                  # Vizualizamos yungay
# Realizamos el corte con sus combinaciones 
yun   <- ee$Image('LANDSAT/LC08/C01/T1_TOA/LC08_008066_20200610')$    # Cargamos la imagen a descargar 
         clip(Yungay)%>%                                              # Cortamos la imagen con el sho de yungay
         ee$Image$select(c("B6","B5", "B4"))                          # Realizamos la combinacion de bandas 
# Llamamos al objeto creado
Map$centerObject(yun)                                                 # Centramos el mapa para vizualizacion
Map$addLayer(yun)                                                     # Llamamos el objeto 

NDVI <- yun$normalizedDifference(c("B5", "B4"))                       # Realizamos el indice de NDVI para yungay

Map$centerObject(NDVI)                                                # Centramos el mapa para vizualizacion
Map$addLayer(eeObject =NDVI, visParams = list(                        # LLamamos a NDVI y ponemos un parametro de colores
  min=0.2,                                                            # Realizamos valores minimos de 0.2
  max=0.8,                                                            # Realizamos valores maximos de 0.8
  palette= cpt("grass_ndvi", 10)))                                    # utilizamos la paleta de colores de grass






