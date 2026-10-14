"""
Expediente 04: La ley del primer dígito y las cuentas de Grecia
Unión Europea, 1999–2009
Temas: 2.1 tablas de frecuencia y diagramas de barras · 1.2 tipo de variable

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: eurostat_finanzas_publicas_1999_2009.csv
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

eu = leer("eurostat_finanzas_publicas_1999_2009.csv")

# 1. Primer dígito de cada cifra
eu = eu[eu["value"].abs() >= 1].copy()
eu["digito"] = eu["value"].abs().astype(str).str.lstrip("0.").str[0].astype(int)
benford = pd.Series(np.log10(1 + 1 / np.arange(1, 10)), index=range(1, 10))

frec = eu["digito"].value_counts(normalize=True).sort_index()
print(pd.DataFrame({"observado": frec, "benford": benford}).round(3))

# 2. Desviación absoluta media (MAD) por país
def mad(df):
    f = df["digito"].value_counts(normalize=True).reindex(range(1, 10), fill_value=0)
    return (f - benford).abs().mean()

ranking = eu.groupby("geo").apply(mad, include_groups=False).sort_values(ascending=False)
print("\nPaíses más alejados de Benford (MAD):")
print(ranking.round(4).head(10))
print(f"Grecia (EL) queda en el puesto {list(ranking.index).index('EL') + 1} de {len(ranking)}")

grecia = eu[eu["geo"] == "EL"]["digito"].value_counts(normalize=True).sort_index()
plt.figure(figsize=(7, 4))
plt.bar(grecia.index, grecia.values, color="#1d5c4a", label="Grecia")
plt.plot(benford.index, benford.values, "o-", color="#a3392c", label="Ley de Benford")
plt.xticks(range(1, 10))
plt.xlabel("Primer dígito")
plt.ylabel("Frecuencia relativa")
plt.legend()
plt.title("Cifras fiscales de Grecia 1999-2009 frente a Benford")
plt.tight_layout()
plt.show()

# Para pensar: ¿En qué posición quedó Grecia con los datos corregidos? Si un país corrige sus cifras después de un escándalo, ¿qué esperarías que le pase a su ajuste con Benford?
