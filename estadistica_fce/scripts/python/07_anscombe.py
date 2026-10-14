"""
Expediente 07: Mismos números, gráficas opuestas
Anscombe 1973 · Matejka y Fitzmaurice 2017
Temas: 3.1 gráficos de dos variables · 3.2 correlación · 2.2 resúmenes

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: anscombe_cuarteto.csv, datasaurus_docena.csv
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

import matplotlib.pyplot as plt

an = leer("anscombe_cuarteto.csv")
ds = leer("datasaurus_docena.csv")

# 1. Resúmenes por conjunto
def resumen(df):
    return df.groupby("conjunto").apply(lambda g: pd.Series({
        "media_x": g["x"].mean(), "desv_x": g["x"].std(),
        "media_y": g["y"].mean(), "desv_y": g["y"].std(),
        "r": g["x"].corr(g["y"]),
    }), include_groups=False).round(2)

print("Cuarteto de Anscombe:")
print(resumen(an))
print("\nDocena del Datasaurus:")
print(resumen(ds))

# 2. Una gráfica por conjunto, con los mismos ejes
for df, columnas in [(an, 2), (ds, 5)]:
    grupos = df["conjunto"].unique()
    filas = -(-len(grupos) // columnas)
    fig, ejes = plt.subplots(filas, columnas, figsize=(3 * columnas, 3 * filas), sharex=True, sharey=True)
    for eje, g in zip(ejes.flat, grupos):
        d = df[df["conjunto"] == g]
        eje.scatter(d["x"], d["y"], s=10, color="#1d5c4a")
        eje.set_title(g, fontsize=9)
    for eje in list(ejes.flat)[len(grupos):]:
        eje.axis("off")
    plt.tight_layout()
    plt.show()

# 3. Quitar el atípico del conjunto 3
c3 = an[an["conjunto"] == "(3) Outlier"]
sin_atipico = c3[c3["y"] < c3["y"].max()]
print(f"\nConjunto 3: r con atípico = {c3['x'].corr(c3['y']):.3f}, sin atípico = {sin_atipico['x'].corr(sin_atipico['y']):.3f}")

# Para pensar: Si un analista te entrega solo la tabla de resúmenes, ¿podrías saber cuál conjunto es el dinosaurio? ¿Qué le pedirías antes de creer en una correlación?
