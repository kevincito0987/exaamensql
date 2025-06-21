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
-- Procedimiento: ps_cancelar_pedido
-- Descripción: Marca un pedido como "cancelado", elimina todas sus líneas de detalle,
--              y devuelve el stock de los productos e ingredientes asociados.
-- Parámetros de entrada:
--   p_pedido_id INT: El ID del pedido que se va a cancelar.
-- Returns:
--   A message indicating the result of the operation and the number of deleted detail lines.
CREATE PROCEDURE ps_cancelar_pedido (
    IN p_pedido_id INT
)
BEGIN
    DECLARE v_lineas_detalles_eliminadas INT DEFAULT 0;
    DECLARE v_lineas_extras_eliminadas INT DEFAULT 0;
    DECLARE v_pedido_cancelado_id INT DEFAULT 6; -- Assuming 'Canceled' has ID 6 in the Estado_Pedido table

    -- Variables for Detalles_Pedido cursor
    DECLARE v_detalle_id INT;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad_detalle INT;

    -- Variables for Detalle_Pedido_Ingrediente_Extra cursor
    DECLARE v_ingrediente_id INT;
    DECLARE v_cantidad_extra INT;

    -- Flag to check if cursor is done
    DECLARE done INT DEFAULT FALSE;

    -- Cursor to iterate over order details
    DECLARE cur_detalles CURSOR FOR
        SELECT id_detalle_pedido, producto_id_detalle, cantidad
        FROM Detalles_Pedido
        WHERE pedido_id_detalle = p_pedido_id;

    -- Cursor to iterate over extra ingredients of the order details
    DECLARE cur_extras CURSOR FOR
        SELECT dpi.ingrediente_id_detalle, dpi.cantidad_extra
        FROM Detalle_Pedido_Ingrediente_Extra dpi
        JOIN Detalles_Pedido dp ON dpi.detalle_pedido_id = dp.id_detalle_pedido
        WHERE dp.pedido_id_detalle = p_pedido_id;

    -- Continue handler for cursors
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Error handler: If any SQL exception occurs, the transaction is rolled back.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la transacción. No se pudo cancelar el pedido o eliminar sus detalles y devolver stock.';
    END;

    START TRANSACTION;

    -- Step 1: Return stock for extra ingredients first (if any)
    OPEN cur_extras;
    SET done = FALSE; -- Reset done flag for the new cursor
    read_extras_loop: LOOP
        FETCH cur_extras INTO v_ingrediente_id, v_cantidad_extra;
        IF done THEN
            LEAVE read_extras_loop;
        END IF;

        -- Update ingredient stock
        UPDATE Ingrediente
        SET cantidad_stock = cantidad_stock + v_cantidad_extra
        WHERE id_ingrediente = v_ingrediente_id;
    END LOOP;
    CLOSE cur_extras;

    -- Delete extra ingredient details associated with this order
    DELETE FROM Detalle_Pedido_Ingrediente_Extra
    WHERE detalle_pedido_id IN (SELECT id_detalle_pedido FROM Detalles_Pedido WHERE pedido_id_detalle = p_pedido_id);
    SET v_lineas_extras_eliminadas = ROW_COUNT();

    -- Step 2: Return product stock and delete detail lines
    OPEN cur_detalles;
    SET done = FALSE; -- Reset done flag for the new cursor
    read_detalles_loop: LOOP
        FETCH cur_detalles INTO v_detalle_id, v_producto_id, v_cantidad_detalle;
        IF done THEN
            LEAVE read_detalles_loop;
        END IF;

        -- Update product stock
        UPDATE Producto
        SET cantidad_stock = cantidad_stock + v_cantidad_detalle
        WHERE id_producto = v_producto_id;

    END LOOP;
    CLOSE cur_detalles;

    -- Delete all detail lines associated with this order
    DELETE FROM Detalles_Pedido
    WHERE pedido_id_detalle = p_pedido_id;
    SET v_lineas_detalles_eliminadas = ROW_COUNT();

    -- Step 3: Update the order status to 'Canceled'
    UPDATE Pedidos
    SET estado_pedido_id = v_pedido_cancelado_id,
        pago_confirmado = FALSE -- Assume payment is not confirmed upon cancellation
    WHERE id_pedido = p_pedido_id;

    COMMIT;

    -- Return a message with the result
    SELECT CONCAT(
        'Pedido ID ', p_pedido_id, ' has been marked as canceled. ',
        'Deleted ', v_lineas_detalles_eliminadas, ' detail lines and ',
        v_lineas_extras_eliminadas, ' extra ingredient lines. ',
        'Product and ingredient stock has been returned.'
    ) AS Mensaje;

END $$
DELIMITER ;

-- EXAMPLE: Cancel an order
-- Replace '1' with an existing order ID you want to cancel.
-- Ensure that the order with ID 1 exists in your 'Pedidos' table and has associated details,
-- and that the products and ingredients in those details have stock in the Producto and Ingrediente tables.
CALL ps_cancelar_pedido(1);
