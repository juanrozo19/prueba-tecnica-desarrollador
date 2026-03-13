import json
import mariadb
from fastapi import FastAPI

app = FastAPI(title="API Prueba Técnica", version="1.0")


def cargar_configuracion(ruta="config.json"):
    # Leo la configuración de conexión desde el archivo JSON
    with open(ruta, "r", encoding="utf-8") as archivo:
        return json.load(archivo)


def conectar_bd():
    config = cargar_configuracion()["source_db"]

    # Abro la conexión a MariaDB usando la base creada en la Sección A
    return mariadb.connect(
        host=config["host"],
        port=config["port"],
        user=config["user"],
        password=config["password"],
        database=config["database"]
    )


@app.get("/ventas/por-categoria")
def obtener_ventas_por_categoria():
    conexion = conectar_bd()
    cursor = conexion.cursor()

    # Agrupo las ventas por categoría y calculo el total vendido
    consulta = """
        SELECT
            p.categoria,
            SUM(v.cantidad * p.precio) AS total_ventas
        FROM ventas v
        INNER JOIN productos p
            ON v.id_producto = p.id_producto
        GROUP BY p.categoria
        ORDER BY p.categoria
    """

    cursor.execute(consulta)
    resultados = cursor.fetchall()

    cursor.close()
    conexion.close()

    respuesta = []
    for fila in resultados:
        respuesta.append({
            "categoria": fila[0],
            "total_ventas": float(fila[1])
        })

    return respuesta