-- Creación de la tabla 'fabricante'
CREATE TABLE fabricante (
    codigo INT(10) PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Creación de la tabla 'producto'
CREATE TABLE producto (
    codigo INT(10) PRIMARY KEY,
    nombre VARCHAR(100),
    precio DOUBLE,
    codigo_fabricante INT(10),
    -- Definición de la clave foránea
    CONSTRAINT fk_codigo_fabricante
        FOREIGN KEY (codigo_fabricante)
        REFERENCES fabricante(codigo)
        ON DELETE CASCADE -- Opcional: Si eliminas un fabricante, sus productos también se eliminan.
        ON UPDATE CASCADE  -- Opcional: Si cambias el código de un fabricante, se actualiza en los productos.
);

-- Opcional: Insertar algunos datos de ejemplo para probar

-- Insertar fabricantes
INSERT INTO fabricante (codigo, nombre) VALUES
(1, 'Sony'),
(2, 'Samsung'),
(3, 'Apple');

-- Insertar productos
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES
(101, 'Televisor OLED', 1500.00, 1),
(102, 'Auriculares Inalámbricos', 200.00, 1),
(103, 'Smartphone Galaxy', 900.00, 2),
(104, 'Tablet Android', 350.00, 2),
(105, 'MacBook Pro', 2200.00, 3),
(106, 'iPhone 15', 1200.00, 3);

SELECT * FROM producto;
SELECT * FROM fabricante;

-- Creación de una funcion sql para obtener el precio promedio de los productos de un fabricante.

DELIMITER $$
    CREATE FUNCTION getAvgPrice(codigoFabricante INT) RETURNS DOUBLE
    DETERMINISTIC
    BEGIN
        DECLARE avgPrice DOUBLE;
        SELECT AVG(precio) INTO avgPrice FROM producto WHERE codigo_fabricante = codigoFabricante;
        RETURN avgPrice;
    END ;
DELIMITER ;


SELECT getAvgPrice(1);
SELECT getAvgPrice(2);
SELECT getAvgPrice(3);


-- Creación de una función sql para calcular el precio total de todos los productos de un fabricante.

DELIMITER $$
    CREATE FUNCTION getTotalPrice(codigoFabricante INT) RETURNS DOUBLE
    DETERMINISTIC
    BEGIN
        DECLARE totalPrice DOUBLE;
        SELECT SUM(precio) INTO totalPrice FROM producto WHERE codigo_fabricante = codigoFabricante;
        RETURN totalPrice;
    END ;
DELIMITER ;

SELECT getTotalPrice(1);
SELECT getTotalPrice(2);
SELECT getTotalPrice(3);

-- Creación de una función sql para Obtener el nombre del producto más caro.

DELIMITER $$
    CREATE FUNCTION getCheapestProduct(codigoFabricante INT) RETURNS VARCHAR(100)
    DETERMINISTIC
    BEGIN
        DECLARE cheapestProduct VARCHAR(100);
        SELECT nombre INTO cheapestProduct FROM producto WHERE codigo_fabricante = codigoFabricante AND precio = (SELECT MIN(precio) FROM producto WHERE codigo_fabricante = codigoFabricante);
        RETURN cheapestProduct;
    END ;
DELIMITER ;

SELECT getCheapestProduct(1);
SELECT getCheapestProduct(2);
SELECT getCheapestProduct(3);

-- Creación de una función sql para Contar la cantidad de productos disponibles de un fabricante.

DELIMITER $$
    CREATE FUNCTION getProductCount(codigoFabricante INT) RETURNS INT
    DETERMINISTIC
    BEGIN
        DECLARE productCount INT;
        SELECT COUNT(codigo) INTO productCount FROM producto WHERE codigo_fabricante = codigoFabricante;
        RETURN productCount;
    END ;
DELIMITER ;

SELECT getProductCount(1);
SELECT getProductCount(2);
SELECT getProductCount(3);

-- Creación de una función sql para Obtener el precio mínimo de los productos de un fabricante.

DELIMITER $$
    CREATE FUNCTION getMinPrice(codigoFabricante INT) RETURNS DOUBLE
    DETERMINISTIC
    BEGIN
        DECLARE minPrice DOUBLE;
        SELECT MIN(precio) INTO minPrice FROM producto WHERE codigo_fabricante = codigoFabricante;
        RETURN minPrice;
    END ;
DELIMITER ;

SELECT getMinPrice(1);
SELECT getMinPrice(2);
SELECT getMinPrice(3);
