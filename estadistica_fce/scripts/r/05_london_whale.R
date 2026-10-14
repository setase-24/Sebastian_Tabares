# Expediente 05: La ballena de Londres y una fórmula mal copiada
# JPMorgan Chase, 2012
# Temas: 2.2 dispersión y medidas de riesgo · percentiles
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: sp500_shiller_mensual.csv
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

sp <- leer("sp500_shiller_mensual.csv") |> mutate(fecha = as.Date(fecha))
datos <- sp |> filter(fecha >= as.Date("1990-01-01"), fecha <= as.Date("2007-12-31")) |> pull(rend_mensual_pct)

# 1. Desviación estándar y VaR histórico al 95 %
media <- mean(datos); desv <- sd(datos)
cat(sprintf("Media mensual: %.2f %%   Desviación estándar: %.2f %%\n", media, desv))
cat(sprintf("VaR histórico 95 %% (percentil 5): %.2f %%\n", quantile(datos, 0.05)))

# 2. El error de JPMorgan: dividir por la suma en vez del promedio deja la volatilidad a la mitad
var_bien <- media - 1.645 * desv
var_mal  <- media - 1.645 * desv / 2
cat(sprintf("VaR paramétrico con la volatilidad correcta: %.2f %%\n", var_bien))
cat(sprintf("VaR paramétrico con el error:                %.2f %%\n", var_mal))

crisis <- sp |> filter(fecha >= as.Date("2008-01-01"), fecha <= as.Date("2009-12-31"))
cat("\nMeses de 2008-2009:", nrow(crisis), "\n")
cat("Meses peores que el VaR correcto:", sum(crisis$rend_mensual_pct < var_bien), "\n")
cat("Meses peores que el VaR con error:", sum(crisis$rend_mensual_pct < var_mal), "\n")
cat("Si el VaR al 95 % estuviera bien calibrado, se esperaría superarlo en 1 de cada 20 meses.\n")

g <- ggplot(crisis, aes(fecha, rend_mensual_pct)) +
  geom_col(fill = "#1d5c4a") +
  geom_hline(aes(yintercept = var_bien, linetype = "VaR correcto")) +
  geom_hline(aes(yintercept = var_mal, linetype = "VaR con el error"), color = "#a3392c") +
  labs(x = NULL, y = "Rendimiento mensual (%)", linetype = NULL,
       title = "S&P 500 en 2008-2009 frente al VaR estimado con 1990-2007") +
  theme_minimal()
print(g)

# Para pensar: Si el VaR dice «95 % de los meses perderás menos de X», ¿cuántos meses de cada 100 esperarías que se pase? ¿Qué te dice que en 2008 se haya pasado muchas más veces?
