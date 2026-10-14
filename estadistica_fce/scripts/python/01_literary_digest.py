"""
Expediente 01: La encuesta más grande que falló
Estados Unidos, 1936
Temas: 1.1 población y muestra · 4.3 probabilidad frecuentista

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: literary_digest_1936.csv
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

ld = leer("literary_digest_1936.csv")

# 1. Porcentaje de Landon por estado y en total
ld["pct_landon"] = 100 * ld["sondeo_landon"] / (ld["sondeo_landon"] + ld["sondeo_roosevelt"])
total_landon = ld["sondeo_landon"].sum()
total_fdr = ld["sondeo_roosevelt"].sum()
print(f"Papeletas en la tabla: {total_landon + total_fdr:,}")
print(f"Landon según el sondeo: {100 * total_landon / (total_landon + total_fdr):.1f} %")
print("Resultado real de la elección: Roosevelt 60,8 %, Landon 36,5 %")

estados = ld[ld["estado"] != "Other"]
print(f"Estados donde el sondeo daba ganador a Landon: {(estados['pct_landon'] > 50).sum()} de {len(estados)}")
print("En la elección real Landon ganó solo 2: Maine y Vermont.")

# 2. Buscar filas sospechosas
print("\nVotos de Roosevelt repetidos en estados distintos:")
print(ld[ld.duplicated("sondeo_roosevelt", keep=False)].sort_values("sondeo_roosevelt"))
print("\nFilas con los mismos votos de Landon y Roosevelt:")
print(ld[ld.duplicated(["sondeo_landon", "sondeo_roosevelt"], keep=False)])
print(f"\nSuma de votos electorales: {ld['votos_electorales'].sum()} (debería ser 531)")

# 3. Gráfica: porcentaje de Landon por estado
orden = estados.sort_values("pct_landon")
plt.figure(figsize=(7, 10))
plt.barh(orden["estado"], orden["pct_landon"], color="#1d5c4a")
plt.axvline(50, color="#a3392c", linestyle="--")
plt.xlabel("% de papeletas a favor de Landon")
plt.title("Literary Digest 1936: lo que decía el sondeo")
plt.tight_layout()
plt.show()

# Para pensar: Roosevelt sacó el 61 % real. ¿Por qué 2,4 millones de respuestas no bastaron? ¿Qué parte del error viene de a quién se le envió la papeleta y qué parte de quién decidió responder?
