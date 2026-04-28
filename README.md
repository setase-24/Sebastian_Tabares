# Minería de Datos - Repositorio de Talleres

Este repositorio está destinado a que los estudiantes del curso de **Minería de Datos** almacenen y organicen sus talleres a lo largo del semestre.

## Objetivo

Centralizar la entrega y el seguimiento de las actividades del curso en un único repositorio. Cada estudiante debe enviar lo desarrollado en clase mediante un pull request, modificando únicamente la carpeta que tiene su nombre.

## Estructura del repositorio

Las entregas se organizan por grupo, por estudiante y por taller.

```text
dm_2016325/
├── README.md
├── grupo_1/
│   ├── jerez_tomas/
│   │   ├── taller_01/
│   │   ├── taller_02/
│   │   ├── taller_03/
│   │   ├── taller_04/
│   │   └── taller_05/
│   ├── gomez_juan_jose/
│   ├── canelo_janith/
│   ├── tabaco_sebastian/
│   ├── luciano_winston/
│   ├── correa_keiner/
│   ├── rava_oscar/
│   ├── guerrero_luisa/
│   └── aldana_juan_pablo/
├── grupo_2/
│   ├── bejarano_elian/
│   │   ├── taller_01/
│   │   ├── taller_02/
│   │   ├── taller_03/
│   │   ├── taller_04/
│   │   └── taller_05/
│   ├── gomez_sergio/
│   ├── angulo_daniel/
│   ├── ortiz_owen/
│   ├── roncancio_daniela/
│   ├── vargas_mateo/
│   ├── sanchez_jorge/
│   ├── camacho_juan/
│   └── ardila_cristian/
```

Cada estudiante tiene sus carpetas de talleres creadas desde `taller_01` hasta `taller_05`. Si en una nueva clase aparece otra actividad, se agregará una carpeta adicional siguiendo el mismo patrón.

## Instrucciones para entregar una actividad por pull request

### 1. Identifica tu grupo

Ubica si perteneces a `grupo_1` o a `grupo_2`.

### 2. Ubica tu carpeta personal

Dentro de tu grupo ya existe una carpeta con tu nombre.

Ruta de ejemplo:

```text
grupo_1/jerez_tomas/
```

Debes trabajar solamente dentro de tu carpeta personal.

### 3. Identifica la actividad de la clase

Cada actividad se publica en una carpeta con nombre `taller_XX`, por ejemplo:

- `taller_01`
- `taller_02`
- `taller_05`

Debes agregar lo desarrollado en clase únicamente en la carpeta correspondiente a la actividad asignada.

Ruta de ejemplo:

```text
grupo_1/jerez_tomas/taller_01/
```

### 4. Coloca allí todos los archivos de tu trabajo

Dentro de la carpeta del taller puedes incluir, según corresponda:

- notebooks de Jupyter (`.ipynb`)
- scripts en Python (`.py`)
- archivos de datos pequeños
- imágenes, gráficas o reportes
- un `README.md` breve si necesitas explicar la solución o la ejecución

### 5. Crea una rama para tu entrega

Antes de hacer cambios, crea una rama con un nombre claro.

Ejemplo:

```bash
git checkout -b jerez_tomas/taller_01
```

### 6. Sube tus cambios y abre un pull request

Después de agregar los archivos de tu taller:

```bash
git add grupo_1/jerez_tomas/taller_01/
git commit -m "Agrega taller 01 de Jerez Tomas"
git push origin jerez_tomas/taller_01
```

Luego abre un pull request hacia la rama principal del repositorio.

El pull request debe cumplir estas condiciones:

- modifica únicamente tu carpeta personal
- incluye solamente los archivos del taller correspondiente
- no cambia archivos de otros estudiantes
- no cambia la estructura general del repositorio
- tiene un título claro, por ejemplo: `Taller 01 - Jerez Tomas`

### 7. Mantén separadas las entregas por actividad

Cada nueva actividad debe quedar en su carpeta correspondiente.

Ejemplo:

- La actividad de `taller_01` va en `grupo_X/tu_carpeta/taller_01/`
- La actividad de `taller_02` va en `grupo_X/tu_carpeta/taller_02/`

No debes mezclar archivos de distintas clases en una misma carpeta de actividad.

### 8. No cambies la estructura del repositorio

Para facilitar la revisión:

- no cambies el nombre de tu carpeta
- no subas archivos fuera de tu carpeta personal
- no borres carpetas de otros compañeros
- no modifiques la organización de `grupo_1`, `grupo_2` o `taller_XX`
- no borres los archivos `.gitkeep`; solo sirven para que Git conserve las carpetas vacías

## Buenas prácticas

- Verifica que tus notebooks y scripts abran correctamente antes de subirlos.
- Usa nombres de archivo claros y descriptivos.
- Incluye únicamente el material necesario para revisar la actividad.
- Evita archivos demasiado pesados o innecesarios.
- Si tu entrega requiere instrucciones de uso, agrega un `README.md` dentro de tu carpeta.

## Nota

La estructura general del repositorio es: `grupo -> estudiante -> taller`.
