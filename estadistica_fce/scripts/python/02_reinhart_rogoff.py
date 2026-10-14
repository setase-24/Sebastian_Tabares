"""
Expediente 02: El error de Excel que justificó la austeridad
Harvard y UMass Amherst, 2010–2013
Temas: 2.2 media, mediana y media ponderada · 2.3 datos atípicos

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: reinhart_rogoff_1946_2009.csv
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

rr = leer("reinhart_rogoff_1946_2009.csv")
orden = ["0-30%", "30-60%", "60-90%", ">90%"]
rr["categoria_deuda"] = pd.Categorical(rr["categoria_deuda"], categories=orden, ordered=True)

# 1. Cada país-año pesa lo mismo
print("Media y mediana con todos los país-año:")
print(rr.groupby("categoria_deuda", observed=True)["crecimiento_pib_real_pct"].agg(["mean", "median", "count"]).round(2))

# 2. Cada país pesa lo mismo (promedio de promedios), como hicieron Reinhart y Rogoff
def promedio_por_pais(df):
    por_pais = df.groupby(["categoria_deuda", "pais"], observed=True)["crecimiento_pib_real_pct"].mean()
    return por_pais.groupby(level="categoria_deuda", observed=True).mean()

excluidos = ["Australia", "Austria", "Belgium", "Canada", "Denmark"]
tabla = pd.DataFrame({
    "pais_anio": rr.groupby("categoria_deuda", observed=True)["crecimiento_pib_real_pct"].mean(),
    "promedio_por_pais": promedio_por_pais(rr),
    "con_error_excel": promedio_por_pais(rr[~rr["pais"].isin(excluidos)]),
}).round(2)
print("\nTres formas de promediar el crecimiento (%):")
print(tabla)
print("Reinhart y Rogoff publicaron -0,1 % para >90%. Además del error de Excel, excluyeron años de Nueva Zelanda, Australia y Canadá.")

# 3. Atípicos en la categoría >90%
alta = rr[rr["categoria_deuda"] == ">90%"]
print("\nAños que aporta cada país a la categoría >90%:")
print(alta["pais"].value_counts())
paises = alta["pais"].value_counts().index.tolist()
plt.figure(figsize=(9, 5))
plt.boxplot([alta.loc[alta["pais"] == p, "crecimiento_pib_real_pct"] for p in paises], tick_labels=paises)
plt.axhline(0, color="gray", linewidth=0.8)
plt.ylabel("Crecimiento del PIB real (%)")
plt.title("Países con deuda > 90 % del PIB")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# Para pensar: En la versión publicada, Nueva Zelanda aportaba un solo año a la categoría >90% (1951, con crecimiento de −7,6 %) y el Reino Unido aportaba 19. Con promedios por país, ese único año pesa lo mismo que los 19 británicos. ¿Es justo? ¿Qué pregunta responde cada forma de promediar?
