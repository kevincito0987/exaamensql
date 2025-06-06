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
DROP TABLE IF EXISTS `Conbos_detalles_pedidos`;

CREATE TABLE `Telefonos_Clientes` (
    `telefono_id` INTEGER(11) NOT NULL,
    `cliente_id` INTEGER(11) NOT NULL,
    PRIMARY KEY (`telefono_id`, `cliente_id`),
    UNIQUE (`telefono_id`, `cliente_id`),
    FOREIGN KEY (`telefono_id`) REFERENCES `Telefono`(`id_telefono`),
    FOREIGN KEY (`cliente_id`) REFERENCES `Cliente`(`id_cliente`)
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
    PRIMARY KEY (`combo_id`, `pedido_id`),
    UNIQUE (`combo_id`, `pedido_id`),
    FOREIGN KEY (`combo_id`) REFERENCES `Combos`(`id_combo`),
    FOREIGN KEY (`pedido_id`) REFERENCES `Pedidos`(`id_pedido`)
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
ALTER TABLE `Telefonos_Clientes` ADD FOREIGN KEY (`telefono_id`) REFERENCES `Telefono`(`id_telefono`);
ALTER TABLE `Telefonos_Clientes` ADD FOREIGN KEY (`cliente_id`) REFERENCES `Cliente`(`id_cliente`);
ALTER TABLE `Conbos_detalles_pedidos` ADD FOREIGN KEY (`combo_id`) REFERENCES `Combos`(`id_combo`);
ALTER TABLE `Conbos_detalles_pedidos` ADD FOREIGN KEY (`pedido_id`) REFERENCES `Pedidos`(`id_pedido`);


-- Insert sample data into the tables
INSERT INTO `Pais` (`id_pais`, `nombre_pais`, `codigo_ISO`) VALUES
(1, 'Colombia', 'CO'),
(2, 'Estados Unidos', 'US'),
(3, 'México', 'MX');

INSERT INTO `Departamento` (`id_departamento`, `pais_id_departamento`, `nombre_departamento`) VALUES
(1, 1, 'Antioquia'),
(2, 1, 'Cundinamarca'),
(3, 2, 'California'),
(4, 3, 'Jalisco');

INSERT INTO `Ciudad` (`id_ciudad`, `departamento_id_ciudad`, `pais_id_ciudad`, `nombre_ciudad`) VALUES
(1, 1, 1, 'Medellín'),
(2, 2, 1, 'Bogotá'),
(3, 3, 2, 'Los Ángeles'),
(4, 4, 3, 'Guadalajara');

INSERT INTO `Direccion` (`id_direccion`, `pais_id_direccion`, `departamento_id_direccion`, `ciudad_id_direccion`, `complemento`, `codigo_postal`) VALUES
(1, 1, 1, 1, 'Calle 10 #20-30', '050001'),
(2, 1, 2, 2, 'Avenida 5 #15-20', '110001'),
(3, 2, 3, 3, '123 Main St', '90001'),
(4, 3, 4, 4, '456 Elm St', '44100');

INSERT INTO `Cliente` (`id_cliente`, `nombre_cliente`, `direccion_cliente_id`, `telefono_id_cliente`) VALUES
(1, 'Juan Pérez', 1, 1),
(2, 'María Gómez', 2, 2),
(3, 'John Doe', 3, 3),
(4, 'Jane Smith', 4, 4);

INSERT INTO `Telefono` (`id_telefono`, `codigo_pais`, `numero`) VALUES
(1, '+57', '3001234567'),
(2, '+57', '3109876543'),
(3, '+1', '2134567890'),
(4, '+52', '3334567890');

INSERT INTO `Telefonos_Clientes` (`telefono_id`, `cliente_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO `tipos_bebidas` (`id_tipo_bebida`, `nombre_tipo_bebida`, `descripcion_tipo_bebida`) VALUES
(1, 'Gaseosa', 'Bebida carbonatada'),
(2, 'Agua', 'Agua purificada');
INSERT INTO `Bebidas` (`id_bebida`, `tipo_bebida_id`, `nombre_bebida`, `numero_litros`, `descripcion_bebida`, `valor_bebida`) VALUES
(1, 1, 'Coca-Cola', 2, 'Bebida gaseosa', 3.50),
(2, 1, 'Pepsi', 2, 'Bebida gaseosa', 3.00),
(3, 2, 'Agua Mineral', 1, 'Agua purificada', 1.50);

INSERT INTO `Tipos_Pizza` (`id_tipo_pizza`, `nombre_tipo_pizza`, `descripcion_tipo_pizza`) VALUES
(1, 'Delgada', 'Pizza con masa delgada'),
(2, 'Gruesa', 'Pizza con masa gruesa');

INSERT INTO `Pizza` (`id_pizza`, `tipo_pizza_id`, `nombre_pizza`, `descripcion_pizza`, `preparacion_pizza`, `tamaño_pizza`) VALUES
(1, 1, 'Margarita', 'Pizza con tomate y queso', 'Horneada a la perfección', 'Mediana'),
(2, 2, 'Pepperoni', 'Pizza con pepperoni y queso', 'Horneada con amor', 'Grande');

INSERT INTO `Ingredientes` (`id_ingrediente`, `nombre_ingrediente`, `precio_ingrediente`, `proveedor_ingrediente`, `descripcion_ingrediente`) VALUES
(1, 'Queso', 1.00, 'Proveedor A', 'Queso fresco'),
(2, 'Pepperoni', 1.50, 'Proveedor B', 'Rodajas de pepperoni'),
(3, 'Champiñones', 0.75, 'Proveedor C', 'Champiñones frescos');

-- Insert sample data into the Ingredientes_Pizza table
INSERT INTO `Ingredientes_Pizza` (`pizza_id`, `pizza_tipo_id`, `ingrediente_id`, `total_pizza`) VALUES
(1, 1, 1, 1.00),
(1, 1, 2, 1.50),
(2, 2, 2, 1.50),
(2, 2, 3, 0.75);

INSERT INTO `Combos` (`id_combo`, `nombre_combo`, `pizza_id_combo`, `bebida_id_combo`, `descripcion_combo`, `mas_ingredientes`, `valor_total_combo`) VALUES
(1, 'Combo Familiar', 1, 1, 'Incluye una pizza Margarita y una Coca-Cola', TRUE, 10.00),
(2, 'Combo Pareja', 2, 2, 'Incluye una pizza Pepperoni y una Pepsi', FALSE, 8.00);

INSERT INTO `Tipo_metodo_pago` (`id_tipo_metodo_pago`, `nombre_tipo_metodo_pago`, `descricpcion_tipo_metodo_pago`) VALUES
(1, 'Tarjeta', 'Pago con tarjeta de crédito o débito'),
(2, 'Efectivo', 'Pago en efectivo');

INSERT INTO `Metodo_Pago` (`id_metodo_pago`, `tipo_metodo_pago_id`, `nombre_metodo_pago`, `descripcion_metodo_pago`) VALUES
(1, 1, 'Tarjeta de Crédito', 'Pago con tarjeta de crédito'),
(2, 2, 'Efectivo', 'Pago en efectivo');

INSERT INTO `Detalles_Pedido` (`id_detalle_pedido`, `pedido_id_detalle`, `combo_id_detalle`, `valor_total`) VALUES
(1, 1, 1, 10.00),
(2, 2, 2, 8.00),
(3, 3, 1, 10.00),
(4, 4, 2, 8.00);

INSERT INTO `Conbos_detalles_pedidos` (`combo_id`, `pedido_id`) VALUES
(1, 1),
(2, 2),
(1, 3),
(2, 4);

-- Insert sample data into the Pedidos table
INSERT INTO `Pedidos` (`id_pedido`, `cliente_id_pedido`, `hora_pedido`, `metodo_pago_id`) VALUES
(1, 1, '12:30:00', 1),
(2, 2, '13:00:00', 2),
(3, 3, '14:15:00', 1),
(4, 4, '15:45:00', 2);