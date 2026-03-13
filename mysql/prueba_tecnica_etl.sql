-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-03-2026 a las 06:45:52
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `prueba_tecnica_etl`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_detalladas`
--

CREATE TABLE `ventas_detalladas` (
  `id_venta` int(11) NOT NULL,
  `fecha_venta` date NOT NULL,
  `cantidad` int(11) NOT NULL,
  `nombre_cliente` varchar(100) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `total_venta` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas_detalladas`
--

INSERT INTO `ventas_detalladas` (`id_venta`, `fecha_venta`, `cantidad`, `nombre_cliente`, `ciudad`, `categoria`, `precio`, `total_venta`) VALUES
(1, '2023-05-01', 2, 'Juan Pérez', 'Bogotá', 'Electrónica', 500.00, 1000.00),
(2, '2023-05-15', 1, 'Juan Pérez', 'Bogotá', 'Hogar', 200.00, 200.00),
(3, '2023-06-05', 1, 'María López', 'Medellín', 'Electrónica', 1500.00, 1500.00),
(4, '2023-06-20', 3, 'Carlos Gómez', 'Cali', 'Hogar', 200.00, 600.00),
(5, '2023-06-25', 1, 'Carlos Gómez', 'Cali', 'Electrónica', 500.00, 500.00),
(6, '2023-07-10', 4, 'Ana Torres', 'Bogotá', 'Ropa', 100.00, 400.00),
(7, '2023-07-15', 2, 'Luis Ramírez', 'Barranquilla', 'Electrónica', 1500.00, 3000.00),
(8, '2023-07-20', 1, 'Luis Ramírez', 'Barranquilla', 'Electrónica', 500.00, 500.00);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ventas_detalladas`
--
ALTER TABLE `ventas_detalladas`
  ADD PRIMARY KEY (`id_venta`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
