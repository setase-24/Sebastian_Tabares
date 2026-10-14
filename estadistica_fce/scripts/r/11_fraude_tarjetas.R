# Expediente 11: ¿Por qué el banco te bloquea compras legítimas?
# Tarjetahabientes europeos, septiembre de 2013
# Temas: 4.5 probabilidad condicional · 4.6 teorema de Bayes · tasa base
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: fraude_tarjetas_muestra.csv
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

f <- leer("fraude_tarjetas_muestra.csv")
fraude <- f$Class == 1

# 1. Tasa base y montos
cat(sprintf("Transacciones: %d   Fraudes: %d   Proporción: %.4f %%\n", nrow(f), sum(fraude), 100 * mean(fraude)))
print(f |> group_by(Class) |> summarise(media = mean(Amount), mediana = median(Amount), desv = sd(Amount), maximo = max(Amount)))

# 2. Una alerta simple: V14 < -5
alerta <- f$V14 < -5
sens <- mean(alerta[fraude]); falsa <- mean(alerta[!fraude]); p <- mean(fraude)
cat(sprintf("\nP(alerta | fraude)    = %.3f\n", sens))
cat(sprintf("P(alerta | no fraude) = %.4f\n", falsa))
cat(sprintf("P(fraude | alerta) por Bayes = %.3f\n", sens * p / (sens * p + falsa * (1 - p))))
cat(sprintf("P(fraude | alerta) contando  = %.3f\n", mean(fraude[alerta])))

# 3. Un detector "99 % / 1 %" con la tasa base real
base <- 0.00173; n <- 100000
fraudes <- n * base
verdaderas <- 0.99 * fraudes
falsas <- 0.01 * (n - fraudes)
cat(sprintf("\nDe %d transacciones: %.0f fraudes\n", n, fraudes))
cat(sprintf("Alertas verdaderas: %.0f   Alertas falsas: %.0f\n", verdaderas, falsas))
cat(sprintf("P(fraude | alerta) = %.3f\n", verdaderas / (verdaderas + falsas)))

# Para pensar: Si fueras el banco, ¿qué cuesta más: una alarma falsa o un fraude no detectado? ¿Cómo cambiarías el umbral de la alerta según esa respuesta?
