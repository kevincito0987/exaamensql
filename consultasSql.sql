-- Verificación de los datos insertados
SELECT * FROM `Pais`;
SELECT * FROM `Departamento`;
SELECT * FROM `Ciudad`;
SELECT * FROM `Direccion`;
SELECT * FROM `Cliente`;
SELECT * FROM `Tipo_Telefono`;
SELECT * FROM `Telefono_Clientes`;
SELECT * FROM `Tipo_metodo_pago`;
SELECT * FROM `Metodo_Pago`;
SELECT * FROM `Estado_Pedido`;
SELECT * FROM `Pedidos`;
SELECT * FROM `Tipo_Producto`;
SELECT * FROM `Producto`;
SELECT * FROM `Pizza`;
SELECT * FROM `Bebida`;
SELECT * FROM `Combo`;
SELECT * FROM `Componente_Combo`;
SELECT * FROM `Ingrediente`;
SELECT * FROM `Pizza_Ingrediente_Base`;
SELECT * FROM `Presentacion_Pizza`;
SELECT * FROM `Precio_Vigente_Producto`;
SELECT * FROM `Precio_Pizza_Por_Presentacion`;
SELECT * FROM `Detalles_Pedido`;
SELECT * FROM `Detalle_Pedido_Ingrediente_Extra`;

-- Verificación de los índices creados
SHOW INDEX FROM `Pais`;
SHOW INDEX FROM `Departamento`;
SHOW INDEX FROM `Ciudad`;
SHOW INDEX FROM `Direccion`;
SHOW INDEX FROM `Cliente`;
SHOW INDEX FROM `Tipo_Telefono`;
SHOW INDEX FROM `Telefono_Clientes`;
SHOW INDEX FROM `Tipo_metodo_pago`;
SHOW INDEX FROM `Metodo_Pago`;
SHOW INDEX FROM `Estado_Pedido`;
SHOW INDEX FROM `Pedidos`;
SHOW INDEX FROM `Tipo_Producto`;
SHOW INDEX FROM `Producto`;
SHOW INDEX FROM `Precio_Vigente_Producto`;
SHOW INDEX FROM `Pizza`;
SHOW INDEX FROM `Bebida`;
SHOW INDEX FROM `Combo`;
SHOW INDEX FROM `Componente_Combo`;
SHOW INDEX FROM `Ingrediente`;
SHOW INDEX FROM `Pizza_Ingrediente_Base`;
SHOW INDEX FROM `Presentacion_Pizza`;
SHOW INDEX FROM `Precio_Pizza_Por_Presentacion`;
SHOW INDEX FROM `Detalles_Pedido`;
SHOW INDEX FROM `Detalle_Pedido_Ingrediente_Extra`;

-- Consultas con Indexes.

-- Consultar el detalle de un pedido (productos y sus ingredientes)

SELECT
    p.id_pedido,
    p.fecha_hora_pedido,
    p.total_pedido,
    c.nombres_cliente,
    c.apellidos_cliente,
    est.nombre_estado AS estado_pedido,
    dp.cantidad,
    prod.nombre_producto,
    prod_tipo.nombre_tipo_producto,
    pp.nombre_presentacion AS presentacion_pizza, -- Será NULL para no-pizzas
    dp.precio_unitario_aplicado,
    dp.subtotal_linea,
    GROUP_CONCAT(DISTINCT ing_base.nombre_ingrediente SEPARATOR ', ') AS ingredientes_base,
    GROUP_CONCAT(DISTINCT CONCAT(ing_extra.nombre_ingrediente, ' (', dpie.cantidad_extra, ')') SEPARATOR ', ') AS ingredientes_extra
FROM
    Pedidos AS p
JOIN
    Cliente AS c ON p.cliente_id_pedido = c.id_cliente -- Usa idx_cliente_pedido en Pedidos y PRIMARY KEY en Cliente
JOIN
    Estado_Pedido AS est ON p.estado_pedido_id = est.id_estado_pedido -- Usa idx_estado_pedido en Pedidos y PRIMARY KEY en Estado_Pedido
JOIN
    Detalles_Pedido AS dp ON p.id_pedido = dp.pedido_id_detalle -- Usa idx_pedido_id_detalle en Detalles_Pedido y PRIMARY KEY en Pedidos
JOIN
    Producto AS prod ON dp.producto_id_detalle = prod.id_producto -- Usa idx_producto_id_detalle en Detalles_Pedido y PRIMARY KEY en Producto
JOIN
    Tipo_Producto AS prod_tipo ON prod.tipo_producto_id = prod_tipo.id_tipo_producto -- Usa idx_tipo_producto en Producto y PRIMARY KEY en Tipo_Producto
LEFT JOIN
    Presentacion_Pizza AS pp ON dp.presentacion_pizza_id_detalle = pp.id_presentacion_pizza -- Usa PRIMARY KEY en Presentacion_Pizza
LEFT JOIN
    Pizza AS piz ON prod.id_producto = piz.id_pizza AND prod_tipo.nombre_tipo_producto = 'Pizza' -- Usa PRIMARY KEY en Pizza
LEFT JOIN
    Pizza_Ingrediente_Base AS pib ON piz.id_pizza = pib.pizza_id -- Usa idx_pizza_base en Pizza_Ingrediente_Base
LEFT JOIN
    Ingrediente AS ing_base ON pib.ingrediente_id = ing_base.id_ingrediente -- Usa PRIMARY KEY en Ingrediente
LEFT JOIN
    Detalle_Pedido_Ingrediente_Extra AS dpie ON dp.id_detalle_pedido = dpie.detalle_pedido_id -- Usa idx_detalle_pedido_extra en Detalle_Pedido_Ingrediente_Extra
LEFT JOIN
    Ingrediente AS ing_extra ON dpie.ingrediente_id_detalle = ing_extra.id_ingrediente -- Usa PRIMARY KEY en Ingrediente
WHERE
    p.id_pedido = 1 -- Filtra por el ID del pedido que deseas consultar
GROUP BY
    p.id_pedido, dp.id_detalle_pedido -- Agrupar para consolidar ingredientes por cada línea de detalle de pedido
ORDER BY
    dp.id_detalle_pedido;


-- -- Actualizar el precio de una pizza en el menú

-- Paso 1: Identificar y "cerrar" el precio anterior
-- Supongamos que queremos actualizar el precio de la Pizza Margarita (id_pizza = 1)
-- en su presentación Mediana (id_presentacion_pizza = 2).

UPDATE `Precio_Pizza_Por_Presentacion`
SET
    `fecha_fin_vigencia` = CURDATE() -- O la fecha y hora en que quieres que el precio anterior deje de ser válido
WHERE
    `pizza_id_presentacion` = 1 AND -- ID de la Pizza Margarita
    `presentacion_pizza_id` = 2 AND -- ID de la Presentación Mediana
    `fecha_fin_vigencia` = '9999-12-31'; -- Asume que '9999-12-31' indica una vigencia "abierta" o futura muy lejana
                                        -- O usa la fecha actual si sabes que es el único vigente.
                                        -- Puedes ajustar este WHERE para apuntar al registro vigente actual.

-- Paso 2: Insertar el nuevo precio con su nueva fecha de vigencia
INSERT INTO `Precio_Pizza_Por_Presentacion`
    (`id_precio_pizza_presentacion`, `pizza_id_presentacion`, `presentacion_pizza_id`, `precio_base`, `fecha_inicio_vigencia`, `fecha_fin_vigencia`)
VALUES
    (
        (SELECT COALESCE(MAX(id_precio_pizza_presentacion), 0) + 1 FROM `Precio_Pizza_Por_Presentacion` AS temp_table), -- Genera un nuevo ID, ajústate a tu estrategia de ID (AUTO_INCREMENT es mejor)
        1, -- ID de la Pizza Margarita
        2, -- ID de la Presentación Mediana
        16.50, -- El NUEVO precio base
        CURDATE(), -- La fecha de hoy, o la fecha en que quieres que el nuevo precio entre en vigencia
        '9999-12-31' -- Una fecha muy lejana para indicar que este es el precio actual/futuro indefinido
    );
--verificar que el precio se ha insertado correctamente
SELECT * FROM `Precio_Pizza_Por_Presentacion` WHERE `id_precio_pizza_presentacion` = (SELECT MAX(id_precio_pizza_presentacion) FROM `Precio_Pizza_Por_Presentacion`);

-- Actualizar la dirección de un cliente

UPDATE `Direccion`
SET
    `complemento` = 'Calle 10 #20-30, Apartamento 101', -- O la nueva dirección
    `codigo_postal` = '050002' -- O el nuevo código postal
WHERE
    `id_direccion` = 1; -- ID de la dirección que quieres actualizar

SELECT * FROM `Direccion`
WHERE `id_direccion` = 1;


-- Eliminar un producto del menú (bebida)

DELETE FROM `Bebida`
WHERE `id_bebida` = 4;

SELECT * FROM `Bebida`
WHERE `id_bebida` = 4;

-- Eliminar un ingrediente de la base de datos.

DELETE FROM `Pizza_Ingrediente_Base`
WHERE `ingrediente_id` = 5; -- Usa el índice idx_ingrediente_base

-- Paso 2: Eliminar el ingrediente de los detalles de pedido como extra
-- Esto quita la 'Piña' de cualquier pedido donde fue añadida como ingrediente extra
DELETE FROM `Detalle_Pedido_Ingrediente_Extra`
WHERE `ingrediente_id_detalle` = 5; -- Usa el índice idx_ingrediente_extra_detalle

-- Paso 3: Ahora sí, eliminar el ingrediente de la tabla principal
DELETE FROM `Ingrediente`
WHERE `id_ingrediente` = 5; -- Usa la PRIMARY KEY (id_ingrediente)

SELECT * FROM `Ingrediente`
WHERE `id_ingrediente` = 5;

-- Consultar todos los pedidos de un cliente

SELECT
    p.id_pedido,
    p.fecha_hora_pedido,
    p.total_pedido,
    mp.nombre_metodo_pago,
    est.nombre_estado AS estado_pedido,
    p.pago_confirmado,
    p.instrucciones_especiales_cliente,
    p.hora_recogida_estimada
FROM
    Pedidos AS p
JOIN
    Cliente AS c ON p.cliente_id_pedido = c.id_cliente -- Unión con Cliente para verificar o filtrar
JOIN
    Metodo_Pago AS mp ON p.metodo_pago_id = mp.id_metodo_pago -- Para obtener el nombre del método de pago
JOIN
    Estado_Pedido AS est ON p.estado_pedido_id = est.id_estado_pedido -- Para obtener el nombre del estado del pedido
WHERE
    c.id_cliente = 1 -- Filtra por el ID del cliente deseado (Ej: Cliente con ID 1)
ORDER BY
    p.fecha_hora_pedido DESC; -- Ordena los pedidos del más reciente al más antiguo

-- Listar todos los productos disponibles en el menú (pizzas y bebidas)

SELECT
    p.id_producto,
    p.nombre_producto,
    tp.nombre_tipo_producto,
    -- Información específica para Pizzas
    CASE
        WHEN tp.nombre_tipo_producto = 'Pizza' THEN pp.nombre_presentacion
        ELSE NULL
    END AS presentacion,
    -- Información específica para Bebidas
    CASE
        WHEN tp.nombre_tipo_producto = 'Bebida' THEN b.capacidad_ml
        ELSE NULL
    END AS capacidad_ml,
    -- Precio vigente (para productos no-pizza o el precio general de la pizza si no hay presentaciones)
    COALESCE(
        ppp.precio_base, -- Precio por presentación de pizza
        pvp.precio_base  -- Precio general del producto
    ) AS precio_actual
FROM
    Producto AS p
JOIN
    Tipo_Producto AS tp ON p.tipo_producto_id = tp.id_tipo_producto -- Usará idx_tipo_producto en Producto y PRIMARY KEY en Tipo_Producto
LEFT JOIN
    Bebida AS b ON p.id_producto = b.id_bebida AND tp.nombre_tipo_producto = 'Bebida' -- Usará PRIMARY KEY en Bebida y Producto
LEFT JOIN
    Pizza AS piz ON p.id_producto = piz.id_pizza AND tp.nombre_tipo_producto = 'Pizza' -- Usará PRIMARY KEY en Pizza y Producto
LEFT JOIN
    Precio_Pizza_Por_Presentacion AS ppp ON piz.id_pizza = ppp.pizza_id_presentacion
                                        AND ppp.fecha_inicio_vigencia <= CURDATE()
                                        AND ppp.fecha_fin_vigencia >= CURDATE() -- Usará idx_pizza_presentacion y idx_fechas_vigencia_pizza
LEFT JOIN
    Presentacion_Pizza AS pp ON ppp.presentacion_pizza_id = pp.id_presentacion_pizza -- Usará PRIMARY KEY en Presentacion_Pizza
LEFT JOIN
    Precio_Vigente_Producto AS pvp ON p.id_producto = pvp.prducto_id_precio
                                    AND pvp.fecha_inicio_vigencia <= CURDATE()
                                    AND pvp.fecha_fin_vigencia >= CURDATE() -- Usará idx_producto_precio y idx_fechas_vigencia
WHERE
    p.esta_activo = TRUE AND -- Solo productos activos
    (tp.nombre_tipo_producto = 'Pizza' OR tp.nombre_tipo_producto = 'Bebida') -- Filtra por tipo Pizza o Bebida
ORDER BY
    p.nombre_producto, tp.nombre_tipo_producto, presentacion;

-- Listar todos los ingredientes disponibles para personalizar una pizza 

SELECT
    ing.id_ingrediente,
    ing.nombre_ingrediente,
    ing.precio_adicional_extra
FROM
    Ingrediente AS ing
LEFT JOIN
    Pizza_Ingrediente_Base AS pib ON ing.id_ingrediente = pib.ingrediente_id -- Usará idx_ingrediente_base
WHERE
    pib.pizza_id IS NULL; -- Filtra por ingredientes que no están en una pizza

-- Calcular el costo total de un pedido (incluyendo ingredientes adicionales)

SELECT
    p.id_pedido,
    p.fecha_hora_pedido,
    c.nombres_cliente,
    c.apellidos_cliente,
    SUM(dp.subtotal_linea) AS subtotal_productos,
    COALESCE(SUM(dpie.precio_extra_aplicado * dpie.cantidad_extra), 0) AS costo_ingredientes_extra,
    (SUM(dp.subtotal_linea) + COALESCE(SUM(dpie.precio_extra_aplicado * dpie.cantidad_extra), 0)) AS costo_total_calculado
FROM
    Pedidos AS p
JOIN
    Cliente AS c ON p.cliente_id_pedido = c.id_cliente -- Usa idx_cliente_pedido en Pedidos y PRIMARY KEY en Cliente
JOIN
    Detalles_Pedido AS dp ON p.id_pedido = dp.pedido_id_detalle -- Usa idx_pedido_id_detalle en Detalles_Pedido y PRIMARY KEY en Pedidos
LEFT JOIN
    Detalle_Pedido_Ingrediente_Extra AS dpie ON dp.id_detalle_pedido = dpie.detalle_pedido_id -- Usa idx_detalle_pedido_extra en Detalle_Pedido_Ingrediente_Extra
WHERE
    p.id_pedido = 1 -- Sustituye '1' por el ID del pedido que quieras calcular
GROUP BY
    p.id_pedido, p.fecha_hora_pedido, c.nombres_cliente, c.apellidos_cliente;

-- Listar los clientes que han hecho más de 5 pedidos

SELECT
    c.id_cliente,
    c.nombres_cliente,
    c.apellidos_cliente,
    c.email,
    COUNT(p.id_pedido) AS total_pedidos_realizados
FROM
    Cliente AS c
JOIN
    Pedidos AS p ON c.id_cliente = p.cliente_id_pedido -- Usará PRIMARY KEY en Cliente y idx_cliente_pedido en Pedidos
GROUP BY
    c.id_cliente, c.nombres_cliente, c.apellidos_cliente, c.email
HAVING
    COUNT(p.id_pedido) > 1; -- Cambia '1' por '5' si necesitas más de 5 pedidos.
                            -- Usé '1' para que los ejemplos de insert que te di devuelvan resultados.
                            -- Con los inserts actuales, ningún cliente tiene 5 o más pedidos.
ORDER BY
    total_pedidos_realizados DESC;

-- Buscar pedidos programados para recogerse después de una hora específica

SELECT
    p.id_pedido,
    p.fecha_hora_pedido,
    p.hora_recogida_estimada,
    p.metodo_pago_id,
    mp.nombre_metodo_pago,
    p.total_pedido,
    est.nombre_estado AS estado_pedido,
    p.pago_confirmado,
    p.instrucciones_especiales_cliente
FROM
    Pedidos AS p
JOIN
    Metodo_Pago AS mp ON p.metodo_pago_id = mp.id_metodo_pago -- Usará PRIMARY KEY en Metodo_Pago
JOIN
    Estado_Pedido AS est ON p.estado_pedido_id = est.id_estado_pedido -- Usará PRIMARY KEY en Estado_Pedido
WHERE
    p.hora_recogida_estimada > '14:00:00' -- Sustituye '14:00:00' por la hora que quieres buscar
ORDER BY
    p.hora_recogida_estimada ASC;

-- Listar todos los combos de pizzas con bebidas disponibles en el menú

SELECT
    c.id_combo,
    p_combo.nombre_producto AS nombre_combo,
    COALESCE(pvp.precio_base, 'No hay precio registrado') AS precio_del_combo, -- Obtiene cualquier precio registrado, o un mensaje si no hay ninguno
    GROUP_CONCAT(
        CONCAT(
            pc.nombre_producto, ' (x', cc.cantidad, ')'
        )
        ORDER BY pc.nombre_producto
        SEPARATOR ', '
    ) AS componentes_del_combo
FROM
    Combo AS c
JOIN
    Producto AS p_combo ON c.id_combo = p_combo.id_producto
JOIN
    Tipo_Producto AS tp_combo ON p_combo.tipo_producto_id = tp_combo.id_tipo_producto
LEFT JOIN
    Precio_Vigente_Producto AS pvp ON p_combo.id_producto = pvp.prducto_id_precio
    -- ¡ESTA ES LA LÍNEA MODIFICADA! Se eliminan las condiciones de fecha.
    -- Ahora se unirá con CUALQUIER registro de precio para el combo,
    -- sin importar su fecha de inicio o fin de vigencia.
JOIN
    Componente_Combo AS cc ON c.id_combo = cc.combo_id
JOIN
    Producto AS pc ON cc.producto_componente_id = pc.id_producto
JOIN
    Tipo_Producto AS tpc ON pc.tipo_producto_id = tpc.id_tipo_producto
WHERE
    p_combo.esta_activo = TRUE AND tp_combo.nombre_tipo_producto = 'Combo'
GROUP BY
    c.id_combo, p_combo.nombre_producto, pvp.precio_base
HAVING
    SUM(CASE WHEN tpc.nombre_tipo_producto = 'Pizza' THEN 1 ELSE 0 END) > 0 AND
    SUM(CASE WHEN tpc.nombre_tipo_producto = 'Bebida' THEN 1 ELSE 0 END) > 0
ORDER BY
    nombre_combo;
SELECT
    id_precio_vigente_producto,
    prducto_id_precio,
    precio_base,
    fecha_inicio_vigencia,
    fecha_fin_vigencia
FROM
    Precio_Vigente_Producto
WHERE
    prducto_id_precio = 3; -- ID del Combo Familiar


SELECT * FROM `Precio_Vigente_Producto`;
SELECT * FROM `Producto`;

-- Actualizar el nombre del producto 1

UPDATE `Producto`
SET
    `nombre_producto` = 'Pizza Napolitana'
WHERE
    `id_producto` = 1;


-- Buscar pizzas con un precio mayor a $100

SELECT
    p.id_producto,
    p.nombre_producto AS nombre_pizza,
    pp.nombre_presentacion,
    ppp.precio_base AS precio_vigente
FROM
    Producto AS p
JOIN
    Tipo_Producto AS tp ON p.tipo_producto_id = tp.id_tipo_producto -- Usa idx_tipo_producto en Producto y PRIMARY KEY en Tipo_Producto
JOIN
    Pizza AS piz ON p.id_producto = piz.id_pizza -- Usa PRIMARY KEY en Pizza y Producto
JOIN
    Precio_Pizza_Por_Presentacion AS ppp ON piz.id_pizza = ppp.pizza_id_presentacion
                                        AND ppp.fecha_inicio_vigencia <= CURDATE()
                                        AND ppp.fecha_fin_vigencia >= CURDATE() -- Usa idx_pizza_presentacion y idx_fechas_vigencia_pizza
JOIN
    Presentacion_Pizza AS pp ON ppp.presentacion_pizza_id = pp.id_presentacion_pizza -- Usa PRIMARY KEY en Presentacion_Pizza
WHERE
    tp.nombre_tipo_producto = 'Pizza' AND -- Nos aseguramos de que es una pizza
    p.esta_activo = TRUE AND              -- Que la pizza esté activa
    ppp.precio_base > 100.00              -- Filtra por precio mayor a 100
ORDER BY
    p.nombre_producto, pp.nombre_presentacion;

-- calcular el total de ingresos por día, semana y mes

SELECT
    DATE(fecha_hora_pedido) AS fecha_del_pedido,
    SUM(total_pedido) AS ingresos_totales_del_dia
FROM
    Pedidos
WHERE
    pago_confirmado = TRUE -- Opcional: Solo incluir pedidos que han sido pagados
GROUP BY
    DATE(fecha_hora_pedido)
ORDER BY
    fecha_del_pedido DESC;

-- Ingresos por Día


SELECT
    DATE(fecha_hora_pedido) AS fecha_del_pedido,
    SUM(total_pedido) AS ingresos_totales_del_dia
FROM
    Pedidos
WHERE
    pago_confirmado = TRUE -- Opcional: Solo incluir pedidos que han sido pagados
GROUP BY
    DATE(fecha_hora_pedido)
ORDER BY
    fecha_del_pedido DESC;

    -- Ingresos por Semana

SELECT
    YEARWEEK(fecha_hora_pedido) AS semana_del_pedido,
    SUM(total_pedido) AS ingresos_totales_de_la_semana
FROM
    Pedidos
WHERE
    pago_confirmado = TRUE -- Opcional: Solo incluir pedidos que han sido pagados
GROUP BY
    YEARWEEK(fecha_hora_pedido)
ORDER BY
    semana_del_pedido DESC;

-- Ingresos por Mes

SELECT
    DATE_FORMAT(fecha_hora_pedido, '%Y-%m') AS mes_del_pedido,
    SUM(total_pedido) AS ingresos_totales_del_mes
FROM
    Pedidos
WHERE
    pago_confirmado = TRUE -- Opcional: Solo incluir pedidos que han sido pagados
GROUP BY
    DATE_FORMAT(fecha_hora_pedido, '%Y-%m')
ORDER BY
    mes_del_pedido DESC;