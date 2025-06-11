SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `Pais`;
DROP TABLE IF EXISTS `Departamento`;
DROP TABLE IF EXISTS `Ciudad`;
DROP TABLE IF EXISTS `Direccion`;
DROP TABLE IF EXISTS `Cliente`;
DROP TABLE IF EXISTS `Ingredientes_Pizza`;
DROP TABLE IF EXISTS `Pedidos`;
DROP TABLE IF EXISTS `Metodo_Pago`;
DROP TABLE IF EXISTS `Detalles_Pedido`;
DROP TABLE IF EXISTS `Tipo_Telefono`;
DROP TABLE IF EXISTS `Telefono_Clientes`;
DROP TABLE IF EXISTS `Tipo_metodo_pago`;
DROP TABLE IF EXISTS `Tipo_Producto`;
DROP TABLE IF EXISTS `Producto`;
DROP TABLE IF EXISTS `Precio_Vigente_Producto`;
DROP TABLE IF EXISTS `Pizza`;
DROP TABLE IF EXISTS `Bebida`;
DROP TABLE IF EXISTS `Combo`;
DROP TABLE IF EXISTS `Componente_Combo`;
DROP TABLE IF EXISTS `Ingrediente`;
DROP TABLE IF EXISTS `Pizza_Ingrediente_Base`;
DROP TABLE IF EXISTS `Presentacion_Pizza`;
DROP TABLE IF EXISTS `Precio_Pizza_Por_Presentacion`;
DROP TABLE IF EXISTS `Estado_Pedido`;
DROP TABLE IF EXISTS `Detalle_Pedido_Ingrediente_Extra`;
SET FOREIGN_KEY_CHECKS = 1;

-- Tabla: Pais
CREATE TABLE `Pais` (
    `id_pais` INTEGER(11) NOT NULL,
    `nombre_pais` VARCHAR(100) NOT NULL,
    `codigo_ISO` CHAR(2) NOT NULL,
    PRIMARY KEY (`id_pais`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_pais`, `codigo_ISO`) -- Índice: Unicidad y búsqueda por nombre/código
);

-- Explicación de índices para 'Pais':
-- 1. PRIMARY KEY (`id_pais`):
--    - Función: Identificación única del país y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_pais`, `codigo_ISO`):
--    - Función: Garantiza que no existan países con el mismo nombre y código ISO.
--      Acelera búsquedas por nombre de país o por nombre y código ISO.

-- Tabla: Departamento
CREATE TABLE `Departamento` (
    `id_departamento` INTEGER(11) NOT NULL,
    `pais_id_departamento` INTEGER(11) NOT NULL,
    `nombre_departamento` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_departamento`), -- Índice: Clave Primaria (automático)
    UNIQUE (`pais_id_departamento`, `nombre_departamento`), -- Índice: Unicidad y búsqueda por país y nombre
    INDEX `idx_nombre_departamento` (`nombre_departamento`) -- Índice: Búsqueda rápida por nombre de departamento
);

-- Explicación de índices para 'Departamento':
-- 1. PRIMARY KEY (`id_departamento`):
--    - Función: Identificación única del departamento y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`pais_id_departamento`, `nombre_departamento`):
--    - Función: Asegura que no haya dos departamentos con el mismo nombre dentro del mismo país.
--      Optimiza búsquedas donde se filtra por país y nombre de departamento.
-- 3. INDEX `idx_nombre_departamento` (`nombre_departamento`):
--    - Función: Mejora el rendimiento al buscar departamentos por su nombre, sin importar el país.

-- Tabla: Ciudad
CREATE TABLE `Ciudad` (
    `id_ciudad` INTEGER(11) NOT NULL,
    `departamento_id_ciudad` INTEGER(11) NOT NULL,
    `nombre_ciudad` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_ciudad`), -- Índice: Clave Primaria (automático)
    UNIQUE (`departamento_id_ciudad`, `nombre_ciudad`), -- Índice: Unicidad y búsqueda por departamento y nombre
    INDEX `idx_nombre_ciudad` (`nombre_ciudad`) -- Índice: Búsqueda rápida por nombre de ciudad
);

-- Explicación de índices para 'Ciudad':
-- 1. PRIMARY KEY (`id_ciudad`):
--    - Función: Identificación única de la ciudad y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`departamento_id_ciudad`, `nombre_ciudad`):
--    - Función: Garantiza que no existan ciudades con el mismo nombre dentro del mismo departamento.
--      Optimiza búsquedas donde se filtra por departamento y nombre de ciudad.
-- 3. INDEX `idx_nombre_ciudad` (`nombre_ciudad`):
--    - Función: Mejora el rendimiento al buscar ciudades por su nombre, sin importar el departamento.

-- Tabla: Direccion
CREATE TABLE `Direccion` (
    `id_direccion` INTEGER(11) NOT NULL,
    `cliente_id_direccion` INTEGER(11) NOT NULL,
    `pais_id_direccion` INTEGER(11) NOT NULL,
    `departamento_id_direccion` INTEGER(11) NOT NULL,
    `ciudad_id_direccion` INTEGER(11) NOT NULL,
    `complemento` VARCHAR(255) NOT NULL,
    `codigo_postal` VARCHAR(20) NOT NULL,
    `es_principal` BOOLEAN NOT NULL,
    PRIMARY KEY (`id_direccion`), -- Índice: Clave Primaria (automático)
    UNIQUE (`cliente_id_direccion`, `codigo_postal`), -- Índice: Unicidad por cliente y código postal
    INDEX `idx_cliente_direccion` (`cliente_id_direccion`), -- Índice: Búsqueda de direcciones por cliente
    INDEX `idx_ubicacion_direccion` (`pais_id_direccion`, `departamento_id_direccion`, `ciudad_id_direccion`) -- Índice: Búsqueda por ubicación
);

-- Explicación de índices para 'Direccion':
-- 1. PRIMARY KEY (`id_direccion`):
--    - Función: Identificación única de la dirección y búsquedas rápidas por ID.
-- 2. UNIQUE (`cliente_id_direccion`, `codigo_postal`):
--    - Función: Evita que un mismo cliente tenga la misma combinación de dirección y código postal duplicada.
-- 3. INDEX `idx_cliente_direccion` (`cliente_id_direccion`):
--    - Función: Optimiza la búsqueda de todas las direcciones asociadas a un cliente específico. Muy útil para mostrar las direcciones de un usuario.
-- 4. INDEX `idx_ubicacion_direccion` (`pais_id_direccion`, `departamento_id_direccion`, `ciudad_id_direccion`):
--    - Función: Acelera consultas que buscan direcciones por su ubicación geográfica (país, departamento, ciudad).

-- Tabla: Cliente
CREATE TABLE `Cliente` (
    `id_cliente` INTEGER(11) NOT NULL,
    `nombres_cliente` VARCHAR(100) NOT NULL,
    `apellidos_cliente` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `fecha_registro_cliente` DATETIME NOT NULL,
    PRIMARY KEY (`id_cliente`), -- Índice: Clave Primaria (automático)
    UNIQUE INDEX `idx_unique_email` (`email`), -- Índice: Unicidad y búsqueda por email
    INDEX `idx_nombres_apellidos` (`nombres_cliente`, `apellidos_cliente`), -- Índice: Búsqueda y ordenación por nombre/apellido
    INDEX `idx_fecha_registro` (`fecha_registro_cliente`) -- Índice: Búsqueda y ordenación por fecha de registro
);

-- Explicación de índices para 'Cliente': (Repetido de la explicación anterior para referencia completa)
-- 1. PRIMARY KEY (`id_cliente`):
--    - Función: Identificación única del cliente y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE INDEX `idx_unique_email` (`email`):
--    - Función: Garantiza la unicidad del correo electrónico y acelera búsquedas por email.
-- 3. INDEX `idx_nombres_apellidos` (`nombres_cliente`, `apellidos_cliente`):
--    - Función: Mejora el rendimiento en búsquedas y ordenaciones por nombre y/o apellido.
-- 4. INDEX `idx_fecha_registro` (`fecha_registro_cliente`):
--    - Función: Optimiza consultas que filtran o ordenan clientes por su fecha de registro.

-- Tabla: Ingredientes_Pizza
CREATE TABLE `Ingredientes_Pizza` (
    `pizza_id` INTEGER(11) NOT NULL,
    `pizza_tipo_id` INTEGER(11) NOT NULL,
    `ingrediente_id` INTEGER(11) NOT NULL,
    `total_pizza` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`pizza_id`, `pizza_tipo_id`, `ingrediente_id`) -- Índice: Clave Primaria Compuesta (automático)
);

-- Explicación de índices para 'Ingredientes_Pizza':
-- 1. PRIMARY KEY (`pizza_id`, `pizza_tipo_id`, `ingrediente_id`):
--    - Función: Identificación única de la combinación de pizza, tipo y ingrediente.
--      Optimiza búsquedas directas de un ingrediente específico en una pizza y tipo de pizza.

-- Tabla: Pedidos
CREATE TABLE `Pedidos` (
    `id_pedido` INTEGER(11) NOT NULL,
    `cliente_id_pedido` INTEGER(11) NOT NULL,
    `fecha_hora_pedido` DATETIME NOT NULL,
    `hora_recogida_estimada` TIME NOT NULL,
    `metodo_pago_id` INTEGER(11) NOT NULL,
    `total_pedido` DECIMAL(10,2) NOT NULL,
    `estado_pedido_id` INTEGER(11) NOT NULL,
    `pago_confirmado` BOOLEAN NOT NULL,
    `instrucciones_especiales_cliente` TEXT NOT NULL,
    PRIMARY KEY (`id_pedido`), -- Índice: Clave Primaria (automático)
    INDEX `idx_cliente_pedido` (`cliente_id_pedido`), -- Índice: Búsqueda de pedidos por cliente
    INDEX `idx_fecha_hora_pedido` (`fecha_hora_pedido`), -- Índice: Búsqueda y ordenación por fecha y hora del pedido
    INDEX `idx_estado_pedido` (`estado_pedido_id`) -- Índice: Búsqueda de pedidos por estado
);

-- Explicación de índices para 'Pedidos':
-- 1. PRIMARY KEY (`id_pedido`):
--    - Función: Identificación única del pedido y búsquedas rápidas por ID.
-- 2. INDEX `idx_cliente_pedido` (`cliente_id_pedido`):
--    - Función: Acelera la recuperación de todos los pedidos realizados por un cliente específico. Esencial para el historial de pedidos.
-- 3. INDEX `idx_fecha_hora_pedido` (`fecha_hora_pedido`):
--    - Función: Mejora el rendimiento al buscar o filtrar pedidos por un rango de fechas/horas, o al ordenar pedidos cronológicamente.
-- 4. INDEX `idx_estado_pedido` (`estado_pedido_id`):
--    - Función: Optimiza la búsqueda de pedidos que se encuentran en un estado particular (por ejemplo, "Pendiente", "En preparación", "Entregado").

-- Tabla: Metodo_Pago
CREATE TABLE `Metodo_Pago` (
    `id_metodo_pago` INTEGER(11) NOT NULL,
    `tipo_metodo_pago_id` INTEGER(11) NOT NULL,
    `nombre_metodo_pago` VARCHAR(100) NOT NULL,
    `descripcion_metodo_pago` TEXT NOT NULL,
    PRIMARY KEY (`id_metodo_pago`), -- Índice: Clave Primaria (automático)
    INDEX `idx_nombre_metodo_pago` (`nombre_metodo_pago`) -- Índice: Búsqueda por nombre de método de pago
);

-- Explicación de índices para 'Metodo_Pago':
-- 1. PRIMARY KEY (`id_metodo_pago`):
--    - Función: Identificación única del método de pago y búsquedas rápidas por ID. Crucial para FK.
-- 2. INDEX `idx_nombre_metodo_pago` (`nombre_metodo_pago`):
--    - Función: Mejora el rendimiento al buscar métodos de pago por su nombre.

-- Tabla: Detalles_Pedido
CREATE TABLE `Detalles_Pedido` (
    `id_detalle_pedido` INTEGER(11) NOT NULL,
    `pedido_id_detalle` INTEGER(11) NOT NULL,
    `producto_id_detalle` INTEGER(11) NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `precio_unitario_aplicado` DECIMAL(10,2) NOT NULL,
    `presentacion_pizza_id_detalle` INTEGER(11) NOT NULL,
    `subtotal_linea` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_detalle_pedido`), -- Índice: Clave Primaria (automático)
    UNIQUE (`pedido_id_detalle`, `producto_id_detalle`, `presentacion_pizza_id_detalle`), -- Índice: Unicidad y búsqueda por pedido, producto y presentación
    INDEX `idx_pedido_id_detalle` (`pedido_id_detalle`), -- Índice: Búsqueda de detalles por pedido
    INDEX `idx_producto_id_detalle` (`producto_id_detalle`) -- Índice: Búsqueda de detalles por producto
);

-- Explicación de índices para 'Detalles_Pedido':
-- 1. PRIMARY KEY (`id_detalle_pedido`):
--    - Función: Identificación única del detalle del pedido y búsquedas rápidas por ID.
-- 2. UNIQUE (`pedido_id_detalle`, `producto_id_detalle`, `presentacion_pizza_id_detalle`):
--    - Función: Asegura que una combinación específica de pedido, producto y presentación solo aparezca una vez.
--      Optimiza la búsqueda de una línea de pedido específica.
-- 3. INDEX `idx_pedido_id_detalle` (`pedido_id_detalle`):
--    - Función: Acelera la recuperación de todos los productos en un pedido específico. Muy importante para mostrar el contenido de un pedido.
-- 4. INDEX `idx_producto_id_detalle` (`producto_id_detalle`):
--    - Función: Mejora el rendimiento al buscar qué pedidos incluyen un producto determinado.

-- Tabla: Tipo_Telefono
CREATE TABLE `Tipo_Telefono` (
    `id_tipo_telefono` INTEGER(11) NOT NULL,
    `nombre_tipo_telefono` VARCHAR(100) NOT NULL,
    `descripcion` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_telefono`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_tipo_telefono`) -- Índice: Unicidad y búsqueda por nombre de tipo de teléfono
);

-- Explicación de índices para 'Tipo_Telefono':
-- 1. PRIMARY KEY (`id_tipo_telefono`):
--    - Función: Identificación única del tipo de teléfono y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_tipo_telefono`):
--    - Función: Garantiza que no existan tipos de teléfono con el mismo nombre.
--      Acelera búsquedas por nombre del tipo de teléfono.

-- Tabla: Telefono_Clientes
CREATE TABLE `Telefono_Clientes` (
    `id_telefono_cliente` INTEGER(11) NOT NULL,
    `cliente_id_telefono` INTEGER(11) NOT NULL,
    `codigo_pais` VARCHAR(20) NOT NULL,
    `numero_telefono` VARCHAR(20) NOT NULL,
    `tipo_telefono_id` INTEGER(11) NOT NULL,
    `es_principal` BOOLEAN NOT NULL,
    PRIMARY KEY (`id_telefono_cliente`), -- Índice: Clave Primaria (automático)
    UNIQUE (`cliente_id_telefono`, `codigo_pais`, `numero_telefono`), -- Índice: Unicidad por cliente y número de teléfono
    INDEX `idx_cliente_telefono` (`cliente_id_telefono`), -- Índice: Búsqueda de teléfonos por cliente
    INDEX `idx_numero_telefono` (`numero_telefono`) -- Índice: Búsqueda por número de teléfono
);

-- Explicación de índices para 'Telefono_Clientes':
-- 1. PRIMARY KEY (`id_telefono_cliente`):
--    - Función: Identificación única del teléfono del cliente y búsquedas rápidas por ID.
-- 2. UNIQUE (`cliente_id_telefono`, `codigo_pais`, `numero_telefono`):
--    - Función: Evita que un cliente tenga el mismo número de teléfono (incluyendo código de país) registrado más de una vez.
--      Optimiza la búsqueda de un teléfono específico de un cliente.
-- 3. INDEX `idx_cliente_telefono` (`cliente_id_telefono`):
--    - Función: Acelera la recuperación de todos los números de teléfono asociados a un cliente.
-- 4. INDEX `idx_numero_telefono` (`numero_telefono`):
--    - Función: Mejora el rendimiento al buscar teléfonos por el número, útil para identificar clientes por su número.

-- Tabla: Tipo_metodo_pago
CREATE TABLE `Tipo_metodo_pago` (
    `id_tipo_metodo_pago` INTEGER(11) NOT NULL,
    `nombre_tipo_metodo_pago` VARCHAR(100) NOT NULL,
    `descricpcion_tipo_metodo_pago` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_metodo_pago`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_tipo_metodo_pago`) -- Índice: Unicidad y búsqueda por nombre de tipo de método de pago
);

-- Explicación de índices para 'Tipo_metodo_pago':
-- 1. PRIMARY KEY (`id_tipo_metodo_pago`):
--    - Función: Identificación única del tipo de método de pago y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_tipo_metodo_pago`):
--    - Función: Garantiza que no existan tipos de método de pago con el mismo nombre.
--      Acelera búsquedas por el nombre del tipo de método de pago.

-- Tabla: Tipo_Producto
CREATE TABLE `Tipo_Producto` (
    `id_tipo_producto` INTEGER(11) NOT NULL,
    `nombre_tipo_producto` VARCHAR(200) NOT NULL,
    `descripcion` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_producto`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_tipo_producto`) -- Índice: Unicidad y búsqueda por nombre de tipo de producto
);

-- Explicación de índices para 'Tipo_Producto':
-- 1. PRIMARY KEY (`id_tipo_producto`):
--    - Función: Identificación única del tipo de producto y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_tipo_producto`):
--    - Función: Garantiza que no existan tipos de producto con el mismo nombre.
--      Acelera búsquedas por el nombre del tipo de producto.

-- Tabla: Producto
CREATE TABLE `Producto` (
    `id_producto` INTEGER(11) NOT NULL,
    `nombre_producto` VARCHAR(200) NOT NULL,
    `descripcion` TEXT NOT NULL,
    `tipo_producto_id` INTEGER(11) NOT NULL,
    `esta_activo` BOOLEAN NOT NULL,
    PRIMARY KEY (`id_producto`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_producto`, `tipo_producto_id`), -- Índice: Unicidad y búsqueda por nombre y tipo de producto
    INDEX `idx_tipo_producto` (`tipo_producto_id`), -- Índice: Búsqueda de productos por tipo
    INDEX `idx_nombre_producto` (`nombre_producto`) -- Índice: Búsqueda por nombre de producto
);

-- Explicación de índices para 'Producto':
-- 1. PRIMARY KEY (`id_producto`):
--    - Función: Identificación única del producto y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_producto`, `tipo_producto_id`):
--    - Función: Asegura que no haya productos con el mismo nombre y tipo duplicados.
--      Optimiza la búsqueda de un producto específico por su nombre y tipo.
-- 3. INDEX `idx_tipo_producto` (`tipo_producto_id`):
--    - Función: Acelera la recuperación de productos de un tipo específico (ej. todas las pizzas, todas las bebidas).
-- 4. INDEX `idx_nombre_producto` (`nombre_producto`):
--    - Función: Mejora el rendimiento al buscar productos por su nombre.

-- Tabla: Precio_Vigente_Producto
CREATE TABLE `Precio_Vigente_Producto` (
    `id_precio_vigente_producto` INTEGER(11) NOT NULL,
    `prducto_id_precio` INTEGER(11) NOT NULL,
    `precio_base` DECIMAL(10,2) NOT NULL,
    `fecha_inicio_vigencia` DATE NOT NULL,
    `fecha_fin_vigencia` DATE NOT NULL,
    PRIMARY KEY (`id_precio_vigente_producto`), -- Índice: Clave Primaria (automático)
    UNIQUE (`prducto_id_precio`, `fecha_inicio_vigencia`), -- Índice: Unicidad y búsqueda por producto y fecha de inicio de vigencia
    INDEX `idx_producto_precio` (`prducto_id_precio`), -- Índice: Búsqueda de precios por producto
    INDEX `idx_fechas_vigencia` (`fecha_inicio_vigencia`, `fecha_fin_vigencia`) -- Índice: Búsqueda por rango de fechas de vigencia
);

-- Explicación de índices para 'Precio_Vigente_Producto':
-- 1. PRIMARY KEY (`id_precio_vigente_producto`):
--    - Función: Identificación única del registro de precio y búsquedas rápidas por ID.
-- 2. UNIQUE (`prducto_id_precio`, `fecha_inicio_vigencia`):
--    - Función: Evita que un producto tenga dos precios que comiencen su vigencia en la misma fecha, garantizando un historial de precios coherente.
--      Optimiza la búsqueda del precio de un producto a partir de una fecha específica.
-- 3. INDEX `idx_producto_precio` (`prducto_id_precio`):
--    - Función: Acelera la recuperación de todos los registros de precios para un producto dado.
-- 4. INDEX `idx_fechas_vigencia` (`fecha_inicio_vigencia`, `fecha_fin_vigencia`):
--    - Función: Mejora el rendimiento al buscar precios vigentes dentro de un rango de fechas.

-- Tabla: Pizza
CREATE TABLE `Pizza` (
    `id_pizza` INTEGER(11) NOT NULL,
    `instrucciones_preparacion` TEXT NOT NULL,
    PRIMARY KEY (`id_pizza`) -- Índice: Clave Primaria (automático)
);

-- Explicación de índices para 'Pizza':
-- 1. PRIMARY KEY (`id_pizza`):
--    - Función: Identificación única de la pizza y búsquedas rápidas por ID. Crucial para FK.

-- Tabla: Bebida
CREATE TABLE `Bebida` (
    `id_bebida` INTEGER(11) NOT NULL,
    `capacidad_ml` INTEGER NOT NULL,
    PRIMARY KEY (`id_bebida`) -- Índice: Clave Primaria (automático)
);

-- Explicación de índices para 'Bebida':
-- 1. PRIMARY KEY (`id_bebida`):
--    - Función: Identificación única de la bebida y búsquedas rápidas por ID. Crucial para FK.

-- Tabla: Combo
CREATE TABLE `Combo` (
    `id_combo` INTEGER(11) NOT NULL,
    `nombre_combo` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_combo`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_combo`) -- Índice: Unicidad y búsqueda por nombre de combo
);

-- Explicación de índices para 'Combo':
-- 1. PRIMARY KEY (`id_combo`):
--    - Función: Identificación única del combo y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_combo`):
--    - Función: Garantiza que no existan combos con el mismo nombre.
--      Acelera búsquedas por el nombre del combo.

-- Tabla: Componente_Combo
CREATE TABLE `Componente_Combo` (
    `id_componente_combo` INTEGER(11) NOT NULL,
    `combo_id` INTEGER(11) NOT NULL,
    `producto_componente_id` INTEGER(11) NOT NULL,
    `cantidad` INTEGER NOT NULL,
    PRIMARY KEY (`id_componente_combo`), -- Índice: Clave Primaria (automático)
    UNIQUE (`combo_id`, `producto_componente_id`), -- Índice: Unicidad y búsqueda por combo y producto componente
    INDEX `idx_combo_componente` (`combo_id`), -- Índice: Búsqueda de componentes por combo
    INDEX `idx_producto_componente` (`producto_componente_id`) -- Índice: Búsqueda de combos por producto componente
);

-- Explicación de índices para 'Componente_Combo':
-- 1. PRIMARY KEY (`id_componente_combo`):
--    - Función: Identificación única del componente del combo y búsquedas rápidas por ID.
-- 2. UNIQUE (`combo_id`, `producto_componente_id`):
--    - Función: Asegura que un combo no tenga el mismo producto listado como componente más de una vez.
--      Optimiza la búsqueda de un componente específico dentro de un combo.
-- 3. INDEX `idx_combo_componente` (`combo_id`):
--    - Función: Acelera la recuperación de todos los productos que forman parte de un combo.
-- 4. INDEX `idx_producto_componente` (`producto_componente_id`):
--    - Función: Mejora el rendimiento al buscar en qué combos se utiliza un producto determinado.

-- Tabla: Ingrediente
CREATE TABLE `Ingrediente` (
    `id_ingrediente` INTEGER(11) NOT NULL,
    `nombre_ingrediente` VARCHAR(200) NOT NULL,
    `descripcion` TEXT NOT NULL,
    `precio_adicional_extra` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_ingrediente`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_ingrediente`) -- Índice: Unicidad y búsqueda por nombre de ingrediente
);

-- Explicación de índices para 'Ingrediente':
-- 1. PRIMARY KEY (`id_ingrediente`):
--    - Función: Identificación única del ingrediente y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_ingrediente`):
--    - Función: Garantiza que no existan ingredientes con el mismo nombre.
--      Acelera búsquedas por el nombre del ingrediente.

-- Tabla: Pizza_Ingrediente_Base
CREATE TABLE `Pizza_Ingrediente_Base` (
    `id_pizza_ingrediente_base` INTEGER(11) NOT NULL,
    `pizza_id` INTEGER(11) NOT NULL,
    `ingrediente_id` INTEGER(11) NOT NULL,
    PRIMARY KEY (`id_pizza_ingrediente_base`), -- Índice: Clave Primaria (automático)
    UNIQUE (`pizza_id`, `ingrediente_id`), -- Índice: Unicidad y búsqueda por pizza e ingrediente
    INDEX `idx_pizza_base` (`pizza_id`), -- Índice: Búsqueda de ingredientes base por pizza
    INDEX `idx_ingrediente_base` (`ingrediente_id`) -- Índice: Búsqueda de pizzas por ingrediente base
);

-- Explicación de índices para 'Pizza_Ingrediente_Base':
-- 1. PRIMARY KEY (`id_pizza_ingrediente_base`):
--    - Función: Identificación única de la relación pizza-ingrediente base y búsquedas rápidas por ID.
-- 2. UNIQUE (`pizza_id`, `ingrediente_id`):
--    - Función: Asegura que cada combinación de pizza e ingrediente base sea única.
--      Optimiza la búsqueda de un ingrediente base específico para una pizza.
-- 3. INDEX `idx_pizza_base` (`pizza_id`):
--    - Función: Acelera la recuperación de todos los ingredientes base de una pizza.
-- 4. INDEX `idx_ingrediente_base` (`ingrediente_id`):
--    - Función: Mejora el rendimiento al buscar en qué pizzas se utiliza un ingrediente como base.

-- Tabla: Presentacion_Pizza
CREATE TABLE `Presentacion_Pizza` (
    `id_presentacion_pizza` INTEGER(11) NOT NULL,
    `nombre_presentacion` VARCHAR(50) NOT NULL,
    `descripcion` TEXT NOT NULL,
    PRIMARY KEY (`id_presentacion_pizza`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_presentacion`) -- Índice: Unicidad y búsqueda por nombre de presentación
);

-- Explicación de índices para 'Presentacion_Pizza':
-- 1. PRIMARY KEY (`id_presentacion_pizza`):
--    - Función: Identificación única de la presentación de pizza y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_presentacion`):
--    - Función: Garantiza que no existan presentaciones de pizza con el mismo nombre.
--      Acelera búsquedas por el nombre de la presentación.

-- Tabla: Precio_Pizza_Por_Presentacion
CREATE TABLE `Precio_Pizza_Por_Presentacion` (
    `id_precio_pizza_presentacion` INTEGER(11) NOT NULL,
    `pizza_id_presentacion` INTEGER(11) NOT NULL,
    `presentacion_pizza_id` INTEGER(11) NOT NULL,
    `precio_base` DECIMAL(10,2) NOT NULL,
    `fecha_inicio_vigencia` DATE NOT NULL,
    `fecha_fin_vigencia` DATE NOT NULL,
    PRIMARY KEY (`id_precio_pizza_presentacion`), -- Índice: Clave Primaria (automático)
    UNIQUE (`pizza_id_presentacion`, `presentacion_pizza_id`, `fecha_inicio_vigencia`), -- Índice: Unicidad y búsqueda por pizza, presentación y fecha de inicio
    INDEX `idx_pizza_presentacion` (`pizza_id_presentacion`, `presentacion_pizza_id`), -- Índice: Búsqueda de precios por pizza y presentación
    INDEX `idx_fechas_vigencia_pizza` (`fecha_inicio_vigencia`, `fecha_fin_vigencia`) -- Índice: Búsqueda por rango de fechas de vigencia para precios de pizza
);

-- Explicación de índices para 'Precio_Pizza_Por_Presentacion':
-- 1. PRIMARY KEY (`id_precio_pizza_presentacion`):
--    - Función: Identificación única del precio de pizza por presentación y búsquedas rápidas por ID.
-- 2. UNIQUE (`pizza_id_presentacion`, `presentacion_pizza_id`, `fecha_inicio_vigencia`):
--    - Función: Asegura que para una pizza y presentación dadas, solo haya un precio que comience su vigencia en una fecha específica.
--      Optimiza la búsqueda del precio de una pizza en una presentación particular a partir de una fecha.
-- 3. INDEX `idx_pizza_presentacion` (`pizza_id_presentacion`, `presentacion_pizza_id`):
--    - Función: Acelera la recuperación de todos los precios para una pizza en una presentación específica.
-- 4. INDEX `idx_fechas_vigencia_pizza` (`fecha_inicio_vigencia`, `fecha_fin_vigencia`):
--    - Función: Mejora el rendimiento al buscar precios vigentes de pizzas dentro de un rango de fechas.

-- Tabla: Estado_Pedido
CREATE TABLE `Estado_Pedido` (
    `id_estado_pedido` INTEGER(11) NOT NULL,
    `nombre_estado` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id_estado_pedido`), -- Índice: Clave Primaria (automático)
    UNIQUE (`nombre_estado`) -- Índice: Unicidad y búsqueda por nombre de estado
);

-- Explicación de índices para 'Estado_Pedido':
-- 1. PRIMARY KEY (`id_estado_pedido`):
--    - Función: Identificación única del estado del pedido y búsquedas rápidas por ID. Crucial para FK.
-- 2. UNIQUE (`nombre_estado`):
--    - Función: Garantiza que no existan estados de pedido con el mismo nombre.
--      Acelera búsquedas por el nombre del estado del pedido.

-- Tabla: Detalle_Pedido_Ingrediente_Extra
CREATE TABLE `Detalle_Pedido_Ingrediente_Extra` (
    `id_detalle_pedido_ingrediente_extra` INTEGER(11) NOT NULL,
    `detalle_pedido_id` INTEGER(11) NOT NULL,
    `ingrediente_id_detalle` INTEGER(11) NOT NULL,
    `cantidad_extra` INTEGER NOT NULL,
    `precio_extra_aplicado` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_detalle_pedido_ingrediente_extra`), -- Índice: Clave Primaria (automático)
    UNIQUE (`detalle_pedido_id`, `ingrediente_id_detalle`), -- Índice: Unicidad y búsqueda por detalle de pedido e ingrediente extra
    INDEX `idx_detalle_pedido_extra` (`detalle_pedido_id`), -- Índice: Búsqueda de ingredientes extra por detalle de pedido
    INDEX `idx_ingrediente_extra_detalle` (`ingrediente_id_detalle`) -- Índice: Búsqueda de detalles de pedido por ingrediente extra
);

-- Explicación de índices para 'Detalle_Pedido_Ingrediente_Extra':
-- 1. PRIMARY KEY (`id_detalle_pedido_ingrediente_extra`):
--    - Función: Identificación única del detalle de ingrediente extra y búsquedas rápidas por ID.
-- 2. UNIQUE (`detalle_pedido_id`, `ingrediente_id_detalle`):
--    - Función: Asegura que un mismo ingrediente extra no se añada dos veces a la misma línea de detalle de pedido.
--      Optimiza la búsqueda de un ingrediente extra específico en un detalle de pedido.
-- 3. INDEX `idx_detalle_pedido_extra` (`detalle_pedido_id`):
--    - Función: Acelera la recuperación de todos los ingredientes extra para una línea de pedido específica.
-- 4. INDEX `idx_ingrediente_extra_detalle` (`ingrediente_id_detalle`):
--    - Función: Mejora el rendimiento al buscar en qué detalles de pedido se añadió un ingrediente extra.

-- Restablecimiento de Foreign Keys (no se necesitan índices adicionales para las FKs, ya que las columnas referenciadas ya suelen estar indexadas por ser PKs o por los índices agregados)
ALTER TABLE `Departamento` ADD FOREIGN KEY (`pais_id_departamento`) REFERENCES `Pais`(`id_pais`);
ALTER TABLE `Ciudad` ADD FOREIGN KEY (`departamento_id_ciudad`) REFERENCES `Departamento`(`id_departamento`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`pais_id_direccion`) REFERENCES `Pais`(`id_pais`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`departamento_id_direccion`) REFERENCES `Departamento`(`id_departamento`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`ciudad_id_direccion`) REFERENCES `Ciudad`(`id_ciudad`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`cliente_id_direccion`) REFERENCES `Cliente`(`id_cliente`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`metodo_pago_id`) REFERENCES `Metodo_Pago`(`id_metodo_pago`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`estado_pedido_id`) REFERENCES `Estado_Pedido`(`id_estado_pedido`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`cliente_id_pedido`) REFERENCES `Cliente`(`id_cliente`); -- Corregido de Detalles_Pedido a Cliente
ALTER TABLE `Metodo_Pago` ADD FOREIGN KEY (`tipo_metodo_pago_id`) REFERENCES `Tipo_metodo_pago`(`id_tipo_metodo_pago`);
ALTER TABLE `Detalles_Pedido` ADD FOREIGN KEY (`producto_id_detalle`) REFERENCES `Producto`(`id_producto`);
ALTER TABLE `Detalles_Pedido` ADD FOREIGN KEY (`presentacion_pizza_id_detalle`) REFERENCES `Presentacion_Pizza`(`id_presentacion_pizza`);
ALTER TABLE `Telefono_Clientes` ADD FOREIGN KEY (`cliente_id_telefono`) REFERENCES `Cliente`(`id_cliente`);
ALTER TABLE `Telefono_Clientes` ADD FOREIGN KEY (`tipo_telefono_id`) REFERENCES `Tipo_Telefono`(`id_tipo_telefono`);
ALTER TABLE `Producto` ADD FOREIGN KEY (`tipo_producto_id`) REFERENCES `Tipo_Producto`(`id_tipo_producto`);
ALTER TABLE `Precio_Vigente_Producto` ADD FOREIGN KEY (`prducto_id_precio`) REFERENCES `Producto`(`id_producto`);
ALTER TABLE `Pizza` ADD FOREIGN KEY (`id_pizza`) REFERENCES `Producto`(`id_producto`);
ALTER TABLE `Bebida` ADD FOREIGN KEY (`id_bebida`) REFERENCES `Producto`(`id_producto`);
ALTER TABLE `Combo` ADD FOREIGN KEY (`id_combo`) REFERENCES `Producto`(`id_producto`);
ALTER TABLE `Componente_Combo` ADD FOREIGN KEY (`producto_componente_id`) REFERENCES `Producto`(`id_producto`);
ALTER TABLE `Componente_Combo` ADD FOREIGN KEY (`combo_id`) REFERENCES `Combo`(`id_combo`);
ALTER TABLE `Pizza_Ingrediente_Base` ADD FOREIGN KEY (`pizza_id`) REFERENCES `Pizza`(`id_pizza`);
ALTER TABLE `Pizza_Ingrediente_Base` ADD FOREIGN KEY (`ingrediente_id`) REFERENCES `Ingrediente`(`id_ingrediente`);
ALTER TABLE `Precio_Pizza_Por_Presentacion` ADD FOREIGN KEY (`pizza_id_presentacion`) REFERENCES `Pizza`(`id_pizza`);
ALTER TABLE `Precio_Pizza_Por_Presentacion` ADD FOREIGN KEY (`presentacion_pizza_id`) REFERENCES `Presentacion_Pizza`(`id_presentacion_pizza`);
ALTER TABLE `Detalle_Pedido_Ingrediente_Extra` ADD FOREIGN KEY (`detalle_pedido_id`) REFERENCES `Detalles_Pedido`(`id_detalle_pedido`);
ALTER TABLE `Detalle_Pedido_Ingrediente_Extra` ADD FOREIGN KEY (`ingrediente_id_detalle`) REFERENCES `Ingrediente`(`id_ingrediente`);