# Craftech challenge

## Tercera parte del challenge

Para la implementacion del pipeline se uso Github Actions: cada vez que se modifica index.html y se pushea, se triggerean las siguientes acciones: 

- Se construye la imagen de docker usando docker compose

- Se pushea la imagen a docker hub

- Se actualiza un servicio de ECS con la nueva imagen, exponiendo el contenedor a internet.

El servicio ECS tiene que estar previamente creado y definido, no se autommatiza el proceso de creacion de los recursos de AWS.

