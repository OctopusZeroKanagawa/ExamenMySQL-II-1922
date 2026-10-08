# Trigger - 1922

## Enunciado

Se solicito crear un trigger el cual calculara y rellenara la fecha de vencimiento
de una nueva membresia, sumando 30 dias a la fecha de inicio de esta. 
Se pide explicitamente que sea despues de un after insert.

## Desarrollo 

Debido a como esta estructurado el proyecto, se tuvo que cambiar el after insert
a un before, pues el after no permite modificar los datos.

Su ejecución es bastante sencilla:

- Primero borramos un trigger previo que cumplia una tarea similar para que no 
  genere conflicto con el nuevo script.
- Despues hacemos una verificación con la fecha de inicio; En caso de que no se
  tenga una fecha de inicio se aplica un CURDATE para asignarle la fecha de hoy.
- Finalmente asiganmos la fecha de fin, esto se hace agarrando la fecha de inicio
  y sumandole 30 dias con un INTERVAL 30 DAY

## Pruebas

Se realizaron pruebas con 3 inserts junto con su respectiva consulta  para verificar 
el funcionamiento correcto del trigger; Se inserto una suscripcion sin fecha de
inicio y fin, una sin fecha de inicio pero con fecha de fin, y una con ambos valores.
Los 3 mostraron funcionar sin problema.

Se uso (SELECT MIN(id_usuario)   FROM usuarios), y (SELECT MIN(id_membresia) FROM membresias)
para evitar errores, y se borran las inserciones al final.
