"""
Expediente 08: ¿Discriminación en las admisiones?
Universidad de California, Berkeley, 1973
Temas: 3.1 tablas de contingencia · 4.5 probabilidad condicional · paradoja de Simpson

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: berkeley_admisiones_1973.csv
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

b = leer("berkeley_admisiones_1973.csv")

# 1. Tabla de contingencia sexo x resultado
tabla = b.pivot_table(index="sexo", columns="resultado", values="frecuencia", aggfunc="sum")
tabla["P(admitido | sexo)"] = (tabla["Admitido"] / tabla.sum(axis=1)).round(3)
print(tabla)

# 2. Por departamento
por_dep = b.pivot_table(index=["departamento", "sexo"], columns="resultado", values="frecuencia", aggfunc="sum")
por_dep["tasa"] = por_dep["Admitido"] / (por_dep["Admitido"] + por_dep["Rechazado"])
tasas = por_dep["tasa"].unstack().round(2)
postulantes = b.groupby(["departamento", "sexo"])["frecuencia"].sum().unstack()
tasas["% mujeres entre postulantes"] = (100 * postulantes["Mujer"] / postulantes.sum(axis=1)).round(0)
tasas["tasa total del depto"] = (por_dep["Admitido"].groupby(level=0).sum() / postulantes.sum(axis=1)).round(2)
print("\nP(admitido | sexo, departamento):")
print(tasas)

ax = tasas[["Hombre", "Mujer"]].plot(kind="bar", color=["#1d5c4a", "#a3392c"], figsize=(8, 4))
ax.set_ylabel("Tasa de admisión")
ax.set_title("Berkeley 1973: admisión por departamento")
plt.xticks(rotation=0)
plt.tight_layout()
plt.show()

# Para pensar: ¿En qué departamentos se postulaban más las mujeres, y qué tan difícil era entrar ahí? ¿Qué otra variable escondida podría cambiar una conclusión en una base de datos de crédito o de salarios?
