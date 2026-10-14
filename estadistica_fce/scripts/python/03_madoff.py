"""
Expediente 03: Demasiado estable para ser real
Nueva York, 1990–2008
Temas: 2.2 desviación estándar y coeficiente de variación · 2.3 atípicos

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: madoff_fairfield_sentry_mensual.csv
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

m = leer("madoff_fairfield_sentry_mensual.csv")

# 1. Resumen de cada serie
def resumen(x):
    return pd.Series({
        "media": x.mean(), "mediana": x.median(), "desv_est": x.std(),
        "coef_variacion": x.std() / x.mean(), "meses_negativos": (x < 0).sum(),
        "minimo": x.min(), "maximo": x.max(),
    })

tabla = pd.DataFrame({"Fairfield (Madoff)": resumen(m["rend_fairfield_pct"]),
                      "S&P 500": resumen(m["rend_sp500_pct"])}).round(2)
print(tabla)
print(f"\nLa hoja del fondo decía 'solo 13 meses con pérdida'. En la tabla hay {(m['rend_fairfield_pct'] < 0).sum()}.")

# 2. Histogramas con la misma escala y valor acumulado de 100 dólares
fig, ejes = plt.subplots(1, 2, figsize=(11, 4), sharex=True)
bins = range(-21, 13)
ejes[0].hist(m["rend_fairfield_pct"], bins=bins, color="#1d5c4a")
ejes[0].set_title("Fairfield Sentry (Madoff)")
ejes[1].hist(m["rend_sp500_pct"], bins=bins, color="#a3392c")
ejes[1].set_title("S&P 500")
for e in ejes:
    e.set_xlabel("Rendimiento mensual (%)")
plt.tight_layout()
plt.show()

m["fecha"] = pd.to_datetime(m["mes"])
plt.figure(figsize=(9, 4))
plt.plot(m["fecha"], 100 * (1 + m["rend_fairfield_pct"] / 100).cumprod(), label="Fairfield (Madoff)")
plt.plot(m["fecha"], 100 * (1 + m["rend_sp500_pct"] / 100).cumprod(), label="S&P 500")
plt.ylabel("Valor de 100 dólares")
plt.legend()
plt.title("Demasiado estable para ser real")
plt.tight_layout()
plt.show()

# 3. Correlación con el mercado
r = m["rend_fairfield_pct"].corr(m["rend_sp500_pct"])
print(f"Correlación Fairfield vs S&P 500: {r:.2f}")

# Para pensar: La hoja informativa del fondo dice «solo 13 meses con pérdida». Cuenta tú los meses negativos en la tabla. ¿Coinciden? ¿Qué te dice eso de confiar en el resumen sin mirar los datos?
