SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `Transacciones_Pago`;
DROP TABLE IF EXISTS `Facturacion`;
DROP TABLE IF EXISTS `Ingredientes_Pizza`;
DROP TABLE IF EXISTS `Detalle_Pedido_Ingrediente_Extra`;
DROP TABLE IF EXISTS `Detalles_Pedido`;
DROP TABLE IF EXISTS `Pedidos`;
DROP TABLE IF EXISTS `Metodo_Pago`;
DROP TABLE IF EXISTS `Tipo_metodo_pago`;
DROP TABLE IF EXISTS `Estado_Pedido`;
DROP TABLE IF EXISTS `Precio_Pizza_Por_Presentacion`;
DROP TABLE IF EXISTS `Presentacion_Pizza`;
DROP TABLE IF EXISTS `Pizza_Ingrediente_Base`;
DROP TABLE IF EXISTS `Ingrediente`;
DROP TABLE IF EXISTS `Componente_Combo`;
DROP TABLE IF EXISTS `Combo`;
DROP TABLE IF EXISTS `Bebida`;
DROP TABLE IF EXISTS `Pizza`;
DROP TABLE IF EXISTS `Precio_Vigente_Producto`;
DROP TABLE IF EXISTS `Producto`;
DROP TABLE IF EXISTS `Tipo_Producto`;
DROP TABLE IF EXISTS `Telefono_Clientes`;
DROP TABLE IF EXISTS `Tipo_Telefono`;
DROP TABLE IF EXISTS `Direccion`;
DROP TABLE IF EXISTS `Cliente`;
DROP TABLE IF EXISTS `Ciudad`;
DROP TABLE IF EXISTS `Departamento`;
DROP TABLE IF EXISTS `Pais`;

SET FOREIGN_KEY_CHECKS = 1;

--
-- Definición de Tablas con Claves Foráneas (FKs) integradas
--
-- Tabla: Pais
CREATE TABLE Pais (
    id_pais INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_pais VARCHAR(100) NOT NULL,
    codigo_iso CHAR(2) NOT NULL
);
-- Índices para búsqueda eficiente
CREATE UNIQUE INDEX idx_unique_pais_nombre_codigo ON Pais (nombre_pais, codigo_iso);


-- Tabla: Departamento
CREATE TABLE Departamento (
    id_departamento INTEGER PRIMARY KEY AUTO_INCREMENT,
    pais_id_departamento INTEGER NOT NULL,
    nombre_departamento VARCHAR(100) NOT NULL,
    FOREIGN KEY (pais_id_departamento) REFERENCES Pais(id_pais)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_departamento_pais_nombre ON Departamento (pais_id_departamento, nombre_departamento);
CREATE INDEX idx_fk_departamento_pais_id ON Departamento (pais_id_departamento);


-- Tabla: Ciudad
CREATE TABLE Ciudad (
    id_ciudad INTEGER PRIMARY KEY AUTO_INCREMENT,
    departamento_id_ciudad INTEGER NOT NULL,
    nombre_ciudad VARCHAR(100) NOT NULL,
    FOREIGN KEY (departamento_id_ciudad) REFERENCES Departamento(id_departamento)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_ciudad_departamento_nombre ON Ciudad (departamento_id_ciudad, nombre_ciudad);
CREATE INDEX idx_fk_ciudad_departamento_id ON Ciudad (departamento_id_ciudad);


-- Tabla: Cliente
CREATE TABLE Cliente (
    id_cliente INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombres_cliente VARCHAR(100) NOT NULL,
    apellidos_cliente VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    fecha_registro_cliente TIMESTAMP NOT NULL
);
-- Índices para búsqueda eficiente
CREATE INDEX idx_cliente_nombre_apellido ON Cliente (nombres_cliente, apellidos_cliente);
CREATE INDEX idx_cliente_fecha_registro ON Cliente (fecha_registro_cliente);


-- Tabla: Direccion
CREATE TABLE Direccion (
    id_direccion INTEGER PRIMARY KEY AUTO_INCREMENT,
    cliente_id_direccion INTEGER NOT NULL,
    ciudad_id_direccion INTEGER NOT NULL,
    complemento VARCHAR(255) NOT NULL,
    codigo_postal VARCHAR(20) NOT NULL,
    es_principal BOOLEAN NOT NULL,
    FOREIGN KEY (cliente_id_direccion) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (ciudad_id_direccion) REFERENCES Ciudad(id_ciudad)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_direccion_cliente_codigopostal ON Direccion (cliente_id_direccion, codigo_postal);
CREATE INDEX idx_fk_direccion_ciudad_id ON Direccion (ciudad_id_direccion);
CREATE INDEX idx_fk_direccion_cliente_id ON Direccion (cliente_id_direccion);
-- Índice opcional para búsquedas por si es principal (si es una consulta frecuente)
CREATE INDEX idx_direccion_es_principal ON Direccion (es_principal);


-- Tabla: Tipo_Telefono
CREATE TABLE Tipo_Telefono (
    id_tipo_telefono INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_telefono VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);
-- UNIQUE index on nombre_tipo_telefono handles indexing. No new index needed.


-- Tabla: Telefono_Clientes
CREATE TABLE Telefono_Clientes (
    id_telefono_cliente INTEGER PRIMARY KEY AUTO_INCREMENT,
    cliente_id_telefono INTEGER NOT NULL,
    codigo_pais VARCHAR(20) NOT NULL,
    numero_telefono VARCHAR(20) NOT NULL,
    tipo_telefono_id INTEGER NOT NULL,
    es_principal BOOLEAN NOT NULL,
    FOREIGN KEY (cliente_id_telefono) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (tipo_telefono_id) REFERENCES Tipo_Telefono(id_tipo_telefono)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_telefono_cliente_num ON Telefono_Clientes (cliente_id_telefono, codigo_pais, numero_telefono);
CREATE INDEX idx_fk_telefono_clientes_tipo_id ON Telefono_Clientes (tipo_telefono_id);
-- Índice opcional para búsquedas por si es principal
CREATE INDEX idx_telefono_clientes_es_principal ON Telefono_Clientes (es_principal);


-- Tabla: Tipo_Producto
CREATE TABLE Tipo_Producto (
    id_tipo_producto INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_producto VARCHAR(200) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);
-- UNIQUE index on nombre_tipo_producto handles indexing. No new index needed.


-- Tabla: Producto (General)
CREATE TABLE Producto (
    id_producto INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    tipo_producto_id INTEGER NOT NULL,
    esta_activo BOOLEAN NOT NULL,
    cantidad_stock INTEGER NOT NULL,
    FOREIGN KEY (tipo_producto_id) REFERENCES Tipo_Producto(id_tipo_producto)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_producto_nombre_tipo ON Producto (nombre_producto, tipo_producto_id);
CREATE INDEX idx_fk_producto_tipo_id ON Producto (tipo_producto_id);
-- Índices opcionales para filtrado y control de inventario
CREATE INDEX idx_producto_esta_activo ON Producto (esta_activo);
CREATE INDEX idx_producto_cantidad_stock ON Producto (cantidad_stock);


-- Tabla: Precio_Vigente_Producto
CREATE TABLE Precio_Vigente_Producto (
    id_precio_vigente_producto INTEGER PRIMARY KEY AUTO_INCREMENT,
    producto_id_precio INTEGER NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,
    FOREIGN KEY (producto_id_precio) REFERENCES Producto(id_producto)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_precio_vigente_producto_fecha ON Precio_Vigente_Producto (producto_id_precio, fecha_inicio_vigencia);
CREATE INDEX idx_fk_precio_vigente_producto_id ON Precio_Vigente_Producto (producto_id_precio);
-- Índice para búsquedas por rango de fechas
CREATE INDEX idx_precio_vigente_producto_fechas ON Precio_Vigente_Producto (fecha_inicio_vigencia, fecha_fin_vigencia);


-- Tabla: Pizza (Especialización de Producto)
CREATE TABLE Pizza (
    id_pizza INTEGER PRIMARY KEY, -- También FK a Producto
    instrucciones_preparacion TEXT NOT NULL,
    FOREIGN KEY (id_pizza) REFERENCES Producto(id_producto)
);
-- PK already provides index. No new index needed.


-- Tabla: Bebida (Especialización de Producto)
CREATE TABLE Bebida (
    id_bebida INTEGER PRIMARY KEY, -- También FK a Producto
    capacidad_ml INTEGER NOT NULL,
    capacidad VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_bebida) REFERENCES Producto(id_producto)
);
-- PK already provides index. No new index needed.


-- Tabla: Combo (Especialización de Producto)
CREATE TABLE Combo (
    id_combo INTEGER PRIMARY KEY, -- También FK a Producto
    nombre_combo VARCHAR(100) NOT NULL UNIQUE, -- Añadido UNIQUE por lógica de negocio
    FOREIGN KEY (id_combo) REFERENCES Producto(id_producto)
);
-- PK and UNIQUE index on nombre_combo already provide indexing. No new index needed.


-- Tabla: Componente_Combo
CREATE TABLE Componente_Combo (
    id_componente_combo INTEGER PRIMARY KEY AUTO_INCREMENT,
    combo_id INTEGER NOT NULL,
    producto_componente_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    FOREIGN KEY (combo_id) REFERENCES Combo(id_combo),
    FOREIGN KEY (producto_componente_id) REFERENCES Producto(id_producto)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_componente_combo_producto ON Componente_Combo (combo_id, producto_componente_id);
CREATE INDEX idx_fk_componente_combo_id ON Componente_Combo (combo_id);
CREATE INDEX idx_fk_componente_combo_producto_id ON Componente_Combo (producto_componente_id);


-- Tabla: Ingrediente
CREATE TABLE Ingrediente (
    id_ingrediente INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_ingrediente VARCHAR(200) NOT NULL UNIQUE, -- Añadido UNIQUE por lógica de negocio
    descripcion TEXT NOT NULL,
    precio_adicional_extra DECIMAL(10,2) NOT NULL
);
-- PK and UNIQUE index on nombre_ingrediente already provide indexing. No new index needed.


-- Tabla: Pizza_Ingrediente_Base
CREATE TABLE Pizza_Ingrediente_Base (
    id_pizza_ingrediente_base INTEGER PRIMARY KEY AUTO_INCREMENT,
    pizza_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    FOREIGN KEY (pizza_id) REFERENCES Pizza(id_pizza),
    FOREIGN KEY (ingrediente_id) REFERENCES Ingrediente(id_ingrediente)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_pizza_ingrediente_base ON Pizza_Ingrediente_Base (pizza_id, ingrediente_id);
CREATE INDEX idx_fk_pizza_ingrediente_base_pizza_id ON Pizza_Ingrediente_Base (pizza_id);
CREATE INDEX idx_fk_pizza_ingrediente_base_ingrediente_id ON Pizza_Ingrediente_Base (ingrediente_id);


-- Tabla: Presentacion_Pizza
CREATE TABLE Presentacion_Pizza (
    id_presentacion_pizza INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_presentacion VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);
-- PK and UNIQUE index on nombre_presentacion already provide indexing. No new index needed.


-- Tabla: Precio_Pizza_Por_Presentacion
CREATE TABLE Precio_Pizza_Por_Presentacion (
    id_precio_pizza_presentacion INTEGER PRIMARY KEY AUTO_INCREMENT,
    pizza_id_presentacion INTEGER NOT NULL,
    presentacion_pizza_id INTEGER NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,
    FOREIGN KEY (pizza_id_presentacion) REFERENCES Pizza(id_pizza),
    FOREIGN KEY (presentacion_pizza_id) REFERENCES Presentacion_Pizza(id_presentacion_pizza)
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_precio_pizza_presentacion_pizza_id ON Precio_Pizza_Por_Presentacion (pizza_id_presentacion);
CREATE INDEX idx_fk_precio_pizza_presentacion_presentacion_id ON Precio_Pizza_Por_Presentacion (presentacion_pizza_id);
-- Índice para búsquedas por rango de fechas
CREATE INDEX idx_precio_pizza_presentacion_fechas ON Precio_Pizza_Por_Presentacion (fecha_inicio_vigencia, fecha_fin_vigencia);


-- Tabla: Estado_Pedido
CREATE TABLE Estado_Pedido (
    id_estado_pedido INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_estado VARCHAR(50) NOT NULL UNIQUE
);
-- PK and UNIQUE index on nombre_estado already provide indexing. No new index needed.


-- Tabla: Tipo_metodo_pago
CREATE TABLE Tipo_metodo_pago (
    id_tipo_metodo_pago INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_metodo_pago VARCHAR(100) NOT NULL UNIQUE,
    descricpcion_tipo_metodo_pago TEXT NOT NULL
);
-- PK and UNIQUE index on nombre_tipo_metodo_pago already provide indexing. No new index needed.


-- Tabla: Metodo_Pago
CREATE TABLE Metodo_Pago (
    id_metodo_pago INTEGER PRIMARY KEY AUTO_INCREMENT,
    tipo_metodo_pago_id INTEGER NOT NULL,
    nombre_metodo_pago VARCHAR(100) NOT NULL,
    descripcion_metodo_pago TEXT NOT NULL,
    FOREIGN KEY (tipo_metodo_pago_id) REFERENCES Tipo_metodo_pago(id_tipo_metodo_pago)
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_metodo_pago_tipo_id ON Metodo_Pago (tipo_metodo_pago_id);
CREATE UNIQUE INDEX idx_unique_metodo_pago_nombre ON Metodo_Pago (nombre_metodo_pago); -- Asumo que el nombre es único


-- Tabla: Pedidos
CREATE TABLE Pedidos (
    id_pedido INTEGER PRIMARY KEY AUTO_INCREMENT,
    cliente_id_pedido INTEGER NOT NULL,
    fecha_hora_pedido TIMESTAMP NOT NULL,
    hora_recogida_estimada TIME NOT NULL,
    metodo_pago_id INTEGER NOT NULL,
    total_pedido DECIMAL(10,2) NOT NULL,
    estado_pedido_id INTEGER NOT NULL,
    pago_confirmado BOOLEAN NOT NULL,
    instrucciones_especiales_cliente TEXT NOT NULL,
    FOREIGN KEY (cliente_id_pedido) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (metodo_pago_id) REFERENCES Metodo_Pago(id_metodo_pago),
    FOREIGN KEY (estado_pedido_id) REFERENCES Estado_Pedido(id_estado_pedido)
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_pedidos_cliente_id ON Pedidos (cliente_id_pedido);
CREATE INDEX idx_fk_pedidos_metodo_pago_id ON Pedidos (metodo_pago_id);
CREATE INDEX idx_fk_pedidos_estado_pedido_id ON Pedidos (estado_pedido_id);
-- Índices para búsquedas por fecha/hora y estado
CREATE INDEX idx_pedidos_fecha_hora ON Pedidos (fecha_hora_pedido);
CREATE INDEX idx_pedidos_pago_confirmado ON Pedidos (pago_confirmado);


-- Tabla: Detalles_Pedido
CREATE TABLE Detalles_Pedido (
    id_detalle_pedido INTEGER PRIMARY KEY AUTO_INCREMENT,
    pedido_id_detalle INTEGER NOT NULL,
    producto_id_detalle INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario_aplicado DECIMAL(10,2) NOT NULL,
    presentacion_pizza_id_detalle INTEGER NOT NULL,
    subtotal_linea DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id_detalle) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (producto_id_detalle) REFERENCES Producto(id_producto),
    FOREIGN KEY (presentacion_pizza_id_detalle) REFERENCES Presentacion_Pizza(id_presentacion_pizza)
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_detalles_pedido_prod_pres ON Detalles_Pedido (pedido_id_detalle, producto_id_detalle, presentacion_pizza_id_detalle);
CREATE INDEX idx_fk_detalles_pedido_pedido_id ON Detalles_Pedido (pedido_id_detalle);
CREATE INDEX idx_fk_detalles_pedido_producto_id ON Detalles_Pedido (producto_id_detalle);
CREATE INDEX idx_fk_detalles_pedido_presentacion_id ON Detalles_Pedido (presentacion_pizza_id_detalle);


-- Tabla: Detalle_Pedido_Ingrediente_Extra
CREATE TABLE Detalle_Pedido_Ingrediente_Extra (
    id_detalle_pedido_ingrediente_extra INTEGER PRIMARY KEY AUTO_INCREMENT,
    detalle_pedido_id INTEGER NOT NULL,
    ingrediente_id_detalle INTEGER NOT NULL,
    cantidad_extra INTEGER NOT NULL,
    precio_extra_aplicado DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (detalle_pedido_id) REFERENCES Detalles_Pedido(id_detalle_pedido),
    FOREIGN KEY (ingrediente_id_detalle) REFERENCES Ingrediente(id_ingrediente)
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_detalle_pedido_ingrediente_extra_detalle_id ON Detalle_Pedido_Ingrediente_Extra (detalle_pedido_id);
CREATE INDEX idx_fk_detalle_pedido_ingrediente_extra_ingrediente_id ON Detalle_Pedido_Ingrediente_Extra (ingrediente_id_detalle);


-- Tabla: Ingredientes_Pizza (Nota: esta tabla en tu definición es diferente a Pizza_Ingrediente_Base)
-- Asumo que es una tabla de relación con un "tipo de pizza" y total, que parece más una tabla de informes o un diseño distinto.
-- Si es una tabla de relación M:M entre Pizza, Tipo_Pizza y Ingrediente, su PK compuesta ya la indexa.
CREATE TABLE Ingredientes_Pizza (
    pizza_id INTEGER NOT NULL,
    pizza_tipo_id INTEGER NOT NULL, -- Asumiendo que existe una tabla Tipo_Pizza para esta FK
    ingrediente_id INTEGER NOT NULL,
    total_pizza DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pizza_id, pizza_tipo_id, ingrediente_id),
    FOREIGN KEY (pizza_id) REFERENCES Pizza(id_pizza),
    FOREIGN KEY (ingrediente_id) REFERENCES Ingrediente(id_ingrediente)
    -- NOTA: Se asume que pizza_tipo_id es una FK a una tabla Tipo_Pizza, que no fue proporcionada.
    -- Si esa tabla existiera, la FK sería: FOREIGN KEY (pizza_tipo_id) REFERENCES Tipo_Pizza(id_tipo_pizza)
);
-- PK already provides index. No new index needed unless specific queries benefit from partial indexes.


-- Tabla: Facturacion (Facturas en tu definición)
CREATE TABLE Facturacion (
    id_factura INTEGER PRIMARY KEY AUTO_INCREMENT,
    pedido_id_factura INTEGER NOT NULL UNIQUE, -- UNIQUE para relación 1:1 con Pedido
    cliente_id_factura INTEGER NOT NULL,
    numero_factura VARCHAR(50) NOT NULL UNIQUE, -- El número de factura es único
    fecha_emision TIMESTAMP NOT NULL,
    subtotal_productos DECIMAL(10,2) NOT NULL,
    impuestos DECIMAL(10,2) NOT NULL,
    estado_factura VARCHAR(50) NOT NULL,
    total_factura DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id_factura) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (cliente_id_factura) REFERENCES Cliente(id_cliente)
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_facturacion_cliente_id ON Facturacion (cliente_id_factura);
CREATE INDEX idx_fk_facturacion_pedido_id ON Facturacion (pedido_id_factura); -- Aunque es UNIQUE, explícito para FK
CREATE INDEX idx_facturacion_fecha_emision ON Facturacion (fecha_emision);
CREATE INDEX idx_facturacion_estado ON Facturacion (estado_factura);


-- Tabla: Transacciones_Pago
CREATE TABLE Transacciones_Pago (
    id_transaccion INTEGER PRIMARY KEY AUTO_INCREMENT,
    factura_id_transaccion INTEGER NOT NULL,
    metodo_pago_id_transaccion INTEGER NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL,
    fecha_pago TIMESTAMP NOT NULL,
    referencia_externa VARCHAR(255) NOT NULL, -- Asumo NOT NULL para referencia
    FOREIGN KEY (factura_id_transaccion) REFERENCES Facturacion(id_factura),
    FOREIGN KEY (metodo_pago_id_transaccion) REFERENCES Metodo_Pago(id_metodo_pago)
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_transacciones_pago_factura_id ON Transacciones_Pago (factura_id_transaccion);
CREATE INDEX idx_fk_transacciones_pago_metodo_id ON Transacciones_Pago (metodo_pago_id_transaccion);
CREATE INDEX idx_transacciones_pago_fecha_pago ON Transacciones_Pago (fecha_pago);

-- #############################################################################
-- #                        INSERCIONES DE DATOS (15 por tabla)                  #
-- #############################################################################

-- Desactivar temporalmente la revisión de claves foráneas para evitar problemas de orden
SET FOREIGN_KEY_CHECKS=0;

-- Limpiar tablas antes de insertar (opcional, pero recomendado para ejecuciones limpias)
TRUNCATE TABLE Transacciones_Pago;
TRUNCATE TABLE Facturacion;
TRUNCATE TABLE Detalle_Pedido_Ingrediente_Extra;
TRUNCATE TABLE Detalles_Pedido;
TRUNCATE TABLE Pedidos;
TRUNCATE TABLE Metodo_Pago;
TRUNCATE TABLE Tipo_metodo_pago;
TRUNCATE TABLE Estado_Pedido;
TRUNCATE TABLE Precio_Pizza_Por_Presentacion;
TRUNCATE TABLE Presentacion_Pizza;
TRUNCATE TABLE Pizza_Ingrediente_Base;
TRUNCATE TABLE Ingrediente;
TRUNCATE TABLE Componente_Combo;
TRUNCATE TABLE Combo;
TRUNCATE TABLE Bebida;
TRUNCATE TABLE Pizza;
TRUNCATE TABLE Precio_Vigente_Producto;
TRUNCATE TABLE Producto;
TRUNCATE TABLE Tipo_Producto;
TRUNCATE TABLE Telefono_Clientes;
TRUNCATE TABLE Tipo_Telefono;
TRUNCATE TABLE Direccion;
TRUNCATE TABLE Cliente;
TRUNCATE TABLE Ciudad;
TRUNCATE TABLE Departamento;
TRUNCATE TABLE Pais;
-- La tabla Ingredientes_Pizza no se trunca porque no se insertarán datos debido a la FK faltante.


-- =============================================================================
-- TABLA: Pais
-- =============================================================================
INSERT INTO Pais (id_pais, nombre_pais, codigo_iso) VALUES
(1, 'Colombia', 'CO'),
(2, 'Estados Unidos', 'US'),
(3, 'España', 'ES'),
(4, 'México', 'MX'),
(5, 'Argentina', 'AR'),
(6, 'Canadá', 'CA'),
(7, 'Brasil', 'BR'),
(8, 'Francia', 'FR'),
(9, 'Alemania', 'DE'),
(10, 'Italia', 'IT'),
(11, 'Japón', 'JP'),
(12, 'Australia', 'AU'),
(13, 'Reino Unido', 'GB'),
(14, 'Chile', 'CL'),
(15, 'Perú', 'PE');

-- =============================================================================
-- TABLA: Departamento
-- =============================================================================
INSERT INTO Departamento (id_departamento, pais_id_departamento, nombre_departamento) VALUES
(1, 1, 'Santander'),
(2, 1, 'Antioquia'),
(3, 1, 'Cundinamarca'),
(4, 2, 'California'),
(5, 2, 'Florida'),
(6, 2, 'Texas'),
(7, 3, 'Madrid'),
(8, 3, 'Cataluña'),
(9, 4, 'Jalisco'),
(10, 4, 'Ciudad de México'),
(11, 5, 'Buenos Aires'),
(12, 6, 'Ontario'),
(13, 7, 'São Paulo'),
(14, 8, 'Isla de Francia'),
(15, 9, 'Berlín');

-- =============================================================================
-- TABLA: Ciudad
-- =============================================================================
INSERT INTO Ciudad (id_ciudad, departamento_id_ciudad, nombre_ciudad) VALUES
(1, 1, 'Bucaramanga'),
(2, 1, 'Floridablanca'),
(3, 2, 'Medellín'),
(4, 3, 'Bogotá'),
(5, 4, 'Los Ángeles'),
(6, 5, 'Miami'),
(7, 6, 'Houston'),
(8, 7, 'Madrid'),
(9, 8, 'Barcelona'),
(10, 9, 'Guadalajara'),
(11, 10, 'Ciudad de México'),
(12, 11, 'Buenos Aires'),
(13, 12, 'Toronto'),
(14, 13, 'São Paulo'),
(15, 14, 'París');

-- =============================================================================
-- TABLA: Cliente
-- =============================================================================
INSERT INTO Cliente (id_cliente, nombres_cliente, apellidos_cliente, email, fecha_registro_cliente) VALUES
(1, 'Juan', 'Pérez García', 'juan.perez@email.com', '2023-01-15 10:00:00'),
(2, 'Ana', 'Gómez López', 'ana.gomez@email.com', '2023-02-20 11:30:00'),
(3, 'Carlos', 'Rodríguez Martínez', 'carlos.rodriguez@email.com', '2023-03-05 14:00:00'),
(4, 'Sofía', 'Hernández Ruiz', 'sofia.hernandez@email.com', '2023-04-11 16:45:00'),
(5, 'Luis', 'Martín Díaz', 'luis.martin@email.com', '2023-05-18 09:00:00'),
(6, 'Lucía', 'Jiménez Moreno', 'lucia.jimenez@email.com', '2023-06-22 18:20:00'),
(7, 'Miguel', 'Sánchez Gil', 'miguel.sanchez@email.com', '2023-07-30 20:00:00'),
(8, 'Elena', 'Fernández Romero', 'elena.fernandez@email.com', '2023-08-14 12:10:00'),
(9, 'David', 'Torres Navarro', 'david.torres@email.com', '2023-09-01 13:00:00'),
(10, 'Laura', 'Vázquez Ramos', 'laura.vazquez@email.com', '2023-10-19 15:50:00'),
(11, 'Daniel', 'Morales Castro', 'daniel.morales@email.com', '2023-11-25 17:00:00'),
(12, 'Paula', 'Ortega Prieto', 'paula.ortega@email.com', '2023-12-08 19:30:00'),
(13, 'Javier', 'Serrano Domínguez', 'javier.serrano@email.com', '2024-01-20 21:00:00'),
(14, 'María', 'Reyes Soto', 'maria.reyes@email.com', '2024-02-28 08:45:00'),
(15, 'Adrián', 'Blanco Vidal', 'adrian.blanco@email.com', '2024-03-15 11:00:00');

-- =============================================================================
-- TABLA: Direccion
-- =============================================================================
INSERT INTO Direccion (id_direccion, cliente_id_direccion, ciudad_id_direccion, complemento, codigo_postal, es_principal) VALUES
(1, 1, 4, 'Apto 101, Edificio Central', '110111', 1),
(2, 2, 3, 'Casa 12, Barrio Laureles', '050031', 1),
(3, 3, 8, 'Piso 5, Puerta A, Gran Vía', '28013', 1),
(4, 4, 11, 'Colonia Roma Norte, Av. Insurgentes Sur 123', '06700', 1),
(5, 5, 12, 'Departamento 8B, Palermo', 'C1425', 1),
(6, 6, 9, 'Carrer de Balmes, 200', '08006', 1),
(7, 7, 5, 'Apt 25, Hollywood Hills', '90028', 1),
(8, 8, 6, 'Suite 305, South Beach', '33139', 1),
(9, 9, 1, 'Carrera 27 # 29-30, Sotomayor', '680003', 1),
(10, 10, 2, 'Calle 33 # 15-20, Cañaveral', '681004', 1),
(11, 11, 7, '123 Main St, Downtown', '77002', 1),
(12, 12, 13, 'Unit 4, Queen Street West', 'M5V 2A2', 1),
(13, 13, 14, 'Andar 10, Avenida Paulista', '01310-200', 1),
(14, 14, 15, 'Appartement 7, 8ème arrondissement', '75008', 1),
(15, 15, 4, 'Conjunto Residencial El Bosque, Torre 2 Apto 802', '110231', 0);

-- =============================================================================
-- TABLA: Tipo_Telefono (Valores de catálogo)
-- =============================================================================
INSERT INTO Tipo_Telefono (id_tipo_telefono, nombre_tipo_telefono, descripcion) VALUES
(1, 'Móvil', 'Teléfono celular personal.'),
(2, 'Casa', 'Teléfono fijo del domicilio.'),
(3, 'Trabajo', 'Teléfono de contacto laboral.'),
(4, 'Otro', 'Otro tipo de número de contacto.');

-- =============================================================================
-- TABLA: Telefono_Clientes
-- =============================================================================
INSERT INTO Telefono_Clientes (id_telefono_cliente, cliente_id_telefono, codigo_pais, numero_telefono, tipo_telefono_id, es_principal) VALUES
(1, 1, '+57', '3001234567', 1, 1),
(2, 2, '+57', '3109876543', 1, 1),
(3, 3, '+34', '600112233', 1, 1),
(4, 4, '+52', '5512345678', 1, 1),
(5, 5, '+54', '1198765432', 1, 1),
(6, 6, '+34', '611223344', 1, 1),
(7, 7, '+1', '3105550100', 1, 1),
(8, 8, '+1', '3055550199', 1, 1),
(9, 9, '+57', '3157654321', 1, 1),
(10, 10, '+57', '3182345678', 1, 1),
(11, 11, '+1', '7135551234', 1, 1),
(12, 12, '+1', '4165559876', 1, 1),
(13, 13, '+55', '11912345678', 1, 1),
(14, 14, '+33', '612345678', 1, 1),
(15, 15, '+57', '3208765432', 2, 0);

-- =============================================================================
-- TABLA: Tipo_Producto (Valores de catálogo)
-- =============================================================================
INSERT INTO Tipo_Producto (id_tipo_producto, nombre_tipo_producto, descripcion) VALUES
(1, 'Pizza', 'Pizzas artesanales con diversos ingredientes.'),
(2, 'Bebida', 'Bebidas refrescantes, sodas y jugos.'),
(3, 'Combo', 'Paquetes que incluyen varios productos con descuento.'),
(4, 'Postre', 'Opciones dulces para después de la comida.'),
(5, 'Adicional', 'Ingredientes o productos extra para complementar el pedido.');

-- =============================================================================
-- TABLA: Producto
-- =============================================================================
INSERT INTO Producto (id_producto, nombre_producto, descripcion, tipo_producto_id, esta_activo, cantidad_stock) VALUES
-- Pizzas (5)
(1, 'Pizza de Pepperoni', 'Clásica pizza con base de tomate, mozzarella y abundante pepperoni.', 1, 1, 100),
(2, 'Pizza Hawaiana', 'Polémica pero deliciosa pizza con piña, jamón y queso.', 1, 1, 100),
(3, 'Pizza Carnívora', 'Para los amantes de la carne: pepperoni, salchicha italiana, jamón y tocineta.', 1, 1, 80),
(4, 'Pizza Vegetariana', 'Saludable mezcla de pimientos, champiñones, cebolla, aceitunas y tomate.', 1, 1, 90),
(5, 'Pizza de Pollo BBQ', 'Exquisita combinación de pollo a la parrilla, salsa BBQ y cebolla roja.', 1, 1, 70),
-- Bebidas (5)
(6, 'Coca-Cola', 'Refresco de cola carbonatado.', 2, 1, 500),
(7, 'Jugo de Naranja Natural', 'Jugo recién exprimido, sin aditivos.', 2, 1, 200),
(8, 'Agua Mineral', 'Agua de manantial sin gas.', 2, 1, 400),
(9, 'Cerveza Club Colombia', 'Cerveza lager nacional.', 2, 1, 150),
(10, 'Té Helado de Limón', 'Té negro refrescante con un toque de limón.', 2, 1, 250),
-- Combos (5)
(11, 'Combo Amigos', '2 Pizzas Medianas (cualquier sabor) + 1 Gaseosa 1.5L', 3, 1, 50),
(12, 'Combo Personal', '1 Pizza Personal + 1 Gaseosa personal', 3, 1, 100),
(13, 'Combo Familiar', '1 Pizza Familiar + 1 Pizza Mediana dulce + 1 Gaseosa 2L', 3, 1, 40),
(14, 'Combo Pareja', '2 Pizzas Personales + 2 Bebidas Personales + 1 Postre', 3, 1, 60),
(15, 'Combo Fiesta', '4 Pizzas Familiares + 4 Gaseosas 2L', 3, 1, 20);

-- =============================================================================
-- TABLA: Precio_Vigente_Producto
-- =============================================================================
INSERT INTO Precio_Vigente_Producto (id_precio_vigente_producto, producto_id_precio, precio_base, fecha_inicio_vigencia, fecha_fin_vigencia) VALUES
-- Precios para productos que no son pizzas (bebidas, combos)
(1, 6, 4000.00, '2023-01-01', '2025-12-31'), -- Coca-Cola
(2, 7, 6000.00, '2023-01-01', '2025-12-31'), -- Jugo de Naranja
(3, 8, 3000.00, '2023-01-01', '2025-12-31'), -- Agua Mineral
(4, 9, 5500.00, '2023-01-01', '2025-12-31'), -- Cerveza
(5, 10, 4500.00, '2023-01-01', '2025-12-31'), -- Té Helado
(6, 11, 70000.00, '2023-01-01', '2025-12-31'), -- Combo Amigos
(7, 12, 25000.00, '2023-01-01', '2025-12-31'), -- Combo Personal
(8, 13, 95000.00, '2023-01-01', '2025-12-31'), -- Combo Familiar
(9, 14, 55000.00, '2023-01-01', '2025-12-31'), -- Combo Pareja
(10, 15, 200000.00, '2023-01-01', '2025-12-31'), -- Combo Fiesta
(11, 1, 0.00, '2023-01-01', '2025-12-31'), -- Pizza (precio base en presentación)
(12, 2, 0.00, '2023-01-01', '2025-12-31'), -- Pizza (precio base en presentación)
(13, 3, 0.00, '2023-01-01', '2025-12-31'), -- Pizza (precio base en presentación)
(14, 4, 0.00, '2023-01-01', '2025-12-31'), -- Pizza (precio base en presentación)
(15, 5, 0.00, '2023-01-01', '2025-12-31'); -- Pizza (precio base en presentación)

-- =============================================================================
-- TABLA: Pizza (Especialización)
-- =============================================================================
INSERT INTO Pizza (id_pizza, instrucciones_preparacion) VALUES
(1, 'Hornear a 220°C por 12 minutos. Base de tomate, queso mozzarella y pepperoni.'),
(2, 'Hornear a 220°C por 13 minutos. Base de tomate, queso, jamón y trozos de piña.'),
(3, 'Hornear a 230°C por 15 minutos. Cargar generosamente con todas las carnes.'),
(4, 'Hornear a 210°C por 14 minutos. Distribuir los vegetales uniformemente.'),
(5, 'Hornear a 220°C por 14 minutos. Añadir la salsa BBQ en espiral antes de hornear.');

-- =============================================================================
-- TABLA: Bebida (Especialización)
-- =============================================================================
INSERT INTO Bebida (id_bebida, capacidad_ml, capacidad) VALUES
(6, 500, '500 ml'),
(7, 350, '350 ml'),
(8, 600, '600 ml'),
(9, 330, '330 ml'),
(10, 450, '450 ml');

-- =============================================================================
-- TABLA: Combo (Especialización)
-- =============================================================================
INSERT INTO Combo (id_combo, nombre_combo) VALUES
(11, 'Combo Amigos'),
(12, 'Combo Personal'),
(13, 'Combo Familiar'),
(14, 'Combo Pareja'),
(15, 'Combo Fiesta');

-- =============================================================================
-- TABLA: Componente_Combo
-- =============================================================================
INSERT INTO Componente_Combo (id_componente_combo, combo_id, producto_componente_id, cantidad) VALUES
(1, 11, 1, 2), -- 2 pizzas pepperoni para Combo Amigos
(2, 11, 6, 1), -- 1 Coca-Cola para Combo Amigos
(3, 12, 2, 1), -- 1 Pizza Hawaiana para Combo Personal
(4, 12, 7, 1), -- 1 Jugo para Combo Personal
(5, 13, 3, 1), -- 1 Pizza Carnivora para Combo Familiar
(6, 13, 5, 1), -- 1 Pizza Pollo BBQ para Combo Familiar
(7, 13, 6, 2), -- 2 Coca-colas para Combo Familiar
(8, 14, 4, 2), -- 2 Pizzas Vegetarianas para Combo Pareja
(9, 14, 8, 2), -- 2 Aguas para Combo Pareja
(10, 15, 1, 1), -- ... Se asume que los componentes varían y aquí se registran
(11, 15, 2, 1),
(12, 15, 3, 1),
(13, 15, 4, 1),
(14, 15, 6, 4),
(15, 11, 2, 0); -- Ejemplo de un componente opcional (cantidad 0), si la lógica lo permite


-- =============================================================================
-- TABLA: Ingrediente
-- =============================================================================
INSERT INTO Ingrediente (id_ingrediente, nombre_ingrediente, descripcion, precio_adicional_extra) VALUES
(1, 'Queso Mozzarella Extra', 'Doble porción de nuestro queso mozzarella de alta calidad.', 4500.00),
(2, 'Pepperoni', 'Rodajas de salami curado y especiado.', 3500.00),
(3, 'Jamón', 'Finas lonjas de jamón de cerdo.', 3000.00),
(4, 'Piña', 'Trozos de piña dulce en almíbar.', 2500.00),
(5, 'Champiñones Frescos', 'Champiñones laminados y salteados.', 3000.00),
(6, 'Tocineta Ahumada', 'Crujientes tiras de tocineta ahumada.', 4000.00),
(7, 'Salchicha Italiana', 'Salchicha de cerdo con hinojo y especias.', 4000.00),
(8, 'Pimiento Verde', 'Tiras de pimiento verde fresco.', 2000.00),
(9, 'Cebolla Roja', 'Rodajas finas de cebolla roja.', 1500.00),
(10, 'Aceitunas Negras', 'Aceitunas negras sin hueso.', 2500.00),
(11, 'Pollo a la Parrilla', 'Trozos de pechuga de pollo marinados y asados.', 5000.00),
(12, 'Salsa BBQ', 'Salsa barbacoa con un toque dulce y ahumado.', 2000.00),
(13, 'Maíz Dulce', 'Granos de maíz tierno.', 2000.00),
(14, 'Tomate en Rodajas', 'Rodajas de tomate fresco.', 1500.00),
(15, 'Anchoas', 'Filetes de anchoa en aceite de oliva.', 5500.00);

-- =============================================================================
-- TABLA: Pizza_Ingrediente_Base (Ingredientes por defecto de cada pizza)
-- =============================================================================
-- Pizza Pepperoni (1)
INSERT INTO Pizza_Ingrediente_Base (pizza_id, ingrediente_id) VALUES (1, 1), (1, 2);
-- Pizza Hawaiana (2)
INSERT INTO Pizza_Ingrediente_Base (pizza_id, ingrediente_id) VALUES (2, 1), (2, 3), (2, 4);
-- Pizza Carnívora (3)
INSERT INTO Pizza_Ingrediente_Base (pizza_id, ingrediente_id) VALUES (3, 1), (3, 2), (3, 6), (3, 7);
-- Pizza Vegetariana (4)
INSERT INTO Pizza_Ingrediente_Base (pizza_id, ingrediente_id) VALUES (4, 1), (4, 5), (4, 8), (4, 9), (4, 10);
-- Pizza Pollo BBQ (5)
INSERT INTO Pizza_Ingrediente_Base (pizza_id, ingrediente_id) VALUES (5, 1), (5, 9), (5, 11), (5, 12);
-- Rellenando para llegar a 15... (se puede repetir o añadir más combinaciones base)
INSERT INTO Pizza_Ingrediente_Base (pizza_id, ingrediente_id) VALUES
(1, 3), -- Pepperoni con Jamón
(2, 6), -- Hawaiana con Tocineta
(3, 5), -- Carnívora con Champiñones
(4, 13), -- Vegetariana con Maíz
(5, 6); -- Pollo BBQ con Tocineta


-- =============================================================================
-- TABLA: Presentacion_Pizza (Valores de catálogo)
-- =============================================================================
INSERT INTO Presentacion_Pizza (id_presentacion_pizza, nombre_presentacion, descripcion) VALUES
(1, 'Personal', 'Pizza individual, ideal para una persona (4 porciones).'),
(2, 'Mediana', 'Para compartir entre 2-3 personas (8 porciones).'),
(3, 'Familiar', 'Perfecta para un grupo de 4-5 personas (12 porciones).'),
(4, 'Gigante', 'El tamaño más grande para fiestas (16 porciones).');

-- =============================================================================
-- TABLA: Precio_Pizza_Por_Presentacion
-- =============================================================================
-- Precios para Pizza Pepperoni (1)
INSERT INTO Precio_Pizza_Por_Presentacion (pizza_id_presentacion, presentacion_pizza_id, precio_base, fecha_inicio_vigencia, fecha_fin_vigencia) VALUES
(1, 1, 18000.00, '2023-01-01', '2025-12-31'),
(1, 2, 32000.00, '2023-01-01', '2025-12-31'),
(1, 3, 45000.00, '2023-01-01', '2025-12-31'),
-- Precios para Pizza Hawaiana (2)
(2, 1, 19000.00, '2023-01-01', '2025-12-31'),
(2, 2, 34000.00, '2023-01-01', '2025-12-31'),
(2, 3, 48000.00, '2023-01-01', '2025-12-31'),
-- Precios para Pizza Carnívora (3)
(3, 1, 22000.00, '2023-01-01', '2025-12-31'),
(3, 2, 38000.00, '2023-01-01', '2025-12-31'),
(3, 3, 55000.00, '2023-01-01', '2025-12-31'),
-- Precios para Pizza Vegetariana (4)
(4, 1, 17000.00, '2023-01-01', '2025-12-31'),
(4, 2, 30000.00, '2023-01-01', '2025-12-31'),
(4, 3, 42000.00, '2023-01-01', '2025-12-31'),
-- Precios para Pizza Pollo BBQ (5)
(5, 1, 21000.00, '2023-01-01', '2025-12-31'),
(5, 2, 37000.00, '2023-01-01', '2025-12-31'),
(5, 3, 52000.00, '2023-01-01', '2025-12-31');


-- =============================================================================
-- TABLA: Estado_Pedido (Valores de catálogo)
-- =============================================================================
INSERT INTO Estado_Pedido (id_estado_pedido, nombre_estado) VALUES
(1, 'Recibido'),
(2, 'Confirmado'),
(3, 'En preparación'),
(4, 'Listo para recoger'),
(5, 'En camino'),
(6, 'Entregado'),
(7, 'Cancelado');

-- =============================================================================
-- TABLA: Tipo_metodo_pago (Valores de catálogo)
-- =============================================================================
INSERT INTO Tipo_metodo_pago (id_tipo_metodo_pago, nombre_tipo_metodo_pago, descricpcion_tipo_metodo_pago) VALUES
(1, 'Tarjeta de Crédito', 'Pago con tarjeta de crédito Visa, MasterCard, etc.'),
(2, 'Tarjeta de Débito', 'Pago con tarjeta de débito con fondos de cuenta bancaria.'),
(3, 'Efectivo', 'Pago en efectivo al momento de la entrega o recogida.'),
(4, 'Plataforma en línea', 'Pago a través de pasarelas como PSE, PayPal, etc.'),
(5, 'Nequi/Daviplata', 'Pago a través de aplicaciones móviles bancarias.');

-- =============================================================================
-- TABLA: Metodo_Pago
-- =============================================================================
INSERT INTO Metodo_Pago (id_metodo_pago, tipo_metodo_pago_id, nombre_metodo_pago, descripcion_metodo_pago) VALUES
(1, 1, 'Visa', 'Tarjeta de crédito Visa.'),
(2, 1, 'MasterCard', 'Tarjeta de crédito MasterCard.'),
(3, 2, 'Débito Bancolombia', 'Tarjeta débito de Bancolombia.'),
(4, 3, 'Efectivo Contra Entrega', 'Pago en efectivo al recibir el pedido.'),
(5, 4, 'PSE', 'Pagos Seguros en Línea Colombia.'),
(6, 5, 'Nequi', 'Pago desde la aplicación Nequi.'),
(7, 5, 'Daviplata', 'Pago desde la aplicación Daviplata.'),
(8, 1, 'American Express', 'Tarjeta de crédito American Express.'),
(9, 2, 'Débito Davivienda', 'Tarjeta débito de Davivienda.'),
(10, 4, 'PayPal', 'Pasarela de pago internacional PayPal.'),
(11, 3, 'Efectivo en Tienda', 'Pago en efectivo al recoger en el local.'),
(12, 1, 'Diners Club', 'Tarjeta de crédito Diners Club.'),
(13, 2, 'Maestro', 'Tarjeta débito Maestro.'),
(14, 4, 'Wompi', 'Pasarela de pagos de Bancolombia.'),
(15, 5, 'Ahorro a la Mano', 'Pago desde la aplicación de Bancolombia.');


-- =============================================================================
-- TABLA: Pedidos
-- =============================================================================
INSERT INTO Pedidos (id_pedido, cliente_id_pedido, fecha_hora_pedido, hora_recogida_estimada, metodo_pago_id, total_pedido, estado_pedido_id, pago_confirmado, instrucciones_especiales_cliente) VALUES
(1, 1, '2024-05-10 19:30:00', '20:15:00', 1, 53500.00, 6, 1, 'Sin cebolla, por favor.'),
(2, 2, '2024-05-10 20:00:00', '20:45:00', 4, 34000.00, 6, 1, 'Bien caliente.'),
(3, 3, '2024-05-11 12:00:00', '12:40:00', 2, 99000.00, 6, 1, 'Cortar la pizza en 16 porciones.'),
(4, 4, '2024-05-11 13:15:00', '14:00:00', 5, 42000.00, 6, 1, 'Dejar en portería.'),
(5, 5, '2024-05-12 18:00:00', '18:45:00', 6, 21000.00, 6, 1, 'Extra salsa BBQ.'),
(6, 6, '2024-05-12 19:00:00', '19:40:00', 7, 79000.00, 6, 1, 'Gracias!'),
(7, 7, '2024-05-13 20:30:00', '21:10:00', 8, 38000.00, 5, 1, 'Timbrar en el apto 502.'),
(8, 8, '2024-05-13 21:00:00', '21:45:00', 9, 52000.00, 4, 1, 'Llamar al llegar.'),
(9, 9, '2024-05-14 19:45:00', '20:25:00', 10, 18000.00, 3, 1, 'Sin aceitunas.'),
(10, 10, '2024-05-14 20:10:00', '20:50:00', 11, 32000.00, 2, 0, 'Cliente recoge.'),
(11, 11, '2024-05-15 18:30:00', '19:15:00', 12, 59500.00, 1, 0, 'Adicionar borde de queso.'),
(12, 12, '2024-05-15 19:00:00', '19:40:00', 13, 100000.00, 1, 0, 'Dos salsas de ajo.'),
(13, 13, '2024-05-16 12:30:00', '13:10:00', 14, 30000.00, 7, 0, 'Cancelado por el cliente.'),
(14, 14, '2024-05-16 14:00:00', '14:45:00', 15, 55000.00, 1, 0, 'Factura a nombre de la empresa XYZ.'),
(15, 15, '2024-05-16 20:00:00', '20:40:00', 4, 25000.00, 1, 0, 'Piso 3, sin ascensor.');


-- =============================================================================
-- TABLA: Detalles_Pedido
-- =============================================================================
INSERT INTO Detalles_Pedido (id_detalle_pedido, pedido_id_detalle, producto_id_detalle, cantidad, precio_unitario_aplicado, presentacion_pizza_id_detalle, subtotal_linea) VALUES
(1, 1, 1, 1, 45000.00, 3, 45000.00), -- Pedido 1: Pizza Pepperoni Familiar
(2, 1, 6, 2, 4000.00, 1, 8000.00),   -- Pedido 1: 2 Coca-Colas (asumo pres. 1 = N/A para no pizza)
(3, 2, 2, 1, 34000.00, 2, 34000.00), -- Pedido 2: Pizza Hawaiana Mediana
(4, 3, 3, 1, 55000.00, 3, 55000.00), -- Pedido 3: Pizza Carnívora Familiar
(5, 3, 1, 1, 42000.00, 3, 42000.00), -- Pedido 3: Pizza Vegetariana Familiar
(6, 4, 4, 1, 42000.00, 3, 42000.00), -- Pedido 4: Pizza Vegetariana Familiar
(7, 5, 5, 1, 21000.00, 1, 21000.00), -- Pedido 5: Pizza Pollo BBQ Personal
(8, 6, 11, 1, 70000.00, 2, 70000.00),-- Pedido 6: Combo Amigos (asumo pres. 2 = mediana)
(9, 6, 8, 2, 3000.00, 1, 6000.00),   -- Pedido 6: 2 Aguas Adicionales
(10, 7, 3, 1, 38000.00, 2, 38000.00),-- Pedido 7: Pizza Carnívora Mediana
(11, 8, 5, 1, 52000.00, 3, 52000.00),-- Pedido 8: Pizza Pollo BBQ Familiar
(12, 9, 1, 1, 18000.00, 1, 18000.00),-- Pedido 9: Pizza Pepperoni Personal
(13, 10, 1, 1, 32000.00, 2, 32000.00),-- Pedido 10: Pizza Pepperoni Mediana
(14, 11, 2, 1, 34000.00, 2, 34000.00),-- Pedido 11: Pizza Hawaiana Mediana
(15, 11, 10, 2, 4500.00, 1, 9000.00);  -- Pedido 11: 2 Tés Helados

-- =============================================================================
-- TABLA: Detalle_Pedido_Ingrediente_Extra
-- =============================================================================
INSERT INTO Detalle_Pedido_Ingrediente_Extra (id_detalle_pedido_ingrediente_extra, detalle_pedido_id, ingrediente_id_detalle, cantidad_extra, precio_extra_aplicado) VALUES
(1, 1, 6, 1, 4000.00),   -- Pedido 1, Detalle 1: Extra Tocineta para la Pepperoni
(2, 1, 1, 1, 4500.00),   -- Pedido 1, Detalle 1: Extra Queso para la Pepperoni
(3, 4, 11, 1, 5000.00),  -- Pedido 3, Detalle 4: Extra Pollo para la Carnívora
(4, 5, 13, 1, 2000.00),  -- Pedido 3, Detalle 5: Extra Maíz para la Vegetariana
(5, 7, 12, 2, 4000.00),  -- Pedido 5, Detalle 7: Doble Salsa BBQ
(6, 10, 5, 1, 3000.00),  -- Pedido 7, Detalle 10: Champiñones para la Carnívora
(7, 12, 6, 1, 4000.00),  -- Pedido 9, Detalle 12: Tocineta para la Pepperoni
(8, 14, 1, 1, 4500.00),  -- Pedido 11, Detalle 14: Extra Queso para la Hawaiana
(9, 1, 5, 1, 3000.00),   -- más...
(10, 2, 1, 1, 4500.00),
(11, 3, 2, 1, 3500.00),
(12, 4, 3, 1, 3000.00),
(13, 5, 4, 1, 2500.00),
(14, 6, 7, 1, 4000.00),
(15, 7, 8, 1, 2000.00);

-- =============================================================================
-- TABLA: Facturacion
-- =============================================================================
-- Solo se facturan los pedidos entregados y confirmados
INSERT INTO Facturacion (id_factura, pedido_id_factura, cliente_id_factura, numero_factura, fecha_emision, subtotal_productos, impuestos, estado_factura, total_factura) VALUES
(1, 1, 1, 'FE-2024-0001', '2024-05-10 20:15:01', 53000.00, 500.00, 'Pagada', 53500.00),
(2, 2, 2, 'FE-2024-0002', '2024-05-10 20:45:02', 34000.00, 0.00, 'Pagada', 34000.00),
(3, 3, 3, 'FE-2024-0003', '2024-05-11 12:40:03', 97000.00, 2000.00, 'Pagada', 99000.00),
(4, 4, 4, 'FE-2024-0004', '2024-05-11 14:00:04', 42000.00, 0.00, 'Pagada', 42000.00),
(5, 5, 5, 'FE-2024-0005', '2024-05-12 18:45:05', 21000.00, 0.00, 'Pagada', 21000.00),
(6, 6, 6, 'FE-2024-0006', '2024-05-12 19:40:06', 76000.00, 3000.00, 'Pagada', 79000.00),
(8, 8, 8, 'FE-2024-0008', '2024-05-13 21:45:08', 52000.00, 0.00, 'Pendiente', 52000.00),
(9, 9, 9, 'FE-2024-0009', '2024-05-14 20:25:09', 18000.00, 0.00, 'Pagada', 18000.00),
(10, 10, 10, 'FE-2024-0010', '2024-05-14 20:50:10', 32000.00, 0.00, 'Pendiente', 32000.00),
(11, 11, 11, 'FE-2024-0011', '2024-05-15 19:15:11', 43000.00, 500.00, 'Pendiente', 43500.00),
(12, 12, 12, 'FE-2024-0012', '2024-05-15 19:40:12', 100000.00, 0.00, 'Pendiente', 100000.00),
(13, 14, 14, 'FE-2024-0013', '2024-05-16 14:45:13', 55000.00, 0.00, 'Pendiente', 55000.00),
(14, 15, 15, 'FE-2024-0014', '2024-05-16 20:40:14', 25000.00, 0.00, 'Pendiente', 25000.00),
-- Se omite el pedido 13 que fue cancelado
(15, 7, 7, 'FE-2024-0015-DUPLICADA', '2024-05-13 21:10:07', 38000.00, 0.00, 'Anulada', 38000.00); -- Ejemplo de factura anulada


-- =============================================================================
-- TABLA: Transacciones_Pago
-- =============================================================================
INSERT INTO Transacciones_Pago (id_transaccion, factura_id_transaccion, metodo_pago_id_transaccion, monto_pagado, fecha_pago, referencia_externa) VALUES
(1, 1, 1, 53500.00, '2024-05-10 19:30:05', 'TXN_VISA_001'),
(2, 2, 4, 34000.00, '2024-05-10 20:45:10', 'CASH_ENTREGA_001'),
(3, 3, 2, 99000.00, '2024-05-11 12:00:15', 'TXN_MC_001'),
(4, 4, 5, 42000.00, '2024-05-11 13:15:20', 'PSE_REF_98765'),
(5, 5, 6, 21000.00, '2024-05-12 18:00:25', 'NEQUI_REF_ABCDE'),
(6, 6, 7, 79000.00, '2024-05-12 19:00:30', 'DAVI_REF_FGHIJ'),
(7, 9, 10, 18000.00, '2024-05-14 19:45:35', 'PAYPAL_ID_12345'),
-- El resto de facturas están pendientes de pago, por lo que no tienen transacción.
-- Rellenando para llegar a 15, simulando pagos parciales o posteriores
(8, 7, 8, 38000.00, '2024-05-14 10:00:00', 'TXN_AMEX_001'),
(9, 8, 9, 52000.00, '2024-05-15 11:00:00', 'DEBITO_DAV_REF_111'),
(10, 10, 11, 32000.00, '2024-05-15 12:00:00', 'CASH_TIENDA_002'),
(11, 11, 12, 43500.00, '2024-05-16 13:00:00', 'TXN_DINERS_001'),
(12, 12, 13, 100000.00, '2024-05-17 14:00:00', 'DEBITO_MAE_REF_222'),
(13, 13, 14, 55000.00, '2024-05-18 15:00:00', 'WOMPI_REF_333'),
(14, 14, 15, 25000.00, '2024-05-19 16:00:00', 'AHM_REF_444'),
(15, 1, 1, 0.00, '2024-05-10 20:20:00', 'TXN_VISA_001_ANULACION'); -- Ejemplo de una anulación de pago

-- Reactivar la revisión de claves foráneas
SET FOREIGN_KEY_CHECKS=1;


-- ============================================================================= Selects

-- Selección de datos de un cliente
SELECT * FROM Cliente;

-- Selección de datos de un direccion
SELECT * FROM Direccion;

-- Selección de datos de un tipo de telefono
SELECT * FROM Tipo_Telefono;

-- Selección de datos de un telefono
SELECT * FROM Telefono_Clientes;

-- Selección de datos de un tipo de producto
SELECT * FROM Tipo_Producto;

-- Selección de datos de un producto
SELECT * FROM Producto;

-- Selección de datos de un precio de producto
SELECT * FROM Precio_Vigente_Producto;

-- Selección de datos de una pizza
SELECT * FROM Pizza;

-- Selección de datos de una bebida
SELECT * FROM Bebida;

-- Selección de datos de un combo
SELECT * FROM Combo;

-- Selección de datos de un componente de un combo
SELECT * FROM Componente_Combo;

-- Selección de datos de un ingrediente
SELECT * FROM Ingrediente;

-- Selección de datos de una pizza con ingredientes
SELECT * FROM Pizza_Ingrediente_Base;

-- Selección de datos de una presentación de pizza
SELECT * FROM Presentacion_Pizza;

-- Selección de datos de un precio de pizza por presentación
SELECT * FROM Precio_Pizza_Por_Presentacion;

-- Selección de datos de un estado de pedido
SELECT * FROM Estado_Pedido;

-- Selección de datos de un tipo de método de pago
SELECT * FROM Tipo_metodo_pago;

-- Selección de datos de un método de pago
SELECT * FROM Metodo_Pago;

-- Selección de datos de un pedido
SELECT * FROM Pedidos;

-- Selección de datos de detalles de un pedido
SELECT * FROM Detalles_Pedido;

-- Selección de datos de detalles de un pedido con ingredientes adicionales
SELECT * FROM Detalle_Pedido_Ingrediente_Extra;

-- Selección de datos de ingredientes de una pizza
SELECT * FROM Ingredientes_Pizza;

-- Selección de datos de facturación
SELECT * FROM Facturacion;

-- Selección de datos de transacciones de pago
SELECT * FROM Transacciones_Pago;

-- Mostrar indexes de las tablas

SHOW INDEXES FROM Pais;
SHOW INDEXES FROM Departamento;
SHOW INDEXES FROM Ciudad;
SHOW INDEXES FROM Cliente;
SHOW INDEXES FROM Direccion;
SHOW INDEXES FROM Tipo_Telefono;
SHOW INDEXES FROM Telefono_Clientes;
SHOW INDEXES FROM Tipo_Producto;
SHOW INDEXES FROM Producto;
SHOW INDEXES FROM Precio_Vigente_Producto;
SHOW INDEXES FROM Pizza;
SHOW INDEXES FROM Bebida;
SHOW INDEXES FROM Combo;
SHOW INDEXES FROM Componente_Combo;
SHOW INDEXES FROM Ingrediente;
SHOW INDEXES FROM Pizza_Ingrediente_Base;
SHOW INDEXES FROM Presentacion_Pizza;
SHOW INDEXES FROM Precio_Pizza_Por_Presentacion;
SHOW INDEXES FROM Estado_Pedido;
SHOW INDEXES FROM Tipo_metodo_pago;
SHOW INDEXES FROM Metodo_Pago;
SHOW INDEXES FROM Pedidos;
SHOW INDEXES FROM Detalles_Pedido;
SHOW INDEXES FROM Detalle_Pedido_Ingrediente_Extra;
SHOW INDEXES FROM Ingredientes_Pizza;
SHOW INDEXES FROM Facturacion;
SHOW INDEXES FROM Transacciones_Pago;