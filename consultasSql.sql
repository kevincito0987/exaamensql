-- Consultar el detalle de un pedido (productos y sus ingredientes)

SELECT 
    p.id_pedido,
    c.nombre_cliente,
    pi.nombre_pizza,
    i.nombre_ingrediente,
    d.valor_total
FROM 
    Pedidos p
JOIN 
    Cliente c ON p.cliente_id_pedido = c.id_cliente
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
JOIN 
    Combos co ON d.combo_id_detalle = co.id_combo
JOIN 
    Pizza pi ON co.pizza_id_combo = pi.id_pizza
JOIN 
    Ingredientes_Pizza ip ON pi.id_pizza = ip.pizza_id
JOIN 
    Ingredientes i ON ip.ingrediente_id = i.id_ingrediente
WHERE 
    p.id_pedido = 5;

-- Actualizar el precio de una pizza en el menú
ALTER TABLE `Pizza`
ADD COLUMN `valor_pizza` DECIMAL(10,2) NOT NULL AFTER `tamaño_pizza`;
UPDATE `Pizza`
SET `valor_pizza` = 12.00
WHERE `id_pizza` = 3;

SELECT id_pizza, valor_pizza FROM `Pizza`
WHERE id_pizza = 3;

-- Actualizar la dirección de un cliente

UPDATE `Direccion`
SET `complemento` = 'Calle 10 #20-30, Apartamento 101', `codigo_postal` = '050002'
WHERE `id_direccion` = 1;

SELECT * FROM `Direccion`
WHERE `id_direccion` = 1;

-- Eliminar un producto del menú (bebida)

DELETE FROM `Bebidas`
WHERE `id_bebida` = 4;

SELECT * FROM `Bebidas`
WHERE `id_bebida` = 3;

-- Eliminar un ingrediente de la base de datos

DELETE FROM `Ingredientes`
WHERE `id_ingrediente` = 4;

DELETE FROM `Ingredientes_Pizza`
WHERE `ingrediente_id` = 4;

-- Verificar que el ingrediente ha sido eliminado

SELECT * FROM `Ingredientes`
WHERE `id_ingrediente` = 4;

-- Consultar todos los pedidos de un cliente

SELECT 
    p.id_pedido,
    c.nombre_cliente,
    p.hora_pedido,
    d.valor_total
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
JOIN 
    Cliente c ON p.cliente_id_pedido = c.id_cliente
WHERE 
    c.id_cliente = 5;

-- Listar todos los productos disponibles en el menú (pizzas y bebidas)

SELECT 
    p.id_pizza,
    p.nombre_pizza,
    p.descripcion_pizza,
    p.valor_pizza,
    b.id_bebida,
    b.nombre_bebida,
    b.valor_bebida
FROM 
    Pizza p
LEFT JOIN 
    Bebidas b ON p.id_pizza = b.id_bebida;

-- Listar todos los ingredientes disponibles para personalizar una pizza 

SELECT 
    i.id_ingrediente,
    i.nombre_ingrediente,
    i.precio_ingrediente,
    i.proveedor_ingrediente,
    i.descripcion_ingrediente
FROM 
    Ingredientes i
ORDER BY 
    i.nombre_ingrediente;

-- Calcular el costo total de un pedido (incluyendo ingredientes adicionales)

SELECT 
    p.id_pedido,
    c.nombre_cliente,
    SUM(co.valor_total_combo) AS costo_total
FROM 
    Pedidos p
JOIN 
    Cliente c ON p.cliente_id_pedido = c.id_cliente
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
JOIN 
    Combos co ON d.combo_id_detalle = co.id_combo
JOIN 
    Ingredientes_Pizza ip ON co.pizza_id_combo = ip.pizza_id
WHERE 
    p.id_pedido = 5
GROUP BY 
    p.id_pedido, c.nombre_cliente;

-- Listar los clientes que han hecho más de 5 pedidos

SELECT 
    c.id_cliente,
    c.nombre_cliente,
    COUNT(p.id_pedido) AS total_pedidos
FROM 
    Cliente c
JOIN 
    Pedidos p ON c.id_cliente = p.cliente_id_pedido
GROUP BY 
    c.id_cliente, c.nombre_cliente
HAVING 
    COUNT(p.id_pedido) > 5;

-- Buscar pedidos programados para recogerse después de una hora específica

SELECT 
    p.id_pedido,
    c.nombre_cliente,
    p.hora_pedido,
    d.valor_total
FROM 
    Pedidos p
JOIN 
    Cliente c ON p.cliente_id_pedido = c.id_cliente
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
WHERE 
    p.hora_pedido > '14:00:00'
ORDER BY 
    p.hora_pedido ASC;

-- Listar todos los combos de pizzas con bebidas disponibles en el menú

SELECT 
    co.id_combo,
    co.nombre_combo,
    p.nombre_pizza,
    b.nombre_bebida,
    co.valor_total_combo
FROM 
    Combos co
JOIN 
    Pizza p ON co.pizza_id_combo = p.id_pizza
JOIN 
    Bebidas b ON co.bebida_id_combo = b.id_bebida
ORDER BY 
    co.nombre_combo;

-- Buscar pizzas con un precio mayor a $100

SELECT 
    p.id_pizza,
    p.nombre_pizza,
    p.valor_pizza
FROM 
    Pizza p
WHERE 
    p.valor_pizza > 100.00
ORDER BY 
    p.valor_pizza DESC;

-- calcular el total de ingresos por día, semana y mes

SELECT 
    DATE(p.hora_pedido) AS fecha,
    SUM(d.valor_total) AS total_ingresos
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
GROUP BY 
    DATE(p.hora_pedido)
ORDER BY 
    fecha DESC;

-- Ingresos por Día

SELECT 
    DATE(p.hora_pedido) AS fecha,
    SUM(d.valor_total) AS total_ingresos
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
GROUP BY 
    DATE(p.hora_pedido)
ORDER BY 
    fecha DESC;

-- Ingresos por Semana

SELECT 
    YEARWEEK(p.hora_pedido) AS semana,
    SUM(d.valor_total) AS total_ingresos
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
GROUP BY 
    YEARWEEK(p.hora_pedido)
ORDER BY 
    semana DESC;

-- Ingresos por Mes

SELECT 
    DATE_FORMAT(p.hora_pedido, '%Y-%m') AS mes,
    SUM(d.valor_total) AS total_ingresos
FROM 
    Pedidos p
JOIN 
    Detalles_Pedido d ON p.id_pedido = d.pedido_id_detalle
GROUP BY 
    DATE_FORMAT(p.hora_pedido, '%Y-%m')
ORDER BY 
    mes DESC;