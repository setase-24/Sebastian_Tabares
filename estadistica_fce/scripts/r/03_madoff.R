# Expediente 03: Demasiado estable para ser real
# Nueva York, 1990–2008
# Temas: 2.2 desviación estándar y coeficiente de variación · 2.3 atípicos
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: madoff_fairfield_sentry_mensual.csv
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

m <- leer("madoff_fairfield_sentry_mensual.csv")

# 1. Resumen de cada serie
resumen <- function(x) c(media = mean(x), mediana = median(x), desv_est = sd(x),
                         coef_variacion = sd(x) / mean(x), meses_negativos = sum(x < 0),
                         minimo = min(x), maximo = max(x))
print(round(cbind(Fairfield = resumen(m$rend_fairfield_pct), SP500 = resumen(m$rend_sp500_pct)), 2))
cat("\nLa hoja del fondo decía 'solo 13 meses con pérdida'. En la tabla hay",
    sum(m$rend_fairfield_pct < 0), "\n")

# 2. Histogramas con la misma escala y valor acumulado de 100 dólares
largo <- rbind(data.frame(serie = "Fairfield (Madoff)", r = m$rend_fairfield_pct),
               data.frame(serie = "S&P 500", r = m$rend_sp500_pct))
print(ggplot(largo, aes(r, fill = serie)) + geom_histogram(binwidth = 1) +
        facet_wrap(~serie) + scale_fill_manual(values = c("#1d5c4a", "#a3392c")) +
        labs(x = "Rendimiento mensual (%)", y = "Meses") + theme_minimal() + theme(legend.position = "none"))

m <- m |> mutate(fecha = as.Date(paste0(mes, "-01")),
                 Fairfield = 100 * cumprod(1 + rend_fairfield_pct / 100),
                 SP500 = 100 * cumprod(1 + rend_sp500_pct / 100))
print(ggplot(m, aes(fecha)) + geom_line(aes(y = Fairfield, color = "Fairfield (Madoff)")) +
        geom_line(aes(y = SP500, color = "S&P 500")) +
        scale_color_manual(values = c("#1d5c4a", "#a3392c")) +
        labs(x = NULL, y = "Valor de 100 dólares", color = NULL, title = "Demasiado estable para ser real") +
        theme_minimal())

# 3. Correlación con el mercado
cat(sprintf("Correlación Fairfield vs S&P 500: %.2f\n", cor(m$rend_fairfield_pct, m$rend_sp500_pct)))

# Para pensar: La hoja informativa del fondo dice «solo 13 meses con pérdida». Cuenta tú los meses negativos en la tabla. ¿Coinciden? ¿Qué te dice eso de confiar en el resumen sin mirar los datos?
