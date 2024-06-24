# Craftech challenge

## Segunda parte del challenge

Primero, para que el proyecto funcione hay que definir un .env para la API en el backend. Una vez se tuvo la API funcionando, se definio un compose que levante los 3 microservicios, en vez de tener 2 compose separados, cada uno levantando el front y el back por separado.

Una de las opciones fue mediante el compose que levanta los 3 contenedores, intentar llamando mediante una variable de entorno a los otros compose, pero cada compose en vez de buscar sus dependencias en su respectivo subdirectorio, las buscaba en el root del proyecto, por lo que descarte hacerlo de esa forma. En vez de eso me incline por el compose que levanta todos los servicios necesarios, indicando en cada servicio el path de los subdirectorios a los archivos / carpetas que necesitase.

Una vez hecho eso, la APP funciono bien en el local, lo complicado fue hacer que funcione en la nube. Explore varias herramientas y opciones para el despliegue en la nube:

- Opcion 1: aws ecs. Esta es la herramienta de aws para manjear ecs con docker, pero no logre hacerla andar por un error en el que tenia que realizar un downgrade de docker que no pude hacer.

- Opcion 2: ecs-cli. Es una herramienta de docker para aws, la cual ha dejado de tener soporte desde noviembre del 2023. Esta herramienta forma una plantilla de cloud formation a partir del .yaml de docker compose. Esto es, genera el repositorio(ECR), el cluster(ECS), los servicios y sus definiciones. Esta opcion es la que mejor funciono

- Opcion 3: otra opcion es hacer lo que hacen las herramientas anteriormente mencionadas, pero de forma "manual" escribiendo un script para usarse con AWS CLI. Este no es un aproach que haya podido hacer funcionar por el momento.

- Opcion 4: usando Kubernetes. Una vez se tienen las imagenes necesarias en un repositorio de imagenes como Docker Hub, se puede configurar un cluster de Kubernetes en amazon EKS. Luego se configuran archivos YAML para el despliegue de los servicios de la db, el front y el back.

Si bien con ecs-cli se logra levantar el proyecto en la nube, y quedan los 3 servicios expuestos, no es posible conectar el front con el back debido a problemas de seguridad propios al navegador(chrome). Parece haber un problema con el sistema CORS de la API que esta bloqueando los request que manda el navegador en la nube. El front funciona correctamente, y la API responde a postman.

## Opcion 2

Es necesario: 

- Tener instalado ecs-cli. Referencia: [ecs-cli](https://www.docker.com/blog/docker-compose-from-local-to-amazon-ecs/). 
  
- Estar logeado en docker para poder pushear las imagenes a DockerHub. 

- Estar logeado con credenciales de aws para que la herramienta pueda usar la cuenta de aws

Para pushear las imagenes

` docker compose push `

Para que docker compose haga target en ECS, es necesario crear un contexto de docker, del tipo ECS

` docker context create ecs craftech_cloud `

Se switchea a ese contexto 

` docker context use craftech_cloud `

Luego se puede hacer el deploy normalmente con

` docker compose up -d `

### Opcion 4

Es necesario tener instalado kubectl, docker compose y minikube

Se generaron 3 pods, 1 para cada uno de los contenedores. Asi mismo, se generan 3 servicios, un ClusterIP para la db, el cual usa la API, un LoadBalancer para la API y un LoadBalancer para el front.

#### Despliegue local

Se ejecuta el script *deploy.sh* para despliegue local, el cual va a levantar el cluster local, generar los servicios y esperar a que se le asignen IP a esos servicios, lo cual se hace con el siguiente comando

` minikube tunnel`

Una vez asignadas las IP, el script levanta la IP asignada y la pasa como variable de entorno al frontend para que este pueda encontrar el backend. Esto se hace generando los congifmaps correspondientes a cada archivo .env presente en el proyecto.

Luego de esto, se construyen y pushean las imagenes a dockerhub, para luego crear los pods correspondientes al back y el front.

Se puede ver la IP asignada al frontend usando el comando

` kubectl get services `

#### Despliegue en la nube

Se necesita tener instalado AWSCLI con las credenciales de un usuario IAM capaz de usar amazon EKS. Ademas se necesita eksctl para la generacion automatizada del cluster.

Una vez se tienen las herramientas necesarias, se ejecuta el siguiente comando, que genera un cluster EKS con 3 nodos, que las manejan instancias EC2 del tipo t2.small.

```
eksctl create cluster \                  
--name challenge-cluster \
--region us-east-2 \
--nodegroup-name workers \
--node-type t2.small \
--nodes 3
```

Luego de que el comando se termina de ejecutar, se maneja el cluster como se hacía en el local. Dado que se crea un servicio loadbalancer, la ip que se expone a internet con el front va a ser dada por el comando kubectl get services

Para borrar el cluster y todos los recursos asociados:

`eksctl delete cluster --name challenge-cluster`

**Para automatizar todo esto, se escribió un script que da la opcion a elegir entre despliegue local o en la nube.**





