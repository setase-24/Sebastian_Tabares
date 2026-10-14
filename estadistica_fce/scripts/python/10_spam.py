"""
Expediente 10: Bayes contra el correo basura
Hewlett-Packard 1999 · Paul Graham 2002
Temas: 4.5 probabilidad condicional · 4.6 teorema de Bayes · leyes de De Morgan

Material de apoyo de Probabilidad y Estadística Fundamental (FCE).
Autor: Sebastián Tabares
Datos: spambase_hp_1999.csv
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

s = leer("spambase_hp_1999.csv")

# 1. Bayes con la palabra "free"
spam = s["es_spam"] == 1
free = s["word_freq_free"] > 0
p_spam = spam.mean()
p_free = free.mean()
p_free_dado_spam = free[spam].mean()
p_spam_dado_free = p_free_dado_spam * p_spam / p_free
print(f"P(spam) = {p_spam:.3f}")
print(f"P(free) = {p_free:.3f}")
print(f"P(free | spam) = {p_free_dado_spam:.3f}")
print(f"P(spam | free) por Bayes = {p_spam_dado_free:.3f}")
print(f"P(spam | free) contando  = {spam[free].mean():.3f}")

# 2. Varias palabras
filas = []
for palabra in ["free", "money", "remove", "credit", "meeting", "george", "hp"]:
    tiene = s[f"word_freq_{palabra}"] > 0
    filas.append({"palabra": palabra, "P(palabra)": tiene.mean(), "P(spam | palabra)": spam[tiene].mean()})
print()
print(pd.DataFrame(filas).sort_values("P(spam | palabra)", ascending=False).round(3).to_string(index=False))

# 3. Leyes de De Morgan
money = s["word_freq_money"] > 0
forma_1 = ~(free | money)
forma_2 = ~free & ~money
print(f"\nNOT (free OR money):       {forma_1.sum()} correos")
print(f"(NOT free) AND (NOT money): {forma_2.sum()} correos")
print("¿Son iguales?", (forma_1 == forma_2).all())

# Para pensar: Este filtro se entrenó con los correos de una sola empresa. ¿Funcionaría igual con tu correo de la universidad? ¿Qué palabras cambiarías?
