# Expediente 04: La ley del primer dígito y las cuentas de Grecia
# Unión Europea, 1999–2009
# Temas: 2.1 tablas de frecuencia y diagramas de barras · 1.2 tipo de variable
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: eurostat_finanzas_publicas_1999_2009.csv
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

eu <- leer("eurostat_finanzas_publicas_1999_2009.csv")

# 1. Primer dígito de cada cifra
eu <- eu |> filter(abs(value) >= 1) |>
  mutate(digito = as.integer(substr(gsub("^[0.]+", "", format(abs(value), scientific = FALSE, trim = TRUE)), 1, 1)))
benford <- log10(1 + 1 / (1:9))
frec <- prop.table(table(factor(eu$digito, levels = 1:9)))
print(round(data.frame(digito = 1:9, observado = as.numeric(frec), benford = benford), 3))

# 2. Desviación absoluta media (MAD) por país
ranking <- eu |> group_by(geo) |>
  summarise(MAD = mean(abs(as.numeric(prop.table(table(factor(digito, levels = 1:9)))) - benford))) |>
  arrange(desc(MAD))
cat("\nPaíses más alejados de Benford (MAD):\n")
print(head(ranking, 10))
cat("Grecia (EL) queda en el puesto", which(ranking$geo == "EL"), "de", nrow(ranking), "\n")

grecia <- eu |> filter(geo == "EL") |> count(digito) |> mutate(frecuencia = n / sum(n))
g <- ggplot(grecia, aes(digito, frecuencia)) +
  geom_col(fill = "#1d5c4a") +
  geom_point(data = data.frame(digito = 1:9, frecuencia = benford), color = "#a3392c", size = 3) +
  geom_line(data = data.frame(digito = 1:9, frecuencia = benford), color = "#a3392c") +
  scale_x_continuous(breaks = 1:9) +
  labs(x = "Primer dígito", y = "Frecuencia relativa",
       title = "Cifras fiscales de Grecia 1999-2009 (barras) frente a Benford (puntos)") +
  theme_minimal()
print(g)

# Para pensar: ¿En qué posición quedó Grecia con los datos corregidos? Si un país corrige sus cifras después de un escándalo, ¿qué esperarías que le pase a su ajuste con Benford?
