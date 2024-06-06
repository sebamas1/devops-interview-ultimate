# Craftech challenge

## Segunda parte del challenge

Primero, para que el proyecto funcione hay que definir un .env para la API en el backend. Una vez se tuvo la API funcionando, se definio un compose que levante los 3 microservicios, en vez de tener 2 compose separados, cada uno levantando el front y el back por separado.

Una de las opciones fue mediante el compose que levanta los 3 contenedores, intentar llamando mediante una variable de entorno a los otros compose, pero cada compose en vez de buscar sus dependencias en su respectivo subdirectorio, las buscaba en el root del proyecto, por lo que descarte hacerlo de esa forma. En vez de eso me incline por el compose que levanta todos los servicios necesarios, indicando en cada servicio el path de los subdirectorios a los archivos / carpetas que necesitase.

Una vez hecho eso, la APP funciono bien en el local, lo complicado fue hacer que funcione en la nube. Explore varias herramientas y opciones para el despliegue en la nube:

- Opcion 1: aws ecs. Esta es la herramienta de aws para manjear ecs con docker, pero no logre hacerla andar por un error en el que tenia que realizar un downgrade de docker que no pude hacer.

- Opcion 2: ecs-cli. Es una herramienta de docker para aws, la cual ha dejado de tener soporte desde noviembre del 2023. Esta herramienta forma una plantilla de cloud formation a partir del .yaml de docker compose. Esto es, genera el repositorio(ECR), el cluster(ECS), los servicios y sus definiciones. Esta opcion es la que mejor funciono

- Opcion 3: otra opcion es hacer lo que hacen las herramientas anteriormente mencionadas, pero de forma "manual" escribiendo un script para usarse con AWS CLI. Este no es un aproach que haya podido hacer funcionar por el momento.

Si bien con ecs-cli se logra levantar el proyecto en la nube, y quedan los 3 servicios expuestos, no es posible conectar el front con el back debido a problemas de seguridad propios al navegador(chrome). Parece haber un problema con el sistema CORS de la API que esta bloqueando los request que manda el navegador en la nube. El front funciona correctamente, y la API responde a postman.

chrome://flags/#block-insecure-private-network-requests

Para que el navegador no se niegue a mandar la solicitud, es necesario desactivar la flag de arriba.