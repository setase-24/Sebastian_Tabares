# Expediente 06: Cuando todas las casas cayeron juntas
# Estados Unidos, 2000–2011
# Temas: 3.2 coeficiente de correlación · correlación que cambia en el tiempo
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: case_shiller_ciudades_eeuu.csv
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

cs <- leer("case_shiller_ciudades_eeuu.csv") |> mutate(fecha = as.Date(fecha)) |> select(-compuesto_20)

# 1. Variación mensual de cada ciudad
ciudades <- setdiff(names(cs), "fecha")
var <- cs |> mutate(across(all_of(ciudades), \(x) 100 * (x / lag(x) - 1)))
antes  <- var |> filter(fecha >= as.Date("2000-01-01"), fecha <= as.Date("2006-06-01"))
crisis <- var |> filter(fecha >= as.Date("2006-07-01"), fecha <= as.Date("2011-12-01"))
m_antes  <- cor(antes[ciudades],  use = "pairwise.complete.obs")
m_crisis <- cor(crisis[ciudades], use = "pairwise.complete.obs")
prom <- function(m) mean(m[upper.tri(m)], na.rm = TRUE)
cat(sprintf("Correlación promedio entre ciudades, 2000 a mediados de 2006: %.2f\n", prom(m_antes)))
cat(sprintf("Correlación promedio entre ciudades, mediados de 2006 a 2011: %.2f\n", prom(m_crisis)))

# 2. Mapas de calor
a_largo <- function(m, periodo) {
  data.frame(c1 = rep(rownames(m), ncol(m)), c2 = rep(colnames(m), each = nrow(m)), r = as.vector(m), periodo = periodo)
}
calor <- rbind(a_largo(m_antes, "2000 - jun 2006"), a_largo(m_crisis, "jul 2006 - 2011"))
print(ggplot(calor, aes(c1, c2, fill = r)) + geom_tile() + facet_wrap(~periodo) +
        scale_fill_gradient2(low = "#2b5c8a", mid = "white", high = "#a3392c", limits = c(-1, 1)) +
        labs(x = NULL, y = NULL) + theme_minimal() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 6), axis.text.y = element_text(size = 6)))

# 3. Miami contra Denver
md <- rbind(transform(antes[c("miami", "denver")], periodo = "antes"),
            transform(crisis[c("miami", "denver")], periodo = "crisis"))
print(md |> group_by(periodo) |> summarise(r = cor(miami, denver, use = "complete.obs")))
g <- ggplot(md, aes(denver, miami, color = periodo)) + geom_point() +
  scale_color_manual(values = c("#1d5c4a", "#a3392c")) +
  labs(x = "Denver: variación mensual (%)", y = "Miami: variación mensual (%)",
       title = "Cuando todas las casas cayeron juntas") + theme_minimal()
print(g)

# Para pensar: Si un banco diversificó comprando hipotecas en 20 ciudades porque «no están muy correlacionadas», ¿qué le pasó a esa diversificación en 2007? ¿Qué supuesto falló?
