# Expediente 10: Bayes contra el correo basura
# Hewlett-Packard 1999 · Paul Graham 2002
# Temas: 4.5 probabilidad condicional · 4.6 teorema de Bayes · leyes de De Morgan
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: spambase_hp_1999.csv
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

s <- leer("spambase_hp_1999.csv")

# 1. Bayes con la palabra "free"
spam <- s$es_spam == 1
free <- s$word_freq_free > 0
p_spam <- mean(spam); p_free <- mean(free); p_free_dado_spam <- mean(free[spam])
cat(sprintf("P(spam) = %.3f\nP(free) = %.3f\nP(free | spam) = %.3f\n", p_spam, p_free, p_free_dado_spam))
cat(sprintf("P(spam | free) por Bayes = %.3f\n", p_free_dado_spam * p_spam / p_free))
cat(sprintf("P(spam | free) contando  = %.3f\n", mean(spam[free])))

# 2. Varias palabras
palabras <- c("free", "money", "remove", "credit", "meeting", "george", "hp")
tabla <- do.call(rbind, lapply(palabras, function(w) {
  tiene <- s[[paste0("word_freq_", w)]] > 0
  data.frame(palabra = w, p_palabra = mean(tiene), p_spam_dado_palabra = mean(spam[tiene]))
}))
print(tabla |> arrange(desc(p_spam_dado_palabra)) |> mutate(across(where(is.numeric), \(x) round(x, 3))))

# 3. Leyes de De Morgan
money <- s$word_freq_money > 0
forma_1 <- !(free | money)
forma_2 <- !free & !money
cat("\nNOT (free OR money):       ", sum(forma_1), "correos\n")
cat("(NOT free) AND (NOT money):", sum(forma_2), "correos\n")
cat("¿Son iguales?", all(forma_1 == forma_2), "\n")

# Para pensar: Este filtro se entrenó con los correos de una sola empresa. ¿Funcionaría igual con tu correo de la universidad? ¿Qué palabras cambiarías?
