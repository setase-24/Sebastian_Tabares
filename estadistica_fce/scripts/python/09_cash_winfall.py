"""
Expediente 09: La lotería que sí se podía ganar
Massachusetts, 2005–2012
Temas: 4.4 reglas de conteo · 4.2 probabilidad clásica · valor esperado

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: no requiere archivo
"""

from math import comb

# 1. Lotería 6 de 46 (Cash WinFall)
N, K = 46, 6
total = comb(N, K)
print(f"Combinaciones posibles: {total:,}")

# Probabilidad de acertar exactamente k números (hipergeométrica)
prob = {k: comb(K, k) * comb(N - K, K - k) / total for k in range(K + 1)}
for k, p in prob.items():
    print(f"Acertar {k}: {p:.8f}  (1 en {1 / p:,.0f})")

# 2. Baloto: verifica el formato vigente en la página oficial y cambia estos valores
numeros, de_cuantos, superbalotas = 5, 43, 16
baloto = comb(de_cuantos, numeros) * superbalotas
print(f"\nBaloto ({numeros} de {de_cuantos} + 1 de {superbalotas}): {baloto:,} combinaciones")
print(f"Es {baloto / total:.1f} veces más difícil que Cash WinFall")

# 3. Valor esperado en una semana de roll-down
# Supuestos del ejercicio (aproximan las reglas del juego; puedes cambiarlos):
# premios fijos por nivel, más el roll-down repartido entre los niveles 5, 4 y 3.
vendidos = 1_500_000
precio = 2
premios_fijos = {5: 4000, 4: 150, 3: 5, 2: 2}   # acertar 2 = un tiquete gratis
reparto = {5: 0.225, 4: 0.225, 3: 0.55}
roll_down = 2_000_000

valor_esperado = sum(premio * prob[k] for k, premio in premios_fijos.items())
print(f"\nValor esperado solo con premios fijos: {valor_esperado:.2f} dólares")
for k, fraccion in reparto.items():
    ganadores = vendidos * prob[k]
    extra = roll_down * fraccion / ganadores
    valor_esperado += prob[k] * extra
    print(f"Acertar {k}: unos {ganadores:,.0f} ganadores; el roll-down le suma ≈ {extra:,.0f} dólares a cada uno")
print(f"Valor esperado de un tiquete de {precio} dólares en semana de roll-down: {valor_esperado:.2f} dólares")
print("Si es mayor que el precio, comprar muchísimos tiquetes da ganancia esperada positiva.")

# Para pensar: ¿Por qué el estado no perdía plata aunque estos grupos ganaran? ¿Quién estaba pagando las ganancias de los grupos organizados?
