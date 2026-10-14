"""
Expediente 05: La ballena de Londres y una fórmula mal copiada
JPMorgan Chase, 2012
Temas: 2.2 dispersión y medidas de riesgo · percentiles

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: sp500_shiller_mensual.csv
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

sp = leer("sp500_shiller_mensual.csv")
sp["fecha"] = pd.to_datetime(sp["fecha"])
datos = sp[(sp["fecha"] >= "1990-01-01") & (sp["fecha"] <= "2007-12-31")]["rend_mensual_pct"].dropna()

# 1. Desviación estándar y VaR histórico al 95 %
media, desv = datos.mean(), datos.std()
var_historico = datos.quantile(0.05)
print(f"Media mensual: {media:.2f} %   Desviación estándar: {desv:.2f} %")
print(f"VaR histórico 95 % (percentil 5): {var_historico:.2f} %")

# 2. El error de JPMorgan: dividir por la suma en vez del promedio deja la volatilidad a la mitad
desv_error = desv / 2
var_bien = media - 1.645 * desv
var_mal = media - 1.645 * desv_error
print(f"VaR paramétrico con la volatilidad correcta: {var_bien:.2f} %")
print(f"VaR paramétrico con el error:                {var_mal:.2f} %")

# ¿Cuántos meses de 2008-2009 la pérdida superó cada VaR?
crisis = sp[(sp["fecha"] >= "2008-01-01") & (sp["fecha"] <= "2009-12-31")]
print(f"\nMeses de 2008-2009: {len(crisis)}")
print(f"Meses peores que el VaR correcto: {(crisis['rend_mensual_pct'] < var_bien).sum()}")
print(f"Meses peores que el VaR con error: {(crisis['rend_mensual_pct'] < var_mal).sum()}")
print("Si el VaR al 95 % estuviera bien calibrado, se esperaría superarlo en 1 de cada 20 meses.")

plt.figure(figsize=(9, 4))
plt.bar(crisis["fecha"], crisis["rend_mensual_pct"], width=20, color="#1d5c4a")
plt.axhline(var_bien, color="#1d5c4a", linestyle="--", label="VaR correcto")
plt.axhline(var_mal, color="#a3392c", linestyle="--", label="VaR con el error")
plt.ylabel("Rendimiento mensual (%)")
plt.legend()
plt.title("S&P 500 en 2008-2009 frente al VaR estimado con 1990-2007")
plt.tight_layout()
plt.show()

# Para pensar: Si el VaR dice «95 % de los meses perderás menos de X», ¿cuántos meses de cada 100 esperarías que se pase? ¿Qué te dice que en 2008 se haya pasado muchas más veces?
