# Expediente 07: Mismos números, gráficas opuestas
# Anscombe 1973 · Matejka y Fitzmaurice 2017
# Temas: 3.1 gráficos de dos variables · 3.2 correlación · 2.2 resúmenes
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: anscombe_cuarteto.csv, datasaurus_docena.csv
# Paquetes: install.packages(c("dplyr", "ggplot2"))

library(dplyr)
library(ggplot2)

URL_DATOS <- "https://raw.githubusercontent.com/setase-24/Sebastian_Tabares/main/estadistica_fce/datos/"

# Lee el CSV desde la carpeta datos/ si existe; si no, lo descarga de GitHub.
leer <- function(archivo) {
  for (ruta in c("datos", "../datos", "../../datos")) {
    f <- file.path(ruta, archivo)
    if (file.exists(f)) return(read.csv(f))
  }
  read.csv(paste0(URL_DATOS, archivo))
}

an <- leer("anscombe_cuarteto.csv")
ds <- leer("datasaurus_docena.csv")

# 1. Resúmenes por conjunto
resumen <- function(df) {
  df |> group_by(conjunto) |>
    summarise(media_x = mean(x), desv_x = sd(x), media_y = mean(y), desv_y = sd(y), r = cor(x, y)) |>
    mutate(across(where(is.numeric), \(v) round(v, 2)))
}
cat("Cuarteto de Anscombe:\n"); print(resumen(an))
cat("\nDocena del Datasaurus:\n"); print(resumen(ds), n = 13)

# 2. Una gráfica por conjunto, con los mismos ejes
print(ggplot(an, aes(x, y)) + geom_point(color = "#1d5c4a") + facet_wrap(~conjunto) + theme_minimal())
print(ggplot(ds, aes(x, y)) + geom_point(color = "#1d5c4a", size = 0.8) + facet_wrap(~conjunto, ncol = 5) + theme_minimal())

# 3. Quitar el atípico del conjunto 3
c3 <- an |> filter(conjunto == "(3) Outlier")
sin_atipico <- c3 |> filter(y < max(y))
cat(sprintf("\nConjunto 3: r con atípico = %.3f, sin atípico = %.3f\n", cor(c3$x, c3$y), cor(sin_atipico$x, sin_atipico$y)))

# Para pensar: Si un analista te entrega solo la tabla de resúmenes, ¿podrías saber cuál conjunto es el dinosaurio? ¿Qué le pedirías antes de creer en una correlación?
