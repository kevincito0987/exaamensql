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
    codigo_iso CHAR(2) NOT NULL,
    UNIQUE (nombre_pais, codigo_iso)
);

-- Tabla: Departamento
CREATE TABLE Departamento (
    id_departamento INTEGER PRIMARY KEY AUTO_INCREMENT,
    pais_id_departamento INTEGER NOT NULL,
    nombre_departamento VARCHAR(100) NOT NULL,
    FOREIGN KEY (pais_id_departamento) REFERENCES Pais(id_pais) ON DELETE CASCADE,
    UNIQUE (pais_id_departamento, nombre_departamento)
);
CREATE INDEX idx_fk_departamento_pais_id ON Departamento (pais_id_departamento);

-- Tabla: Ciudad
CREATE TABLE Ciudad (
    id_ciudad INTEGER PRIMARY KEY AUTO_INCREMENT,
    departamento_id_ciudad INTEGER NOT NULL,
    nombre_ciudad VARCHAR(100) NOT NULL,
    FOREIGN KEY (departamento_id_ciudad) REFERENCES Departamento(id_departamento) ON DELETE CASCADE,
    UNIQUE (departamento_id_ciudad, nombre_ciudad)
);
CREATE INDEX idx_fk_ciudad_departamento_id ON Ciudad (departamento_id_ciudad);

-- Tabla: Cliente
CREATE TABLE Cliente (
    id_cliente INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombres_cliente VARCHAR(100) NOT NULL,
    apellidos_cliente VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    fecha_registro_cliente TIMESTAMP NOT NULL
);
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
    FOREIGN KEY (cliente_id_direccion) REFERENCES Cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (ciudad_id_direccion) REFERENCES Ciudad(id_ciudad) ON DELETE CASCADE,
    UNIQUE (cliente_id_direccion, codigo_postal)
);
CREATE INDEX idx_fk_direccion_ciudad_id ON Direccion (ciudad_id_direccion);
CREATE INDEX idx_fk_direccion_cliente_id ON Direccion (cliente_id_direccion);
CREATE INDEX idx_direccion_es_principal ON Direccion (es_principal);

-- Tabla: Tipo_Telefono
CREATE TABLE Tipo_Telefono (
    id_tipo_telefono INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_telefono VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);

-- Tabla: Telefono_Clientes
CREATE TABLE Telefono_Clientes (
    id_telefono_cliente INTEGER PRIMARY KEY AUTO_INCREMENT,
    cliente_id_telefono INTEGER NOT NULL,
    codigo_pais VARCHAR(20) NOT NULL,
    numero_telefono VARCHAR(20) NOT NULL,
    tipo_telefono_id INTEGER NOT NULL,
    es_principal BOOLEAN NOT NULL,
    FOREIGN KEY (cliente_id_telefono) REFERENCES Cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (tipo_telefono_id) REFERENCES Tipo_Telefono(id_tipo_telefono) ON DELETE RESTRICT,
    UNIQUE (cliente_id_telefono, codigo_pais, numero_telefono)
);
CREATE INDEX idx_fk_telefono_clientes_tipo_id ON Telefono_Clientes (tipo_telefono_id);
CREATE INDEX idx_telefono_clientes_es_principal ON Telefono_Clientes (es_principal);

-- Tabla: Tipo_Producto
CREATE TABLE Tipo_Producto (
    id_tipo_producto INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_producto VARCHAR(200) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);

-- Tabla: Producto
CREATE TABLE Producto (
    id_producto INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    tipo_producto_id INTEGER NOT NULL,
    esta_activo BOOLEAN NOT NULL,
    cantidad_stock INTEGER NOT NULL,
    FOREIGN KEY (tipo_producto_id) REFERENCES Tipo_Producto(id_tipo_producto) ON DELETE RESTRICT,
    UNIQUE (nombre_producto, tipo_producto_id)
);
CREATE INDEX idx_fk_producto_tipo_id ON Producto (tipo_producto_id);
CREATE INDEX idx_producto_esta_activo ON Producto (esta_activo);
CREATE INDEX idx_producto_cantidad_stock ON Producto (cantidad_stock);

-- Tabla: Precio_Vigente_Producto
CREATE TABLE Precio_Vigente_Producto (
    id_precio_vigente_producto INTEGER PRIMARY KEY AUTO_INCREMENT,
    producto_id_precio INTEGER NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,
    FOREIGN KEY (producto_id_precio) REFERENCES Producto(id_producto) ON DELETE CASCADE,
    UNIQUE (producto_id_precio, fecha_inicio_vigencia)
);
CREATE INDEX idx_fk_precio_vigente_producto_id ON Precio_Vigente_Producto (producto_id_precio);
CREATE INDEX idx_precio_vigente_producto_fechas ON Precio_Vigente_Producto (fecha_inicio_vigencia, fecha_fin_vigencia);

-- Tabla: Pizza (Especialización de Producto)
CREATE TABLE Pizza (
    id_pizza INTEGER PRIMARY KEY,
    instrucciones_preparacion TEXT NOT NULL,
    FOREIGN KEY (id_pizza) REFERENCES Producto(id_producto) ON DELETE CASCADE
);

-- Tabla: Bebida (Especialización de Producto)
CREATE TABLE Bebida (
    id_bebida INTEGER PRIMARY KEY,
    capacidad_ml INTEGER NOT NULL,
    capacidad VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_bebida) REFERENCES Producto(id_producto) ON DELETE CASCADE
);

-- Tabla: Combo (Especialización de Producto)
CREATE TABLE Combo (
    id_combo INTEGER PRIMARY KEY,
    nombre_combo VARCHAR(100) NOT NULL UNIQUE,
    FOREIGN KEY (id_combo) REFERENCES Producto(id_producto) ON DELETE CASCADE
);

-- Tabla: Componente_Combo
CREATE TABLE Componente_Combo (
    id_componente_combo INTEGER PRIMARY KEY AUTO_INCREMENT,
    combo_id INTEGER NOT NULL,
    producto_componente_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    FOREIGN KEY (combo_id) REFERENCES Combo(id_combo) ON DELETE CASCADE,
    FOREIGN KEY (producto_componente_id) REFERENCES Producto(id_producto) ON DELETE RESTRICT,
    UNIQUE (combo_id, producto_componente_id)
);
CREATE INDEX idx_fk_componente_combo_id ON Componente_Combo (combo_id);
CREATE INDEX idx_fk_componente_combo_producto_id ON Componente_Combo (producto_componente_id);

-- Tabla: Ingrediente
CREATE TABLE Ingrediente (
    id_ingrediente INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_ingrediente VARCHAR(200) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL,
    precio_adicional_extra DECIMAL(10,2) NOT NULL
);

-- Tabla: Pizza_Ingrediente_Base
CREATE TABLE Pizza_Ingrediente_Base (
    id_pizza_ingrediente_base INTEGER PRIMARY KEY AUTO_INCREMENT,
    pizza_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    FOREIGN KEY (pizza_id) REFERENCES Pizza(id_pizza) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_id) REFERENCES Ingrediente(id_ingrediente) ON DELETE RESTRICT,
    UNIQUE (pizza_id, ingrediente_id)
);
CREATE INDEX idx_fk_pizza_ingrediente_base_pizza_id ON Pizza_Ingrediente_Base (pizza_id);
CREATE INDEX idx_fk_pizza_ingrediente_base_ingrediente_id ON Pizza_Ingrediente_Base (ingrediente_id);

-- Tabla: Presentacion_Pizza
CREATE TABLE Presentacion_Pizza (
    id_presentacion_pizza INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_presentacion VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);

-- Tabla: Precio_Pizza_Por_Presentacion
CREATE TABLE Precio_Pizza_Por_Presentacion (
    id_precio_pizza_presentacion INTEGER PRIMARY KEY AUTO_INCREMENT,
    pizza_id_presentacion INTEGER NOT NULL,
    presentacion_pizza_id INTEGER NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,
    FOREIGN KEY (pizza_id_presentacion) REFERENCES Pizza(id_pizza) ON DELETE CASCADE,
    FOREIGN KEY (presentacion_pizza_id) REFERENCES Presentacion_Pizza(id_presentacion_pizza) ON DELETE CASCADE
);
CREATE INDEX idx_fk_precio_pizza_presentacion_pizza_id ON Precio_Pizza_Por_Presentacion (pizza_id_presentacion);
CREATE INDEX idx_fk_precio_pizza_presentacion_presentacion_id ON Precio_Pizza_Por_Presentacion (presentacion_pizza_id);
CREATE INDEX idx_precio_pizza_presentacion_fechas ON Precio_Pizza_Por_Presentacion (fecha_inicio_vigencia, fecha_fin_vigencia);

-- Tabla: Estado_Pedido
CREATE TABLE Estado_Pedido (
    id_estado_pedido INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_estado VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla: Tipo_metodo_pago
CREATE TABLE Tipo_metodo_pago (
    id_tipo_metodo_pago INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo_metodo_pago VARCHAR(100) NOT NULL UNIQUE,
    descricpcion_tipo_metodo_pago TEXT NOT NULL
);

-- Tabla: Metodo_Pago
CREATE TABLE Metodo_Pago (
    id_metodo_pago INTEGER PRIMARY KEY AUTO_INCREMENT,
    tipo_metodo_pago_id INTEGER NOT NULL,
    nombre_metodo_pago VARCHAR(100) NOT NULL,
    descripcion_metodo_pago TEXT NOT NULL,
    FOREIGN KEY (tipo_metodo_pago_id) REFERENCES Tipo_metodo_pago(id_tipo_metodo_pago) ON DELETE RESTRICT,
    UNIQUE (nombre_metodo_pago)
);
CREATE INDEX idx_fk_metodo_pago_tipo_id ON Metodo_Pago (tipo_metodo_pago_id);

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
    FOREIGN KEY (cliente_id_pedido) REFERENCES Cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES Metodo_Pago(id_metodo_pago) ON DELETE RESTRICT,
    FOREIGN KEY (estado_pedido_id) REFERENCES Estado_Pedido(id_estado_pedido) ON DELETE RESTRICT
);
CREATE INDEX idx_fk_pedidos_cliente_id ON Pedidos (cliente_id_pedido);
CREATE INDEX idx_fk_pedidos_metodo_pago_id ON Pedidos (metodo_pago_id);
CREATE INDEX idx_fk_pedidos_estado_pedido_id ON Pedidos (estado_pedido_id);
CREATE INDEX idx_pedidos_fecha_hora ON Pedidos (fecha_hora_pedido);
CREATE INDEX idx_pedidos_pago_confirmado ON Pedidos (pago_confirmado);

-- Tabla: Detalles_Pedido
CREATE TABLE Detalles_Pedido (
    id_detalle_pedido INTEGER PRIMARY KEY AUTO_INCREMENT,
    pedido_id_detalle INTEGER NOT NULL,
    producto_id_detalle INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    presentacion_pizza_id_detalle INTEGER NOT NULL,
    subtotal_linea DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id_detalle) REFERENCES Pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (producto_id_detalle) REFERENCES Producto(id_producto) ON DELETE RESTRICT,
    FOREIGN KEY (presentacion_pizza_id_detalle) REFERENCES Presentacion_Pizza(id_presentacion_pizza) ON DELETE RESTRICT,
    UNIQUE (pedido_id_detalle, producto_id_detalle, presentacion_pizza_id_detalle)
);
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
    FOREIGN KEY (detalle_pedido_id) REFERENCES Detalles_Pedido(id_detalle_pedido) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_id_detalle) REFERENCES Ingrediente(id_ingrediente) ON DELETE RESTRICT
);
CREATE INDEX idx_fk_detalle_pedido_ingrediente_extra_detalle_id ON Detalle_Pedido_Ingrediente_Extra (detalle_pedido_id);
CREATE INDEX idx_fk_detalle_pedido_ingrediente_extra_ingrediente_id ON Detalle_Pedido_Ingrediente_Extra (ingrediente_id_detalle);

-- Tabla: Ingredientes_Pizza
CREATE TABLE Ingredientes_Pizza (
    pizza_id INTEGER NOT NULL,
    pizza_tipo_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    total_pizza DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pizza_id, pizza_tipo_id, ingrediente_id),
    FOREIGN KEY (pizza_id) REFERENCES Pizza(id_pizza) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_id) REFERENCES Ingrediente(id_ingrediente) ON DELETE RESTRICT
);

-- Tabla: Facturacion
CREATE TABLE Facturacion (
    id_factura INTEGER PRIMARY KEY AUTO_INCREMENT,
    pedido_id_factura INTEGER NOT NULL UNIQUE,
    cliente_id_factura INTEGER NOT NULL,
    numero_factura VARCHAR(50) NOT NULL UNIQUE,
    fecha_emision TIMESTAMP NOT NULL,
    subtotal_productos DECIMAL(10,2) NOT NULL,
    impuestos DECIMAL(10,2) NOT NULL,
    estado_factura VARCHAR(50) NOT NULL,
    total_factura DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id_factura) REFERENCES Pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id_factura) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);
CREATE INDEX idx_fk_facturacion_cliente_id ON Facturacion (cliente_id_factura);
CREATE INDEX idx_fk_facturacion_pedido_id ON Facturacion (pedido_id_factura);
CREATE INDEX idx_facturacion_fecha_emision ON Facturacion (fecha_emision);
CREATE INDEX idx_facturacion_estado ON Facturacion (estado_factura);

-- Tabla: Transacciones_Pago
CREATE TABLE Transacciones_Pago (
    id_transaccion INTEGER PRIMARY KEY AUTO_INCREMENT,
    factura_id_transaccion INTEGER NOT NULL,
    metodo_pago_id_transaccion INTEGER NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL,
    fecha_pago TIMESTAMP NOT NULL,
    referencia_externa VARCHAR(255) NOT NULL,
    FOREIGN KEY (factura_id_transaccion) REFERENCES Facturacion(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (metodo_pago_id_transaccion) REFERENCES Metodo_Pago(id_metodo_pago) ON DELETE RESTRICT
);
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
-- Desactivar temporalmente las comprobaciones de claves foráneas para facilitar la inserción
-- Desactivar temporalmente las comprobaciones de claves foráneas para facilitar la inserción
-- Desactivar temporalmente las comprobaciones de claves foráneas para facilitar la inserción
SET FOREIGN_KEY_CHECKS = 0;

-- Inserts para Tabla: Pais
INSERT INTO Pais (id_pais, nombre_pais, codigo_iso) VALUES
(1, 'Colombia', 'CO'),
(2, 'México', 'MX'),
(3, 'Argentina', 'AR'),
(4, 'Chile', 'CL'),
(5, 'Perú', 'PE'),
(6, 'España', 'ES'),
(7, 'Estados Unidos', 'US'),
(8, 'Canadá', 'CA'),
(9, 'Brasil', 'BR'),
(10, 'Francia', 'FR'),
(11, 'Alemania', 'DE'),
(12, 'Italia', 'IT'),
(13, 'Reino Unido', 'GB'),
(14, 'Australia', 'AU'),
(15, 'Japón', 'JP');

-- Inserts para Tabla: Departamento (usando IDs de Pais del 1 al 15)
INSERT INTO Departamento (id_departamento, pais_id_departamento, nombre_departamento) VALUES
(1, 1, 'Cundinamarca'), (2, 1, 'Antioquia'), (3, 1, 'Valle del Cauca'), (4, 2, 'Ciudad de México'), (5, 2, 'Jalisco'),
(6, 3, 'Buenos Aires'), (7, 3, 'Córdoba'), (8, 4, 'Santiago'), (9, 4, 'Valparaíso'), (10, 5, 'Lima'),
(11, 5, 'Arequipa'), (12, 6, 'Madrid'), (13, 7, 'California'), (14, 8, 'Ontario'), (15, 9, 'São Paulo');

-- Inserts para Tabla: Ciudad (usando IDs de Departamento del 1 al 15)
INSERT INTO Ciudad (id_ciudad, departamento_id_ciudad, nombre_ciudad) VALUES
(1, 1, 'Bogotá'), (2, 2, 'Medellín'), (3, 3, 'Cali'), (4, 4, 'Ciudad de México'), (5, 5, 'Guadalajara'),
(6, 6, 'Buenos Aires'), (7, 7, 'Córdoba'), (8, 8, 'Santiago'), (9, 9, 'Valparaíso'), (10, 10, 'Lima'),
(11, 11, 'Arequipa'), (12, 12, 'Madrid'), (13, 13, 'Los Ángeles'), (14, 14, 'Toronto'), (15, 15, 'São Paulo');

-- Inserts para Tabla: Cliente
INSERT INTO Cliente (id_cliente, nombres_cliente, apellidos_cliente, email, fecha_registro_cliente) VALUES
(1, 'Juan', 'Pérez', 'juan.perez@example.com', '2023-01-10 10:00:00'),
(2, 'Maria', 'Gómez', 'maria.gomez@example.com', '2023-01-15 11:30:00'),
(3, 'Carlos', 'López', 'carlos.lopez@example.com', '2023-02-01 09:45:00'),
(4, 'Ana', 'Rodríguez', 'ana.rodriguez@example.com', '2023-02-05 14:00:00'),
(5, 'Pedro', 'Martínez', 'pedro.martinez@example.com', '2023-03-01 16:15:00'),
(6, 'Laura', 'Hernández', 'laura.hernandez@example.com', '2023-03-10 10:30:00'),
(7, 'Miguel', 'Díaz', 'miguel.diaz@example.com', '2023-04-01 12:00:00'),
(8, 'Sofía', 'Fernández', 'sofia.fernandez@example.com', '2023-04-05 08:45:00'),
(9, 'Javier', 'González', 'javier.gonzalez@example.com', '2023-05-01 13:20:00'),
(10, 'Valeria', 'Ruiz', 'valeria.ruiz@example.com', '2023-05-10 17:00:00'),
(11, 'Ricardo', 'Silva', 'ricardo.silva@example.com', '2023-06-01 09:00:00'),
(12, 'Isabella', 'Torres', 'isabella.torres@example.com', '2023-06-05 11:00:00'),
(13, 'Andrés', 'Ramírez', 'andres.ramirez@example.com', '2023-07-01 14:30:00'),
(14, 'Gabriela', 'Flores', 'gabriela.flores@example.com', '2023-07-05 16:45:00'),
(15, 'Diego', 'Benítez', 'diego.benítez@example.com', '2023-08-01 10:10:00');

-- Inserts para Tabla: Direccion (usando IDs de Cliente del 1 al 15 y Ciudad del 1 al 15)
INSERT INTO Direccion (id_direccion, cliente_id_direccion, ciudad_id_direccion, complemento, codigo_postal, es_principal) VALUES
(1, 1, 1, 'Calle 10 # 20-30, Apto 101', '110111', TRUE),
(2, 2, 2, 'Carrera 50 # 15-25, Casa 2', '050010', TRUE),
(3, 3, 3, 'Avenida 3N # 4-50, Oficina 302', '760042', FALSE),
(4, 4, 4, 'Reforma 100, Piso 5', '06600', TRUE),
(5, 5, 5, 'Av. Chapultepec 200, Local 1', '44100', TRUE),
(6, 6, 6, 'Santa Fe 1234, Dpto 8B', 'C1060AAB', TRUE),
(7, 7, 7, 'Independencia 500, Of. 10', 'X5000ICU', FALSE),
(8, 8, 8, 'Avenida Libertador O-1200, Depto 45', '8320000', TRUE),
(9, 9, 9, 'Calle Prat 789, Local 3', '2340000', FALSE),
(10, 10, 10, 'Jiron Larco 123, Piso 7', '15074', TRUE),
(11, 11, 11, 'Av. Ejercito 1500, Interior 2', '04000', FALSE),
(12, 12, 12, 'Gran Via 50, Escalera A, 3 Derecha', '28013', TRUE),
(13, 13, 13, 'Sunset Blvd 1000, Apt 10', '90028', TRUE),
(14, 14, 14, 'Yonge St 250, Unit 12', 'M4Y 2B6', FALSE),
(15, 15, 15, 'Rua Augusta 2000, Sala 10', '01304-000', TRUE);

-- Inserts para Tabla: Tipo_Telefono
INSERT INTO Tipo_Telefono (id_tipo_telefono, nombre_tipo_telefono, descripcion) VALUES
(1, 'Móvil', 'Teléfono celular personal'),
(2, 'Fijo', 'Teléfono de línea fija residencial o de oficina'),
(3, 'Trabajo', 'Teléfono de la oficina o del trabajo'),
(4, 'Casa', 'Teléfono principal de la casa'),
(5, 'Fax', 'Número de fax'),
(6, 'Emergencia', 'Número de contacto para emergencias'),
(7, 'Alternativo', 'Número de teléfono secundario'),
(8, 'Soporte', 'Número de soporte técnico'),
(9, 'Comercial', 'Número de teléfono de un negocio'),
(10, 'Personal', 'Teléfono personal no laboral'),
(11, 'VoIP', 'Teléfono basado en Voz sobre IP'),
(12, 'Satélite', 'Teléfono satelital'),
(13, 'Recados', 'Teléfono para dejar mensajes'),
(14, 'Oficina', 'Teléfono de la oficina principal'),
(15, 'Ventas', 'Teléfono del departamento de ventas');

-- Inserts para Tabla: Telefono_Clientes (usando IDs de Cliente del 1 al 15 y Tipo_Telefono del 1 al 15)
INSERT INTO Telefono_Clientes (id_telefono_cliente, cliente_id_telefono, codigo_pais, numero_telefono, tipo_telefono_id, es_principal) VALUES
(1, 1, '+57', '3001234567', 1, TRUE),
(2, 2, '+57', '3109876543', 1, TRUE),
(3, 3, '+57', '6017654321', 2, TRUE),
(4, 4, '+52', '5512345678', 1, TRUE),
(5, 5, '+52', '3398765432', 2, FALSE),
(6, 6, '+54', '1150001000', 1, TRUE),
(7, 7, '+54', '3514000200', 2, TRUE),
(8, 8, '+56', '987654321', 1, TRUE),
(9, 9, '+56', '221234567', 2, FALSE),
(10, 10, '+51', '991122334', 1, TRUE),
(11, 11, '+51', '054321098', 2, TRUE),
(12, 12, '+34', '600112233', 1, TRUE),
(13, 13, '+1', '2135551234', 1, TRUE),
(14, 14, '+1', '4165555678', 2, FALSE),
(15, 15, '+55', '11987654321', 1, TRUE);

-- Inserts para Tabla: Tipo_Producto
INSERT INTO Tipo_Producto (id_tipo_producto, nombre_tipo_producto, descripcion) VALUES
(1, 'Pizza', 'Variedad de pizzas con diferentes ingredientes y tamaños'),
(2, 'Bebida', 'Bebidas refrescantes de varias marcas y sabores'),
(3, 'Combo', 'Combinaciones de pizzas, bebidas y acompañamientos'),
(4, 'Postre', 'Opciones dulces para después de la comida'),
(5, 'Acompañamiento', 'Adiciones como papas fritas, alitas, etc.'),
(6, 'Ensalada', 'Opciones de ensaladas frescas'),
(7, 'Salsa Extra', 'Salsas adicionales para acompañar'),
(8, 'Ingrediente Adicional', 'Ingredientes para añadir a la pizza'),
(9, 'Menú Infantil', 'Opciones de comida adaptadas para niños'),
(10, 'Cerveza', 'Cervezas nacionales e importadas'),
(11, 'Vino', 'Vinos tintos y blancos'),
(12, 'Café', 'Bebidas a base de café'),
(13, 'Té', 'Bebidas de té calientes o frías'),
(14, 'Helado', 'Postres congelados'),
(15, 'Promoción Especial', 'Productos con descuentos por tiempo limitado');

-- Inserts para Tabla: Producto (Se han aumentado los productos para cubrir las especializaciones)
INSERT INTO Producto (id_producto, nombre_producto, descripcion, tipo_producto_id, esta_activo, cantidad_stock) VALUES
(1, 'Pizza Pepperoni Clásica', 'Pizza con salsa de tomate, mozzarella y pepperoni', 1, TRUE, 100),
(2, 'Pizza Jamón y Queso', 'Pizza con jamón y abundante queso mozzarella', 1, TRUE, 90),
(3, 'Pizza Vegetariana', 'Pizza con vegetales frescos de temporada', 1, TRUE, 85),
(4, 'Pizza Hawaiana', 'Pizza con jamón, piña y queso', 1, TRUE, 70),
(5, 'Pizza Pollo BBQ', 'Pizza con pollo a la parrilla y salsa BBQ', 1, TRUE, 75),
(6, 'Pizza 4 Quesos', 'Combinación de cuatro quesos especiales', 1, TRUE, 80),
(7, 'Pizza Mexicana', 'Pizza con carne molida, jalapeños y frijoles', 1, TRUE, 60),
(8, 'Pizza de Carnes', 'Pizza con pepperoni, jamón y salchicha', 1, TRUE, 95),
(9, 'Pizza Margarita', 'Pizza clásica con tomate, mozzarella y albahaca', 1, TRUE, 110),
(10, 'Pizza Champignones', 'Pizza con champiñones frescos laminados', 1, TRUE, 65),
(11, 'Pizza Carbonara', 'Pizza con salsa carbonara, panceta y huevo', 1, TRUE, 55),
(12, 'Pizza Fugazza', 'Pizza con cebolla y orégano', 1, TRUE, 50),
(13, 'Pizza Ranchera', 'Pizza con chorizo, maíz y pimientos', 1, TRUE, 45),
(14, 'Pizza Caprichosa', 'Pizza con jamón, champiñones, alcachofas y aceitunas', 1, TRUE, 40),
(15, 'Pizza Mediterránea', 'Pizza con aceitunas negras, pimientos y queso feta', 1, TRUE, 35),

(16, 'Coca-Cola 1.5L', 'Bebida gaseosa Coca-Cola de 1.5 litros', 2, TRUE, 200),
(17, 'Pepsi 1.5L', 'Bebida gaseosa Pepsi de 1.5 litros', 2, TRUE, 180),
(18, 'Sprite 1.5L', 'Bebida gaseosa Sprite de 1.5 litros', 2, TRUE, 170),
(19, 'Agua Mineral 1L', 'Botella de agua mineral de 1 litro', 2, TRUE, 250),
(20, 'Jugo de Naranja 1L', 'Jugo natural de naranja de 1 litro', 2, TRUE, 150),
(21, 'Cerveza Lager', 'Cerveza tipo Lager', 2, TRUE, 120),
(22, 'Cerveza Negra', 'Cerveza oscura tipo Stout', 2, TRUE, 100),
(23, 'Limonada Natural', 'Limonada fresca hecha en casa', 2, TRUE, 90),
(24, 'Té Helado Melocotón', 'Té helado sabor melocotón', 2, TRUE, 110),
(25, 'Gaseosa Uva', 'Bebida gaseosa sabor uva', 2, TRUE, 80),
(26, 'Refresco de Tamarindo', 'Refresco de sabor tamarindo', 2, TRUE, 70),
(27, 'Agua con Gas', 'Agua mineral con gas', 2, TRUE, 60),
(28, 'Malta', 'Bebida de malta sin alcohol', 2, TRUE, 50),
(29, 'Gaseosa Cola Zero', 'Bebida gaseosa Cola sin azúcar', 2, TRUE, 130),
(30, 'Cerveza Light', 'Cerveza baja en calorías', 2, TRUE, 140),

(31, 'Combo Familiar', '2 Pizzas grandes, 4 bebidas y 1 acompañamiento', 3, TRUE, 50),
(32, 'Combo Amigos', '1 Pizza mediana, 2 bebidas y 1 postre', 3, TRUE, 40),
(33, 'Combo Personal', '1 Pizza personal y 1 bebida', 3, TRUE, 60),
(34, 'Combo Pareja', '1 Pizza mediana y 2 bebidas', 3, TRUE, 35),
(35, 'Combo Fiesta', '3 Pizzas grandes, 6 bebidas y 2 acompañamientos', 3, TRUE, 25),
(36, 'Combo Infantil', 'Pizza pequeña, jugo y postre para niños', 3, TRUE, 30),
(37, 'Combo Ejecutivo', 'Pizza personal, ensalada y bebida', 3, TRUE, 20),
(38, 'Combo Universitario', 'Pizza personal + bebida pequeña', 3, TRUE, 75),
(39, 'Combo Light', 'Pizza vegetariana personal y agua mineral', 3, TRUE, 15),
(40, 'Combo Vegano', 'Pizza vegana y bebida vegetal', 3, TRUE, 10),
(41, 'Combo Max', 'Pizza XL, 2 bebidas de 2L y 2 acompañamientos', 3, TRUE, 8),
(42, 'Combo Noche', 'Pizza grande, 2 cervezas y papas', 3, TRUE, 12),
(43, 'Combo Dulce', 'Pizza de postre, 2 helados y café', 3, TRUE, 7),
(44, 'Combo Ahorro', 'Pizza mediana, 1 bebida y 1 salsa extra', 3, TRUE, 28),
(45, 'Combo Gourmet', 'Pizza especial de la casa, vino y tiramisú', 3, TRUE, 5);


-- Inserts para Tabla: Precio_Vigente_Producto (actualizado para incluir todos los IDs de Producto)
INSERT INTO Precio_Vigente_Producto (id_precio_vigente_producto, producto_id_precio, precio_base, fecha_inicio_vigencia, fecha_fin_vigencia) VALUES
(1, 1, 25.00, '2023-01-01', '2024-12-31'), (2, 2, 24.00, '2023-01-01', '2024-12-31'),
(3, 3, 23.00, '2023-01-01', '2024-12-31'), (4, 4, 22.00, '2023-01-01', '2024-12-31'),
(5, 5, 26.00, '2023-01-01', '2024-12-31'), (6, 6, 27.00, '2023-01-01', '2024-12-31'),
(7, 7, 28.00, '2023-01-01', '2024-12-31'), (8, 8, 29.00, '2023-01-01', '2024-12-31'),
(9, 9, 20.00, '2023-01-01', '2024-12-31'), (10, 10, 21.00, '2023-01-01', '2024-12-31'),
(11, 11, 30.00, '2023-01-01', '2024-12-31'), (12, 12, 19.00, '2023-01-01', '2024-12-31'),
(13, 13, 25.00, '2023-01-01', '2024-12-31'), (14, 14, 26.00, '2023-01-01', '2024-12-31'),
(15, 15, 27.00, '2023-01-01', '2024-12-31'),

(16, 16, 5.50, '2023-01-01', '2024-12-31'), (17, 17, 5.00, '2023-01-01', '2024-12-31'),
(18, 18, 5.00, '2023-01-01', '2024-12-31'), (19, 19, 3.00, '2023-01-01', '2024-12-31'),
(20, 20, 6.00, '2023-01-01', '2024-12-31'), (21, 21, 10.00, '2023-01-01', '2024-12-31'),
(22, 22, 11.00, '2023-01-01', '2024-12-31'), (23, 23, 7.00, '2023-01-01', '2024-12-31'),
(24, 24, 6.50, '2023-01-01', '2024-12-31'), (25, 25, 4.00, '2023-01-01', '2024-12-31'),
(26, 26, 4.50, '2023-01-01', '2024-12-31'), (27, 27, 3.50, '2023-01-01', '2024-12-31'),
(28, 28, 5.00, '2023-01-01', '2024-12-31'), (29, 29, 5.50, '2023-01-01', '2024-12-31'),
(30, 30, 9.00, '2023-01-01', '2024-12-31'),

(31, 31, 70.00, '2023-01-01', '2024-12-31'), (32, 32, 45.00, '2023-01-01', '2024-12-31'),
(33, 33, 30.00, '2023-01-01', '2024-12-31'), (34, 34, 40.00, '2023-01-01', '2024-12-31'),
(35, 35, 100.00, '2023-01-01', '2024-12-31'), (36, 36, 25.00, '2023-01-01', '2024-12-31'),
(37, 37, 35.00, '2023-01-01', '2024-12-31'), (38, 38, 20.00, '2023-01-01', '2024-12-31'),
(39, 39, 28.00, '2023-01-01', '2024-12-31'), (40, 40, 32.00, '2023-01-01', '2024-12-31'),
(41, 41, 120.00, '2023-01-01', '2024-12-31'), (42, 42, 65.00, '2023-01-01', '2024-12-31'),
(43, 43, 40.00, '2023-01-01', '2024-12-31'), (44, 44, 38.00, '2023-01-01', '2024-12-31'),
(45, 45, 80.00, '2023-01-01', '2024-12-31');

-- Inserts para Tabla: Pizza (usando IDs de Producto del 1 al 15)
INSERT INTO Pizza (id_pizza, instrucciones_preparacion) VALUES
(1, 'Horno a 220C por 12-15 minutos. Cortar en 8 porciones.'),
(2, 'Horno a 200C por 10-13 minutos. Cortar en 6 porciones.'),
(3, 'Horno a 210C por 13-16 minutos. Cortar en 10 porciones.'),
(4, 'Horno a 230C por 10-14 minutos. Cortar en 8 porciones.'),
(5, 'Horno a 200C por 11-14 minutos. Cortar en 6 porciones.'),
(6, 'Horno a 225C por 12-15 minutos. Cortar en 8 porciones.'),
(7, 'Horno a 205C por 10-13 minutos. Cortar en 6 porciones.'),
(8, 'Horno a 215C por 13-16 minutos. Cortar en 10 porciones.'),
(9, 'Horno a 235C por 10-14 minutos. Cortar en 8 porciones.'),
(10, 'Horno a 200C por 11-14 minutos. Cortar en 6 porciones.'),
(11, 'Horno a 220C por 12-15 minutos. Cortar en 8 porciones.'),
(12, 'Horno a 200C por 10-13 minutos. Cortar en 6 porciones.'),
(13, 'Horno a 210C por 13-16 minutos. Cortar en 10 porciones.'),
(14, 'Horno a 230C por 10-14 minutos. Cortar en 8 porciones.'),
(15, 'Horno a 200C por 11-14 minutos. Cortar en 6 porciones.');

-- Inserts para Tabla: Bebida (usando IDs de Producto del 16 al 30)
INSERT INTO Bebida (id_bebida, capacidad_ml, capacidad) VALUES
(16, 1500, '1.5 Litros'),
(17, 1500, '1.5 Litros'),
(18, 1500, '1.5 Litros'),
(19, 1000, '1 Litro'),
(20, 1000, '1 Litro'),
(21, 330, 'Lata'),
(22, 330, 'Lata'),
(23, 500, 'Vaso Grande'),
(24, 500, 'Vaso Grande'),
(25, 350, 'Botella Pequeña'),
(26, 350, 'Botella Pequeña'),
(27, 330, 'Botella Pequeña'),
(28, 330, 'Botella Pequeña'),
(29, 1500, '1.5 Litros'),
(30, 330, 'Lata');

-- Inserts para Tabla: Combo (usando IDs de Producto del 31 al 45)
INSERT INTO Combo (id_combo, nombre_combo) VALUES
(31, 'Combo Familiar'),
(32, 'Combo Amigos'),
(33, 'Combo Personal'),
(34, 'Combo Pareja'),
(35, 'Combo Fiesta'),
(36, 'Combo Infantil'),
(37, 'Combo Ejecutivo'),
(38, 'Combo Universitario'),
(39, 'Combo Light'),
(40, 'Combo Vegano'),
(41, 'Combo Max'),
(42, 'Combo Noche'),
(43, 'Combo Dulce'),
(44, 'Combo Ahorro'),
(45, 'Combo Gourmet');

-- Inserts para Tabla: Componente_Combo (usando IDs de Combo y Producto válidos)
INSERT INTO Componente_Combo (id_componente_combo, combo_id, producto_componente_id, cantidad) VALUES
(1, 31, 1, 2), (2, 31, 16, 4), (3, 31, 46, 1), -- Combo Familiar: 2 Pizza Pepperoni, 4 Coca-Cola, 1 Papas Fritas (asumo 46 es Papas fritas)
(4, 32, 2, 1), (5, 32, 17, 2), (6, 32, 47, 1), -- Combo Amigos: Pizza Jamón, 2 Pepsi, 1 Tiramisú (asumo 47 es Tiramisú)
(7, 33, 3, 1), (8, 33, 18, 1), -- Combo Personal: Pizza Vegetariana, Sprite
(9, 34, 4, 1), (10, 34, 19, 2), -- Combo Pareja: Pizza Hawaiana, 2 Aguas
(11, 35, 5, 3), (12, 35, 20, 6), (13, 35, 48, 2), -- Combo Fiesta: 3 Pizza Pollo BBQ, 6 Jugos, 2 Papas Fritas
(14, 36, 6, 1), (15, 36, 23, 1), (16, 36, 47, 1), -- Combo Infantil: Pizza 4 Quesos, Limonada, Tiramisú
(17, 37, 7, 1), (18, 37, 27, 1), (19, 37, 49, 1), -- Combo Ejecutivo: Pizza Mexicana, Agua con Gas, Ensalada César (asumo 49 es Ensalada César)
(20, 38, 8, 1), (21, 38, 16, 1), -- Combo Universitario: Pizza Carnes, Coca-Cola
(22, 39, 3, 1), (23, 39, 19, 1), -- Combo Light: Pizza Vegetariana, Agua Mineral
(24, 40, 3, 1), (25, 40, 20, 1), -- Combo Vegano: Pizza Vegetariana, Jugo Naranja (Si hay bebida vegana específica usar esa)
(26, 41, 9, 1), (27, 41, 16, 2), (28, 41, 46, 2), -- Combo Max: Pizza Margarita, 2 Coca-Cola 1.5L, 2 Papas Fritas
(29, 42, 10, 1), (30, 42, 21, 2), (31, 42, 46, 1), -- Combo Noche: Pizza Champignones, 2 Cervezas Lager, Papas Fritas
(32, 43, 11, 1), (33, 43, 47, 2), (34, 43, 50, 1), -- Combo Dulce: Pizza Carbonara, 2 Tiramisú, Café (asumo 50 es Café)
(35, 44, 12, 1), (36, 44, 17, 1), (37, 44, 51, 1), -- Combo Ahorro: Pizza Fugazza, Pepsi, Salsa Ajo (asumo 51 es Salsa Ajo)
(38, 45, 13, 1), (39, 45, 52, 1), (40, 45, 47, 1); -- Combo Gourmet: Pizza Ranchera, Vino Tinto (asumo 52 es Vino Tinto), Tiramisú

-- Nota: IDs 46, 47, 48, 49, 50, 51, 52 son placeholders para otros productos generales como 'Papas Fritas Grandes', 'Tiramisú', etc.
-- Deberías asegurarte de que estos IDs también existen en la tabla Producto con su tipo_producto_id correcto.
INSERT INTO Producto (id_producto, nombre_producto, descripcion, tipo_producto_id, esta_activo, cantidad_stock) VALUES
(46, 'Papas Fritas Grandes', 'Porción grande de papas fritas', 5, TRUE, 150),
(47, 'Tiramisú', 'Postre italiano clásico', 4, TRUE, 30),
(48, 'Alitas de Pollo x6', '6 Alitas de pollo con salsa BBQ', 5, TRUE, 50),
(49, 'Ensalada César', 'Ensalada con lechuga romana, crutones, queso parmesano y aderezo César', 6, TRUE, 40),
(50, 'Café Americano', 'Café negro tradicional', 12, TRUE, 90),
(51, 'Salsa Ajo', 'Salsa cremosa de ajo para acompañar', 7, TRUE, 100),
(52, 'Vino Tinto Joven', 'Vino tinto de la casa, joven y afrutado', 11, TRUE, 20),
(53, 'Helado Chocolate', 'Tarrina de helado de chocolate', 14, TRUE, 50),
(54, 'Brownie con Helado', 'Brownie caliente con una bola de helado', 4, TRUE, 25),
(55, 'Aros de Cebolla', 'Porción de aros de cebolla apanados', 5, TRUE, 70),
(56, 'Gaseosa Mini', 'Refresco de 250ml', 2, TRUE, 200),
(57, 'Te Hielo Durazno', 'Te helado sabor durazno', 2, TRUE, 100),
(58, 'Palitos de Queso', 'Palitos de queso empanizados', 5, TRUE, 80),
(59, 'Pan de Ajo', 'Pan tostado con mantequilla de ajo y perejil', 5, TRUE, 90),
(60, 'Sopa del Día', 'Sopa fresca del día', 6, TRUE, 30);


-- Inserts para Tabla: Ingrediente
INSERT INTO Ingrediente (id_ingrediente, nombre_ingrediente, descripcion, precio_adicional_extra) VALUES
(1, 'Pepperoni', 'Rodajas de salchicha picante', 2.00),
(2, 'Extra Queso Mozzarella', 'Doble porción de queso mozzarella', 1.50),
(3, 'Champiñones Frescos', 'Rodajas de champiñones naturales', 1.75),
(4, 'Cebolla', 'Cebolla fresca cortada en julianas', 1.00),
(5, 'Pimientos', 'Mix de pimientos rojos y verdes', 1.25),
(6, 'Aceitunas Negras', 'Aceitunas negras rebanadas', 1.50),
(7, 'Jamón', 'Jamón cocido en cubos', 2.00),
(8, 'Piña', 'Trozos de piña fresca', 1.50),
(9, 'Pollo A la Parrilla', 'Trozos de pollo a la parrilla', 2.50),
(10, 'Bacon Crujiente', 'Tiras de bacon cocido', 2.25),
(11, 'Maíz Dulce', 'Granos de maíz dulce', 1.00),
(12, 'Tomate Cherry', 'Tomates cherry cortados a la mitad', 1.75),
(13, 'Rúcula', 'Hojas frescas de rúcula', 1.25),
(14, 'Orégano Fresco', 'Hojas de orégano fresco', 0.50),
(15, 'Jalapeños', 'Rodajas de jalapeños picantes', 1.00);

-- Inserts para Tabla: Pizza_Ingrediente_Base (usando IDs de Pizza y Ingrediente válidos)
INSERT INTO Pizza_Ingrediente_Base (id_pizza_ingrediente_base, pizza_id, ingrediente_id) VALUES
(1, 1, 1), (2, 1, 2), -- Pizza Pepperoni: Pepperoni, Extra Queso
(3, 2, 2), (4, 2, 7), -- Pizza Jamón y Queso: Extra Queso, Jamón
(5, 3, 3), (6, 3, 4), (7, 3, 5), -- Pizza Vegetariana: Champiñones, Cebolla, Pimientos
(8, 4, 7), (9, 4, 8), -- Pizza Hawaiana: Jamón, Piña
(10, 5, 9), (11, 5, 10), -- Pizza Pollo BBQ: Pollo, Bacon
(12, 6, 2), (13, 6, 13), -- Pizza 4 Quesos: Extra Queso, Rúcula
(14, 7, 4), (15, 7, 15), -- Pizza Mexicana: Cebolla, Jalapeños
(16, 8, 1), (17, 8, 7), (18, 8, 10), -- Pizza de Carnes: Pepperoni, Jamón, Bacon
(19, 9, 12), (20, 9, 2), (21, 9, 14), -- Pizza Margarita: Tomate Cherry, Extra Queso, Orégano
(22, 10, 3), (23, 10, 2), -- Pizza Champiñones: Champiñones, Extra Queso
(24, 11, 10), (25, 11, 2), -- Pizza Carbonara: Bacon Crujiente, Extra Queso
(26, 12, 4), (27, 12, 14), -- Pizza Fugazza: Cebolla, Orégano Fresco
(28, 13, 11), (29, 13, 5), -- Pizza Ranchera: Maíz Dulce, Pimientos
(30, 14, 7), (31, 14, 3), (32, 14, 6), -- Pizza Caprichosa: Jamón, Champiñones, Aceitunas
(33, 15, 6), (34, 15, 5), (35, 15, 2); -- Pizza Mediterránea: Aceitunas Negras, Pimientos, Extra Queso

-- Inserts para Tabla: Presentacion_Pizza
INSERT INTO Presentacion_Pizza (id_presentacion_pizza, nombre_presentacion, descripcion) VALUES
(1, 'Pequeña', 'Pizza de 6 porciones, ideal para 1 persona'),
(2, 'Mediana', 'Pizza de 8 porciones, ideal para 2-3 personas'),
(3, 'Grande', 'Pizza de 10 porciones, ideal para 3-4 personas'),
(4, 'Familiar', 'Pizza de 12 porciones, ideal para 4-5 personas'),
(5, 'Personal', 'Pizza individual de 4 porciones'),
(6, 'XL', 'Pizza extra grande de 14 porciones'),
(7, 'Rectangular', 'Pizza con forma rectangular, para compartir'),
(8, 'Sin Gluten', 'Base de pizza apta para celíacos'),
(9, 'Delgada', 'Pizza con masa extra fina'),
(10, 'Gruesa', 'Pizza con masa gruesa y esponjosa'),
(11, 'Bordes Rellenos', 'Bordes de la pizza rellenos de queso'),
(12, 'Sin Orilla', 'Pizza sin borde tradicional'),
(13, 'Doble Capa', 'Pizza con doble capa de ingredientes'),
(14, 'Vegana', 'Pizza con ingredientes 100% veganos'),
(15, 'Kids', 'Pizza de tamaño reducido para niños');

-- Inserts para Tabla: Precio_Pizza_Por_Presentacion (usando IDs de Pizza y Presentacion_Pizza válidos)
INSERT INTO Precio_Pizza_Por_Presentacion (id_precio_pizza_presentacion, pizza_id_presentacion, presentacion_pizza_id, precio_base, fecha_inicio_vigencia, fecha_fin_vigencia) VALUES
(1, 1, 1, 15.00, '2023-01-01', '2024-12-31'), (2, 1, 2, 20.00, '2023-01-01', '2024-12-31'),
(3, 1, 3, 25.00, '2023-01-01', '2024-12-31'), (4, 2, 2, 21.00, '2023-01-01', '2024-12-31'),
(5, 3, 3, 26.00, '2023-01-01', '2024-12-31'), (6, 4, 1, 16.00, '2023-01-01', '2024-12-31'),
(7, 5, 2, 22.00, '2023-01-01', '2024-12-31'), (8, 6, 3, 27.00, '2023-01-01', '2024-12-31'),
(9, 7, 1, 17.00, '2023-01-01', '2024-12-31'), (10, 8, 2, 23.00, '2023-01-01', '2024-12-31'),
(11, 9, 3, 28.00, '2023-01-01', '2024-12-31'), (12, 10, 1, 18.00, '2023-01-01', '2024-12-31'),
(13, 11, 2, 24.00, '2023-01-01', '2024-12-31'), (14, 12, 3, 29.00, '2023-01-01', '2024-12-31'),
(15, 13, 1, 19.00, '2023-01-01', '2024-12-31');

-- Inserts para Tabla: Estado_Pedido
INSERT INTO Estado_Pedido (id_estado_pedido, nombre_estado) VALUES
(1, 'Pendiente'), (2, 'Confirmado'), (3, 'En Preparación'), (4, 'En Camino'), (5, 'Entregado'),
(6, 'Cancelado'), (7, 'Reembolsado'), (8, 'En Espera'), (9, 'Rechazado'), (10, 'Devuelto'),
(11, 'Fallido'), (12, 'Retenido'), (13, 'En Recogida'), (14, 'Completado'), (15, 'Abierto');

-- Inserts para Tabla: Tipo_metodo_pago
INSERT INTO Tipo_metodo_pago (id_tipo_metodo_pago, nombre_tipo_metodo_pago, descricpcion_tipo_metodo_pago) VALUES
(1, 'Efectivo', 'Pago en moneda física al momento de la entrega o recogida'),
(2, 'Tarjeta de Crédito', 'Pago con tarjeta de crédito (Visa, Mastercard, Amex, etc.)'),
(3, 'Tarjeta de Débito', 'Pago con tarjeta de débito'),
(4, 'Transferencia Bancaria', 'Pago realizado mediante una transferencia electrónica'),
(5, 'PSE', 'Pago Seguro en Línea (Colombia)'),
(6, 'PayPal', 'Pago a través de la plataforma PayPal'),
(7, 'Criptomoneda', 'Pago con criptomonedas (Bitcoin, Ethereum, etc.)'),
(8, 'Billetera Digital', 'Pago con aplicaciones de billetera digital (Nequi, Daviplata, etc.)'),
(9, 'Cheque', 'Pago mediante cheque bancario'),
(10, 'Cupón/Vale', 'Pago total o parcial con un cupón o vale'),
(11, 'Contra Entrega', 'Pago al recibir el producto'),
(12, 'Online', 'Pago realizado en línea al momento de la compra'),
(13, 'Puntos Fidelidad', 'Pago usando puntos de programas de fidelidad'),
(14, 'Credito Tienda', 'Crédito otorgado por la tienda'),
(15, 'Gift Card', 'Pago con tarjeta de regalo');

-- Inserts para Tabla: Metodo_Pago (usando IDs de Tipo_metodo_pago del 1 al 15)
INSERT INTO Metodo_Pago (id_metodo_pago, tipo_metodo_pago_id, nombre_metodo_pago, descripcion_metodo_pago) VALUES
(1, 1, 'Efectivo en Tienda', 'Pago en efectivo directamente en el local'),
(2, 1, 'Efectivo a Domicilio', 'Pago en efectivo al repartidor en la entrega'),
(3, 2, 'Visa', 'Tarjeta de crédito Visa'),
(4, 2, 'Mastercard', 'Tarjeta de crédito Mastercard'),
(5, 3, 'Débito Bancolombia', 'Tarjeta de débito del banco Bancolombia'),
(6, 4, 'Transferencia PSE', 'Transferencia bancaria a través de PSE'),
(7, 5, 'PSE Bancolombia', 'PSE con Bancolombia'),
(8, 6, 'PayPal Express', 'Pago rápido con PayPal'),
(9, 7, 'Bitcoin', 'Pago con Bitcoin'),
(10, 8, 'Nequi', 'Billetera digital Nequi'),
(11, 9, 'Cheque al Portador', 'Cheque al portador'),
(12, 10, 'Cupón Promocional', 'Cupón de descuento'),
(13, 11, 'Contra Entrega Efectivo', 'Pago en efectivo al momento de la entrega'),
(14, 12, 'Mercado Pago', 'Plataforma de pagos online'),
(15, 13, 'Puntos de Cliente Frecuente', 'Uso de puntos acumulados');

-- Inserts para Tabla: Pedidos (usando IDs de Cliente, Metodo_Pago, Estado_Pedido válidos)
INSERT INTO Pedidos (id_pedido, cliente_id_pedido, fecha_hora_pedido, hora_recogida_estimada, metodo_pago_id, total_pedido, estado_pedido_id, pago_confirmado, instrucciones_especiales_cliente) VALUES
(1, 1, '2023-09-01 18:00:00', '18:45:00', 1, 45.00, 5, TRUE, 'Sin cebolla en la pizza'),
(2, 2, '2023-09-01 19:30:00', '20:15:00', 3, 75.50, 4, TRUE, 'Entregar al vecino si no estoy'),
(3, 3, '2023-09-02 12:00:00', '12:40:00', 5, 20.00, 3, TRUE, 'Extra picante en salsa'),
(4, 4, '2023-09-02 14:15:00', '15:00:00', 6, 60.00, 2, TRUE, 'Ninguna'),
(5, 5, '2023-09-03 20:00:00', '20:45:00', 8, 30.00, 1, FALSE, 'Llamar al llegar'),
(6, 6, '2023-09-04 11:00:00', '11:30:00', 2, 55.00, 5, TRUE, 'Dejar en la portería'),
(7, 7, '2023-09-04 17:00:00', '17:45:00', 4, 80.00, 4, TRUE, 'Ninguna'),
(8, 8, '2023-09-05 19:10:00', '19:50:00', 7, 28.50, 3, TRUE, 'Sin cilantro'),
(9, 9, '2023-09-05 21:00:00', '21:40:00', 9, 100.00, 2, TRUE, 'Celebración de cumpleaños'),
(10, 10, '2023-09-06 13:00:00', '13:45:00', 10, 40.00, 1, FALSE, 'Ninguna'),
(11, 11, '2023-09-06 18:30:00', '19:10:00', 11, 65.00, 5, TRUE, 'Entregar rápido'),
(12, 12, '2023-09-07 10:00:00', '10:45:00', 12, 35.00, 4, TRUE, 'Ninguna'),
(13, 13, '2023-09-07 16:00:00', '16:30:00', 13, 90.00, 3, TRUE, 'Doble queso'),
(14, 14, '2023-09-08 19:45:00', '20:25:00', 14, 50.00, 2, TRUE, 'Ninguna'),
(15, 15, '2023-09-08 22:00:00', '22:30:00', 15, 22.50, 1, FALSE, 'Llamar antes de llegar');

-- Inserts para Tabla: Detalles_Pedido (usando IDs de Pedidos, Producto, Presentacion_Pizza válidos)
INSERT INTO Detalles_Pedido (id_detalle_pedido, pedido_id_detalle, producto_id_detalle, cantidad, presentacion_pizza_id_detalle, subtotal_linea) VALUES
(1, 1, 1, 1, 3, 25.00), (2, 1, 16, 2, 1, 11.00), (3, 1, 51, 1, 1, 2.50), -- Pedido 1: Pizza Grande, 2 Coca-Cola, 1 Salsa Ajo
(4, 2, 31, 1, 1, 70.00), (5, 2, 47, 1, 1, 12.00), -- Pedido 2: Combo Familiar, Tiramisú
(6, 3, 2, 1, 2, 21.00), -- Pedido 3: Pizza Jamón y Queso Mediana
(7, 4, 38, 1, 1, 20.00), (8, 4, 50, 2, 1, 12.00), -- Pedido 4: Combo Universitario, 2 Café Americano
(9, 5, 3, 1, 1, 15.00), (10, 5, 29, 1, 1, 5.50), -- Pedido 5: Pizza Vegetariana Pequeña, Coca-Cola Zero
(11, 6, 4, 1, 3, 26.00), (12, 6, 46, 1, 1, 8.00), -- Pedido 6: Pizza Hawaiana Grande, Papas Fritas
(13, 7, 32, 1, 1, 50.00), (14, 7, 49, 1, 1, 15.00), -- Pedido 7: Combo Amigos, Ensalada César
(15, 8, 5, 1, 1, 16.00), (16, 8, 17, 1, 1, 5.50), -- Pedido 8: Pizza Pollo BBQ Pequeña, Pepsi
(17, 9, 35, 1, 1, 100.00), -- Pedido 9: Combo Fiesta
(18, 10, 6, 1, 2, 22.00), (19, 10, 18, 1, 1, 6.00), -- Pedido 10: Pizza 4 Quesos Mediana, Sprite
(20, 11, 41, 1, 1, 75.00), -- Pedido 11: Combo Max
(21, 12, 7, 1, 5, 10.00), (22, 12, 24, 1, 1, 4.00), -- Pedido 12: Pizza Mexicana Personal, Té Helado Melocotón
(23, 13, 8, 1, 3, 27.00), (24, 13, 36, 1, 1, 18.00), -- Pedido 13: Pizza de Carnes Grande, Combo Infantil
(25, 14, 33, 1, 1, 60.00), -- Pedido 14: Combo Personal
(26, 15, 9, 1, 1, 17.00), (27, 15, 25, 1, 1, 5.00); -- Pedido 15: Pizza Margarita Pequeña, Gaseosa Uva

-- Inserts para Tabla: Detalle_Pedido_Ingrediente_Extra (usando IDs de Detalles_Pedido y Ingrediente válidos)
INSERT INTO Detalle_Pedido_Ingrediente_Extra (id_detalle_pedido_ingrediente_extra, detalle_pedido_id, ingrediente_id_detalle, cantidad_extra, precio_extra_aplicado) VALUES
(1, 1, 4, 1, 1.00), -- Pedido 1, Detalle 1 (Pizza), extra Cebolla
(2, 2, 2, 1, 1.50), -- Pedido 2, Detalle 1 (Combo), extra Queso
(3, 3, 1, 1, 2.00), -- Pedido 3, Detalle 1 (Pizza), extra Pepperoni
(4, 4, 3, 1, 1.75), -- Pedido 4, Detalle 1 (Combo), extra Champiñones
(5, 5, 5, 1, 1.25), -- Pedido 5, Detalle 1 (Pizza), extra Pimientos
(6, 6, 6, 1, 1.50), -- Pedido 6, Detalle 1 (Pizza), extra Aceitunas
(7, 7, 7, 1, 2.00), -- Pedido 7, Detalle 1 (Combo), extra Jamón
(8, 8, 8, 1, 1.50), -- Pedido 8, Detalle 1 (Pizza), extra Piña
(9, 9, 9, 1, 2.50), -- Pedido 9, Detalle 1 (Combo), extra Pollo
(10, 10, 10, 1, 2.25), -- Pedido 10, Detalle 1 (Pizza), extra Bacon
(11, 11, 11, 1, 1.00), -- Pedido 11, Detalle 1 (Combo), extra Maíz
(12, 12, 12, 1, 1.75), -- Pedido 12, Detalle 1 (Pizza), extra Tomate Cherry
(13, 13, 13, 1, 1.25), -- Pedido 13, Detalle 1 (Pizza), extra Rúcula
(14, 14, 14, 1, 0.50), -- Pedido 14, Detalle 1 (Combo), extra Orégano
(15, 15, 15, 1, 1.00); -- Pedido 15, Detalle 1 (Pizza), extra Jalapeños

-- Inserts para Tabla: Ingredientes_Pizza (usando IDs de Pizza, Tipo_Producto (simulando Tipo_Pizza), e Ingrediente válidos)
-- NOTA: `pizza_tipo_id` se usará con el ID de `Tipo_Producto` para simular `Tipo_Pizza`
INSERT INTO Ingredientes_Pizza (pizza_id, pizza_tipo_id, ingrediente_id, total_pizza) VALUES
(1, 1, 1, 25.00), (1, 1, 2, 26.50), -- Pizza Pepperoni
(2, 1, 2, 21.00), (2, 1, 3, 22.75), -- Pizza Jamón y Queso
(3, 1, 4, 26.00), (3, 1, 5, 27.25), -- Pizza Vegetariana
(4, 1, 6, 16.00), (4, 1, 7, 18.00), -- Pizza Hawaiana
(5, 1, 8, 22.00), (5, 1, 9, 24.50), -- Pizza Pollo BBQ
(6, 1, 1, 27.00), (6, 1, 10, 29.25), -- Pizza 4 Quesos
(7, 1, 2, 17.00), (7, 1, 11, 18.00), -- Pizza Mexicana
(8, 1, 3, 23.00), (8, 1, 12, 24.75), -- Pizza de Carnes
(9, 1, 4, 28.00), (9, 1, 13, 29.25), -- Pizza Margarita
(10, 1, 5, 18.00), (10, 1, 14, 18.50), -- Pizza Champiñones
(11, 1, 6, 24.00), (11, 1, 15, 25.00), -- Pizza Carbonara
(12, 1, 7, 29.00), (12, 1, 1, 31.00), -- Pizza Fugazza
(13, 1, 8, 19.00), (13, 1, 2, 20.50), -- Pizza Ranchera
(14, 1, 9, 28.00), (14, 1, 3, 29.75), -- Pizza Caprichosa
(15, 1, 10, 22.00), (15, 1, 4, 23.00); -- Pizza Mediterránea

-- Inserts para Tabla: Facturacion (usando IDs de Pedidos y Cliente válidos)
INSERT INTO Facturacion (id_factura, pedido_id_factura, cliente_id_factura, numero_factura, fecha_emision, subtotal_productos, impuestos, estado_factura, total_factura) VALUES
(1, 1, 1, 'FAC0001', '2023-09-01 19:00:00', 38.50, 6.50, 'Pagada', 45.00),
(2, 2, 2, 'FAC0002', '2023-09-01 20:30:00', 70.00, 12.00, 'Pagada', 82.00),
(3, 3, 3, 'FAC0003', '2023-09-02 13:00:00', 21.00, 3.50, 'Pagada', 24.50),
(4, 4, 4, 'FAC0004', '2023-09-02 15:15:00', 32.00, 5.00, 'Pagada', 37.00),
(5, 5, 5, 'FAC0005', '2023-09-03 21:00:00', 20.50, 3.50, 'Pendiente', 24.00),
(6, 6, 6, 'FAC0006', '2023-09-04 12:00:00', 34.00, 5.50, 'Pagada', 39.50),
(7, 7, 7, 'FAC0007', '2023-09-04 18:00:00', 65.00, 10.50, 'Pagada', 75.50),
(8, 8, 8, 'FAC0008', '2023-09-05 20:00:00', 21.50, 3.50, 'Pagada', 25.00),
(9, 9, 9, 'FAC0009', '2023-09-05 22:00:00', 80.00, 13.00, 'Pagada', 93.00),
(10, 10, 10, 'FAC0010', '2023-09-06 14:00:00', 28.00, 4.50, 'Pendiente', 32.50),
(11, 11, 11, 'FAC0011', '2023-09-06 19:30:00', 60.00, 9.50, 'Pagada', 69.50),
(12, 12, 12, 'FAC0012', '2023-09-07 11:00:00', 14.00, 2.50, 'Pagada', 16.50),
(13, 13, 13, 'FAC0013', '2023-09-07 17:00:00', 45.00, 7.00, 'Pagada', 52.00),
(14, 14, 14, 'FAC0014', '2023-09-08 20:30:00', 50.00, 8.00, 'Pagada', 58.00),
(15, 15, 15, 'FAC0015', '2023-09-08 23:00:00', 22.00, 3.50, 'Pendiente', 25.50);

-- Inserts para Tabla: Transacciones_Pago (usando IDs de Facturacion y Metodo_Pago válidos)
INSERT INTO Transacciones_Pago (id_transaccion, factura_id_transaccion, metodo_pago_id_transaccion, monto_pagado, fecha_pago, referencia_externa) VALUES
(1, 1, 1, 45.00, '2023-09-01 19:05:00', 'REF001A'),
(2, 2, 3, 82.00, '2023-09-01 20:35:00', 'REF002B'),
(3, 3, 5, 24.50, '2023-09-02 13:05:00', 'REF003C'),
(4, 4, 6, 37.00, '2023-09-02 15:20:00', 'REF004D'),
(5, 5, 8, 24.00, '2023-09-03 21:05:00', 'REF005E'),
(6, 6, 2, 39.50, '2023-09-04 12:05:00', 'REF006F'),
(7, 7, 4, 75.50, '2023-09-04 18:05:00', 'REF007G'),
(8, 8, 7, 25.00, '2023-09-05 20:05:00', 'REF008H'),
(9, 9, 9, 93.00, '2023-09-05 22:05:00', 'REF009I'),
(10, 10, 10, 32.50, '2023-09-06 14:05:00', 'REF010J'),
(11, 11, 11, 69.50, '2023-09-06 19:35:00', 'REF011K'),
(12, 12, 12, 16.50, '2023-09-07 11:05:00', 'REF012L'),
(13, 13, 13, 52.00, '2023-09-07 17:05:00', 'REF013M'),
(14, 14, 14, 58.00, '2023-09-08 20:35:00', 'REF014N'),
(15, 15, 15, 25.50, '2023-09-08 23:05:00', 'REF015O');

-- Reactivar las comprobaciones de claves foráneas
SET FOREIGN_KEY_CHECKS = 1;


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
