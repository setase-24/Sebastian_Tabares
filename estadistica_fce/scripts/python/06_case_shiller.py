"""
Expediente 06: Cuando todas las casas cayeron juntas
Estados Unidos, 2000–2011
Temas: 3.2 coeficiente de correlación · correlación que cambia en el tiempo

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: case_shiller_ciudades_eeuu.csv
"""
import os
import pandas as pd

URL_DATOS = "https://raw.githubusercontent.com/setase-24/Sebastian_Tabares/main/estadistica_fce/datos/"

def leer(archivo):
    """Lee el CSV desde la carpeta datos/ si existe; si no, lo descarga de GitHub."""
    for ruta in ("datos", "../datos", "../../datos"):
        if os.path.exists(os.path.join(ruta, archivo)):
            return pd.read_csv(os.path.join(ruta, archivo))
    return pd.read_csv(URL_DATOS + archivo)

import numpy as np
import matplotlib.pyplot as plt

cs = leer("case_shiller_ciudades_eeuu.csv")
cs["fecha"] = pd.to_datetime(cs["fecha"])
cs = cs.set_index("fecha").drop(columns="compuesto_20")

# 1. Variación mensual de cada ciudad
var = cs.pct_change(fill_method=None) * 100
antes = var.loc["2000-01-01":"2006-06-01"].corr()
crisis = var.loc["2006-07-01":"2011-12-01"].corr()

def promedio_pares(m):
    valores = m.values[np.triu_indices_from(m.values, 1)]
    return np.nanmean(valores)

print(f"Correlación promedio entre ciudades, 2000 a mediados de 2006: {promedio_pares(antes):.2f}")
print(f"Correlación promedio entre ciudades, mediados de 2006 a 2011: {promedio_pares(crisis):.2f}")

# 2. Mapas de calor
fig, ejes = plt.subplots(1, 2, figsize=(14, 6))
for eje, m, titulo in [(ejes[0], antes, "2000 - jun 2006"), (ejes[1], crisis, "jul 2006 - 2011")]:
    im = eje.imshow(m, vmin=-1, vmax=1, cmap="RdBu_r")
    eje.set_xticks(range(len(m)), m.columns, rotation=90, fontsize=7)
    eje.set_yticks(range(len(m)), m.columns, fontsize=7)
    eje.set_title(titulo)
fig.colorbar(im, ax=ejes, shrink=0.7)
plt.show()

# 3. Miami contra Denver
for nombre, desde, hasta, color in [("antes", "2000-01-01", "2006-06-01", "#1d5c4a"), ("crisis", "2006-07-01", "2011-12-01", "#a3392c")]:
    trozo = var.loc[desde:hasta, ["miami", "denver"]].dropna()
    plt.scatter(trozo["denver"], trozo["miami"], color=color, label=f"{nombre}: r = {trozo['miami'].corr(trozo['denver']):.2f}")
plt.xlabel("Denver: variación mensual (%)")
plt.ylabel("Miami: variación mensual (%)")
plt.legend()
plt.title("Cuando todas las casas cayeron juntas")
plt.show()

# Para pensar: Si un banco diversificó comprando hipotecas en 20 ciudades porque «no están muy correlacionadas», ¿qué le pasó a esa diversificación en 2007? ¿Qué supuesto falló?
