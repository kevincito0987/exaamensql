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
DROP TABLE IF EXISTS `Facturacion`;
DROP TABLE IF EXISTS `Transacciones_Pago`;
SET FOREIGN_KEY_CHECKS = 1;

--
-- Definición de Tablas
--

-- Tabla: Pais
CREATE TABLE Pais (
    id_pais INTEGER PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL,
    codigo_iso CHAR(2) NOT NULL
);
-- Índices para búsqueda eficiente
CREATE UNIQUE INDEX idx_unique_pais_nombre_codigo ON Pais (nombre_pais, codigo_iso);


-- Tabla: Departamento
CREATE TABLE Departamento (
    id_departamento INTEGER PRIMARY KEY,
    pais_id_departamento INTEGER NOT NULL,
    nombre_departamento VARCHAR(100) NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_departamento_pais_nombre ON Departamento (pais_id_departamento, nombre_departamento);
CREATE INDEX idx_fk_departamento_pais_id ON Departamento (pais_id_departamento);


-- Tabla: Ciudad
CREATE TABLE Ciudad (
    id_ciudad INTEGER PRIMARY KEY,
    departamento_id_ciudad INTEGER NOT NULL,
    nombre_ciudad VARCHAR(100) NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_ciudad_departamento_nombre ON Ciudad (departamento_id_ciudad, nombre_ciudad);
CREATE INDEX idx_fk_ciudad_departamento_id ON Ciudad (departamento_id_ciudad);


-- Tabla: Direccion
CREATE TABLE Direccion (
    id_direccion INTEGER PRIMARY KEY,
    cliente_id_direccion INTEGER NOT NULL,
    ciudad_id_direccion INTEGER NOT NULL,
    complemento VARCHAR(255) NOT NULL,
    codigo_postal VARCHAR(20) NOT NULL,
    es_principal BOOLEAN NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_direccion_cliente_codigopostal ON Direccion (cliente_id_direccion, codigo_postal);
CREATE INDEX idx_fk_direccion_ciudad_id ON Direccion (ciudad_id_direccion);
CREATE INDEX idx_fk_direccion_cliente_id ON Direccion (cliente_id_direccion);
-- Índice opcional para búsquedas por si es principal (si es una consulta frecuente)
CREATE INDEX idx_direccion_es_principal ON Direccion (es_principal);


-- Tabla: Cliente
CREATE TABLE Cliente (
    id_cliente INTEGER PRIMARY KEY,
    nombres_cliente VARCHAR(100) NOT NULL,
    apellidos_cliente VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    fecha_registro_cliente TIMESTAMP NOT NULL
);
-- Índices para búsqueda eficiente
CREATE INDEX idx_cliente_nombre_apellido ON Cliente (nombres_cliente, apellidos_cliente);
CREATE INDEX idx_cliente_fecha_registro ON Cliente (fecha_registro_cliente);


-- Tabla: Tipo_Telefono
CREATE TABLE Tipo_Telefono (
    id_tipo_telefono INTEGER PRIMARY KEY,
    nombre_tipo_telefono VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);
-- UNIQUE index on nombre_tipo_telefono handles indexing. No new index needed.


-- Tabla: Telefono_Clientes
CREATE TABLE Telefono_Clientes (
    id_telefono_cliente INTEGER PRIMARY KEY,
    cliente_id_telefono INTEGER NOT NULL,
    codigo_pais VARCHAR(20) NOT NULL,
    numero_telefono VARCHAR(20) NOT NULL,
    tipo_telefono_id INTEGER NOT NULL,
    es_principal BOOLEAN NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_telefono_cliente_num ON Telefono_Clientes (cliente_id_telefono, codigo_pais, numero_telefono);
CREATE INDEX idx_fk_telefono_clientes_tipo_id ON Telefono_Clientes (tipo_telefono_id);
-- Índice opcional para búsquedas por si es principal
CREATE INDEX idx_telefono_clientes_es_principal ON Telefono_Clientes (es_principal);


-- Tabla: Tipo_Producto
CREATE TABLE Tipo_Producto (
    id_tipo_producto INTEGER PRIMARY KEY,
    nombre_tipo_producto VARCHAR(200) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);
-- UNIQUE index on nombre_tipo_producto handles indexing. No new index needed.


-- Tabla: Producto (General)
CREATE TABLE Producto (
    id_producto INTEGER PRIMARY KEY,
    nombre_producto VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    tipo_producto_id INTEGER NOT NULL,
    esta_activo BOOLEAN NOT NULL,
    canrtidad_stock INTEGER NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_producto_nombre_tipo ON Producto (nombre_producto, tipo_producto_id);
CREATE INDEX idx_fk_producto_tipo_id ON Producto (tipo_producto_id);
-- Índices opcionales para filtrado y control de inventario
CREATE INDEX idx_producto_esta_activo ON Producto (esta_activo);
CREATE INDEX idx_producto_cantidad_stock ON Producto (canrtidad_stock);


-- Tabla: Precio_Vigente_Producto
CREATE TABLE Precio_Vigente_Producto (
    id_precio_vigente_producto INTEGER PRIMARY KEY,
    prducto_id_precio INTEGER NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_precio_vigente_producto_fecha ON Precio_Vigente_Producto (prducto_id_precio, fecha_inicio_vigencia);
CREATE INDEX idx_fk_precio_vigente_producto_id ON Precio_Vigente_Producto (prducto_id_precio);
-- Índice para búsquedas por rango de fechas
CREATE INDEX idx_precio_vigente_producto_fechas ON Precio_Vigente_Producto (fecha_inicio_vigencia, fecha_fin_vigencia);


-- Tabla: Pizza (Especialización de Producto)
CREATE TABLE Pizza (
    id_pizza INTEGER PRIMARY KEY, -- También FK a Producto
    instrucciones_preparacion TEXT NOT NULL
);
-- PK already provides index. No new index needed.


-- Tabla: Bebida (Especialización de Producto)
CREATE TABLE Bebida (
    id_bebida INTEGER PRIMARY KEY, -- También FK a Producto
    capacidad_ml INTEGER NOT NULL,
    capacidad VARCHAR(50) NOT NULL
);
-- PK already provides index. No new index needed.


-- Tabla: Combo (Especialización de Producto)
CREATE TABLE Combo (
    id_combo INTEGER PRIMARY KEY, -- También FK a Producto
    nombre_combo VARCHAR(100) NOT NULL UNIQUE -- Añadido UNIQUE por lógica de negocio
);
-- PK and UNIQUE index on nombre_combo already provide indexing. No new index needed.


-- Tabla: Componente_Combo
CREATE TABLE Componente_Combo (
    id_componente_combo INTEGER PRIMARY KEY,
    combo_id INTEGER NOT NULL,
    producto_componente_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_componente_combo_producto ON Componente_Combo (combo_id, producto_componente_id);
CREATE INDEX idx_fk_componente_combo_id ON Componente_Combo (combo_id);
CREATE INDEX idx_fk_componente_combo_producto_id ON Componente_Combo (producto_componente_id);


-- Tabla: Ingrediente
CREATE TABLE Ingrediente (
    id_ingrediente INTEGER PRIMARY KEY,
    nombre_ingrediente VARCHAR(200) NOT NULL UNIQUE, -- Añadido UNIQUE por lógica de negocio
    descripcion TEXT NOT NULL,
    precio_adicional_extra DECIMAL(10,2) NOT NULL
);
-- PK and UNIQUE index on nombre_ingrediente already provide indexing. No new index needed.


-- Tabla: Pizza_Ingrediente_Base
CREATE TABLE Pizza_Ingrediente_Base (
    id_pizza_ingrediente_base INTEGER PRIMARY KEY,
    pizza_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_pizza_ingrediente_base ON Pizza_Ingrediente_Base (pizza_id, ingrediente_id);
CREATE INDEX idx_fk_pizza_ingrediente_base_pizza_id ON Pizza_Ingrediente_Base (pizza_id);
CREATE INDEX idx_fk_pizza_ingrediente_base_ingrediente_id ON Pizza_Ingrediente_Base (ingrediente_id);


-- Tabla: Presentacion_Pizza
CREATE TABLE Presentacion_Pizza (
    id_presentacion_pizza INTEGER PRIMARY KEY,
    nombre_presentacion VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL
);
-- PK and UNIQUE index on nombre_presentacion already provide indexing. No new index needed.


-- Tabla: Precio_Pizza_Por_Presentacion
CREATE TABLE Precio_Pizza_Por_Presentacion (
    id_precio_pizza_presentacion INTEGER PRIMARY KEY,
    pizza_id_presentacion INTEGER NOT NULL,
    presentacion_pizza_id INTEGER NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_precio_pizza_presentacion_pizza_id ON Precio_Pizza_Por_Presentacion (pizza_id_presentacion);
CREATE INDEX idx_fk_precio_pizza_presentacion_presentacion_id ON Precio_Pizza_Por_Presentacion (presentacion_pizza_id);
-- Índice para búsquedas por rango de fechas
CREATE INDEX idx_precio_pizza_presentacion_fechas ON Precio_Pizza_Por_Presentacion (fecha_inicio_vigencia, fecha_fin_vigencia);


-- Tabla: Estado_Pedido
CREATE TABLE Estado_Pedido (
    id_estado_pedido INTEGER PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL UNIQUE
);
-- PK and UNIQUE index on nombre_estado already provide indexing. No new index needed.


-- Tabla: Metodo_Pago
CREATE TABLE Metodo_Pago (
    id_metodo_pago INTEGER PRIMARY KEY,
    tipo_metodo_pago_id INTEGER NOT NULL,
    nombre_metodo_pago VARCHAR(100) NOT NULL,
    descripcion_metodo_pago TEXT NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_metodo_pago_tipo_id ON Metodo_Pago (tipo_metodo_pago_id);
CREATE UNIQUE INDEX idx_unique_metodo_pago_nombre ON Metodo_Pago (nombre_metodo_pago); -- Asumo que el nombre es único


-- Tabla: Tipo_metodo_pago
CREATE TABLE Tipo_metodo_pago (
    id_tipo_metodo_pago INTEGER PRIMARY KEY,
    nombre_tipo_metodo_pago VARCHAR(100) NOT NULL UNIQUE,
    descricpcion_tipo_metodo_pago TEXT NOT NULL
);
-- PK and UNIQUE index on nombre_tipo_metodo_pago already provide indexing. No new index needed.


-- Tabla: Pedidos
CREATE TABLE Pedidos (
    id_pedido INTEGER PRIMARY KEY,
    cliente_id_pedido INTEGER NOT NULL,
    fecha_hora_pedido TIMESTAMP NOT NULL,
    hora_recogida_estimada TIME NOT NULL,
    metodo_pago_id INTEGER NOT NULL,
    total_pedido DECIMAL(10,2) NOT NULL,
    estado_pedido_id INTEGER NOT NULL,
    pago_confirmado BOOLEAN NOT NULL,
    instrucciones_especiales_cliente TEXT NOT NULL
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
    id_detalle_pedido INTEGER PRIMARY KEY,
    pedido_id_detalle INTEGER NOT NULL,
    producto_id_detalle INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario_aplicado DECIMAL(10,2) NOT NULL,
    presentacion_pizza_id_detalle INTEGER NOT NULL,
    subtotal_linea DECIMAL(10,2) NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE UNIQUE INDEX idx_unique_detalles_pedido_prod_pres ON Detalles_Pedido (pedido_id_detalle, producto_id_detalle, presentacion_pizza_id_detalle);
CREATE INDEX idx_fk_detalles_pedido_pedido_id ON Detalles_Pedido (pedido_id_detalle);
CREATE INDEX idx_fk_detalles_pedido_producto_id ON Detalles_Pedido (producto_id_detalle);
CREATE INDEX idx_fk_detalles_pedido_presentacion_id ON Detalles_Pedido (presentacion_pizza_id_detalle);


-- Tabla: Detalle_Pedido_Ingrediente_Extra
CREATE TABLE Detalle_Pedido_Ingrediente_Extra (
    id_detalle_pedido_ingrediente_extra INTEGER PRIMARY KEY,
    detalle_pedido_id INTEGER NOT NULL,
    ingrediente_id_detalle INTEGER NOT NULL,
    cantidad_extra INTEGER NOT NULL,
    precio_extra_aplicado DECIMAL(10,2) NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_detalle_pedido_ingrediente_extra_detalle_id ON Detalle_Pedido_Ingrediente_Extra (detalle_pedido_id);
CREATE INDEX idx_fk_detalle_pedido_ingrediente_extra_ingrediente_id ON Detalle_Pedido_Ingrediente_Extra (ingrediente_id_detalle);


-- Tabla: Ingredientes_Pizza (Nota: esta tabla en tu esquema es diferente a Pizza_Ingrediente_Base)
-- Asumo que es una tabla de relación con un "tipo de pizza" y total, que parece más una tabla de informes o un diseño distinto.
-- Si es una tabla de relación M:M entre Pizza, Tipo_Pizza y Ingrediente, su PK compuesta ya la indexa.
CREATE TABLE Ingredientes_Pizza (
    pizza_id INTEGER NOT NULL,
    pizza_tipo_id INTEGER NOT NULL,
    ingrediente_id INTEGER NOT NULL,
    total_pizza DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pizza_id, pizza_tipo_id, ingrediente_id)
);
-- PK already provides index. No new index needed unless specific queries benefit from partial indexes.


-- Tabla: Facturacion (Facturas en tu definición)
CREATE TABLE Facturacion (
    id_factura INTEGER PRIMARY KEY,
    pedido_id_factura INTEGER NOT NULL UNIQUE, -- UNIQUE para relación 1:1 con Pedido
    cliente_id_factura INTEGER NOT NULL,
    numero_factura VARCHAR(50) NOT NULL UNIQUE, -- El número de factura es único
    fecha_emision TIMESTAMP NOT NULL,
    subtotal_productos DECIMAL(10,2) NOT NULL,
    impuestos DECIMAL(10,2) NOT NULL,
    estado_factura VARCHAR(50) NOT NULL,
    total_factura DECIMAL(10,2) NOT NULL
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_facturacion_cliente_id ON Facturacion (cliente_id_factura);
CREATE INDEX idx_fk_facturacion_pedido_id ON Facturacion (pedido_id_factura); -- Aunque es UNIQUE, explícito para FK
CREATE INDEX idx_facturacion_fecha_emision ON Facturacion (fecha_emision);
CREATE INDEX idx_facturacion_estado ON Facturacion (estado_factura);


-- Tabla: Transacciones_Pago
CREATE TABLE Transacciones_Pago (
    id_transaccion INTEGER PRIMARY KEY,
    factura_id_transaccion INTEGER NOT NULL,
    metodo_pago_id_transaccion INTEGER NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL,
    fecha_pago TIMESTAMP NOT NULL,
    referencia_externa VARCHAR(255) NOT NULL -- Asumo NOT NULL para referencia
);
-- Índices para búsqueda eficiente y FK
CREATE INDEX idx_fk_transacciones_pago_factura_id ON Transacciones_Pago (factura_id_transaccion);
CREATE INDEX idx_fk_transacciones_pago_metodo_id ON Transacciones_Pago (metodo_pago_id_transaccion);
CREATE INDEX idx_transacciones_pago_fecha_pago ON Transacciones_Pago (fecha_pago);


--
-- Definición de Claves Foráneas (FKs)
-- (Basadas en las que proporcionaste y algunas correcciones lógicas)
--

ALTER TABLE Departamento ADD FOREIGN KEY (pais_id_departamento) REFERENCES Pais(id_pais);
ALTER TABLE Ciudad ADD FOREIGN KEY (departamento_id_ciudad) REFERENCES Departamento(id_departamento);
ALTER TABLE Direccion ADD FOREIGN KEY (ciudad_id_direccion) REFERENCES Ciudad(id_ciudad);
ALTER TABLE Direccion ADD FOREIGN KEY (cliente_id_direccion) REFERENCES Cliente(id_cliente); -- CORRECCIÓN: Apunta a Cliente, no a Detalles_Pedido

ALTER TABLE Pedidos ADD FOREIGN KEY (cliente_id_pedido) REFERENCES Cliente(id_cliente); -- CORRECCIÓN: Apunta a Cliente, no a Detalles_Pedido
ALTER TABLE Pedidos ADD FOREIGN KEY (metodo_pago_id) REFERENCES Metodo_Pago(id_metodo_pago);
ALTER TABLE Pedidos ADD FOREIGN KEY (estado_pedido_id) REFERENCES Estado_Pedido(id_estado_pedido);

ALTER TABLE Metodo_Pago ADD FOREIGN KEY (tipo_metodo_pago_id) REFERENCES Tipo_metodo_pago(id_tipo_metodo_pago);

ALTER TABLE Detalles_Pedido ADD FOREIGN KEY (pedido_id_detalle) REFERENCES Pedidos(id_pedido); -- Añadida
ALTER TABLE Detalles_Pedido ADD FOREIGN KEY (producto_id_detalle) REFERENCES Producto(id_producto);
ALTER TABLE Detalles_Pedido ADD FOREIGN KEY (presentacion_pizza_id_detalle) REFERENCES Presentacion_Pizza(id_presentacion_pizza);

ALTER TABLE Telefono_Clientes ADD FOREIGN KEY (cliente_id_telefono) REFERENCES Cliente(id_cliente);
ALTER TABLE Telefono_Clientes ADD FOREIGN KEY (tipo_telefono_id) REFERENCES Tipo_Telefono(id_tipo_telefono);

ALTER TABLE Producto ADD FOREIGN KEY (tipo_producto_id) REFERENCES Tipo_Producto(id_tipo_producto);

ALTER TABLE Precio_Vigente_Producto ADD FOREIGN KEY (prducto_id_precio) REFERENCES Producto(id_producto);

ALTER TABLE Pizza ADD FOREIGN KEY (`id_pizza`) REFERENCES `Producto`(`id_producto`); -- Asumiendo especialización
ALTER TABLE Bebida ADD FOREIGN KEY (`id_bebida`) REFERENCES `Producto`(`id_producto`); -- Asumiendo especialización
ALTER TABLE Combo ADD FOREIGN KEY (`id_combo`) REFERENCES `Producto`(`id_producto`); -- Asumiendo especialización

ALTER TABLE Componente_Combo ADD FOREIGN KEY (combo_id) REFERENCES Combo(id_combo);
ALTER TABLE Componente_Combo ADD FOREIGN KEY (producto_componente_id) REFERENCES Producto(id_producto);

ALTER TABLE Pizza_Ingrediente_Base ADD FOREIGN KEY (pizza_id) REFERENCES Pizza(id_pizza);
ALTER TABLE Pizza_Ingrediente_Base ADD FOREIGN KEY (ingrediente_id) REFERENCES Ingrediente(id_ingrediente);

ALTER TABLE Precio_Pizza_Por_Presentacion ADD FOREIGN KEY (pizza_id_presentacion) REFERENCES Pizza(id_pizza);
ALTER TABLE Precio_Pizza_Por_Presentacion ADD FOREIGN KEY (presentacion_pizza_id) REFERENCES Presentacion_Pizza(id_presentacion_pizza);

ALTER TABLE Detalle_Pedido_Ingrediente_Extra ADD FOREIGN KEY (detalle_pedido_id) REFERENCES Detalles_Pedido(id_detalle_pedido);
ALTER TABLE Detalle_Pedido_Ingrediente_Extra ADD FOREIGN KEY (ingrediente_id_detalle) REFERENCES Ingrediente(id_ingrediente);

ALTER TABLE Facturacion ADD FOREIGN KEY (cliente_id_factura) REFERENCES Cliente(id_cliente);
ALTER TABLE Facturacion ADD FOREIGN KEY (pedido_id_factura) REFERENCES Pedidos(id_pedido);

ALTER TABLE Transacciones_Pago ADD FOREIGN KEY (factura_id_transaccion) REFERENCES Facturacion(id_factura);
ALTER TABLE Transacciones_Pago ADD FOREIGN KEY (metodo_pago_id_transaccion) REFERENCES Metodo_Pago(id_metodo_pago);