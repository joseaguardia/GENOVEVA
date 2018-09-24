#!/bin/bash

clear

#Colores y marcas
NOCOL='\e[0m' # No Color
GREEN='\e[1;32m'
BLUE='\e[1;34m'
RED='\e[1;31m'
OK="[${GREEN}✓${NOCOL}]"
KO="[${RED}✗${NOCOL}]"

#Editar esta variable para quitar/añadir símbolos
SIMBOLOS=",.-_!%*+\$"

VERBOSE=0
SECONDS=0
COMBOS=6966714    #Combinaciones por palabra en la lista estimado


printHelp() {
    echo
    echo "Uso:"
    echo "$0 -i inputFile -o outputFile [-v]"
    echo "-i: archivo de entrada que contienen las palabras base"
    echo "-o: archivo de salida"
    echo "-v: modo verbose. Muestra la última entrada generada y otra información"
}

printInfo() {
    echo
    echo "Genera desde una lista de nombres un diccionario para ataques de fuerza bruta."
    echo "Incluye el nombre con fechas, números, sustitución de vocales por números..."
    echo ""
   }


#Lanzamos la ayuda si falta algo
    if [ $# -eq 0 ]; then
        printInfo
        printHelp
        exit 2
    fi


#Pasamos como parámetros las opciones
    while getopts i:o:v OPT $@; do
            case $OPT in
                i) # archivo de entrada
                   ENTRADA="$OPTARG"
                   ;;
                o) # archivo de salida
                   SALIDA="$OPTARG"
                   ;;
                v) VERBOSE=1
            esac
    done


#Comprobamos si el archivo de entrada existe
if [ ! -f $ENTRADA ]; then

    echo
	  echo -e "$KO ${RED}ERROR:${NOCOL} El archivo de entrada $ENTRADA no existe"
    exit 1

fi


#Comprobamos si el archivo de salida ya existe
if [ -f $SALIDA ]; then

    echo
    echo -e "$KO ${RED}ERROR:${NOCOL} El archivo de salida $SALIDA ya existe"
    exit 1

fi


#Comprobamos permiso de escritura en el directorio de salida
RUTA=$(dirname $(readlink -f $SALIDA))
if [ ! -w $RUTA ]; then

    echo
    echo -e "$KO ${RED}ERROR:${NOCOL} No se puede escribir en la ruta $RUTA"
    exit 1

fi

#Sacamos el número de palabras de entrada
LINEAS=$(cat $ENTRADA | tr -d " "  | tr "\t" "\n" | tr [:upper:] [:lower:] | grep . | sort | uniq | wc -l)

echo
echo -e "$OK ${GREEN}[TODO OK!]${NOCOL} Comenzamos a crear el diccionario"
echo
echo -e "Palabras de entrada: \t\t$LINEAS"
echo -e "Combinaciones a crear: $(tput bold)\t\t$(expr $LINEAS \* $COMBOS ) $(tput sgr0)"
echo -e "Tamaño de fichero est.:\t\t$(expr $LINEAS \* 104)MB"
echo
#Limpiamos la entrada de tildes, espacios, líneas vacias, pasamos a minúsculas...
cat $ENTRADA | tr -d " "  | tr "\t" "\n" | tr [:upper:] [:lower:] | grep . | sort | uniq | sed 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚçÇ/aAaAaAaAeEeEiIoOoOoOuUcC/' | while read NOMBRE

    do

        echo -e "$OK Generando combinaciones para $NOMBRE"
        echo


        #Nombre normal, capitalizado, mayúsculas, reverso:
        if [ $VERBOSE = 1 ]; then
            echo "Para el ejemplo 'abecedarios'..."
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios'$NOCOL"
        fi
        echo $NOMBRE >> $SALIDA                                                             #Nombre

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios'$NOCOL"
        fi
        echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' >> $SALIDA                         #Nombre Capitalizado

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS'$NOCOL"
        fi
        echo ${NOMBRE} | tr [:lower:] [:upper:] >> $SALIDA                                  #Nombre Mayúsculas

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba'$NOCOL"
        fi
        echo ${NOMBRE} | rev >> $SALIDA                                                     #Reverso

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA'$NOCOL"
        fi
        echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev >> $SALIDA

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba'$NOCOL"
        fi
        echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g' >> $SALIDA

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA'$NOCOL"
        fi
        echo ${NOMBRE} | tr [:lower:] [:upper:] | rev >> $SALIDA


        #l33t completo de vocales:
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s'$NOCOL"
        fi
        echo ${NOMBRE} | sed 'y/aeioAeio/43104310/' >> $SALIDA                                        #Nombre L33t Solo Vocales

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s'$NOCOL"
        fi
        echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAEIO/43104310/' >> $SALIDA       #Nombe capitalizado L33t Solo vocales

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4B3C3D4R10S'$NOCOL"
        fi
        echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aeioAEIO/43104310/' >> $SALIDA


        #l33t completo de vocales y 's' si lleva "S" el nombre:
        if [[ $NOMBRE == *[Ss]* ]]; then

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10$'$NOCOL"
            fi
            echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/' >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10$'$NOCOL"
            fi
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sSaeioAEIO/$$43104310/' >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4B3C3D4R10$'$NOCOL"
            fi
            echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sSaeioAEIO/$$43104310/' >> $SALIDA

        fi


        #l33t solo de una letra cada vez:
        if [[ $NOMBRE == *[aA]* ]]; then
            if [ $VERBOSE = 1 ]; then
              echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4becedarios'$NOCOL"
            fi
            echo ${NOMBRE} | sed 'y/aA/44/' >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4becedarios'$NOCOL"
            fi
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECEDARIOS'$NOCOL"
            fi
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/aA/44/' >> $SALIDA
        fi

        if [[ $NOMBRE == *[eE]* ]]; then
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3darios'$NOCOL"
            fi
            echo ${NOMBRE} | sed 'y/eE/33/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios'$NOCOL"
            fi
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS'$NOCOL"
            fi
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/eE/33/' >> $SALIDA
        fi
        if [[ $NOMBRE == *[iI]* ]]; then
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os'$NOCOL"
            fi
            echo ${NOMBRE} | sed 'y/iI/11/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os'$NOCOL"
            fi
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS'$NOCOL"
            fi
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/iI/11/' >> $SALIDA
        fi
        if [[ $NOMBRE == *[oO]* ]]; then
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s'$NOCOL"
            fi
            echo ${NOMBRE} | sed 'y/oO/00/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s'$NOCOL"
            fi
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S'$NOCOL"
            fi
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/oO/00/' >> $SALIDA
        fi


        #Añadimos un símbolo detrás
        for (( i=0; i<${#SIMBOLOS}; i++ ))
        do
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "${NOMBRE}${SIMBOLOS:$1:1}" >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}" >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}" >> $SALIDA


            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | rev)${SIMBOLOS:$1:1}" >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev)${SIMBOLOS:$1:1}" >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}" >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | rev | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}" >> $SALIDA



            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}" >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAEIO/43104310/')${SIMBOLOS:$1:1}" >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4B3C3D4R10S${SIMBOLOS:$1:1}'$NOCOL"
            fi
            echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aeioAEIO/43104310/')${SIMBOLOS:$1:1}" >> $SALIDA



            if [[ $NOMBRE == *[Ss]* ]]; then
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedario\$${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedario\$${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIO\$${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/sS/$$/')${SIMBOLOS:$1:1}" >> $SALIDA

            fi

            if [[ $NOMBRE == *[aA]* ]]; then
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECED4RIOS${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/aA/44/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi

            if [[ $NOMBRE == *[eE]* ]]; then
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ab3c3darios${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/eE/33/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi

            if [[ $NOMBRE == *[iI]* ]]; then
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/iI/11/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi

            if [[ $NOMBRE == *[oO]* ]]; then
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}" >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S${SIMBOLOS:$1:1}'$NOCOL"
                fi
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/oO/00/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi

        done


        #Secuencia de números
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios0 -> abecedarios9'$NOCOL"
        fi
        echo -e ${NOMBRE}{0..9} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios00 -> abecedarios99'$NOCOL"
        fi
        echo -e ${NOMBRE}{00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios000 -> abecedarios999'$NOCOL"
        fi
        echo -e ${NOMBRE}{000..999} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios0000 -> abecedarios9999'$NOCOL"
        fi
        echo -e ${NOMBRE}{0000..9999} | tr [:space:] \\n >> $SALIDA

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios0 -> Abecedarios9'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){0..9} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios00 -> Abecedarios99'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios000 -> Abecedarios999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){000..999} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios0000 -> Abecedarios9999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){0000..9999} | tr [:space:] \\n >> $SALIDA

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS0 -> ABECEDARIOS9'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){0..9} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS00 -> ABECEDARIOS99'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS000 -> ABECEDARIOS999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){000..999} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS0000 -> ABECEDARIOS9999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){0000..9999} | tr [:space:] \\n >> $SALIDA


        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba0 -> soiradeceba9'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev){0..9} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba00 -> soiradeceba99'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev){00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba000 -> soiradeceba999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev){000..999} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba0000 -> soiradeceba9999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev){0000..9999} | tr [:space:] \\n >> $SALIDA

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA0 -> soiradecebA9'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev){0..9} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA00 -> soiradecebA99'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev){00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA000 -> soiradecebA999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev){000..999} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA0000 -> soiradecebA9999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev){0000..9999} | tr [:space:] \\n >> $SALIDA


        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba0 -> Soiradeceba9'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g'){0..9} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba00 -> Soiradeceba99'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g'){00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba000 -> Soiradeceba999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g'){000..999} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba0000 -> Soiradeceba9999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g'){0000..9999} | tr [:space:] \\n >> $SALIDA

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA0 -> SOIRADECEBA9'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:]){0..9} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA00 -> SOIRADECEBA99'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:]){00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA000 -> SOIRADECEBA999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:]){000..999} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA0000 -> SOIRADECEBA9999'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:]){0000..9999} | tr [:space:] \\n >> $SALIDA





        #Fechas ddmmyyyy
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios01011950 -> abecedarios31122020'$NOCOL"
        fi
        echo -e ${NOMBRE}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios01011950 -> Abecedarios31122020'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS01011950 -> ABECEDARIOS31122020'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba01011950 -> soiradeceba31122020'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA01011950 -> soiradecebA31122020'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba01011950 -> Soiradeceba31122020'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g'){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA01011950 -> SOIRADECEBA31122020'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:]){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA




        #Fechas ddmmyy
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios010100 -> abecedarios311299'$NOCOL"
        fi
        echo -e ${NOMBRE}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios010100 -> Abecedarios311299'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS010100 -> ABECEDARIOS311299'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA

        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba010100 -> soiradeceba311299'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA010100 -> soiradecebA311299'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba010100 -> Soiradeceba311299'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g'){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
        if [ $VERBOSE = 1 ]; then
            echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA010100 -> SOIRADECEBA311299'$NOCOL"
        fi
        echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:]){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA




        #Simbolo entre nombre y secuencia de números

        for (( i=0; i<${#SIMBOLOS}; i++ ))
        do
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios${SIMBOLOS:$1:1}0 -> abecedarios${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios${SIMBOLOS:$1:1}00 -> abecedarios${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios${SIMBOLOS:$1:1}000 -> abecedarios${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios${SIMBOLOS:$1:1}0000 -> abecedarios${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios${SIMBOLOS:$1:1}010100 -> abecedarios${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedarios${SIMBOLOS:$1:1}01011950 -> abecedarios${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios${SIMBOLOS:$1:1}0 -> Abecedarios${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios${SIMBOLOS:$1:1}00 -> Abecedarios${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios${SIMBOLOS:$1:1}000 -> Abecedarios${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios${SIMBOLOS:$1:1}0000 -> Abecedarios${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios${SIMBOLOS:$1:1}010100 -> Abecedarios${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedarios${SIMBOLOS:$1:1}01011950 -> Abecedarios${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS${SIMBOLOS:$1:1}0 -> ABECEDARIOS${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS${SIMBOLOS:$1:1}00 -> ABECEDARIOS${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS${SIMBOLOS:$1:1}000 -> ABECEDARIOS${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS${SIMBOLOS:$1:1}0000 -> ABECEDARIOS${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS${SIMBOLOS:$1:1}010100 -> ABECEDARIOS${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIOS${SIMBOLOS:$1:1}01011950 -> ABECEDARIOS${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba${SIMBOLOS:$1:1}0 -> soiradeceba${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev)${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba${SIMBOLOS:$1:1}00 -> soiradeceba${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev)${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba${SIMBOLOS:$1:1}000 -> soiradeceba${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev)${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba${SIMBOLOS:$1:1}0000 -> soiradeceba${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev)${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba${SIMBOLOS:$1:1}010100 -> soiradeceba${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev)${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradeceba${SIMBOLOS:$1:1}01011950 -> soiradeceba${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev)${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba${SIMBOLOS:$1:1}0 -> Soiradeceba${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba${SIMBOLOS:$1:1}00 -> Soiradeceba${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba${SIMBOLOS:$1:1}000 -> Soiradeceba${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba${SIMBOLOS:$1:1}0000 -> Soiradeceba${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba${SIMBOLOS:$1:1}010100 -> Soiradeceba${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Soiradeceba${SIMBOLOS:$1:1}01011950 -> Soiradeceba${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA${SIMBOLOS:$1:1}0 -> soiradecebA${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev)${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA${SIMBOLOS:$1:1}00 -> soiradecebA${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev)${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA${SIMBOLOS:$1:1}000 -> soiradecebA${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev)${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA${SIMBOLOS:$1:1}0000 -> soiradecebA${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev)${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA${SIMBOLOS:$1:1}010100 -> soiradecebA${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev)${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'soiradecebA${SIMBOLOS:$1:1}01011950 -> soiradecebA${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | rev)${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA${SIMBOLOS:$1:1}0 -> SOIRADECEBA${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA${SIMBOLOS:$1:1}00 -> SOIRADECEBA${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA${SIMBOLOS:$1:1}000 -> SOIRADECEBA${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA${SIMBOLOS:$1:1}0000 -> SOIRADECEBA${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA${SIMBOLOS:$1:1}010100 -> SOIRADECEBA${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'SOIRADECEBA${SIMBOLOS:$1:1}01011950 -> SOIRADECEBA${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | rev | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}0 -> 4b3c3d4r10s${SIMBOLOS:$1:1}9'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}00 -> 4b3c3d4r10s${SIMBOLOS:$1:1}99'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}000 -> 4b3c3d4r10s${SIMBOLOS:$1:1}999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}0000 -> 4b3c3d4r10s${SIMBOLOS:$1:1}9999'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}010100 -> 4b3c3d4r10s${SIMBOLOS:$1:1}311299'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10s${SIMBOLOS:$1:1}01011950 -> 4b3c3d4r10s${SIMBOLOS:$1:1}31122020'$NOCOL"
            fi
            echo -e $(echo ${NOMBRE} | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAeio/43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            if [[ $NOMBRE == *[Ss]* ]]; then

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10\$${SIMBOLOS:$1:1}0 -> 4b3c3d4r10\$${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10\$${SIMBOLOS:$1:1}00 -> 4b3c3d4r10\$${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10\$${SIMBOLOS:$1:1}000 -> 4b3c3d4r10\$${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10\$${SIMBOLOS:$1:1}0000 -> 4b3c3d4r10\$${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10\$${SIMBOLOS:$1:1}010100 -> 4b3c3d4r10\$${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4b3c3d4r10\$${SIMBOLOS:$1:1}01011950 -> 4b3c3d4r10\$${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedario\$${SIMBOLOS:$1:1}0 -> abecedario\$${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedario\$${SIMBOLOS:$1:1}00 -> abecedario\$${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedario\$${SIMBOLOS:$1:1}000 -> abecedario\$${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedario\$${SIMBOLOS:$1:1}0000 -> abecedario\$${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedario\$${SIMBOLOS:$1:1}010150 -> abecedario\$${SIMBOLOS:$1:1}311220'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedario\$${SIMBOLOS:$1:1}01011950 -> abecedario\$${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedario\$${SIMBOLOS:$1:1}0 -> Abecedario\$${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedario\$${SIMBOLOS:$1:1}00 -> Abecedario\$${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedario\$${SIMBOLOS:$1:1}000 -> Abecedario\$${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedario\$${SIMBOLOS:$1:1}0000 -> Abecedario\$${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedario\$${SIMBOLOS:$1:1}010100 -> Abecedario\$${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedario\$${SIMBOLOS:$1:1}01011950 -> Abecedario\$${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIO\$${SIMBOLOS:$1:1}0 -> ABECEDARIO\$${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIO\$${SIMBOLOS:$1:1}00 -> ABECEDARIO\$${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIO\$${SIMBOLOS:$1:1}000 -> ABECEDARIO\$${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIO\$${SIMBOLOS:$1:1}0000 -> ABECEDARIO\$${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIO\$${SIMBOLOS:$1:1}010100 -> ABECEDARIO\$${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARIO\$${SIMBOLOS:$1:1}01011950 -> ABECEDARIO\$${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi

            if [[ $NOMBRE == *[aA]* ]]; then

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}0 -> 4beced4rios${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}00 -> 4beced4rios${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}000 -> 4beced4rios${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}0000 -> 4beced4rios${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}010100 -> 4beced4rios${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}01011950 -> 4beced4rios${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}0 -> 4beced4rios${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}00 -> 4beced4rios${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}000 -> 4beced4rios${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}0000 -> 4beced4rios${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}010100 -> 4beced4rios${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4beced4rios${SIMBOLOS:$1:1}01011050 -> 4beced4rios${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECED4RIOS${SIMBOLOS:$1:1}0 -> 4BECED4RIOS${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECED4RIOS${SIMBOLOS:$1:1}00 -> 4BECED4RIOS${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECED4RIOS${SIMBOLOS:$1:1}000 -> 4BECED4RIOS${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECED4RIOS${SIMBOLOS:$1:1}0000 -> 4BECED4RIOS${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECED4RIOS${SIMBOLOS:$1:1}010100 -> 4BECED4RIOS${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando '4BECED4RIOS${SIMBOLOS:$1:1}01011950 -> 4BECED4RIOS${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi



            if [[ $NOMBRE == *[eE]* ]]; then

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ab3c3darios${SIMBOLOS:$1:1}0 -> ab3c3darios${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ab3c3darios${SIMBOLOS:$1:1}00 -> ab3c3darios${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ab3c3darios${SIMBOLOS:$1:1}000 -> ab3c3darios${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ab3c3darios${SIMBOLOS:$1:1}0000 -> ab3c3darios${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ab3c3darios${SIMBOLOS:$1:1}010100 -> ab3c3darios${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ab3c3darios${SIMBOLOS:$1:1}01011950 -> ab3c3darios${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios${SIMBOLOS:$1:1}0 -> Ab3c3darios${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios${SIMBOLOS:$1:1}00 -> Ab3c3darios${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios${SIMBOLOS:$1:1}000 -> Ab3c3darios${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios${SIMBOLOS:$1:1}0000 -> Ab3c3darios${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios${SIMBOLOS:$1:1}010100 -> Ab3c3darios${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Ab3c3darios${SIMBOLOS:$1:1}01011950 -> Ab3c3darios${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS${SIMBOLOS:$1:1}0 -> AB3C3DARIOS${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS${SIMBOLOS:$1:1}00 -> AB3C3DARIOS${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS${SIMBOLOS:$1:1}000 -> AB3C3DARIOS${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS${SIMBOLOS:$1:1}0000 -> AB3C3DARIOS${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS${SIMBOLOS:$1:1}010100 -> AB3C3DARIOS${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'AB3C3DARIOS${SIMBOLOS:$1:1}01011950 -> AB3C3DARIOS${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi

            if [[ $NOMBRE == *[iI]* ]]; then

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os${SIMBOLOS:$1:1}0 -> abecedar1os${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os${SIMBOLOS:$1:1}00 -> abecedar1os${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os${SIMBOLOS:$1:1}000 -> abecedar1os${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os${SIMBOLOS:$1:1}0000 -> abecedar1os${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os${SIMBOLOS:$1:1}010100 -> abecedar1os${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedar1os${SIMBOLOS:$1:1}01011950 -> abecedar1os${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os${SIMBOLOS:$1:1}0 -> Abecedar1os${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os${SIMBOLOS:$1:1}00 -> Abecedar1os${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os${SIMBOLOS:$1:1}000 -> Abecedar1os${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os${SIMBOLOS:$1:1}0000 -> Abecedar1os${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os${SIMBOLOS:$1:1}010100 -> Abecedar1os${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedar1os${SIMBOLOS:$1:1}01011950 -> Abecedar1os${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS${SIMBOLOS:$1:1}0 -> ABECEDAR1OS${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS${SIMBOLOS:$1:1}00 -> ABECEDAR1OS${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS${SIMBOLOS:$1:1}000 -> ABECEDAR1OS${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS${SIMBOLOS:$1:1}0000 -> ABECEDAR1OS${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS${SIMBOLOS:$1:1}010100 -> ABECEDAR1OS${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDAR1OS${SIMBOLOS:$1:1}01011950 -> ABECEDAR1OS${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi

            if [[ $NOMBRE == *[oO]* ]]; then

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s${SIMBOLOS:$1:1}0 -> abecedari0s${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s${SIMBOLOS:$1:1}00 -> abecedari0s${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s${SIMBOLOS:$1:1}000 -> abecedari0s${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s${SIMBOLOS:$1:1}0000 -> abecedari0s${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s${SIMBOLOS:$1:1}010100 -> abecedari0s${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'abecedari0s${SIMBOLOS:$1:1}01011950 -> abecedari0s${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s${SIMBOLOS:$1:1}0 -> Abecedari0s${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s${SIMBOLOS:$1:1}00 -> Abecedari0s${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s${SIMBOLOS:$1:1}000 -> Abecedari0s${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s${SIMBOLOS:$1:1}0000 -> Abecedari0s${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s${SIMBOLOS:$1:1}010100 -> Abecedari0s${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'Abecedari0s${SIMBOLOS:$1:1}01011950 -> Abecedari0s${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S${SIMBOLOS:$1:1}0 -> ABECEDARI0S${SIMBOLOS:$1:1}9'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S${SIMBOLOS:$1:1}00 -> ABECEDARI0S${SIMBOLOS:$1:1}99'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S${SIMBOLOS:$1:1}000 -> ABECEDARI0S${SIMBOLOS:$1:1}999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S${SIMBOLOS:$1:1}0000 -> ABECEDARI0S${SIMBOLOS:$1:1}9999'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S${SIMBOLOS:$1:1}010100 -> ABECEDARI0S${SIMBOLOS:$1:1}311299'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
                if [ $VERBOSE = 1 ]; then
                    echo -e "\t[${SECONDS} s]\t${BLUE}Generando 'ABECEDARI0S${SIMBOLOS:$1:1}01011950 -> ABECEDARI0S${SIMBOLOS:$1:1}31122020'$NOCOL"
                fi
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi
        done


        echo -e " $OK"

    done


echo
echo -e "Palabras generadas: \\t$(tput bold)$(wc -l $SALIDA | awk '{print $1}')$(tput sgr0)"
echo -e "Tamaño de archivo: \\t$( du -lh $SALIDA | cut -f1)"
TIEMPO=$(eval "echo $(date -ud "@$SECONDS" +'$((%s/3600/24)) días %H horas %M minutos %S segundos')")
echo -e "Tiempo total: \\t\\t$TIEMPO"
#echo -e "Tiempo total: \\t\\t$SECONDS segundos"
echo
echo -e "$GREEN Archivo $(readlink -f $SALIDA) generado con éxito$NOCOL"
