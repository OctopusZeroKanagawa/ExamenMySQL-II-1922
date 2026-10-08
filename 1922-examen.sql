use coworking_grupo5;

-- Crea un trigger SQL que, al insertar una nueva membresía, calcule y complete automáticamente la fecha de vencimiento sumando 30 días a la fecha de inicio.
-- El trigger debe ejecutarse después de insertar (AFTER INSERT) una membresía.
-- La fecha de vencimiento debe guardarse en el mismo registro de la membresía.
-- Incluye un comentario explicando brevemente cómo funciona el trigger.

DELIMITER $$

DROP TRIGGER IF EXISTS trg_suscripciones_bi_fecha_vencimiento$$
-- Se borra este trigger para evitar conflictos con el nuevo trigger solicitado
DROP TRIGGER IF EXISTS trg_calcular_rellenar_fecha_vencimiento$$
CREATE TRIGGER trg_calcular_rellenar_fecha_vencimiento
BEFORE INSERT ON suscripciones
-- Se cambio por before, puesto que si se mantiene el after, no va a permitir setear los datos, generando un error.
FOR EACH ROW
BEGIN
  SET NEW.fecha_inicio = COALESCE(NEW.fecha_inicio, CURDATE());
  SET NEW.fecha_fin = DATE_ADD(NEW.fecha_inicio, INTERVAL 30 DAY);
  -- La fecha fin se calcula sumandole a la fecha de inicio 30 dias
END$$

DELIMITER ;

INSERT INTO suscripciones (id_usuario, id_membresia, fecha_inicio, fecha_fin)
VALUES ((SELECT MIN(id_usuario)   FROM usuarios),
        (SELECT MIN(id_membresia) FROM membresias),
        NULL,
        NULL);

INSERT INTO suscripciones (id_usuario, id_membresia, fecha_inicio, fecha_fin)
VALUES ((SELECT MIN(id_usuario)   FROM usuarios),
        (SELECT MIN(id_membresia) FROM membresias),
        NULL,
        '2026-10-10');

INSERT INTO suscripciones (id_usuario, id_membresia, fecha_inicio, fecha_fin)
VALUES ((SELECT MIN(id_usuario)   FROM usuarios),
        (SELECT MIN(id_membresia) FROM membresias),
        '2026-10-20',
        '2030-01-01');

-- Verificación: las tres últimas suscripciones insertadas
SELECT id_suscripcion, fecha_inicio, fecha_fin,
       DATEDIFF(fecha_fin, fecha_inicio) AS dias_de_diferencia
FROM suscripciones
ORDER BY id_suscripcion DESC
LIMIT 3;

-- Limpieza
DELETE FROM suscripciones
ORDER BY id_suscripcion DESC
LIMIT 3;

