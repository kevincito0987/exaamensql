SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `Pais`;
DROP TABLE IF EXISTS `Departamento`;
DROP TABLE IF EXISTS `Ciudad`;
DROP TABLE IF EXISTS `Direccion`;
DROP TABLE IF EXISTS `Cliente`;
DROP TABLE IF EXISTS `Bebidas`;
DROP TABLE IF EXISTS `Tipos_Pizza`;
DROP TABLE IF EXISTS `Pizza`;
DROP TABLE IF EXISTS `Ingredientes`;
DROP TABLE IF EXISTS `Ingredientes_Pizza`;
DROP TABLE IF EXISTS `Pedidos`;
DROP TABLE IF EXISTS `Combos`;
DROP TABLE IF EXISTS `Metodo_Pago`;
DROP TABLE IF EXISTS `Detalles_Pedido`;
DROP TABLE IF EXISTS `tipos_bebidas`;
DROP TABLE IF EXISTS `Telefono`;
DROP TABLE IF EXISTS `Telefonos_Clientes`;
DROP TABLE IF EXISTS `Tipo_metodo_pago`;
DROP TABLE IF EXISTS `Conbos_detalles_pedidos`;
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
    PRIMARY KEY (`id_departamento`)
);

CREATE TABLE `Ciudad` (
    `id_ciudad` INTEGER(11) NOT NULL,
    `departamento_id_ciudad` INTEGER(11) NOT NULL,
    `pais_id_ciudad` INTEGER(11) NOT NULL,
    `nombre_ciudad` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_ciudad`)
);

CREATE TABLE `Direccion` (
    `id_direccion` INTEGER(11) NOT NULL,
    `pais_id_direccion` INTEGER(11) NOT NULL,
    `departamento_id_direccion` INTEGER(11) NOT NULL,
    `ciudad_id_direccion` INTEGER(11) NOT NULL,
    `complemento` VARCHAR(255) NOT NULL,
    `codigo_postal` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id_direccion`),
    UNIQUE (`codigo_postal`)
);

CREATE TABLE `Cliente` (
    `id_cliente` INTEGER(11) NOT NULL,
    `nombre_cliente` VARCHAR(255) NOT NULL,
    `direccion_cliente_id` INTEGER(11) NOT NULL,
    `telefono_id_cliente` INTEGER(11) NOT NULL,
    PRIMARY KEY (`id_cliente`)
);

CREATE TABLE `Bebidas` (
    `id_bebida` INTEGER(11) NOT NULL,
    `tipo_bebida_id` INTEGER(11) NOT NULL,
    `nombre_bebida` VARCHAR(100) NOT NULL,
    `numero_litros` INTEGER NOT NULL,
    `descripcion_bebida` TEXT NOT NULL,
    `valor_bebida` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_bebida`)
);

CREATE TABLE `Tipos_Pizza` (
    `id_tipo_pizza` INTEGER(11) NOT NULL,
    `nombre_tipo_pizza` VARCHAR(255) NOT NULL,
    `descripcion_tipo_pizza` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_pizza`)
);

CREATE TABLE `Pizza` (
    `id_pizza` INTEGER(11) NOT NULL,
    `tipo_pizza_id` INTEGER(11) NOT NULL,
    `nombre_pizza` VARCHAR(255) NOT NULL,
    `descripcion_pizza` TEXT NOT NULL,
    `preparacion_pizza` TEXT NOT NULL,
    `tamaño_pizza` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_pizza`)
);

CREATE TABLE `Ingredientes` (
    `id_ingrediente` INTEGER(11) NOT NULL,
    `nombre_ingrediente` VARCHAR(255) NOT NULL,
    `precio_ingrediente` DECIMAL(10,2) NOT NULL,
    `proveedor_ingrediente` VARCHAR(100) NOT NULL,
    `descripcion_ingrediente` TEXT,
    PRIMARY KEY (`id_ingrediente`)
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
    `hora_pedido` TIME NOT NULL,
    `metodo_pago_id` INTEGER(11) NOT NULL,
    PRIMARY KEY (`id_pedido`)
);

CREATE TABLE `Combos` (
    `id_combo` INTEGER(11) NOT NULL,
    `nombre_combo` VARCHAR(100) NOT NULL,
    `pizza_id_combo` INTEGER(11) NOT NULL,
    `bebida_id_combo` INTEGER(11) NOT NULL,
    `descripcion_combo` TEXT NOT NULL,
    `mas_ingredientes` BOOLEAN NOT NULL,
    `valor_total_combo` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_combo`)
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
    `combo_id_detalle` INTEGER(11) NOT NULL,
    `valor_total` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_detalle_pedido`)
);

CREATE TABLE `tipos_bebidas` (
    `id_tipo_bebida` INTEGER(11) NOT NULL,
    `nombre_tipo_bebida` VARCHAR(100) NOT NULL,
    `descripcion_tipo_bebida` TEXT,
    PRIMARY KEY (`id_tipo_bebida`)
);

CREATE TABLE `Telefono` (
    `id_telefono` INTEGER(11) NOT NULL,
    `codigo_pais` VARCHAR(6) NOT NULL,
    `numero` VARCHAR(10) NOT NULL,
    PRIMARY KEY (`id_telefono`)
);

CREATE TABLE `Telefonos_Clientes` (
    `telefono_id` INTEGER(11) NOT NULL,
    `cliente_id` INTEGER(11) NOT NULL,
    PRIMARY KEY (`telefono_id`, `cliente_id`)
);

CREATE TABLE `Tipo_metodo_pago` (
    `id_tipo_metodo_pago` INTEGER(11) NOT NULL,
    `nombre_tipo_metodo_pago` VARCHAR(100) NOT NULL,
    `descricpcion_tipo_metodo_pago` TEXT NOT NULL,
    PRIMARY KEY (`id_tipo_metodo_pago`)
);

CREATE TABLE `Conbos_detalles_pedidos` (
    `combo_id` INTEGER(11) NOT NULL,
    `pedido_id` INTEGER(11) NOT NULL,
    PRIMARY KEY (`combo_id`, `pedido_id`)
);

ALTER TABLE `Departamento` ADD FOREIGN KEY (`pais_id_departamento`) REFERENCES `Pais`(`id_pais`);
ALTER TABLE `Ciudad` ADD FOREIGN KEY (`departamento_id_ciudad`) REFERENCES `Departamento`(`id_departamento`);
ALTER TABLE `Ciudad` ADD FOREIGN KEY (`pais_id_ciudad`) REFERENCES `Pais`(`id_pais`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`departamento_id_direccion`) REFERENCES `Departamento`(`id_departamento`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`pais_id_direccion`) REFERENCES `Pais`(`id_pais`);
ALTER TABLE `Direccion` ADD FOREIGN KEY (`ciudad_id_direccion`) REFERENCES `Ciudad`(`id_ciudad`);
ALTER TABLE `Cliente` ADD FOREIGN KEY (`direccion_cliente_id`) REFERENCES `Direccion`(`id_direccion`);
ALTER TABLE `Cliente` ADD FOREIGN KEY (`telefono_id_cliente`) REFERENCES `Telefonos_Clientes`(`telefono_id`);
ALTER TABLE `Bebidas` ADD FOREIGN KEY (`tipo_bebida_id`) REFERENCES `tipos_bebidas`(`id_tipo_bebida`);
ALTER TABLE `Pizza` ADD FOREIGN KEY (`tipo_pizza_id`) REFERENCES `Tipos_Pizza`(`id_tipo_pizza`);
ALTER TABLE `Ingredientes_Pizza` ADD FOREIGN KEY (`ingrediente_id`) REFERENCES `Ingredientes`(`id_ingrediente`);
ALTER TABLE `Ingredientes_Pizza` ADD FOREIGN KEY (`pizza_id`) REFERENCES `Pizza`(`id_pizza`);
ALTER TABLE `Ingredientes_Pizza` ADD FOREIGN KEY (`pizza_tipo_id`) REFERENCES `Tipos_Pizza`(`id_tipo_pizza`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`metodo_pago_id`) REFERENCES `Metodo_Pago`(`id_metodo_pago`);
ALTER TABLE `Pedidos` ADD FOREIGN KEY (`cliente_id_pedido`) REFERENCES `Detalles_Pedido`(`id_detalle_pedido`);
ALTER TABLE `Combos` ADD FOREIGN KEY (`pizza_id_combo`) REFERENCES `Pizza`(`id_pizza`);
ALTER TABLE `Combos` ADD FOREIGN KEY (`bebida_id_combo`) REFERENCES `Bebidas`(`id_bebida`);
ALTER TABLE `Metodo_Pago` ADD FOREIGN KEY (`tipo_metodo_pago_id`) REFERENCES `Tipo_metodo_pago`(`id_tipo_metodo_pago`);
ALTER TABLE `Detalles_Pedido` ADD FOREIGN KEY (`pedido_id_detalle`) REFERENCES `Conbos_detalles_pedidos`(`pedido_id`);
ALTER TABLE `Detalles_Pedido` ADD FOREIGN KEY (`combo_id_detalle`) REFERENCES `Conbos_detalles_pedidos`(`combo_id`);
ALTER TABLE `Telefonos_Clientes` ADD FOREIGN KEY (`telefono_id`) REFERENCES `Telefono`(`id_telefono`);
ALTER TABLE `Telefonos_Clientes` ADD FOREIGN KEY (`cliente_id`) REFERENCES `Cliente`(`id_cliente`);
ALTER TABLE `Conbos_detalles_pedidos` ADD FOREIGN KEY (`combo_id`) REFERENCES `Combos`(`id_combo`);
ALTER TABLE `Conbos_detalles_pedidos` ADD FOREIGN KEY (`pedido_id`) REFERENCES `Pedidos`(`id_pedido`);