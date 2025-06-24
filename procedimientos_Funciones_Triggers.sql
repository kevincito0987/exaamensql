-- * Ejercicios de procedimiento almacenado

--**`ps_add_pizza_con_ingredientes`**
-- Crea un procedimiento que inserte una nueva pizza en la tabla `pizza` junto con sus ingredientes en `pizza_ingrediente` si no existe.

--     - Parámetros de entrada: `p_nombre_pizza`, `p_precio`, lista de `p_ids_ingredientes`.
--     - Debe recorrer la lista de ingredientes (cursor o ciclo) y hacer los inserts correspondients. 


DROP PROCEDURE IF EXISTS ps_add_pizza_con_ingredientes;

DELIMITER $$

-- Procedimiento: ps_add_pizza_con_ingredientes
-- Descripción: Inserta una nueva pizza en la tabla 'Producto' junto con sus ingredientes
--              en 'Pizza_Ingrediente_Base' si no existe un producto con el mismo nombre.
-- Parámetros de entrada:
--   p_nombre_producto VARCHAR(200): El nombre de la nueva pizza/producto.
--   p_descripcion_producto TEXT: La descripción detallada del producto.
--   p_tipo_producto_id INTEGER: El ID del tipo de producto (debe ser 1 para Pizza).
--   p_esta_activo BOOLEAN: Indica si el producto está activo (TRUE/1) o inactivo (FALSE/0).
--   p_cantidad_stock INTEGER: La cantidad de stock inicial del producto.
--   p_instrucciones_preparacion TEXT: Las instrucciones específicas para preparar la pizza.
--   p_precio_base DECIMAL(10,2): El precio base de la pizza.
--   p_ids_ingredientes VARCHAR(255): Una cadena de IDs de ingredientes
--                                    separados por comas (ej. '1,3,5').
CREATE PROCEDURE ps_add_pizza_con_ingredientes (
    IN p_nombre_producto VARCHAR(200),
    IN p_descripcion_producto TEXT,
    IN p_tipo_producto_id INTEGER,
    IN p_esta_activo BOOLEAN,
    IN p_cantidad_stock INT,
    IN p_instrucciones_preparacion TEXT,
    IN p_precio_base DECIMAL(10, 2),
    IN p_ids_ingredientes VARCHAR(255)
)
BEGIN
    -- Declaración de variables locales
    DECLARE v_id_generado INT;                -- Almacenará el ID de la nueva pizza/producto
    DECLARE v_ingrediente_id INT;             -- Almacenará el ID del ingrediente en cada iteración
    DECLARE v_pos INT DEFAULT 1;              -- Posición actual en la cadena de IDs de ingredientes
    DECLARE v_next_comma INT;                 -- Próxima posición de la coma en la cadena de IDs
    DECLARE v_current_id_str VARCHAR(10);     -- Subcadena para el ID del ingrediente actual
    DECLARE v_fecha_actual DATE;              -- Almacenará la fecha actual para el registro de vigencia
    DECLARE v_fecha_fin_por_defecto DATE;     -- Almacenará una fecha de fin de vigencia predeterminada

    -- Obtener la fecha actual y establecer la fecha de fin por defecto
    SET v_fecha_actual = CURDATE();
    SET v_fecha_fin_por_defecto = '9999-12-31';

    -- Iniciar una transacción para asegurar la integridad de los datos
    START TRANSACTION;

    -- Paso 1: Verificar si ya existe un producto con el mismo nombre
    SELECT id_producto INTO v_id_generado
    FROM Producto
    WHERE nombre_producto = p_nombre_producto;

    IF v_id_generado IS NOT NULL THEN
        -- Si el producto ya existe, revertimos todos los cambios de la transacción
        ROLLBACK;
        -- Y lanzamos una señal de error para informar que la operación falló
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Ya existe un producto con este nombre. No se puede insertar una nueva pizza con el mismo nombre.';
    END IF;

    -- Paso 2: Insertar la información básica del producto en la tabla 'Producto'
    INSERT INTO Producto (nombre_producto, descripcion, tipo_producto_id, esta_activo, cantidad_stock)
    VALUES (p_nombre_producto, p_descripcion_producto, p_tipo_producto_id, p_esta_activo, p_cantidad_stock);

    -- Paso 3: Obtener el ID que la base de datos acaba de generar para el nuevo producto
    SET v_id_generado = LAST_INSERT_ID();

    -- Paso 4: Insertar los detalles específicos de la pizza en la tabla 'Pizza'
    -- 'id_pizza' es la clave primaria de la tabla Pizza y se relaciona con id_producto
    INSERT INTO Pizza (id_pizza, instrucciones_preparacion)
    VALUES (v_id_generado, p_instrucciones_preparacion);

    -- Paso 5: Insertar el precio vigente del producto en la tabla 'Precio_Vigente_Producto'
    -- Se usan las fechas de inicio y fin
    INSERT INTO Precio_Vigente_Producto (producto_id_precio, precio_base, fecha_inicio_vigencia, fecha_fin_vigencia)
    VALUES (v_id_generado, p_precio_base, v_fecha_actual, v_fecha_fin_por_defecto);

    -- Paso 6: Procesar la lista de IDs de ingredientes e insertarlos en 'Pizza_Ingrediente_Base'
    -- Se asume que 'p_ids_ingredientes' es una cadena como "ID1,ID2,ID3".

    -- Limpiar la cadena: si termina en una coma, la eliminamos para evitar problemas en el parseo
    IF RIGHT(p_ids_ingredientes, 1) = ',' THEN
        SET p_ids_ingredientes = LEFT(p_ids_ingredientes, LENGTH(p_ids_ingredientes) - 1);
    END IF;

    -- Encontrar la posición de la primera coma para iniciar el bucle de parseo
    SET v_next_comma = LOCATE(',', p_ids_ingredientes);

    -- Bucle para procesar cada ID de ingrediente
    WHILE v_pos > 0 DO
        IF v_next_comma = 0 THEN
            -- Si no hay más comas, es el último o único ID
            SET v_current_id_str = SUBSTRING(p_ids_ingredientes, v_pos);
            SET v_pos = 0; -- Salir del bucle después de esta iteración
        ELSE
            SET v_current_id_str = SUBSTRING(p_ids_ingredientes, v_pos, v_next_comma - v_pos);
            -- Movemos la posición de inicio para la siguiente iteración
            SET v_pos = v_next_comma + 1;
            SET v_next_comma = LOCATE(',', p_ids_ingredientes, v_pos);
        END IF;

        -- Convertir el ID de ingrediente de texto a número entero
        SET v_ingrediente_id = CAST(v_current_id_str AS UNSIGNED);

        -- Insertar la relación entre la pizza y el ingrediente en la tabla 'Pizza_Ingrediente_Base'
        INSERT INTO Pizza_Ingrediente_Base (pizza_id, ingrediente_id)
        VALUES (v_id_generado, v_ingrediente_id);

    END WHILE;

    -- Paso 7: Confirmar la transacción
    COMMIT;

END $$
DELIMITER ;

-- Ejemplo de uso del procedimiento:
-- Este ejemplo inserta una nueva pizza llamada "Pizza Clásica Hawaiana"
-- con su descripción, precio, stock y los ingredientes 7 (Jamón) y 8 (Piña).
CALL ps_add_pizza_con_ingredientes(
    'Pizza Clásica Hawaiana',          -- p_nombre_producto
    'Una deliciosa pizza con jamón y piña, un clásico tropical.', -- p_descripcion_producto
    1,                                 -- p_tipo_producto_id (1 para Pizza)
    TRUE,                              -- p_esta_activo (1)
    100,                               -- p_cantidad_stock
    'Horno a 200C por 15 minutos, hasta que el queso esté dorado.', -- p_instrucciones_preparacion
    28.50,                             -- p_precio_base
    '7,8'                              -- p_ids_ingredientes (IDs para Jamón y Piña)
);

SELECT * FROM Producto;
SELECT * FROM Pizza;
SELECT * FROM Pizza_Ingrediente_Base;
SELECT * FROM Precio_Vigente_Producto;

--

--1. **`ps_actualizar_precio_pizza`**
--    Procedimiento que reciba `p_pizza_id` y `p_nuevo_precio` y actualice el precio.
--    - Antes de actualizar, valide con un `IF` que el nuevo precio sea mayor que 0; de lo contrario, lance un `SIGNAL`.

-- Nuevo procedimiento: ps_actualizar_precio_pizza
-- Descripción: Actualiza el precio de una pizza finalizando la vigencia del precio actual
--              e insertando un nuevo registro de precio con vigencia a partir de hoy.
-- Parámetros de entrada:
--   p_pizza_id INT: El ID de la pizza cuyo precio se va a actualizar.
--   p_nuevo_precio DECIMAL(10,2): El nuevo precio para la pizza.
DROP PROCEDURE IF EXISTS ps_actualizar_precio_pizza;
DELIMITER $$


CREATE PROCEDURE ps_actualizar_precio_pizza (
    IN p_pizza_id INT,
    IN p_nuevo_precio DECIMAL(10, 2)
)
BEGIN
    DECLARE v_fecha_actual DATE;
    DECLARE v_fecha_fin_por_defecto DATE;

    -- Obtener la fecha actual para la vigencia
    SET v_fecha_actual = CURDATE();
    -- Usar la misma fecha de fin por defecto consistente
    SET v_fecha_fin_por_defecto = '9999-12-31';

    -- Paso 1: Validar que el nuevo precio sea mayor que 0
    IF p_nuevo_precio <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El nuevo precio debe ser mayor que 0.';
    END IF;

    START TRANSACTION;

    -- Paso 2: Finalizar la vigencia del precio actual de la pizza
    -- Se actualiza la fecha_fin_vigencia del precio que estaba activo (con fecha_fin_vigencia en el futuro)
    UPDATE Precio_Vigente_Producto
    SET fecha_fin_vigencia = v_fecha_actual
    WHERE producto_id_precio = p_pizza_id
    AND fecha_fin_vigencia = v_fecha_fin_por_defecto; -- Asumiendo que el precio activo tiene la fecha_fin_por_defecto

    -- Paso 3: Insertar el nuevo precio con vigencia a partir de hoy
    INSERT INTO Precio_Vigente_Producto (producto_id_precio, precio_base, fecha_inicio_vigencia, fecha_fin_vigencia)
    VALUES (p_pizza_id, p_nuevo_precio, v_fecha_actual, v_fecha_fin_por_defecto);

    COMMIT;

END $$
DELIMITER ;

-- EJEMPLO de uso del procedimiento ps_actualizar_precio_pizza:
-- Actualizar el precio de la pizza con ID 1 a 10.00.
-- Asegúrate de que exista una pizza con el ID 1 para que este ejemplo funcione.
CALL ps_actualizar_precio_pizza(1, 10.00);
SELECT * FROM Precio_Vigente_Producto;

-- -- **`ps_generar_pedido`** *(**usar TRANSACTION**)*
-- Procedimiento que reciba:

-- - `p_cliente_id`,
-- - una lista de pizzas y cantidades (`p_items`),
-- - `p_metodo_pago_id`.
--   **Dentro de una transacción**:

-- 1. Inserta en `pedido`.
-- 2. Para cada ítem, inserta en `detalle_pedido` y en `detalle_pedido_pizza`.
-- 3. Si todo va bien, hace `COMMIT`; si falla, `ROLLBACK` y devuelve un mensaje de error.
DROP PROCEDURE IF EXISTS ps_generar_pedido;


DELIMITER $$

-- Procedimiento: ps_generar_pedido
-- Descripción: Genera un nuevo pedido insertando un registro en la tabla 'Pedidos'.
--              Este procedimiento no maneja detalles de ítems individuales ni stock de productos.
-- Parámetros de entrada:
--   p_cliente_id INT: El ID del cliente que realiza el pedido.
--   p_metodo_pago_id INT: El ID del método de pago utilizado.
--   p_total_pedido DECIMAL(10, 2): El monto total del pedido.
--   p_instrucciones_especiales_cliente TEXT: Instrucciones adicionales del cliente para el pedido.
CREATE PROCEDURE ps_generar_pedido (
    IN p_cliente_id INT,
    IN p_metodo_pago_id INT,
    IN p_total_pedido DECIMAL(10, 2),
    IN p_instrucciones_especiales_cliente TEXT
)
BEGIN
    -- Declaración de variables locales
    DECLARE v_estado_pedido_inicial_id INT DEFAULT 1; -- Asumimos 'Pendiente' es el ID 1
    DECLARE v_hora_recogida_estimada TIME;
    DECLARE v_fecha_hora_pedido TIMESTAMP;

    -- Capturamos la fecha y hora actual del pedido
    SET v_fecha_hora_pedido = NOW();
    -- Calculamos una hora estimada de recogida (ej. 30 minutos después de la hora actual)
    SET v_hora_recogida_estimada = ADDTIME(CURRENT_TIME(), '00:30:00');

    -- ¡NINGUNA VALIDACIÓN EXPLÍCITA DENTRO DEL PROCEDIMIENTO!
    -- Cualquier error (ej. claves foráneas no existentes) será un error directo de MySQL.

    START TRANSACTION;

    -- Paso 1: Insertar el nuevo pedido en la tabla Pedidos
    INSERT INTO Pedidos (
        cliente_id_pedido,
        fecha_hora_pedido,
        hora_recogida_estimada,
        metodo_pago_id,
        total_pedido,
        estado_pedido_id,
        pago_confirmado,
        instrucciones_especiales_cliente
    )
    VALUES (
        p_cliente_id,
        v_fecha_hora_pedido,
        v_hora_recogida_estimada,
        p_metodo_pago_id,
        p_total_pedido, -- Se usa el total de pedido proporcionado como parámetro
        v_estado_pedido_inicial_id,
        FALSE, -- Por defecto, el pago no está confirmado al crear el pedido
        p_instrucciones_especiales_cliente
    );

    COMMIT;

    -- Opcional: Mostrar un mensaje de éxito con el ID del pedido generado
    SELECT CONCAT('Pedido #', LAST_INSERT_ID(), ' creado exitosamente para el Cliente ID ', p_cliente_id, '. Total: ', p_total_pedido) AS Mensaje;

END $$
DELIMITER ;

-- EJEMPLO: Generar un pedido (usando solo la tabla Pedidos)
-- Asegúrate de que los IDs de cliente y método de pago existan en tu base de datos.
CALL ps_generar_pedido(
    1,                                      -- p_cliente_id: ID del cliente (ej. 1).
    1,                                      -- p_metodo_pago_id: ID del método de pago (ej. 1).
    42.50,                                  -- p_total_pedido: El total calculado manualmente o desde otra fuente.
    'Entregar en la entrada principal, tocar timbre dos veces.' -- p_instrucciones_especiales_cliente.
);

SELECT * FROM Pedidos;

-- **`ps_cancelar_pedido`**
-- Recibe `p_pedido_id` y:

-- - Marca el pedido como “cancelado” (p. ej. actualiza un campo `estado`),
-- - Elimina todas sus líneas de detalle (`DELETE FROM detalle_pedido WHERE pedido_id = …`).
-- - Devuelve el número de líneas eliminadas.
DROP PROCEDURE IF EXISTS ps_cancelar_pedido;


DELIMITER $$

CREATE PROCEDURE ps_cancelar_pedido (
    IN p_pedido_id INT
)
BEGIN
    DECLARE v_lineas_detalle INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en la transacción. No se pudo cancelar el pedido.' AS Mensaje;
    END;

    START TRANSACTION;

    -- 1. Devolver stock de productos
    UPDATE Producto p
    JOIN (
        SELECT producto_id_detalle, SUM(cantidad) AS cantidad_total
        FROM Detalles_Pedido
        WHERE pedido_id_detalle = p_pedido_id
        GROUP BY producto_id_detalle
    ) x ON p.id_producto = x.producto_id_detalle
    SET p.cantidad_stock = p.cantidad_stock + x.cantidad_total;

    -- 2. (Opcional) Devolver stock de ingredientes extra si aplica
    /*
    UPDATE Ingrediente i
    JOIN (
        SELECT dpi.ingrediente_id_detalle, SUM(dpi.cantidad_extra) AS cantidad_total
        FROM Detalle_Pedido_Ingrediente_Extra dpi
        JOIN Detalles_Pedido dp ON dpi.detalle_pedido_id = dp.id_detalle_pedido
        WHERE dp.pedido_id_detalle = p_pedido_id
        GROUP BY dpi.ingrediente_id_detalle
    ) x ON i.id_ingrediente = x.ingrediente_id_detalle
    SET i.cantidad_stock = i.cantidad_stock + x.cantidad_total;
    */

    -- 3. Contar detalles antes de borrar
    SELECT COUNT(*) INTO v_lineas_detalle FROM Detalles_Pedido WHERE pedido_id_detalle = p_pedido_id;

    -- 4. Borrar el pedido (todo lo relacionado se borra en cascada)
    DELETE FROM Pedidos WHERE id_pedido = p_pedido_id;

    COMMIT;

    SELECT CONCAT('Pedido ', p_pedido_id, ' cancelado. Se eliminaron ', v_lineas_detalle, ' líneas de detalle.') AS Mensaje;
END $$

DELIMITER ;

CALL ps_cancelar_pedido(1);

SELECT * FROM `Pedidos`;

-- **`ps_facturar_pedido`**
-- Crea la factura asociada a un pedido dado (`p_pedido_id`). Debe:

-- - Calcular el total sumando precios de pizzas × cantidad,
-- - Insertar en `factura`.
-- - Devolver el `factura_id` generado.

DROP PROCEDURE IF EXISTS ps_facturar_pedido;
DELIMITER $$

CREATE PROCEDURE ps_facturar_pedido (
    IN p_pedido_id INT
)
BEGIN
    -- Declaración de variables
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_impuestos DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_id_factura INT;
    DECLARE v_cliente_id INT;
    DECLARE v_numero_factura VARCHAR(50);
    DECLARE v_fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    DECLARE v_estado_factura VARCHAR(50) DEFAULT 'Emitida';
    DECLARE v_pedido_existe INT DEFAULT 0;

    -- 1. Verificar si ya existe una factura para este pedido
    SELECT id_factura
      INTO v_id_factura
      FROM Facturacion
     WHERE pedido_id_factura = p_pedido_id
     LIMIT 1;

    IF v_id_factura IS NOT NULL THEN
        -- Ya existe una factura, mostrar datos de la factura y los datos del cliente al lado del id_cliente
        SELECT
            f.cliente_id_factura,
            c.nombres_cliente,
            c.apellidos_cliente,
            f.id_factura,
            f.pedido_id_factura,
            f.numero_factura,
            f.fecha_emision,
            f.subtotal_productos,
            f.impuestos,
            f.estado_factura,
            f.total_factura
        FROM Facturacion f
        JOIN Cliente c ON f.cliente_id_factura = c.id_cliente
        WHERE f.pedido_id_factura = p_pedido_id;
    ELSE
        -- 2. Verificar que el pedido existe
        SELECT COUNT(*)
          INTO v_pedido_existe
          FROM Pedidos
         WHERE id_pedido = p_pedido_id;

        IF v_pedido_existe = 0 THEN
            SIGNAL SQLSTATE '45001'
            SET MESSAGE_TEXT = 'No existe un pedido con ese ID.';
        END IF;

        -- 3. Calcular el subtotal sumando los subtotales de los detalles del pedido
        SELECT SUM(subtotal_linea)
          INTO v_subtotal
          FROM Detalles_Pedido
         WHERE pedido_id_detalle = p_pedido_id;

        IF v_subtotal IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El pedido no tiene detalles y no puede facturarse.';
        END IF;

        -- 4. Calcular los impuestos y el total
        SET v_impuestos = ROUND(v_subtotal * 0.19, 2);
        SET v_total = v_subtotal + v_impuestos;

        -- 5. Obtener el id del cliente
        SELECT cliente_id_pedido
          INTO v_cliente_id
          FROM Pedidos
         WHERE id_pedido = p_pedido_id;

        -- 6. Generar número de factura
        SET v_numero_factura = UUID();

        -- 7. Insertar la factura en la tabla Facturacion
        INSERT INTO Facturacion (
            pedido_id_factura,
            cliente_id_factura,
            numero_factura,
            fecha_emision,
            subtotal_productos,
            impuestos,
            estado_factura,
            total_factura
        ) VALUES (
            p_pedido_id,
            v_cliente_id,
            v_numero_factura,
            v_fecha,
            v_subtotal,
            v_impuestos,
            v_estado_factura,
            v_total
        );

        SET v_id_factura = LAST_INSERT_ID();

        -- 8. Mostrar la factura recién creada junto con los datos del cliente al lado del id_cliente
        SELECT
            f.cliente_id_factura,
            c.nombres_cliente,
            c.apellidos_cliente,
            f.id_factura,
            f.pedido_id_factura,
            f.numero_factura,
            f.fecha_emision,
            f.subtotal_productos,
            f.impuestos,
            f.estado_factura,
            f.total_factura
        FROM Facturacion f
        JOIN Cliente c ON f.cliente_id_factura = c.id_cliente
        WHERE f.id_factura = v_id_factura;
    END IF;

END $$
DELIMITER ;

CALL ps_facturar_pedido(10);
SELECT * FROM Facturacion;