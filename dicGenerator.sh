#!/bin/bash

#set -x

#Colores
NOCOL='\e[0m' # No Color
GREEN='\e[1;32m'
RED='\e[1;31m'
OK="[${GREEN}✓${NOCOL}]"
KO="[${RED}✗${NOCOL}]"

CONTADOR=1
VERBOSE=0
SIMBOLOS=",.-_!%*+\$"
SECONDS=0
COMBOS=6966714    #Combinaciones por palabra en la lista


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

	echo -e "$KO ${RED}ERROR:${NOCOL} El archivo de entrada $ENTRADA no existe"
    exit 1

fi


#Comprobamos si el archivo de salida ya existe
if [ -f $SALIDA ]; then

    echo -e "$KO ${RED}ERROR:${NOCOL} El archivo de salida $SALIDA ya existe"
    exit 1

fi


#Comprobamos permiso de escritura en el directorio de salida
RUTA=$(dirname $(readlink -f $SALIDA))
if [ ! -w $RUTA ]; then
    
    echo -e "$KO ${RED}ERROR:${NOCOL} No se puede escribir en la ruta $RUTA"
    exit 1

fi
    
#Sacamos el número de líneas para el progreso
LINEAS=$(cat $ENTRADA | tr -d " "  | tr "\t" "\n" | tr [:upper:] [:lower:] | grep . | sort | uniq | wc -l)

echo
echo -e "$OK ${GREEN}[TODO OK!]${NOCOL} Comenzamos a crear el diccionario"
echo
echo -e "Palabras de entrada: \t\t$LINEAS" 
echo -e "Combinaciones a crear: \t\t$(expr $LINEAS \* $COMBOS ) " 
echo -e "Tamaño de fichero est.:\t\t$(expr $LINEAS \* 104)MB"
echo
#Limpiamos la entrada de tildes, espacios, líneas vacias, pasamos a minúsculas...
cat $ENTRADA | tr -d " "  | tr "\t" "\n" | tr [:upper:] [:lower:] | grep . | sort | uniq | sed 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚçÇ/aAaAaAaAeEeEiIoOoOoOuUcC/' | while read NOMBRE
    
    do
       
        echo -e "$OK Generando combinaciones para $NOMBRE" 
        echo

        if [ $VERBOSE = 1 ]; then
            #Para mostrar la última palabra generada
            #while /bin/true; do
            until [ $(ps -ef | grep -v grep | grep -c dicGenerator.sh) -le 2 ] ; do
                echo -ne "\\rÚltima entrada:\\t\\t$(tail -1 $SALIDA)" 
                if [ $(ps -ef | grep -v grep | grep -c dicGenerator.sh) -le 2 ]; then
                    break
                fi
                sleep 1
            done &
        fi

        CONTADOR=$((CONTADOR+1))
 
        #Nombre normal, capitalizado, mayúsculas:
        if [ $VERBOSE = 1 ]; then
            echo "Generando 'nombres'"
        fi
        echo $NOMBRE >> $SALIDA                                                             #Nombre
        if [ $VERBOSE = 1 ]; then
            echo "Generando 'Nombres'"
        fi
        echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' >> $SALIDA                         #Nombre Capitalizado
        if [ $VERBOSE = 1 ]; then
            echo "Generando 'NOMBRES'"
        fi
        echo ${NOMBRE} | tr [:lower:] [:upper:] >> $SALIDA                                  #Nombre Mayúsculas

        #l33t completo de vocales:
        if [ $VERBOSE = 1 ]; then
            echo "Generando 'n0mbr3s'"
        fi
        echo ${NOMBRE} | sed 'y/aeioAeio/43104310/' >> $SALIDA                                        #Nombre L33t Solo Vocales
        if [ $VERBOSE = 1 ]; then
            echo "Generando 'N0mbr3s'"
        fi
        echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAEIO/43104310/' >> $SALIDA       #Nombe capitalizado L33t Solo vocales
        if [ $VERBOSE = 1 ]; then
            echo "Generando 'N0MBR3S'"
        fi
        echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aeioAEIO/43104310/' >> $SALIDA
       
        #l33t completo de vocales y 's' si lleva "S" el nombre:
        if [[ $NOMBRE == *[Ss]* ]]; then

            if [ $VERBOSE = 1 ]; then
                echo "Generando 'n0mbr3$'"
            fi
            echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo "Generando 'N0mbr3$'"
            fi
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sSaeioAEIO/$$43104310/' >> $SALIDA
            if [ $VERBOSE = 1 ]; then
                echo "Generando 'N0MBR3$'"
            fi
            echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sSaeioAEIO/$$43104310/' >> $SALIDA
        
        fi
        

        #l33t solo de una letra cada vez:
        if [[ $NOMBRE == *[aA]* ]]; then
            echo ${NOMBRE} | sed 'y/aA/44/' >> $SALIDA
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/' >> $SALIDA
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/aA/44/' >> $SALIDA
        fi
        if [[ $NOMBRE == *[eE]* ]]; then
            echo ${NOMBRE} | sed 'y/eE/33/' >> $SALIDA
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/' >> $SALIDA
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/eE/33/' >> $SALIDA
        fi
        if [[ $NOMBRE == *[iI]* ]]; then
            echo ${NOMBRE} | sed 'y/iI/11/' >> $SALIDA
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/' >> $SALIDA
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/iI/11/' >> $SALIDA
        fi
        if [[ $NOMBRE == *[oO]* ]]; then
            echo ${NOMBRE} | sed 'y/oO/00/' >> $SALIDA
            echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/' >> $SALIDA
            echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/oO/00/' >> $SALIDA
        fi
        

        #Añadimos un símbolo detrás
        for (( i=0; i<${#SIMBOLOS}; i++ ))
        do
            echo "${NOMBRE}${SIMBOLOS:$1:1}" >> $SALIDA
            echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}" >> $SALIDA
            echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}" >> $SALIDA
            echo "$(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}" >> $SALIDA
            echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aeioAEIO/43104310/')${SIMBOLOS:$1:1}" >> $SALIDA
            echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aeioAEIO/43104310/')${SIMBOLOS:$1:1}" >> $SALIDA


            
            if [[ $NOMBRE == *[Ss]* ]]; then

                echo "$(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/sS/$$/')${SIMBOLOS:$1:1}" >> $SALIDA

            fi

            if [[ $NOMBRE == *[aA]* ]]; then
                echo "$(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/aA/44/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi
            if [[ $NOMBRE == *[eE]* ]]; then
                echo "$(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/eE/33/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi
            if [[ $NOMBRE == *[iI]* ]]; then
                echo "$(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/iI/11/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi
            if [[ $NOMBRE == *[oO]* ]]; then
                echo "$(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}" >> $SALIDA
                echo "$(echo ${NOMBRE} | tr [:lower:] [:upper:]| sed 'y/oO/00/')${SIMBOLOS:$1:1}" >> $SALIDA
            fi

        done        


        #Secuencia de números
        echo -e ${NOMBRE}{0..9} | tr [:space:] \\n >> $SALIDA 
        echo -e ${NOMBRE}{00..99} | tr [:space:] \\n >> $SALIDA
        echo -e ${NOMBRE}{000..999} | tr [:space:] \\n >> $SALIDA
        echo -e ${NOMBRE}{0000..9999} | tr [:space:] \\n >> $SALIDA

        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){0..9} | tr [:space:] \\n >> $SALIDA 
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){00..99} | tr [:space:] \\n >> $SALIDA
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){000..999} | tr [:space:] \\n >> $SALIDA
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){0000..9999} | tr [:space:] \\n >> $SALIDA

        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){0..9} | tr [:space:] \\n >> $SALIDA 
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){00..99} | tr [:space:] \\n >> $SALIDA
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){000..999} | tr [:space:] \\n >> $SALIDA
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){0000..9999} | tr [:space:] \\n >> $SALIDA
   
        #Fechas ddmmyyyy 
        echo -e ${NOMBRE}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA 
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA 
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA 

        #Fechas ddmmyy
        echo -e ${NOMBRE}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA 
        echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g'){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA 
        echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:]){01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA 


        #Simbolo entre nombre y secuencia de números

        for (( i=0; i<${#SIMBOLOS}; i++ ))
        do
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e ${NOMBRE}${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:])${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{00..99} | tr [:space:] \\n >> $SALIDA
            echo -e $(echo ${NOMBRE} | sed 'y/sSaeioAeio/$$43104310/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            
            if [[ $NOMBRE == *[Ss]* ]]; then

                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/sS/$$/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi
            
            if [[ $NOMBRE == *[aA]* ]]; then

                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/aA/44/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi


            
            if [[ $NOMBRE == *[eE]* ]]; then

                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/eE/33/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi
            
            if [[ $NOMBRE == *[iI]* ]]; then

                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/iI/11/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


            fi
            
            if [[ $NOMBRE == *[oO]* ]]; then

                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA

                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | sed -e 's/^./\U&/g; s/ ./\U&/g' | sed 'y/oO/00/')${SIMBOLOS:$1:1}{01..31}{01..12}{1950..2020} | tr [:space:] \\n >> $SALIDA


                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0..9} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{00..99} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{000..999} | tr [:space:] \\n >> $SALIDA
                echo -e $(echo ${NOMBRE} | tr [:lower:] [:upper:] | sed 'y/oO/00/')${SIMBOLOS:$1:1}{0000..9999} | tr [:space:] \\n >> $SALIDA
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
