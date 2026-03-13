import json
import mariadb


def cargar_configuracion(ruta="config.json"):
    # Leo la configuración de conexión desde el archivo JSON
    with open(ruta, "r", encoding="utf-8") as archivo:
        return json.load(archivo)


def conectar_bd(config_bd, include_database=True):
    # Armo los parámetros de conexión
    params = {
        "host": config_bd["host"],
        "port": config_bd["port"],
        "user": config_bd["user"],
        "password": config_bd["password"]
    }

    # En algunos casos necesito conectarme sin indicar base de datos,
    # por ejemplo cuando voy a crear la base destino
    if include_database:
        params["database"] = config_bd["database"]

    return mariadb.connect(**params)


def crear_base_destino(config_bd):
    # Me conecto al servidor y creo la base destino si todavía no existe
    conexion = conectar_bd(config_bd, include_database=False)
    cursor = conexion.cursor()

    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {config_bd['database']}")

    cursor.close()
    conexion.close()


def crear_tabla_destino(conexion):
    # Creo la tabla donde voy a dejar la información ya transformada
    cursor = conexion.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS ventas_detalladas (
            id_venta INT PRIMARY KEY,
            fecha_venta DATE NOT NULL,
            cantidad INT NOT NULL,
            nombre_cliente VARCHAR(100) NOT NULL,
            ciudad VARCHAR(100) NOT NULL,
            categoria VARCHAR(50) NOT NULL,
            precio DECIMAL(10,2) NOT NULL,
            total_venta DECIMAL(12,2) NOT NULL
        )
    """)

    cursor.close()
    conexion.commit()


def extraer_transformar(conexion_origen):
    # Aquí hago la parte fuerte del proceso:
    # tomo las ventas y las complemento con la información del cliente
    # y del producto para dejar todo en una sola estructura
    cursor = conexion_origen.cursor()

    consulta = """
        SELECT
            v.id_venta,
            v.fecha_venta,
            v.cantidad,
            c.nombre AS nombre_cliente,
            c.ciudad,
            p.categoria,
            p.precio,
            (v.cantidad * p.precio) AS total_venta
        FROM ventas v
        INNER JOIN clientes c
            ON v.id_cliente = c.id_cliente
        INNER JOIN productos p
            ON v.id_producto = p.id_producto
        ORDER BY v.id_venta
    """

    cursor.execute(consulta)
    filas = cursor.fetchall()
    cursor.close()

    return filas


def cargar_datos(conexion_destino, datos):
    cursor = conexion_destino.cursor()

    # Limpio la tabla para evitar duplicados si vuelvo a correr el ETL
    cursor.execute("DELETE FROM ventas_detalladas")

    insert_sql = """
        INSERT INTO ventas_detalladas (
            id_venta,
            fecha_venta,
            cantidad,
            nombre_cliente,
            ciudad,
            categoria,
            precio,
            total_venta
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """

    # Inserto toda la información ya transformada en la base destino
    cursor.executemany(insert_sql, datos)

    cursor.close()
    conexion_destino.commit()


def main():
    # Cargo la configuración general
    config = cargar_configuracion()

    # Creo la base destino si aún no existe
    crear_base_destino(config["target_db"])

    # Abro conexión con la base origen
    conexion_origen = conectar_bd(config["source_db"])

    # Abro conexión con la base destino
    conexion_destino = conectar_bd(config["target_db"])

    # Creo la tabla final donde voy a guardar el resultado del ETL
    crear_tabla_destino(conexion_destino)

    # Extraigo los datos y los transformo
    datos = extraer_transformar(conexion_origen)

    # Cargo el resultado en la base destino
    cargar_datos(conexion_destino, datos)

    conexion_origen.close()
    conexion_destino.close()

    print("ETL ejecutado correctamente.")


if __name__ == "__main__":
    main()