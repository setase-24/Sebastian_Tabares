"""
Expediente 12: La crisis de las tarjetas en Taiwán
Taiwán, abril–septiembre de 2005
Temas: 1.2 clasificación de variables · 1.3 escalas · 2.1–2.3 descriptiva · 4.5 condicional · De Morgan

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: credito_taiwan_2005.csv
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

c = leer("credito_taiwan_2005.csv")

# 1. Clasificación de variables
clasificacion = pd.DataFrame([
    ("LIMIT_BAL", "cuantitativa continua", "razón"),
    ("SEX", "cualitativa", "nominal"),
    ("EDUCATION", "cualitativa", "ordinal"),
    ("MARRIAGE", "cualitativa", "nominal"),
    ("AGE", "cuantitativa discreta", "razón"),
    ("PAY_1 ... PAY_6", "cualitativa", "ordinal"),
    ("BILL_AMT1 ... 6", "cuantitativa continua", "razón (puede ser negativa)"),
    ("PAY_AMT1 ... 6", "cuantitativa continua", "razón"),
    ("incumplio_mes_siguiente", "cualitativa", "nominal binaria"),
], columns=["variable", "tipo", "escala"])
print(clasificacion.to_string(index=False))

# 2. Códigos no documentados
print("\nEDUCATION:", c["EDUCATION"].value_counts().sort_index().to_dict())
print("MARRIAGE: ", c["MARRIAGE"].value_counts().sort_index().to_dict())
raros = (~c["EDUCATION"].isin([1, 2, 3, 4])) | (~c["MARRIAGE"].isin([1, 2, 3]))
print(f"Clientes con algún código no documentado: {raros.sum()}")

print("\nCupo (LIMIT_BAL):")
print(c["LIMIT_BAL"].describe().round(0))

# 3. Probabilidades condicionales
incumple = c["incumplio_mes_siguiente"] == 1
retraso = c["PAY_1"] >= 1
cupo_bajo = c["LIMIT_BAL"] < 50_000
print(f"\nP(incumplir) = {incumple.mean():.3f}")
print(f"P(incumplir | retraso en sept.) = {incumple[retraso].mean():.3f}")
print(f"P(incumplir | retraso y cupo < 50.000) = {incumple[retraso & cupo_bajo].mean():.3f}")

# De Morgan: NOT (retraso OR cupo_bajo) = (NOT retraso) AND (NOT cupo_bajo)
print(f"\nNOT (retraso OR cupo bajo):            {(~(retraso | cupo_bajo)).sum()}")
print(f"(NOT retraso) AND (NOT cupo bajo):     {(~retraso & ~cupo_bajo).sum()}")

# Para pensar: Un retraso de un mes en septiembre sube la probabilidad de incumplir de 22 % a 50 %. ¿Eso significa que el retraso causa el incumplimiento? ¿Cómo usaría un banco esa información y qué riesgos de discriminación tiene usar sexo o edad?
