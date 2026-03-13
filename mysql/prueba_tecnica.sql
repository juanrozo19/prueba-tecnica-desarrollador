-- Prueba técnica - Sección A
-- Motor elegido: MySQL

CREATE DATABASE IF NOT EXISTS prueba_tecnica;
USE prueba_tecnica;

-- Limpio las tablas por si el script se ejecuta más de una vez
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

-- Tabla de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL
);

-- Tabla de productos
-- Aunque el enunciado solo muestra categoría y precio,
-- uso id_producto porque hay categorías repetidas con precios distintos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

-- Tabla de ventas
-- Cada venta queda asociada a un cliente y a un producto específico
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    fecha_venta DATE NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Datos de clientes
INSERT INTO clientes (id_cliente, nombre, ciudad, fecha_registro) VALUES
(1, 'Juan Pérez', 'Bogotá', '2023-01-15'),
(2, 'María López', 'Medellín', '2023-02-20'),
(3, 'Carlos Gómez', 'Cali', '2023-03-05'),
(4, 'Ana Torres', 'Bogotá', '2023-03-25'),
(5, 'Luis Ramírez', 'Barranquilla', '2023-04-10');

-- Datos de productos
INSERT INTO productos (id_producto, categoria, precio) VALUES
(1, 'Electrónica', 500.00),
(2, 'Electrónica', 1500.00),
(3, 'Hogar', 200.00),
(4, 'Hogar', 750.00),
(5, 'Ropa', 100.00);

-- Datos de ventas
-- Como el enunciado da la categoría pero no el id del producto,
-- hago una asignación válida para poder relacionar bien las tablas
INSERT INTO ventas (id_venta, id_cliente, id_producto, fecha_venta, cantidad) VALUES
(1, 1, 1, '2023-05-01', 2),
(2, 1, 3, '2023-05-15', 1),
(3, 2, 2, '2023-06-05', 1),
(4, 3, 3, '2023-06-20', 3),
(5, 3, 1, '2023-06-25', 1),
(6, 4, 5, '2023-07-10', 4),
(7, 5, 2, '2023-07-15', 2),
(8, 5, 1, '2023-07-20', 1);

-- Punto 1:
-- Total vendido por mes y por categoría
SELECT
    DATE_FORMAT(v.fecha_venta, '%Y-%m') AS mes,
    p.categoria,
    SUM(v.cantidad * p.precio) AS total_ventas
FROM ventas v
INNER JOIN productos p
    ON v.id_producto = p.id_producto
GROUP BY
    DATE_FORMAT(v.fecha_venta, '%Y-%m'),
    p.categoria
ORDER BY
    mes,
    p.categoria;