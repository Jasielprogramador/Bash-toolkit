# Bash-toolkit
## Proyecto realizado por Rafael Aybar Segura, curso 2017-2018, IES AL-ANDALUS
Este proyecto es un conjunto de herramientas para sysadmin para servidores con sistema operativo Ubuntu server 16.04 o superior con las siguientes funcionalidades

-    Copias de seguridad y automatización de tareas.
-    Obtención de información de base de datos MySQL.
-    Gestión de usuarios y permisos.
-    Gestión de discos. **ADVERTENCIA: El autor no se hace responsable de la pérdida de datos ni de las consecuencias que pueda acarrear el mal uso de estos scripts.**    
    - Incluye:
        - Obtención de información de los discos del sistema.
        - Cifrado de particiones/discos.
        - Borrado seguro de archivos (Esta opción puede degradar bastante su disco SSD debido a los procesos de sobreescritura).
        - Eliminación de particiones.

-    Instalación de sistemas operativos en pendrive.
-    Monitorización de procesos.
-    Configuración de tarjetas de red:
 
        **NOTA: El script configurará la tarjeta de red principal y deberá ejecutarse de la siguiente manera, siguiendo el orden de los parámetros de forma rigurosa:**
        
            ./configred.sh nombre-de-la-tarjeta-de-red red ip-de-la-máquina puerta-de-enlace máscara servidores-dns
       
       Ejemplo:
            
            ./configred.sh enp0s3 192.168.209.0 192.168.209.45 192.168.209.1 255.255.255.0 8.8.8.8

-   Servicios DNS, DHCP, dominio Samba y unión de clientes Linux (Ubuntu)

### Requerimientos:
* `Ubuntu server 16.04.4 LTS`
* `Bash`
* `MySQL 5.7 o superior`
* `Python 3.5 o superior` (sólo para obtener información de las bases de datos)
* `SQLAlchemy` Librería para python y bases de datos
* `python-mysqldb` y `python3-mysqldb` (conectores que permiten que python3 interactúe con mysql)
* `cryptsetup` (sólo para las opciones de cifrado)
### Agradecimientos
* A todos los profesores del [IES Al-Andalus](https://iesalandalus.org/)
* A [almuhs](https://github.com/AlmuHS), a [fryntiz](https://github.com/fryntiz), a @saul-bt y a toda la comunidad linuxera que ha hecho posible este proyecto
