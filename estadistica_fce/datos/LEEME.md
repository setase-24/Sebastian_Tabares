# Datos de los casos
Cada archivo es CSV con encabezado, separado por comas, codificación UTF-8 y punto decimal.

## literary_digest_1936.csv

**Sondeo del Literary Digest, 1936**  
Filas: 49 (48 estados + «Other») · Periodo: Octubre de 1936  
Fuente: The Literary Digest, 31 de octubre de 1936; transcrito por Kyle Siegrist, Random Services (Universidad de Alabama en Huntsville) — https://randomservices.org/random/data/LiteraryDigest.html  
Licencia: Dato histórico de dominio público; transcripción de uso educativo  
Caso: La encuesta más grande que falló

| Columna | Qué es | Escala |
|---|---|---|
| `estado` | Abreviatura postal del estado | Nominal |
| `votos_electorales` | Votos en el colegio electoral (1936) | Razón (discreta) |
| `sondeo_landon` | Papeletas recibidas a favor de Landon | Razón (discreta) |
| `sondeo_roosevelt` | Papeletas recibidas a favor de Roosevelt | Razón (discreta) |

**Ojo con los datos:** La transcripción tiene errores probables: CA y AR repiten 7.608 para Roosevelt; ME repite exactamente la fila de LA; NH figura con 16 votos electorales (eran 4). Sirven como ejercicio de detección. Los totales suman 2,15 millones, menos que los 2,37 millones publicados.

## reinhart_rogoff_1946_2009.csv

**Deuda pública y crecimiento, 20 países avanzados**  
Filas: 1.175 país-año · Periodo: 1946–2009  
Fuente: Hoja de trabajo original de Reinhart y Rogoff, procesada por Herndon, Ash y Pollin (2013), archivo RR-processed.dta — https://zenodo.org/records/4017423  
Licencia: Código BSD-2; depósito en Zenodo con AGPL-3.0. Uso académico con cita  
Caso: El error de Excel que justificó la austeridad

| Columna | Qué es | Escala |
|---|---|---|
| `pais` | País | Nominal |
| `anio` | Año | Intervalo |
| `deuda_pib_pct` | Deuda pública bruta como % del PIB | Razón |
| `crecimiento_pib_real_pct` | Crecimiento del PIB real (%) | Intervalo |
| `categoria_deuda` | Tramo de deuda: 0-30%, 30-60%, 60-90%, >90% | Ordinal |

**Ojo con los datos:** Incluye todos los país-año con datos de deuda y crecimiento. Italia entra desde 1951, como en la réplica. Bélgica 1947 tiene un crecimiento muy alto que distorsiona medias.

## madoff_fairfield_sentry_mensual.csv

**Rendimientos mensuales de Fairfield Sentry (fondo de Madoff) y del S&P 500**  
Filas: 215 meses · Periodo: Diciembre de 1990 – octubre de 2008  
Fuente: Hoja informativa de Fairfield Sentry Ltd. publicada por NPB New Private Bank, 17 de noviembre de 2008 (tabla transcrita). S&P 500: datos mensuales de Robert Shiller — https://www.finanzwesir.com/assets/files/FairfieldSentryLtd.pdf  
Licencia: Documento comercial público; uso educativo con cita  
Caso: Demasiado estable para ser real

| Columna | Qué es | Escala |
|---|---|---|
| `mes` | Año-mes (AAAA-MM) | Intervalo |
| `rend_fairfield_pct` | Rendimiento mensual reportado por el fondo (%) | Intervalo |
| `rend_sp500_pct` | Variación mensual del precio promedio del S&P 500 (%), sin dividendos | Intervalo |

**Ojo con los datos:** Los rendimientos del fondo son los que el fondo declaraba, no rendimientos reales: eran inventados. El S&P 500 usa promedios mensuales de precios de cierre (serie de Shiller), por eso sus caídas extremas se ven algo suavizadas.

## eurostat_finanzas_publicas_1999_2009.csv

**Finanzas públicas de 30 países europeos (gov_10a_main)**  
Filas: 28.431 cifras · Periodo: 1999–2009  
Fuente: Eurostat, tabla gov_10a_main, sector gobierno general (S13), millones de euros — https://ec.europa.eu/eurostat/databrowser/view/gov_10a_main/default/table  
Licencia: Reutilización permitida citando a Eurostat  
Caso: La ley del primer dígito y las cuentas de Grecia

| Columna | Qué es | Escala |
|---|---|---|
| `na_item` | Código de la partida fiscal (ingresos, gastos, déficit, etc.) | Nominal |
| `geo` | Código de país (EL = Grecia) | Nominal |
| `year` | Año | Intervalo |
| `value` | Valor en millones de euros | Razón (puede ser negativo en saldos) |
| `flag` | Marca de Eurostat (p = provisional, e = estimado, etc.) | Nominal |

**Ojo con los datos:** Es la versión vigente, descargada en octubre de 2026. Las cifras de Grecia se revisaron después de 2010, así que no es la misma versión que usaron Rauch y coautores en 2011. Excluye agregados (UE, zona euro).

## sp500_shiller_mensual.csv

**S&P 500 mensual desde 1871 (serie de Robert Shiller)**  
Filas: 1.869 meses · Periodo: Enero de 1871 – septiembre de 2026  
Fuente: Robert Shiller, Irrational Exuberance; copia mantenida por el proyecto datasets/s-and-p-500 en GitHub — https://github.com/datasets/s-and-p-500  
Licencia: Datos públicos (ODC-PDDL)  
Caso: La ballena de Londres y una fórmula mal copiada

| Columna | Qué es | Escala |
|---|---|---|
| `fecha` | Primer día del mes | Intervalo |
| `sp500` | Nivel del índice (promedio mensual) | Razón |
| `dividendo` | Dividendo anualizado | Razón |
| `utilidades` | Utilidades anualizadas | Razón |
| `ipc` | Índice de precios al consumidor | Razón |
| `tasa_largo_plazo` | Tasa de bonos a 10 años (%) | Razón |
| `precio_real` | Precio en dólares constantes | Razón |
| `pe10` | Relación precio/utilidad a 10 años (CAPE) | Razón |
| `rend_mensual_pct` | Variación mensual del índice (%) | Intervalo |

**Ojo con los datos:** Las últimas filas pueden tener utilidades y dividendos vacíos o estimados.

## case_shiller_ciudades_eeuu.csv

**Índices de precios de vivienda S&P Case-Shiller, 20 ciudades de EE. UU.**  
Filas: 475 meses · Periodo: Enero de 1987 – julio de 2026  
Fuente: S&P Dow Jones Indices / Cotality, vía FRED (Banco de la Reserva Federal de St. Louis), series desestacionalizadas — https://fred.stlouisfed.org/series/SPCS20RSA  
Licencia: Datos con copyright de S&P; FRED permite uso educativo citando la fuente  
Caso: Cuando todas las casas cayeron juntas

| Columna | Qué es | Escala |
|---|---|---|
| `fecha` | Primer día del mes | Intervalo |
| `compuesto_20` | Índice compuesto de 20 ciudades (enero 2000 = 100) | Razón |
| `nueva_york … cleveland` | Índice de cada ciudad (enero 2000 = 100) | Razón |

**Ojo con los datos:** Algunas ciudades empiezan después de 1987 (Dallas en 2000, por ejemplo); hay celdas vacías al inicio.

## anscombe_cuarteto.csv

**Cuarteto de Anscombe**  
Filas: 44 (4 conjuntos × 11) · Periodo: Publicado en 1973  
Fuente: F. J. Anscombe (1973), Graphs in Statistical Analysis, The American Statistician; versión del paquete quartets de R vía Rdatasets — https://vincentarelbundock.github.io/Rdatasets/doc/quartets/anscombe_quartet.html  
Licencia: Datos de dominio público  
Caso: Mismos números, gráficas opuestas

| Columna | Qué es | Escala |
|---|---|---|
| `conjunto` | Nombre del conjunto: (1) Linear, (2) Nonlinear, (3) Outlier, (4) Leverage | Nominal |
| `x` | Variable x | Razón |
| `y` | Variable y | Razón |

## datasaurus_docena.csv

**Docena del Datasaurus**  
Filas: 1.846 (13 conjuntos × 142) · Periodo: Publicado en 2017  
Fuente: Matejka y Fitzmaurice (2017), Same Stats, Different Graphs, ACM CHI; vía Rdatasets — https://vincentarelbundock.github.io/Rdatasets/doc/quartets/datasaurus_dozen.html  
Licencia: MIT (paquete datasauRus)  
Caso: Mismos números, gráficas opuestas

| Columna | Qué es | Escala |
|---|---|---|
| `conjunto` | Nombre del conjunto (dino, star, circle, …) | Nominal |
| `x` | Variable x | Razón |
| `y` | Variable y | Razón |

## berkeley_admisiones_1973.csv

**Admisiones a posgrado en UC Berkeley, 1973**  
Filas: 24 (2 resultados × 2 sexos × 6 departamentos) · Periodo: Otoño de 1973  
Fuente: Bickel, Hammel y O'Connell (1975), Science; conjunto UCBAdmissions incluido en R — https://vincentarelbundock.github.io/Rdatasets/doc/datasets/UCBAdmissions.html  
Licencia: Datos de dominio público  
Caso: ¿Discriminación en las admisiones?

| Columna | Qué es | Escala |
|---|---|---|
| `resultado` | Admitido o Rechazado | Nominal |
| `sexo` | Hombre o Mujer | Nominal |
| `departamento` | Los seis departamentos más grandes, anonimizados (A–F) | Nominal |
| `frecuencia` | Número de postulantes | Razón (conteo) |

**Ojo con los datos:** Solo incluye los seis departamentos más grandes, no toda la universidad.

## spambase_hp_1999.csv

**Spambase: 4.601 correos clasificados**  
Filas: 4.601 correos · Periodo: Junio–julio de 1999  
Fuente: Hopkins, Reeber, Forman y Suermondt, Hewlett-Packard Labs; UCI Machine Learning Repository — https://archive.ics.uci.edu/dataset/94/spambase  
Licencia: CC BY 4.0  
Caso: Bayes contra el correo basura

| Columna | Qué es | Escala |
|---|---|---|
| `word_freq_*` | 48 columnas: % de palabras del correo que son esa palabra (free, money, remove, george, hp…) | Razón |
| `char_freq_*` | 6 columnas: % de caracteres que son ; ( [ ! $ # | Razón |
| `capital_run_length_average / _longest / _total` | Longitud promedio, máxima y total de secuencias de MAYÚSCULAS | Razón |
| `es_spam` | 1 = spam, 0 = correo legítimo | Nominal (binaria) |

**Ojo con los datos:** Los correos legítimos son de empleados de HP, por eso palabras como «george» (nombre de un empleado) y «hp» delatan que no es spam.

## fraude_tarjetas_muestra.csv

**Fraude con tarjeta de crédito (muestra aleatoria del 10 %)**  
Filas: 29.211 transacciones, 52 fraudes (muestra del 10 % de 284.807) · Periodo: Dos días de septiembre de 2013  
Fuente: Worldline y Machine Learning Group de la Université Libre de Bruxelles (Dal Pozzolo et al., 2015); copia en Zenodo — https://zenodo.org/records/7395559  
Licencia: CC BY 4.0 (copia de Zenodo); original en Kaggle bajo DbCL  
Caso: ¿Por qué el banco te bloquea compras legítimas?

| Columna | Qué es | Escala |
|---|---|---|
| `Time` | Segundos desde la primera transacción del archivo | Razón |
| `V12, V14, V17` | Componentes principales anonimizadas (las más relacionadas con fraude) | Intervalo |
| `Amount` | Monto de la transacción en euros | Razón |
| `Class` | 1 = fraude, 0 = legítima | Nominal (binaria) |

**Ojo con los datos:** Muestra aleatoria simple con semilla fija: conserva la tasa base. En el archivo completo hay 492 fraudes de 284.807 (0,173 %). Se dejaron solo 3 de las 28 variables V para que el archivo pese poco.

## credito_taiwan_2005.csv

**Impago de tarjetas de crédito en Taiwán**  
Filas: 30.000 clientes · Periodo: Abril–septiembre de 2005  
Fuente: Yeh y Lien (2009), Expert Systems with Applications; UCI Machine Learning Repository — https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients  
Licencia: CC BY 4.0  
Caso: La crisis de las tarjetas en Taiwán

| Columna | Qué es | Escala |
|---|---|---|
| `ID` | Identificador del cliente | Nominal |
| `LIMIT_BAL` | Cupo de crédito (dólares taiwaneses) | Razón |
| `SEX` | 1 = hombre, 2 = mujer | Nominal |
| `EDUCATION` | 1 posgrado, 2 universidad, 3 secundaria, 4 otros | Ordinal |
| `MARRIAGE` | 1 casado, 2 soltero, 3 otros | Nominal |
| `AGE` | Edad en años | Razón |
| `PAY_1 … PAY_6` | Estado de pago sep. (1) a abr. (6): −2/−1/0 al día, 1–9 meses de retraso | Ordinal |
| `BILL_AMT1 … 6` | Valor de la factura, sep. a abr. | Razón |
| `PAY_AMT1 … 6` | Valor pagado, sep. a abr. | Razón |
| `incumplio_mes_siguiente` | 1 = incumplió en octubre | Nominal (binaria) |

**Ojo con los datos:** EDUCATION tiene códigos 0, 5 y 6 y MARRIAGE el código 0, que no están documentados. PAY_1 se llama PAY_0 en el archivo original de UCI.
