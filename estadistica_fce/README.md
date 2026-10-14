# Estadística con casos reales

Material de apoyo para Probabilidad y Estadística Fundamental, Facultad de Ciencias Económicas.
Preparado por **Sebastián Tabares**.

Doce casos que pasaron de verdad en economía y finanzas (Reinhart y Rogoff, Madoff, la ballena de Londres, la crisis de 2008, el Literary Digest, Berkeley 1973, entre otros). Cada caso trae sus datos y un script en R y en Python que se resuelve con los temas del primer parcial: variables y escalas, estadística descriptiva de una y dos variables, conteo, probabilidad condicional y teorema de Bayes.

Abre `index.html` en el navegador para ver la página completa.

## Contenido

| Carpeta | Qué tiene |
|---|---|
| `index.html` | La página con los casos, los datos y los scripts |
| `datos/` | 12 archivos CSV y `LEEME.md` con la ficha de cada uno (fuente, licencia, columnas, advertencias) |
| `scripts/r/` | Un script de R por caso (`dplyr` y `ggplot2`) |
| `scripts/python/` | Un script de Python por caso (`pandas` y `matplotlib`) |

## Cómo correr los scripts

**R:** abre el script en RStudio, fija como directorio de trabajo la carpeta `estadistica_fce` y córrelo. Paquetes: `install.packages(c("dplyr", "ggplot2"))`.

**Python:** desde la carpeta `estadistica_fce`, corre `python scripts/python/01_literary_digest.py`. Paquetes: `pip install pandas matplotlib`.

**Sin instalar nada:** copia el script en Google Colab o Posit Cloud. Si no encuentra la carpeta `datos/`, descarga el archivo directamente de este repositorio.

| # | Caso | Temas |
|---|---|---|
| 01 | La encuesta más grande que falló (Estados Unidos, 1936) | 1.1 población y muestra · 4.3 probabilidad frecuentista |
| 02 | El error de Excel que justificó la austeridad (Harvard y UMass Amherst, 2010–2013) | 2.2 media, mediana y media ponderada · 2.3 datos atípicos |
| 03 | Demasiado estable para ser real (Nueva York, 1990–2008) | 2.2 desviación estándar y coeficiente de variación · 2.3 atípicos |
| 04 | La ley del primer dígito y las cuentas de Grecia (Unión Europea, 1999–2009) | 2.1 tablas de frecuencia y diagramas de barras · 1.2 tipo de variable |
| 05 | La ballena de Londres y una fórmula mal copiada (JPMorgan Chase, 2012) | 2.2 dispersión y medidas de riesgo · percentiles |
| 06 | Cuando todas las casas cayeron juntas (Estados Unidos, 2000–2011) | 3.2 coeficiente de correlación · correlación que cambia en el tiempo |
| 07 | Mismos números, gráficas opuestas (Anscombe 1973 · Matejka y Fitzmaurice 2017) | 3.1 gráficos de dos variables · 3.2 correlación · 2.2 resúmenes |
| 08 | ¿Discriminación en las admisiones? (Universidad de California, Berkeley, 1973) | 3.1 tablas de contingencia · 4.5 probabilidad condicional · paradoja de Simpson |
| 09 | La lotería que sí se podía ganar (Massachusetts, 2005–2012) | 4.4 reglas de conteo · 4.2 probabilidad clásica · valor esperado |
| 10 | Bayes contra el correo basura (Hewlett-Packard 1999 · Paul Graham 2002) | 4.5 probabilidad condicional · 4.6 teorema de Bayes · leyes de De Morgan |
| 11 | ¿Por qué el banco te bloquea compras legítimas? (Tarjetahabientes europeos, septiembre de 2013) | 4.5 probabilidad condicional · 4.6 teorema de Bayes · tasa base |
| 12 | La crisis de las tarjetas en Taiwán (Taiwán, abril–septiembre de 2005) | 1.2 clasificación de variables · 1.3 escalas · 2.1–2.3 descriptiva · 4.5 condicional · De Morgan |
