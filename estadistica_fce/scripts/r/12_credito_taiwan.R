# Expediente 12: La crisis de las tarjetas en Taiwán
# Taiwán, abril–septiembre de 2005
# Temas: 1.2 clasificación de variables · 1.3 escalas · 2.1–2.3 descriptiva · 4.5 condicional · De Morgan
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: credito_taiwan_2005.csv
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

cr <- leer("credito_taiwan_2005.csv")

# 1. Clasificación de variables
clasificacion <- data.frame(
  variable = c("LIMIT_BAL", "SEX", "EDUCATION", "MARRIAGE", "AGE", "PAY_1 ... PAY_6",
               "BILL_AMT1 ... 6", "PAY_AMT1 ... 6", "incumplio_mes_siguiente"),
  tipo = c("cuantitativa continua", "cualitativa", "cualitativa", "cualitativa", "cuantitativa discreta",
           "cualitativa", "cuantitativa continua", "cuantitativa continua", "cualitativa"),
  escala = c("razón", "nominal", "ordinal", "nominal", "razón", "ordinal",
             "razón (puede ser negativa)", "razón", "nominal binaria"))
print(clasificacion)

# 2. Códigos no documentados
cat("\nEDUCATION:\n"); print(table(cr$EDUCATION))
cat("MARRIAGE:\n");   print(table(cr$MARRIAGE))
raros <- !(cr$EDUCATION %in% 1:4) | !(cr$MARRIAGE %in% 1:3)
cat("Clientes con algún código no documentado:", sum(raros), "\n")
cat("\nCupo (LIMIT_BAL):\n"); print(summary(cr$LIMIT_BAL))

# 3. Probabilidades condicionales
incumple <- cr$incumplio_mes_siguiente == 1
retraso <- cr$PAY_1 >= 1
cupo_bajo <- cr$LIMIT_BAL < 50000
cat(sprintf("\nP(incumplir) = %.3f\n", mean(incumple)))
cat(sprintf("P(incumplir | retraso en sept.) = %.3f\n", mean(incumple[retraso])))
cat(sprintf("P(incumplir | retraso y cupo < 50.000) = %.3f\n", mean(incumple[retraso & cupo_bajo])))

# De Morgan: NOT (retraso OR cupo_bajo) = (NOT retraso) AND (NOT cupo_bajo)
cat("\nNOT (retraso OR cupo bajo):       ", sum(!(retraso | cupo_bajo)), "\n")
cat("(NOT retraso) AND (NOT cupo bajo):", sum(!retraso & !cupo_bajo), "\n")

# Para pensar: Un retraso de un mes en septiembre sube la probabilidad de incumplir de 22 % a 50 %. ¿Eso significa que el retraso causa el incumplimiento? ¿Cómo usaría un banco esa información y qué riesgos de discriminación tiene usar sexo o edad?
