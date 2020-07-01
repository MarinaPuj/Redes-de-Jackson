# Redes-de-Jackson

Este código simula una red de Jackson. Donde los clientes primero llegan a una cola M/M/2 una vez salen de dicha cola pasan a una M/M/1. Cuándo terminan de ser servidos en la cola M/M/1 vuelven a la cola inicial M/M/2 con una probabilidad del 20%, el resto de los clientes sale de la red.

* Una cola M/M/2 es una cola con 2 servidores, las llegadas y tiempos de servicios de los clientes siguen una distribución exponencial.
  Si los servidores están vacíos cuando llega un cliente irá con la misma probabilidad a cualquier de las dos colas, sino irá al que menos cola tenga.
* Una cola M/M/1 es una cola con 1 servidores, las llegadas y tiempos de servicios de los clientes siguen una distribución exponencial.

Este código es la solución del siguiente enunciado:  A repair and inspection facility consists of two stations: a repair station with two technicians, and an inspection station with 1 inspector. Each repair technician works at the rate 3 items per hour; the inspector can inspect 7 items per hour. Approximately 20% of all items fail inspection and are sent back to the repair station. (This percentage holds even for items that have been repaired two or more times). If items arrive at the rate 4 per hour, simulate the net.

## Resultado
Tendremos dos tablas:
* T. Corresponde a los datos de los clientes cuando son servidos en la cola M/M/2.
* T2.  Corresponde a los datos de los clientes cuando son servidos en la cola M/M/1.
Las colas pueden atender a algún cliente más de una vez, y por eso este estará repetido.

Las dos tablas tendrán estas columnas
* Número de cliente servido, identificación. 'Num_Costumer'
* Tiempo de llegada a la cola. 'Arrival_Time'
* Tiempo en que empieza a ser servido. 'Time_Service_Begins'
* Tiempo en que acaba de ser servido. 'Time_Service_Ends'
* Tiempo que ha tardado en servirse. 'Service_Time'
* Tiempo total que ha estado esperando en esa cola. 'Wq'
* Tiempo total en esa cola. 'W'
* Tiempo de descanso del servidor (en M/M/2 cuando los 2 están libres). 'Idle_Time'

En la cola M/M/2 además tendremos la columna 'Server' que indica que servidor lo sirve.

Sería interesante desarrollar otra tabla con la información del tiempo total que pasa cada cliente en la red de Jackson, el motivo por el que no lo hice es debido a que este código es para un ejercicio de un examen. En el examen solo hacia falta explicar como haríamos el código, una vez explicado me sobraba un poco de tiempo y decidí hacerlo pero no me dió tiempo de pulirlo (Este codigo se basa en una combinación de dos M/M/s y ya tenía desarrollado ese código).
