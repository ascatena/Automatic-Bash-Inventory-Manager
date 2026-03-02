
# Sistema de Gestión de Inventario en Bash  
### CLI Interactiva con Validación de Datos y Manipulación de Archivos
![Bash](https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Terminal](https://img.shields.io/badge/terminal-%234D4D4D.svg?style=for-the-badge&logo=apple-terminal&logoColor=white)

Autor: Adriano Scatena  

---

## Descripción General

Este proyecto implementa un sistema de gestión de inventario desarrollado íntegramente en Bash.  

Se trata de una herramienta de línea de comandos (CLI) interactiva que permite administrar un conjunto de productos almacenados en un archivo de texto estructurado en formato:

```
nombre,precio,cantidad
```

El sistema implementa operaciones completas de gestión (CRUD):

- Agregar productos  
- Listar productos  
- Buscar productos  
- Editar registros existentes  
- Eliminar registros  
- Ordenar productos por precio  

El proyecto demuestra dominio práctico de:

- Programación estructurada en Bash  
- Validación robusta mediante expresiones regulares  
- Manipulación avanzada de archivos de texto  
- Uso de utilidades estándar de Unix (`grep`, `awk`, `sed`, `sort`, `printf`)  
- Control de flujo con estructuras condicionales y bucles  
- Formateo de salida con códigos ANSI  
- Manejo de errores no fatales  
- Interacción continua mediante menú dinámico  

---

## Objetivo del Proyecto

Desarrollar una herramienta CLI que permita gestionar un inventario persistente en disco utilizando exclusivamente Bash y utilidades estándar del sistema.

El sistema:

1. Valida rigurosamente la entrada del usuario.  
2. Evita inconsistencias en los datos almacenados.  
3. Garantiza persistencia en archivo.  
4. Permite edición y eliminación segura de registros.  
5. Mantiene una experiencia interactiva clara en consola.  

---

## Arquitectura del Sistema

El programa `inventory_manager.sh` se organiza en funciones independientes que gestionan cada responsabilidad del sistema:

- `menu()` → Interfaz principal  
- `nuevoProducto()` → Validación y carga de nuevos productos  
- `listarProducto()` → Lectura y formateo tabulado  
- `buscarProducto()` → Búsqueda, edición y eliminación  
- `ordenarProducto()` → Ordenamiento por precio  
- `impresionProducto()` → Persistencia en archivo  
- `goBack()` → Control de navegación  
- `help()` → Documentación por parámetro `-h` / `--help`  

El flujo principal se gestiona mediante un bucle `while true`, manteniendo activa la interacción hasta que el usuario decide finalizar.

---

## Formato de Datos

Cada línea del archivo de inventario respeta el siguiente esquema:

```
nombre,precio,cantidad
```

### Restricciones implementadas

| Campo     | Longitud Máxima | Restricciones | Formato |
|------------|-----------------|---------------|----------|
| Nombre     | 40 caracteres   | No vacío, sin caracteres especiales | Letras y espacios |
| Precio     | 20 caracteres   | No negativo, puede incluir decimal | Numérico |
| Cantidad   | 20 caracteres   | Entero positivo | Numérico entero |

Las validaciones se realizan mediante expresiones regulares y estructuras de control.

---

## Instalación Rápida y Modo de Uso

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/bash-inventory-manager.git

# Entrar al directorio
cd bash-inventory-manager

# Dar permisos y ejecutar
chmod +x inventory_manager.sh
./inventory_manager.sh
```

### Mostrar ayuda

```bash
./inventory_manager.sh -h
```

---

## Flujo de Uso del Sistema

Una vez ejecutado el script, el programa se dirige automáticamente al **menú principal**, desde el cual el usuario debe seleccionar la operación a realizar.

El sistema ofrece cuatro opciones principales. Todas las funciones, una vez finalizadas, permiten:

- Volver al menú principal.
- Salir del programa.

---

### 1. Agregar Producto

Se accede ingresando `1` en el menú.

- Si es la primera ejecución y no existe archivo de inventario, el programa:
  - Crea un archivo base llamado `inventario`.
  - Solicita seleccionar extensión (`.txt` o `.csv`).
- Permite ingresar:
  - Nombre
  - Precio
  - Cantidad
- Implementa:
  - Validación doble de cada campo.
  - Vista previa antes de confirmar.
  - Posibilidad de agregar múltiples productos de manera secuencial.

El sistema garantiza que ningún registro inválido sea persistido.

---

### 2. Listar Producto

Se accede ingresando `2`.

- Verifica existencia del archivo.
- Comprueba que no esté vacío.
- Muestra todos los productos formateados en columnas para facilitar la lectura.

No requiere acciones adicionales por parte del usuario.

---

### 3. Buscar Producto

Se accede ingresando `3`.

- Solicita un parámetro de búsqueda.
- Permite coincidencias parciales (nombre, precio o cantidad).
- Si el nombre es exacto, muestra únicamente el registro correspondiente.
- Indica el número de línea del archivo donde se encuentra cada coincidencia.

Tras mostrar resultados, se habilitan dos opciones:

**1. Editar**
- Se selecciona el número de línea.
- Se elige el campo a modificar.
- Se actualiza el registro utilizando edición directa en archivo.

**2. Eliminar**
- Permite ingresar múltiples líneas separadas por comas.
- Muestra confirmación previa a la eliminación.
- Puede cancelarse antes de ejecutar la acción.

---

### 4. Ordenar Producto

Se accede ingresando `4`.

- Ordena los productos de forma creciente por precio.
- Utiliza ordenamiento numérico.
- Presenta los resultados formateados en consola.

---

## Manejo de Errores y Robustez

Durante toda la ejecución:

- Los errores de entrada no son fatales.
- Siempre se permite reingresar los datos incorrectos.
- No se pierden datos previamente válidos.
- No es necesario reiniciar el programa ante errores.

Este enfoque mejora la experiencia de usuario y evita inconsistencias en el archivo de inventario.

---

## Tecnologías y Herramientas Utilizadas

- Bash  
- grep  
- awk  
- sed  
- sort  
- printf  
- Expresiones regulares POSIX  
- Manejo de flujos estándar  

---

## Referencias

1. GNU Grep Manual  
   https://www.gnu.org/software/grep/manual/  

2. Sort Command Documentation  
   https://www.geeksforgeeks.org/sort-command-linuxunix-examples/  

3. Bash Reference Manual  
   https://www.gnu.org/software/bash/manual/  

4. Sed Command Documentation  
   https://www.geeksforgeeks.org/sed-command-in-linux-unix-with-examples/  

5. Linux Pipe and Redirection  
   https://linuxhandbook.com/pipe-redirection/  
