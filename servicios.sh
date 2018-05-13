#!/bin/bash
while true
do
   cat <<- EOF
   Instalación de servicios
1   Instalación LAMPP.
2   Instalación de servidor DNS (bind9)
3   Instalación de servidor DHCP
4   Generar certificados SSL/TSL
5   Salir
EOF
    read respuesta
    
    case $respuesta in
        1) echo "Instalaremos Apache2, MySQL y PHP"
            #https://www.digitalocean.com/community/tutorials/como-instalar-linux-apache-mysql-php-lamp-en-ubuntu-16-04-es
            echo  "La ruta por defecto donde se alojan las páginas web es /var/www/html"
            sudo apt install php libapache2-mod-php php-mcrypt php-mysqg php-gettext mysql-server mysql-client libmysqlclient-dev;
            echo "Comprobamos que los paquetes se han instsalado correctamente"
            sudo apache2ctl configtest
            sleep 4
            sudo service apache2 status
            sleep 4
            sudo service mysql
            sleep 4
            echo "¿Desea iniciar el asistente para la instalación segura de mysql? Pulsa s para confirmar"
            read instalsec
            if [ "$instalsec" == "s" ]
                then
                    mysql_secure_installation
                else
                    echo "No se iniciará el asistente"
            fi
            echo "¿Quiere ajustar el firewal para permitir tráfico web? Pulsa s para confirmar "
            read permitirweb
            if [ "$permitirweb" == "s" ]
                then
            #Comprobamos la lista de servicios que podemos filtrar
                    sudo ufw app list
                    echo "Añadimos la regla sobre Apache Full"
                    sudo ufw allow in "Apache Full"
            else
                echo "No se ha modificado el firewall"

            fi
            echo "Configuración finalizada"
            ;;
        2) sudo apt install bind9 bind9utils bind9-doc;
            echo "Creamos una copia del archivo named.conf.local llamado named.conf.local.bak"
            sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak
            echo "Introduce el nombre del dominio"
            read nombredom
            echo "Introduce la interfaz de red, por ejemplo enp0s3"
            read interfaz
            if [ -z $interfaz ]
                then
                    echo "Es obligatorio introducir la interfaz"
                    exit
            fi
            if [ -z "$nombredom" ]
                then
                    echo "Debes introducir algún nombre"
                    exit
            else
                echo "Se va a crear el archivo de zona directa vacío"
                sudo cp /etc/bind/db.local /etc/bind/db.$nombredom
                echo "Se va a crear el archivo de zona inversa"
                echo "zone \"$nombredom\" {" >> /etc/bind/named.conf.local
                echo "Seleccione el tipo  de zona (master ó slave)"
                read tipozona
                if [ "$tipozona" = "master" ] || [ "$tipozona" = "slave" ] 
                then
                        echo "  type $tipozona;" >> /etc/bind/named.conf.local
                        echo "  file \"/etc/bind/db.$nombredom\";" >> /etc/bind/named.conf.local
                        echo "};" >> /etc/bind/named.conf.local
                        cat /etc/bind/named.conf.local
                        echo "Se va a proceder a configurar la zona inversa"
                        echo "Introduzca la ip de esta forma: 1.168.192"
                        read ipinversa
                        if [ -z ipinversa ]
                        then
                                echo "Debes introducir una zona inversa"
                                exit
                            else
                            sudo cp /etc/bind/db.127 /etc/bind/db.$ipinversa.rev
                            echo "zone \"$ipinversa.in-addr.arpa\" {" >> /etc/bind/named.conf.local
                            echo "Introduce el tipo de zona inversa (master ó slave)"
                            read tipozonainv
                            if [ "$tipozonainv" = "master" ] || [ "$tipozonainv" = "slave" ]
                            then
                                    echo "  type $tipozonainv;" >> /etc/bind/named.conf.local
                                    echo "  file \"/etc/bind/db.$ipinversa.rev\";" >> /etc/bind/named.conf.local
                                    echo "};" >> /etc/bind/named.conf.local
                                    cat /etc/bind/named.conf.local
                                    echo "¿Desea configurar los reenviadores? (s/n)"
                                    read respreenv
                                    if [ "$respreenv" = "s" ]
                                        then
                                            echo "Introduce los reenviadores (8.8.8.8) por ejemplo"
                                            read reenv
                                            if [ -z "$reenv" ]
                                                then
                                                    echo "Debes introducir los reenviadores"
                                                    exit
                                            fi
                                            #Descomentamos las líneas https://egráficos.stackoverflow.com/questions/160392/quitar-car%c3%a1cter-especiales-en-l%c3%adneas-concretas-con-sed/160396#160396
                                                sudo sed -i '13, 15 s/\/\///' /etc/bind/named.conf.options
                                                #Introducimos los reenviadores en el fichero
                                                sudo sed -i "s/0.0.0.0/$reenv/" /etc/bind/named.conf.options
                                                cat /etc/bind/named.conf.options
                                    elif [ "$respreenv" = "n" ]
                                        then 
                                            echo "No has querido introduccir los reenviadores"
                                    else
                                        echo "Selecciona una opción válida"
                                        exit
                                    fi
                                    echo "Procedemos a configurar de forma básica los archivos de zona directa. Añada las zonas que estime oportunas"
                                                echo "manualmente, así como el resto de parámetros esta configuración será igual para la zona inversa"
                                                echo "Se añadirán registros A para el dominio"
                                                sleep 5
                                                sed -i "s/root.localhost/$nombredom/" /etc/bind/db.$nombredom
                                                sed -i "s/localhost/$nombredom/" /etc/bind/db.$nombredom
                                                #optenemos la ip
                                                echo "introduce la ip"
                                                read ip
                                                if [ -z $ip ]
                                                    then
                                                        echo "Es oligatorio introducir la ip"
                                                        exit
                                                fi
                                                #añadimos la ip
                                                sed -i "s/127.0.0.1/$ip/" /etc/bind/db.$nombredom
                                                cat /etc/bind/db.$nombredom
                                                echo "Realizamos la misma tarea con la zona inversa"
                                                sed -i "s/root.localhost/$nombredom/" /etc/bind/db.$ipinversa.rev
                                                sed -i "s/localhost/$nombredom/" /etc/bind/db.$ipinversa.rev
                                                sed -i "s/1.0.0/$ipinversa/" /etc/bind/db.$ipinversa.rev
                                                cat /etc/bind/db.$ipinversa.rev
                                else
                                    echo "Introduce un tipo de zona válido"
                                    exit
                            fi
                        fi
                else
                    echo "Introduce una respuesta válida"
                    exit
                fi
            fi
        ;;
        3) echo "En progreso" ;;
        4) echo "En progreso" ;;
        5) echo "Adios"
            exit;;
        *) echo "Escoge un parámetro válido" ;;
    esac
    done
