# Expediente 01: La encuesta más grande que falló
# Estados Unidos, 1936
# Temas: 1.1 población y muestra · 4.3 probabilidad frecuentista
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: literary_digest_1936.csv
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

ld <- leer("literary_digest_1936.csv")

# 1. Porcentaje de Landon por estado y en total
ld <- ld |> mutate(pct_landon = 100 * sondeo_landon / (sondeo_landon + sondeo_roosevelt))
total_l <- sum(ld$sondeo_landon); total_r <- sum(ld$sondeo_roosevelt)
cat("Papeletas en la tabla:", format(total_l + total_r, big.mark = ","), "\n")
cat(sprintf("Landon según el sondeo: %.1f %%\n", 100 * total_l / (total_l + total_r)))
cat("Resultado real de la elección: Roosevelt 60,8 %, Landon 36,5 %\n")

estados <- ld |> filter(estado != "Other")
cat("Estados donde el sondeo daba ganador a Landon:", sum(estados$pct_landon > 50), "de", nrow(estados), "\n")
cat("En la elección real Landon ganó solo 2: Maine y Vermont.\n")

# 2. Buscar filas sospechosas
cat("\nVotos de Roosevelt repetidos en estados distintos:\n")
print(ld |> group_by(sondeo_roosevelt) |> filter(n() > 1) |> ungroup())
cat("\nFilas con los mismos votos de Landon y Roosevelt:\n")
print(ld |> group_by(sondeo_landon, sondeo_roosevelt) |> filter(n() > 1) |> ungroup())
cat("\nSuma de votos electorales:", sum(ld$votos_electorales), "(debería ser 531)\n")

# 3. Gráfica: porcentaje de Landon por estado
g <- ggplot(estados, aes(x = pct_landon, y = reorder(estado, pct_landon))) +
  geom_col(fill = "#1d5c4a") +
  geom_vline(xintercept = 50, linetype = "dashed", color = "#a3392c") +
  labs(x = "% de papeletas a favor de Landon", y = NULL,
       title = "Literary Digest 1936: lo que decía el sondeo") +
  theme_minimal()
print(g)

# Para pensar: Roosevelt sacó el 61 % real. ¿Por qué 2,4 millones de respuestas no bastaron? ¿Qué parte del error viene de a quién se le envió la papeleta y qué parte de quién decidió responder?
