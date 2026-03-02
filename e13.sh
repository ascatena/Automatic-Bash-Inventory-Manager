#!/bin/bash

#Funciones para la configuración de salida de texto
    function warning() {    #Texto en Amarillo según ANSI
        START='\033[01;33m'
        END='\033[00;00m'
        MESSAGE=${@:-""}
        echo -e "${START}${MESSAGE}${END}"
    }
    function info() {   #Texto en verde según ANSI
        START='\033[01;32m' 
        END='\033[00;00m'
        MESSAGE=${@:-""}
        echo -e "${START}${MESSAGE}${END}"
    }
    function error() {  #Texto en rojo según ANSI
        START='\033[01;31m'
        END='\033[00;00m'
        MESSAGE=${@:-""}
        echo -n -e "${START}${MESSAGE}${END}"
    }
    function mensaje() {    #Texto con configuración tipo ANSI
            MESSAGE=${@:-""}
            echo -e "${MESSAGE}"
    }
    function opcion() { #Texto con configuración tipo ANSI
        START='\033[01;34m'  # Código ANSI para azul
        END='\033[00m'        # Restablecer el color al final
        MENSAJE=${@:-""}
        echo -e "${START}${MENSAJE}${END}"
    }

# Función para mostrar menú y help
    function menu() {
        echo "==========================="
        info "           MENÚ            "
        echo "==========================="
        echo -n "1."; opcion "Agregar Producto\n"
        echo -n "2."; opcion "Listar Producto\n"
        echo -n "3."; opcion "Buscar Producto\n"
        echo -n "4."; opcion "Ordenar productos por Precio\n"
        echo -n "Pulse 'q' para"; error " Salir\n"
    }
    function help() {
        info "Modo de Uso";echo
        echo "Al correr el programa, notará que se desplegará un menú de opciones. Para la correcta elección de la misma"
        echo -n "se deberá ingresar el número de opción deseada y confirmar con";echo -e "\e[3menter.\e[0m";echo
        info "Opciones Disponibles:";echo
        echo -n "Opción";opcion " [1]";echo
        echo -e -n "\033[01;32m     Agregar Producto:\033[00;00m"
        echo " Si no existe archivo de destino creado, el programa creará un archivo y permitirá"
        echo "  seleccionar la extensión que se desee crear (.txt o .csv). Esta opción permite agregar un producto"
        echo "  nuevo al archivo inventario, especificando su nombre, precio y cantidad. Existen restricciones para cada"
        echo "  parámetro que se especifican a continuación:";echo
        echo -n "      Nombre: - No se permite el ingreso de "; error "nombres que inicien por carácteres especiales";echo
        echo -n "              - No se permite el ingreso de ";error "productos ya ingresados.";echo
        echo -n "              - No se permite el ingreso de ";error "nombres vacíos.";echo
        echo -n "              - No se permite el ingreso de ";error "nombres que excedan los 40 caracteres.";echo
        echo -n "      Precio: - No se permite el ingreso de ";error "precios negativos.";echo
        echo -n "              - No se permite el ingreso de ";error "precios vacíos.";echo
        echo -n "              - No se permite el ingreso de ";error "precios que excedan los 20 caracteres.";echo
        echo -n "      Cantidad: - No se permite el ingreso de ";error "cantidades negativas.";echo
        echo -n "              - No se permite el ingreso de ";error "cantidades decimales.";echo
        echo -n "              - No se permite el ingreso de ";error "cantidades que excedan los 20 caracteres.";echo
        echo;echo "   Estas reestricciones estarán presentes en todos los campos que refieran a dichos parámetros de los productos."
        echo;echo -n "Opción";opcion " [2]";echo
        echo -e -n "\033[01;32m     Listar Producto:\033[00;00m"
        echo " Se mostrarán todos los productos existentes en el archivo inventario formateados" 
        echo "  en columnas para una mejor visualización. No se requiere ninguna otra acción."
        echo;echo -n "Opción";opcion " [3]";echo
        echo -e -n "\033[01;32m     Buscar Producto:\033[00;00m"
        echo " Permite realizar la búsqueda de un producto en el archivo inventario mediante la" 
        echo "  introducción del nombre del mismo. Las coincidencias se muestran en forma de lista, enumeradas según"
        echo "  el número de línea en el archivo."
        echo "  Una vez desplegadas las coincidencias se permiten 3 opciones extras: EDITAR, ELIMINAR y VOLVER.";echo
        echo "      EDITAR: Se debe indicar el número de línea a editar y su parámetro. Permite editar 1 parámetro" 
        echo "              del producto. Al hacerlo se muestran las líneas actualizadas."
        echo "      ELIMINAR: Permite la eliminación de 1 o varias líneas coincidentes. En caso de multiplicidad se"
        echo "                debe informar los números de líneas a eliminar separados por coma. Por ejemplo '1,2,3'"
        echo "                Se incluye una etapa de confirmación, en caso de afirmación se muestra el listado actualizado,"
        echo "                en caso negativo, se permite volver al menú o salir del programa."
        echo "      VOLVER: Permite el retorno al menú o la finalización del programa"
        echo;error "  ACLARACIÓN:";echo " Solo se permite trabajar con líneas resultantes de la búsqueda de hecha."
        echo;echo -n "Opción";opcion " [4]";echo
        echo -e -n "\033[01;32m     Ordenar Producto:\033[00;00m"
        echo " Permite ordenar de forma creciente por precio a todos los productos listados en el archivo." 
        echo "  Se presentan formateados en tipo lista." 
        echo;echo -n "Opción";opcion " [Q]";echo
        echo "   Se permite la finalización del programa desde el propio menú."
    }
#Funciones de programa
    function goBack(){
        flag=0;
        while [ $flag -eq 0 ]; do
        info "\nPresione (M) para volver al menu o presione (Q) para salir."
        read reingreso
        if echo "$reingreso" | grep -iq "^m$"; then
            clear
            flag=1
        elif echo "$reingreso" | grep -iq "^q$"; then
            clear
            info "Saliendo..."
            sleep 1
            clear
            exit
            flag=1
        else
            warning "Entrada no válida."
        fi  
        done
    }

    function nuevoProducto(){
        nombre=""
        precio=""
        cantidad=""
        flag=0
        while [ $flag -eq 0 ]; do
            read -p "Nombre del producto: " nombre
            if [ -z "$nombre" ]; then       #-z verifica la longitud de la cadena, lo que intento es verificar si es nula, si lo es, entonces da verdadero.
                clear
                warning "No se ha ingresado un nombre. Intentelo de nuevo"
            elif [ ${#nombre} -gt 40 ]; then
                clear
                error "Error: El nombre ingresado no puede exceder los 40 caracteres.\n"
            elif  [[ ! "$nombre" =~ ^[A-Za-z\ ]+$ ]]; then
                clear
                error "Error: El nombre ingresado no puede contener caracteres especiales.\n"
            elif [ -e inventario.* ]; then
                archivo=$(echo inventario.* | awk '{print $1}')
                #resultado=$(grep -i "$nombre" "$archivo")
                resultado=$(awk -F, -v nombre="$nombre" '$1 == nombre' "$archivo")
                if [ -n "$resultado" ]; then   # Si la variable resultado no está vacía, el producto existe.
                    error "Error: El producto '$nombre' ya existe en el inventario.\n"
                    flag=1
                    return 1
                fi
                flag=1
            else
                flag=1
            fi
        done
        flag=0
        while [ $flag -eq 0 ]; do
            read -p "Precio del producto: " precio
            if ! [[ "$precio" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then    #Esta sería la sentencia de comprobación que lo ingresado es un valor numérico (segun ChatGPT)
                error "Error: Introduce un número válido.\n"
            elif [[ "$precio" =~ ^- ]]; then         #Chequeo que lo ingresado sea no negativo
                error "Error: Introduce precio no negativo.\n"
            elif [ ${#precio} -gt 20 ]; then
                error "Error: El número no puede exceder los 20 caracteres.\n"
            else
                flag=1
            fi
        done
        flag=0
        while [ $flag -eq 0 ]; do
            read -p "Cantidad de productos: " cantidad
            if ! [[ "$cantidad" =~ ^-?[0-9]+$ ]]; then    #Esta sería la sentencia de comprobación que lo ingresado es un valor numérico (segun ChatGPT)
                error "Error: Introduce un número válido.\n"
            elif [[ "$cantidad" =~ ^- ]]; then         #Chequeo que lo ingresado sea no negativo
                error "Error: Introduce una cantidad no negativa.\n"
            elif [ ${#cantidad} -gt 20 ]; then
                error "Error: El número no puede exceder los 20 caracteres.\n"
            else
                flag=1
            fi
        done
    }

    function listarProducto(){
        if [ -e inventario.* ];then
            
            archivo=$(echo inventario.* | awk '{print $1}')     #Defino variable de trabajo, sirve para reutilizacion del codigo.
                                                                #Con echo "imprimo" todos los archivos coincidentes con el nombre, 
                                                                #y con awk me quedo solo con la primer coincidencia (encaso de que existan más archivos con el nombre inventario, lo cual no deberia ocurrir)
            #Verifico si el archivo esta vacio.
            if [[ ! -s "$archivo" ]]; then      #-s indica si size > 0. Lo niego, de esa forma si esta vacio, ingresa.
                warning "El inventario esta vacio. No hay productos para leer."
            else
                printf "%-40s %-20s %-20s\n" "         Nombre del Producto         " "       Precio      " "      Cantidad     "
                printf "%-40s %-20s %-20s\n" "........................................" " ..................." " ..................."
                while IFS=',' read -r nombre precio cantidad; do    #IFS es la variable de separacion de campos. Se define la , como delimitador.
                        printf "%-40s %20s %20s\n" "$nombre" "$precio" "$cantidad"
                done < "$archivo"
            fi                                                            
        else
            error "No existe el archivo ";echo -n -e "\e[3minventario\e[0m";error " en el directorio. Por favor crearlo ingresando algún producto ";opcion "(Opcion 1)"
            return
        fi
    }

    function buscarProducto(){
        if [ -e inventario.* ];then
            archivo=$(echo inventario.* | awk '{print $1}')     #Defino variable de trabajo, sirve para reutilizacion del codigo.
                                                                #Con echo "imprimo" todos los archivos coincidentes con el nombre, 
                                                                #y con awk me quedo solo con la primer coincidencia (encaso de que existan más archivos con el nombre inventario, lo cual no deberia ocurrir)
            #Verifico si el archivo esta vacio.
            if [[ ! -s "$archivo" ]]; then
                error "El inventario esta vacio. No hay productos para buscar."
                return
            fi
            flag=0
            while [ $flag -eq 0 ];do
                read -p "Nombre del producto a buscar:" nombre          #Se espera y levanta la entrada del usuario.
                if [[ -z "$nombre" ]]; then                             #-z chequea si una cadena esta o no vacia.
                    warning "El nombre del producto no puede estar vacio. Intente de nuevo"
                elif [ "$nombre" =~ ^[A-Za-z\ ]+$ ]; then
                    warning "El nombre no cumple el formato de inventario"
                else
                    clear
                    info "Buscando $nombre..."
                    echo ""
                    flag=1
                    sleep 1
                fi
            done
            #Buscamos el producto
            resultado=$(grep -i -n "$nombre" "$archivo")                #Se filtra con grep el nombre del producto y se guarda TODA la cadena en resultado.

            if [[ -z "$resultado" ]]; then                          #Si resultado es una string vacia, el producto no fue encontrado.
                echo "Producto $nombre no encontrado en el inventario."
            else
                info "Se ha encontrado el siguiente producto:"      #Se muestra el producto filtrado con toda su informacion.
                echo "$resultado" | sed 's/^/\t/'
                echo ""
                echo "¿Qué desea hacer con estas líneas?"
                echo -n "1. ";opcion "Editar"
                echo -n "2. ";opcion "Eliminar"
                echo -n "q. ";opcion "Volver"
                flag=0
                while [ $flag -eq 0 ];do
                    edicion=""
                    read -p "Elija una opción: " edicion
                    case $edicion in
                        [1]*)
                            flag2=0
                            clear
                            while [ $flag2 -eq 0 ]; do
                                echo "$resultado" | sed 's/^/\t/'
                                echo ""
                                info "¿Qué línea desea editar? [Indicar número]"
                                read lineas
                                lineas_encontradas=$(echo "$resultado" | cut -d':' -f1 | tr '\n' ' ')
                                if ! [[ "$lineas" =~ ^[0-9]+$ ]]; then    #Esta sería la sentencia de comprobación que lo ingresado es un valor numérico (segun ChatGPT)
                                    error "Error: Introduce un número válido.\n\n"
                                elif ! [[ " $lineas_encontradas " =~ " $lineas " ]]; then
                                    error "Error: El número ingresado no corresponde a una línea encontrada.\n\n"
                                else
                                    flag2=1
                                fi
                            done
                            clear
                            info "Operando sobre la linea: "
                            sed -n "${lineas}p" "$archivo"
                            echo ""
                            linea=$(sed -n "${lineas}p" "$archivo")
                            IFS=',' read -r nombre precio cantidad <<< "$linea"
                            
                            echo "¿Qué valor desea editar?: " 
                            echo -n "1. ";opcion "Nombre"
                            echo -n "2. ";opcion "Precio"
                            echo -n "3. ";opcion "Cantidad"
                            read valor_edit
                            
                            case $valor_edit in
                                1)
                                    clear
                                    info "Operando sobre la linea: "
                                    sed -n "${lineas}p" "$archivo"
                                    echo ""
                                    flag3=0 
                                    while [ $flag3 -eq 0 ]; do
                                        read -p "Ingrese el nuevo nombre: " nuevoNombre
                                        if [ -z "$nuevoNombre" ]; then       #-z verifica la longitud de la cadena, lo que intento es verificar si es nula, si lo es, entonces da verdadero.
                                            clear
                                            warning "No se ha ingresado un nombre. Intentelo de nuevo"
                                        elif [ ${#nuevoNombre} -gt 40 ]; then
                                            error "Error: El nombre ingresado no puede exceder los 40 caracteres.\n"
                                        else
                                            flag3=1
                                        fi
                                    done
                                    lineaEdit="$nuevoNombre,$precio,$cantidad"
                                    ;;
                                2)
                                    clear
                                    info "Operando sobre la linea: "
                                    sed -n "${lineas}p" "$archivo"
                                    echo ""
                                    flag3=0
                                    while [ $flag3 -eq 0 ]; do
                                        read -p "Ingrese el nuevo precio: " nuevoPrecio
                                        if ! [[ "$nuevoPrecio" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then    #Esta sería la sentencia de comprobación que lo ingresado es un valor numérico (segun ChatGPT)
                                            error "Error: Introduce un número válido.\n"
                                        elif [[ "$nuevoPrecio" =~ ^- ]]; then         #Chequeo que lo ingresado sea no negativo
                                            error "Error: Introduce precio no negativo.\n"
                                        elif [ ${#nuevoPrecio} -gt 20 ]; then
                                            error "Error: El número no puede exceder los 20 caracteres.\n"
                                        else
                                            flag3=1
                                        fi
                                    done
                                    lineaEdit="$nombre,$nuevoPrecio,$cantidad"
                                    ;;
                                3)  
                                    clear
                                    info "Operando sobre la linea: "
                                    sed -n "${lineas}p" "$archivo"
                                    echo ""
                                    flag3=0
                                    while [ $flag3 -eq 0 ]; do
                                        read -p "Ingrese la nueva cantidad de productos: " nuevaCantidad
                                        if ! [[ "$nuevaCantidad" =~ ^-?[0-9]+$ ]]; then    #Esta sería la sentencia de comprobación que lo ingresado es un valor numérico (segun ChatGPT)
                                            error "Error: Introduce un número válido.\n"
                                        elif [[ "$nuevaCantidad" =~ ^- ]]; then         #Chequeo que lo ingresado sea no negativo
                                            error "Error: Introduce una cantidad no negativa.\n"
                                        elif [ ${#nuevaCantidad} -gt 20 ]; then
                                            error "Error: El número no puede exceder los 20 caracteres.\n"
                                        else
                                            flag3=1
                                        fi
                                    done
                                    lineaEdit="$nombre,$precio,$nuevaCantidad"
                                    ;;
                                *)
                                    warning "Opción no válida."
                                    ;;
                            esac
                            sed -i "s|^$linea|$lineaEdit|" "$archivo"       # actualizo el archivo reemplazando la línea original
                            clear
                            info "Lineas actualizadas."
                            listarProducto
                            flag=1;;
                        [2]*)
                            flag2=0
                            clear
                            while [ $flag2 -eq 0 ]; do
                                
                                echo "$resultado" | sed 's/^/\t/'
                                echo ""
                                info "¿Qué linea(s) desea eliminar? [Indicar número de linea, separadas por comas en caso de multiplicidad]"
                                read lineas
                                if ! [[ "$lineas" =~ ^[0-9]+(,[0-9]+)*$ ]]; then    #Esta sería la sentencia de comprobación de pratrón regex. El patron a comparar declara que al inicio de la cadena (^)debe haber un dígito o más([0-9]+), 
                                                                                    #y que luego puede repetirse 0 o más veces el siguiente patron: una coma y luego dígitos, esto se establece como ()* que inidca que lo de adentro de puede repetir 0 o más veces, 
                                                                                    #y (,[0-9]+) que indica el patro de la coma seguida por digitos
                                    error "Error: Introduce un número válido.\n"
                                else
                                    flag2=1
                                    lineas_encontradas=$(echo "$resultado" | cut -d':' -f1 | tr '\n' ',' | sed 's/,$//')
                                    # Verificar que los números ingresados están en las líneas encontradas
                                    for linea in $(echo "$lineas" | tr ',' ' '); do
                                        if [[ ! ",$lineas_encontradas," =~ ",$linea," ]]; then
                                            error "Error: La línea $linea no corresponde a las líneas encontradas.\n"
                                            flag2=0
                                            break
                                        fi
                                    done   
                                fi
                            done
                    
                            lineas=$(echo "$lineas" | tr -cd '0-9,')

                            IFS=',' read -r -a arr <<< "$lineas"

                            flag2=0
                            interrupcion=""
                            salir=0
                            while [ $flag2 -eq 0 ]; do
                                warning "Se ELIMINARÁ la(s) siguiente(s) linea(s): ";
                                for linea_arr in "${arr[@]}"; do
                                    sed -n "${linea_arr}p" "$archivo"
                                done
                                echo ""
                                info "Presione ENTER para continuar o 'q' para interrumpir"
                                read interrupcion
                                case $interrupcion in
                                    "")
                                        info "Eliminando lineas..."
                                        flag2=1
                                        sleep 1
                                        ;;
                                    [Qq]*)
                                        salir=1
                                        flag2=1
                                        ;;
                                    *)
                                        warning "Opción inválida. Inténtalo de nuevo.\n"
                                        ;;
                                esac
                            done
                            if [ $salir -eq 1 ]; then
                                clear
                                return
                            fi
                            #Debo construir el comando adecuado para sed
                            sed_cmd=""
                            for linea_arr2 in "${arr[@]}"; do
                                sed_cmd+="$linea_arr2"d";"
                            done

                            # Elimino el último ';' que sobra
                            sed_cmd=${sed_cmd%;}

                            sed -i -e "$sed_cmd" "$archivo"
                            clear
                            info "Lineas eliminadas."
                            echo ""
                            listarProducto
                            flag=1;;
                        [Qq]*)
                            clear
                            flag=1;;
                        *)
                            warning "Opción inválida. Inténtalo de nuevo.\n";; 
                    esac
                done
            fi
        else
            error "No existe el archivo ";echo -n -e "\e[3minventario\e[0m";error " en el directorio. Por favor creelo ingresado algún producto ";opcion "(Opcion 1)"
            return
        fi
    }

    function ordenarProducto(){
        if [ -e inventario.* ];then
            archivo=$(echo inventario.* | awk '{print $1}')     #Defino variable de trabajo, sirve para reutilizacion del codigo.
                                                                #Con echo "imprimo" todos los archivos coincidentes con el nombre, 
                                                                #y con awk me quedo solo con la primer coincidencia (encaso de que existan más archivos con el nombre inventario, lo cual no deberia ocurrir)
            #Verifico si el archivo esta vacio.
            if [[ ! -s "$archivo" ]]; then
                error "El inventario esta vacio. No hay productos para ordenar."
                return
            fi

            info "Productos ordenados por precio de forma ascendente:\n"
            printf "%-40s %-20s %-20s\n" "         Nombre del Producto         " "       Precio      " "      Cantidad     "
            printf "%-40s %-20s %-20s\n" "........................................" " ..................." " ..................."
            sort -t',' -k2 -n "$archivo" | while IFS=',' read -r nombre precio cantidad; do   #Determino separacion de columnas con -t, ordeno numericamente la 2da columna.
                printf "%-40s %20s %20s\n" "$nombre" "$precio" "$cantidad"                  #IFS es la variable de separacion de campos. Se define la , como delimitador.
            done
        else
            error "No existe el archivo ";echo -n -e "\e[3minventario\e[0m";error " en el directorio. Por favor creelo ingresado algún producto ";opcion "(Opcion 1)"
            return
        fi
    }

    function impresionProducto(){
        if [ -e inventario.* ];then
                    archivo=$(echo inventario.* | awk '{print $1}')     #Con echo "imprimo" todos los archivos coincidentes con el nombre, 
                                                                        #y con awk me quedo solo con la primer coincidencia (encaso de que existan más archivos con el nombre inventario, lo cual no deberia ocurrir)
                    echo -n "$nombre,">> $archivo; echo -n "$precio,">> $archivo; echo "$cantidad">> $archivo
        else 
            echo -n -e "\033[01;32mSe creará el archivo \033[00;00m";echo -n -e "\e[3minventario\e[0m";info " para guardar la información ingresada.\n"
            echo "Desea que este archivo sea:"
            echo -n "1.";opcion " .txt"
            echo -n "2.";opcion " .csv"
            flag=0
            while [ $flag -eq 0 ];do
                read -p "Elige una opción: " extension
                case $extension in
                    [1]*)
                        archivo="inventario.txt"
                        touch $archivo
                        echo -n "$nombre,">> $archivo; echo -n "$precio,">> $archivo; echo "$cantidad">> $archivo
                        clear
                        info "Se ha creado el archivo: ";echo -e "\e[3minventario.txt\e[0m"
                        flag=1;;
                    [2]*)
                        archivo="inventario.csv"
                        touch $archivo
                        echo -n "$nombre,">> $archivo; echo -n "$precio,">> $archivo; echo "$cantidad">> $archivo
                        clear
                        info "Se ha creado el archivo: ";echo -e "\e[3minventario.csv\e[0m"
                        flag=1;;
                    *)
                        warning "Opción inválida. Inténtalo de nuevo.\n";; 
                esac
            done
        fi
    }

#Inicializo la variable de opcion (es global?). Varia el modo de funcionamiento.
opcion="";
extension="";
impresion=0;
clear;
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
    exit
elif [[ -z "$1" || "$1" =~ ^[[:space:]]*$ ]]; then
    :
else
    error "No se reconoce el parámetro «$1».\n"
    echo "Teclea «./e13 -h» ó «./e13 --help» para la lista de opciones."
    exit  
fi
while true; do
    menu
    read -p "Elige una opción: " opcion
    case $opcion in
        [1]*)
            clear;
            mensaje "Agregue su nuevo Producto:\n";
            prodCompleto=0
            while [ "$prodCompleto" = "0" ]; do
                completo=0
                while [ "$completo" = "0" ]; do
                    impresion=0
                    nuevoProducto
                    estado=$?
                    if [ "$estado" -eq 1 ]; then
                        error "El producto ya ha sido ingresado"
                        prodCompleto=1
                        impresion=1
                        break
                    fi
                    clear
                    echo "Usted ha ingresado:"
                    opcion "Nombre:\t";echo "$nombre"
                    opcion "Precio:\t";echo "$precio"
                    opcion "Cantidad:\t";echo "$cantidad"
                    flag=0
                    while [ $flag -eq 0 ]; do
                        info "¿Desea reingresar los datos proporcionados? [s/n]"
                        info "Si se arrepiente y desea salir, presione 'e'."
                        read reingreso
                        # Verifico si la entrada es válida
                        if echo "$reingreso" | grep -iq "^s$"; then
                            clear
                            flag=1
                        elif echo "$reingreso" | grep -iq "^n$"; then
                            completo=1
                            clear
                            flag=1
                        elif echo "$reingreso" | grep -iq "^e$"; then
                            clear
                            flag=1
                            completo=1
                            prodCompleto=1
                            impresion=1
                        else
                            warning "Entrada no válida. Por favor, ingrese 's' para sí o 'n' para no o 'e' para salir."
                        fi
                    done
                done
                if [ $impresion -eq 0 ]; then
                    impresionProducto
                    clear
                    flag=0
                    while [ $flag -eq 0 ]; do
                        info "¿Desea ingresar un nuevo producto? [s/n]"
                        read reingreso
                        # Verifico si la entrada es válida
                        if echo "$reingreso" | grep -iq "^s$"; then
                            clear
                            flag=1
                        elif echo "$reingreso" | grep -iq "^n$"; then
                            prodCompleto=1
                            clear
                            flag=1
                        else
                            warning "Entrada no válida. Por favor, ingrese 's' para sí o 'n' para no."
                        fi
                    done
                fi
            done
            goBack
            ;;
        [2]*)
            clear;
            mensaje "Aqui tiene la lista de productos deseada:\n";
            listarProducto
            goBack      
            ;;
        [3]*)
            clear;
            mensaje "Busqueda de Productos:\n";
            buscarProducto
            goBack
            ;;
        [4]*)
            clear;
            ordenarProducto
            goBack
            ;; 
        [Qq]*)
            clear;
            info "Saliendo...";
            sleep 1
            clear
            exit
            ;;
        *)
            clear;
            warning "Opción inválida. Inténtalo de nuevo.\n";;
    esac
done