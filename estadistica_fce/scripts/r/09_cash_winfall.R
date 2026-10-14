# Expediente 09: La lotería que sí se podía ganar
# Massachusetts, 2005–2012
# Temas: 4.4 reglas de conteo · 4.2 probabilidad clásica · valor esperado
#
# Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
# Autor: Sebastián Tabares
# Datos: no requiere archivo
# Paquetes: install.packages(c("dplyr", "ggplot2"))


# 1. Lotería 6 de 46 (Cash WinFall)
N <- 46; K <- 6
total <- choose(N, K)
cat("Combinaciones posibles:", format(total, big.mark = ","), "\n")

# Probabilidad de acertar exactamente k números (hipergeométrica)
k <- 0:6
prob <- dhyper(k, K, N - K, K)
print(data.frame(aciertos = k, probabilidad = signif(prob, 4), uno_en = round(1 / prob)))

# 2. Baloto: verifica el formato vigente en la página oficial y cambia estos valores
numeros <- 5; de_cuantos <- 43; superbalotas <- 16
baloto <- choose(de_cuantos, numeros) * superbalotas
cat("\nBaloto:", format(baloto, big.mark = ","), "combinaciones\n")
cat(sprintf("Es %.1f veces más difícil que Cash WinFall\n", baloto / total))

# 3. Valor esperado en una semana de roll-down
# Supuestos del ejercicio (aproximan las reglas del juego; puedes cambiarlos):
# premios fijos por nivel, más el roll-down repartido entre los niveles 5, 4 y 3.
vendidos <- 1500000
precio <- 2
p <- setNames(prob, k)
premios_fijos <- c("5" = 4000, "4" = 150, "3" = 5, "2" = 2)   # acertar 2 = un tiquete gratis
reparto <- c("5" = 0.225, "4" = 0.225, "3" = 0.55)
roll_down <- 2000000

ve <- sum(premios_fijos * p[names(premios_fijos)])
cat(sprintf("\nValor esperado solo con premios fijos: %.2f dólares\n", ve))
for (nivel in names(reparto)) {
  ganadores <- vendidos * p[nivel]
  extra <- roll_down * reparto[nivel] / ganadores
  ve <- ve + p[nivel] * extra
  cat(sprintf("Acertar %s: unos %.0f ganadores; el roll-down le suma ≈ %.0f dólares a cada uno\n", nivel, ganadores, extra))
}
cat(sprintf("Valor esperado de un tiquete de %d dólares en semana de roll-down: %.2f dólares\n", precio, ve))

# Para pensar: ¿Por qué el estado no perdía plata aunque estos grupos ganaran? ¿Quién estaba pagando las ganancias de los grupos organizados?
