# Expediente 02: El error de Excel que justificó la austeridad
# Harvard y UMass Amherst, 2010–2013
# Temas: 2.2 media, mediana y media ponderada · 2.3 datos atípicos
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: reinhart_rogoff_1946_2009.csv
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

rr <- leer("reinhart_rogoff_1946_2009.csv") |>
  mutate(categoria_deuda = factor(categoria_deuda, levels = c("0-30%", "30-60%", "60-90%", ">90%")))

# 1. Cada país-año pesa lo mismo
cat("Media y mediana con todos los país-año:\n")
print(rr |> group_by(categoria_deuda) |>
        summarise(media = mean(crecimiento_pib_real_pct), mediana = median(crecimiento_pib_real_pct), n = n()))

# 2. Cada país pesa lo mismo (promedio de promedios), como hicieron Reinhart y Rogoff
promedio_por_pais <- function(df) {
  df |> group_by(categoria_deuda, pais) |> summarise(m = mean(crecimiento_pib_real_pct), .groups = "drop") |>
    group_by(categoria_deuda) |> summarise(m = mean(m))
}
excluidos <- c("Australia", "Austria", "Belgium", "Canada", "Denmark")
tabla <- rr |> group_by(categoria_deuda) |> summarise(pais_anio = mean(crecimiento_pib_real_pct)) |>
  left_join(promedio_por_pais(rr) |> rename(promedio_por_pais = m), by = "categoria_deuda") |>
  left_join(promedio_por_pais(filter(rr, !pais %in% excluidos)) |> rename(con_error_excel = m), by = "categoria_deuda")
cat("\nTres formas de promediar el crecimiento (%):\n")
print(tabla |> mutate(across(where(is.numeric), \(x) round(x, 2))))
cat("Reinhart y Rogoff publicaron -0,1 % para >90%. Además del error de Excel, excluyeron años de Nueva Zelanda, Australia y Canadá.\n")

# 3. Atípicos en la categoría >90%
alta <- rr |> filter(categoria_deuda == ">90%")
cat("\nAños que aporta cada país a la categoría >90%:\n")
print(sort(table(alta$pais), decreasing = TRUE))
g <- ggplot(alta, aes(x = pais, y = crecimiento_pib_real_pct)) +
  geom_boxplot(fill = "#dfeae5") +
  geom_hline(yintercept = 0, color = "gray50") +
  labs(x = NULL, y = "Crecimiento del PIB real (%)", title = "Países con deuda > 90 % del PIB") +
  theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(g)

# Para pensar: En la versión publicada, Nueva Zelanda aportaba un solo año a la categoría >90% (1951, con crecimiento de −7,6 %) y el Reino Unido aportaba 19. Con promedios por país, ese único año pesa lo mismo que los 19 británicos. ¿Es justo? ¿Qué pregunta responde cada forma de promediar?
