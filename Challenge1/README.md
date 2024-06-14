# Challenge 1

## Arquitectura elegida

Se separó el backend y frontend en distintas subredes e instancias EC2. 
Para el frontend, se usan subredes públicas que tienen acceso inbound y outbound a internet. El backend lo corren instancias EC2 en subredes privadas, teniendo comunicación outbound(pero no inbound) a través de NAT gateways. Además, el backend se comunica con las bases de datos relacionales y no relacionales pedidas.

### Cargas variables

Para solucionar esto, se implementaron 2 mecanismos: Elastic Load Balancing(ELB) y Auto Scaling Groups(ASG). Con ELB se logra que el trafico sea repartido equitativamente entre las instancias que estan operacionales. Con ASG se logra el escalado horizontal de las instancias EC2, para que el uso de las instancias se ajuste a la demanda. El scale in y el scale out puede ser controlado mediante políticas establecidas con la ayuda de CloudWatch, esto es, en base por ejemplo al uso del CPU, network, etc.

### Alta disponibilidad

Para lograr este requerimiento, la aplicacion se levanta en 2 zonas de disponibilidad distintas, lo que le da redundancia a la aplicación, y tolerancia a fallos en caso de que una zona de disponibilidad deje de funcionar.



