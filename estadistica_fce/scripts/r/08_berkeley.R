# Expediente 08: ¿Discriminación en las admisiones?
# Universidad de California, Berkeley, 1973
# Temas: 3.1 tablas de contingencia · 4.5 probabilidad condicional · paradoja de Simpson
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: berkeley_admisiones_1973.csv
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

b <- leer("berkeley_admisiones_1973.csv")

# 1. Tabla de contingencia sexo x resultado
tabla <- xtabs(frecuencia ~ sexo + resultado, data = b)
print(tabla)
cat("\nP(admitido | sexo):\n")
print(round(prop.table(tabla, margin = 1)[, "Admitido"], 3))

# 2. Por departamento
por_dep <- b |> group_by(departamento, sexo) |>
  summarise(tasa = sum(frecuencia[resultado == "Admitido"]) / sum(frecuencia),
            postulantes = sum(frecuencia), .groups = "drop")
resumen <- por_dep |> group_by(departamento) |>
  summarise(hombre = tasa[sexo == "Hombre"], mujer = tasa[sexo == "Mujer"],
            pct_mujeres = 100 * postulantes[sexo == "Mujer"] / sum(postulantes),
            tasa_total = sum(tasa * postulantes) / sum(postulantes))
cat("\nP(admitido | sexo, departamento):\n")
print(resumen |> mutate(across(where(is.numeric), \(x) round(x, 2))))

g <- ggplot(por_dep, aes(departamento, tasa, fill = sexo)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("#1d5c4a", "#a3392c")) +
  labs(y = "Tasa de admisión", title = "Berkeley 1973: admisión por departamento") +
  theme_minimal()
print(g)

# Para pensar: ¿En qué departamentos se postulaban más las mujeres, y qué tan difícil era entrar ahí? ¿Qué otra variable escondida podría cambiar una conclusión en una base de datos de crédito o de salarios?
