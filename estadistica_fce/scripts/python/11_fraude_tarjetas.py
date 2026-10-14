"""
Expediente 11: ¿Por qué el banco te bloquea compras legítimas?
Tarjetahabientes europeos, septiembre de 2013
Temas: 4.5 probabilidad condicional · 4.6 teorema de Bayes · tasa base

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: fraude_tarjetas_muestra.csv
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

f = leer("fraude_tarjetas_muestra.csv")
fraude = f["Class"] == 1

# 1. Tasa base y montos
print(f"Transacciones: {len(f):,}   Fraudes: {fraude.sum()}   Proporción: {fraude.mean():.4%}")
print(f.groupby("Class")["Amount"].agg(["mean", "median", "std", "max"]).round(2))

# 2. Una alerta simple: V14 < -5
alerta = f["V14"] < -5
sens = alerta[fraude].mean()
falsa = alerta[~fraude].mean()
p = fraude.mean()
ppv = sens * p / (sens * p + falsa * (1 - p))
print(f"\nP(alerta | fraude)    = {sens:.3f}")
print(f"P(alerta | no fraude) = {falsa:.4f}")
print(f"P(fraude | alerta) por Bayes = {ppv:.3f}")
print(f"P(fraude | alerta) contando  = {fraude[alerta].mean():.3f}")

# 3. Un detector "99 % / 1 %" con la tasa base real
base = 0.00173
n = 100_000
fraudes = n * base
verdaderas = 0.99 * fraudes
falsas = 0.01 * (n - fraudes)
print(f"\nDe {n:,} transacciones: {fraudes:.0f} fraudes")
print(f"Alertas verdaderas: {verdaderas:.0f}   Alertas falsas: {falsas:.0f}")
print(f"P(fraude | alerta) = {verdaderas / (verdaderas + falsas):.3f}")

# Para pensar: Si fueras el banco, ¿qué cuesta más: una alarma falsa o un fraude no detectado? ¿Cómo cambiarías el umbral de la alerta según esa respuesta?
