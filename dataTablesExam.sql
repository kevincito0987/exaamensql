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

CREATE TABLE `Pais` (
    `id_pais` INTEGER(11) NOT NULL,
    `nombre_pais` VARCHAR(100) NOT NULL,
    `codigo_ISO` CHAR(2) NOT NULL,
    PRIMARY KEY (`id_pais`),
    UNIQUE (`nombre_pais`, `codigo_ISO`)
);

CREATE TABLE `Departamento` (
    `id_departamento` INTEGER(11) NOT NULL,
    `pais_id_departamento` INTEGER(11) NOT NULL,
    `nombre_departamento` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_departamento`),
    UNIQUE (`pais_id_departamento`, `nombre_departamento`)
);

CREATE TABLE `Ciudad` (
    `id_ciudad` INTEGER(11) NOT NULL,
    `departamento_id_ciudad` INTEGER(11) NOT NULL,
    `nombre_ciudad` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_ciudad`),
    UNIQUE (`departamento_id_ciudad`, `nombre_ciudad`)
);

CREATE TABLE `Direccion` (
    `id_direccion` INTEGER(11) NOT NULL,
    `cliente_id_direccion` INTEGER(11) NOT NULL,
    `pais_id_direccion` INTEGER(11) NOT NULL,
    `departamento_id_direccion` INTEGER(11) NOT NULL,
    `ciudad_id_direccion` INTEGER(11) NOT NULL,
    `complemento` VARCHAR(255) NOT NULL,
    `codigo_postal` VARCHAR(20) NOT NULL,
    `es_principal` BOOLEAN NOT NULL,
    PRIMARY KEY (`id_direccion`),
    UNIQUE (`cliente_id_direccion`, `codigo_postal`)
);

CREATE TABLE `Cliente` (
    `id_cliente` INTEGER(11) NOT NULL,
    `nombres_cliente` VARCHAR(100) NOT NULL,
    `apellidos_cliente` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `fecha_registro_cliente` DATETIME NOT NULL,
    PRIMARY KEY (`id_cliente`)
);

CREATE TABLE `Ingredientes_Pizza` (
    `pizza_id` INTEGER(11) NOT NULL,
    `pizza_tipo_id` INTEGER(11) NOT NULL,
    `ingrediente_id` INTEGER(11) NOT NULL,
    `total_pizza` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`pizza_id`, `pizza_tipo_id`, `ingrediente_id`)
);

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
    PRIMARY KEY (`id_pedido`)
);

CREATE TABLE `Metodo_Pago` (
    `id_metodo_pago` INTEGER(11) NOT NULL,
    `tipo_metodo_pago_id` INTEGER(11) NOT NULL,
    `nombre_metodo_pago` VARCHAR(100) NOT NULL,
    `descripcion_metodo_pago` TEXT NOT NULL,
    PRIMARY KEY (`id_metodo_pago`)
);

CREATE TABLE `Detalles_Pedido` (
    `id_detalle_pedido` INTEGER(11) NOT NULL,
    `pedido_id_detalle` INTEGER(11) NOT NULL,
    `producto_id_detalle` INTEGER(11) NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `precio_unitario_aplicado` DECIMAL(10,2) NOT NULL,
    `presentacion_pizza_id_detalle` INTEGER(11) NOT NULL,
    `subtotal_linea` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_detalle_pedido`),
    UNIQUE (`pedido_id_detalle`, `producto_id_detalle`, `presentacion_pizza_id_detalle`)
);

CREATE TABLE `Tipo_Telefono` (
    `id_tipo_telefono` INTEGER(11) NOT NULL,
    `nombre_tipo_telefono` VARCHAR(100) NOT NULL,
    `descripcion` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_telefono`),
    UNIQUE (`nombre_tipo_telefono`)
);

CREATE TABLE `Telefono_Clientes` (
    `id_telefono_cliente` INTEGER(11) NOT NULL,
    `cliente_id_telefono` INTEGER(11) NOT NULL,
    `codigo_pais` VARCHAR(20) NOT NULL,
    `numero_telefono` VARCHAR(20) NOT NULL,
    `tipo_telefono_id` INTEGER(11) NOT NULL,
    `es_principal` BOOLEAN NOT NULL,
    PRIMARY KEY (`id_telefono_cliente`),
    UNIQUE (`cliente_id_telefono`, `codigo_pais`, `numero_telefono`)
);

CREATE TABLE `Tipo_metodo_pago` (
    `id_tipo_metodo_pago` INTEGER(11) NOT NULL,
    `nombre_tipo_metodo_pago` VARCHAR(100) NOT NULL,
    `descricpcion_tipo_metodo_pago` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_metodo_pago`)
);

CREATE TABLE `Tipo_Producto` (
    `id_tipo_producto` INTEGER(11) NOT NULL,
    `nombre_tipo_producto` VARCHAR(200) NOT NULL,
    `descripcion` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_producto`),
    UNIQUE (`nombre_tipo_producto`)
);

CREATE TABLE `Producto` (
    `id_producto` INTEGER(11) NOT NULL,
    `nombre_producto` VARCHAR(200) NOT NULL,
    `descripcion` TEXT NOT NULL,
    `tipo_producto_id` INTEGER(11) NOT NULL,
    `esta_activo` BOOLEAN NOT NULL,
    PRIMARY KEY (`id_producto`),
    UNIQUE (`nombre_producto`, `tipo_producto_id`)
);

CREATE TABLE `Precio_Vigente_Producto` (
    `id_precio_vigente_producto` INTEGER(11) NOT NULL,
    `prducto_id_precio` INTEGER(11) NOT NULL,
    `precio_base` DECIMAL(10,2) NOT NULL,
    `fecha_inicio_vigencia` DATE NOT NULL,
    `fecha_fin_vigencia` DATE NOT NULL,
    PRIMARY KEY (`id_precio_vigente_producto`),
    UNIQUE (`prducto_id_precio`, `fecha_inicio_vigencia`)
);

CREATE TABLE `Pizza` (
    `id_pizza` INTEGER(11) NOT NULL,
    `instrucciones_preparacion` TEXT NOT NULL,
    PRIMARY KEY (`id_pizza`)
);

CREATE TABLE `Bebida` (
    `id_bebida` INTEGER(11) NOT NULL,
    `capacidad_ml` INTEGER NOT NULL,
    PRIMARY KEY (`id_bebida`)
);

CREATE TABLE `Combo` (
    `id_combo` INTEGER(11) NOT NULL,
    `nombre_combo` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_combo`)
);

CREATE TABLE `Componente_Combo` (
    `id_componente_combo` INTEGER(11) NOT NULL,
    `combo_id` INTEGER(11) NOT NULL,
    `producto_componente_id` INTEGER(11) NOT NULL,
    `cantidad` INTEGER NOT NULL,
    PRIMARY KEY (`id_componente_combo`),
    UNIQUE (`combo_id`, `producto_componente_id`)
);

CREATE TABLE `Ingrediente` (
    `id_ingrediente` INTEGER(11) NOT NULL,
    `nombre_ingrediente` VARCHAR(200) NOT NULL,
    `descripcion` TEXT NOT NULL,
    `precio_adicional_extra` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_ingrediente`)
);

CREATE TABLE `Pizza_Ingrediente_Base` (
    `id_pizza_ingrediente_base` INTEGER(11) NOT NULL,
    `pizza_id` INTEGER(11) NOT NULL,
    `ingrediente_id` INTEGER(11) NOT NULL,
    PRIMARY KEY (`id_pizza_ingrediente_base`),
    UNIQUE (`pizza_id`, `ingrediente_id`)
);

CREATE TABLE `Presentacion_Pizza` (
    `id_presentacion_pizza` INTEGER(11) NOT NULL,
    `nombre_presentacion` VARCHAR(50) NOT NULL,
    `descripcion` TEXT NOT NULL,
    PRIMARY KEY (`id_presentacion_pizza`),
    UNIQUE (`nombre_presentacion`)
);

CREATE TABLE `Precio_Pizza_Por_Presentacion` (
    `id_precio_pizza_presentacion` INTEGER(11) NOT NULL,
    `pizza_id_presentacion` INTEGER(11) NOT NULL,
    `presentacion_pizza_id` INTEGER(11) NOT NULL,
    `precio_base` DECIMAL(10,2) NOT NULL,
    `fecha_inicio_vigencia` DATE NOT NULL,
    `fecha_fin_vigencia` DATE NOT NULL,
    PRIMARY KEY (`id_precio_pizza_presentacion`)
);

CREATE TABLE `Estado_Pedido` (
    `id_estado_pedido` INTEGER(11) NOT NULL,
    `nombre_estado` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`id_estado_pedido`),
    UNIQUE (`nombre_estado`)
);

CREATE TABLE `Detalle_Pedido_Ingrediente_Extra` (
    `id_detalle_pedido_ingrediente_extra` INTEGER(11) NOT NULL,
    `detalle_pedido_id` INTEGER(11) NOT NULL,
    `ingrediente_id_detalle` INTEGER(11) NOT NULL,
    `cantidad_extra` INTEGER NOT NULL,
    `precio_extra_aplicado` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_detalle_pedido_ingrediente_extra`)
);

ALTER TABLE `Departamento` ADD FOREIGN KEY (`pais_id_departamento`) REFERENCES `Pais`(`id_pais`);
ALTER TABLE `Ciudad` ADD FOREIGN KEY (`departamento_id_ciudad`) REFERENCES `Departamento`(`id_departamento`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`pais_id_direccion`) REFERENCES `Pais`(`id_pais`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`departamento_id_direccion`) REFERENCES `Departamento`(`id_departamento`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`ciudad_id_direccion`) REFERENCES `Ciudad`(`id_ciudad`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`cliente_id_direccion`) REFERENCES `Cliente`(`id_cliente`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`metodo_pago_id`) REFERENCES `Metodo_Pago`(`id_metodo_pago`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`estado_pedido_id`) REFERENCES `Estado_Pedido`(`id_estado_pedido`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`cliente_id_pedido`) REFERENCES `Detalles_Pedido`(`id_detalle_pedido`);
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