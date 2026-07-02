-- Script para crear y poblar la base de datos para la Prueba 3
-- Ejecutar en Oracle SQL Developer en el esquema del estudiante

SET SERVEROUTPUT ON;

-- Eliminar tablas si ya existen
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Asignaciones CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Incidentes CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Agentes CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Crear tabla Agentes
CREATE TABLE Agentes (
    AgenteID     NUMBER PRIMARY KEY,
    Nombre       VARCHAR2(50),
    Especialidad VARCHAR2(50),
    FechaIngreso DATE
);

-- Crear tabla Incidentes
CREATE TABLE Incidentes (
    IncidenteID    NUMBER PRIMARY KEY,
    Descripcion    VARCHAR2(100),
    Severidad      VARCHAR2(20),
    Estado         VARCHAR2(20),
    FechaDeteccion DATE
);

-- Crear tabla Asignaciones
CREATE TABLE Asignaciones (
    AsignacionID NUMBER PRIMARY KEY,
    AgenteID     NUMBER,
    IncidenteID  NUMBER,
    Horas        NUMBER,
    Rol          VARCHAR2(30),
    CONSTRAINT fk_asig_agente    FOREIGN KEY (AgenteID)    REFERENCES Agentes(AgenteID),
    CONSTRAINT fk_asig_incidente FOREIGN KEY (IncidenteID) REFERENCES Incidentes(IncidenteID)
);

-- Insertar datos en Agentes
INSERT INTO Agentes VALUES (101, 'Camila Reyes',     'Pentester',       TO_DATE('2023-03-15','YYYY-MM-DD'));
INSERT INTO Agentes VALUES (102, 'Diego Muñoz',      'Analista SOC',    TO_DATE('2022-07-01','YYYY-MM-DD'));
INSERT INTO Agentes VALUES (103, 'Valentina Soto',   'Analista SOC',    TO_DATE('2024-01-10','YYYY-MM-DD'));
INSERT INTO Agentes VALUES (104, 'Matías Fernández', 'Forense Digital', TO_DATE('2021-11-20','YYYY-MM-DD'));
INSERT INTO Agentes VALUES (105, 'Francisca López',  'Pentester',       TO_DATE('2023-08-05','YYYY-MM-DD'));

-- Insertar datos en Incidentes
INSERT INTO Incidentes VALUES (201, 'Ransomware LockBit en servidor de archivos', 'Critical', 'Abierto',  TO_DATE('2026-03-01','YYYY-MM-DD'));
INSERT INTO Incidentes VALUES (202, 'Campaña de Phishing dirigida a RRHH',        'High',     'Abierto',  TO_DATE('2026-03-03','YYYY-MM-DD'));
INSERT INTO Incidentes VALUES (203, 'DDoS en portal web institucional',            'High',     'Cerrado',  TO_DATE('2026-03-20','YYYY-MM-DD'));
INSERT INTO Incidentes VALUES (204, 'SQL Injection en API de pagos',               'Critical', 'Abierto',  TO_DATE('2026-04-05','YYYY-MM-DD'));
INSERT INTO Incidentes VALUES (205, 'Exfiltración de datos via DNS tunneling',     'Medium',   'Cerrado',  TO_DATE('2026-04-10','YYYY-MM-DD'));
INSERT INTO Incidentes VALUES (206, 'Acceso no autorizado a base de datos',        'Critical', 'Abierto',  TO_DATE('2026-05-02','YYYY-MM-DD'));
INSERT INTO Incidentes VALUES (207, 'Malware en estaciones de trabajo',            'Medium',   'Cerrado',  TO_DATE('2026-05-15','YYYY-MM-DD'));

-- Insertar datos en Asignaciones
INSERT INTO Asignaciones VALUES (1,  101, 201, 40, 'Lider');
INSERT INTO Asignaciones VALUES (2,  102, 201, 35, 'Apoyo');
INSERT INTO Asignaciones VALUES (3,  102, 202, 20, 'Lider');
INSERT INTO Asignaciones VALUES (4,  103, 202, 25, 'Apoyo');
INSERT INTO Asignaciones VALUES (5,  103, 203, 30, 'Lider');
INSERT INTO Asignaciones VALUES (6,  104, 204, 45, 'Lider');
INSERT INTO Asignaciones VALUES (7,  101, 204, 35, 'Apoyo');
INSERT INTO Asignaciones VALUES (8,  105, 205, 25, 'Lider');
INSERT INTO Asignaciones VALUES (9,  104, 201, 20, 'Apoyo');
INSERT INTO Asignaciones VALUES (10, 102, 206, 50, 'Lider');
INSERT INTO Asignaciones VALUES (11, 105, 206, 30, 'Apoyo');
INSERT INTO Asignaciones VALUES (12, 103, 207, 15, 'Lider');

COMMIT;

SELECT 'Tablas creadas y datos insertados correctamente.' AS mensaje FROM dual;

SELECT * FROM Agentes;
SELECT * FROM Incidentes;
SELECT * FROM Asignaciones;

/*
================================================================================
PRUEBA 3 - TÓPICOS AVANZADOS DE BASES DE DATOS
================================================================================

INSTRUCCIONES GENERALES:
- Tiempo: 90 minutos
- Puntaje total: 100 puntos
- Parte 1 (teórica): 40 puntos | Parte 2 (práctica): 60 puntos
- Ejecute el script de datos antes de comenzar la parte práctica
- En la parte teórica, la lógica y el concepto son lo que se evalúa;
  errores menores de sintaxis no penalizan si la idea es correcta

================================================================================
PARTE 1 - PREGUNTAS TEÓRICAS (40 puntos, 10 puntos cada una)
================================================================================
PREGUNTA 1 (10 puntos)
Explica qué es una transacción en una base de datos y describe las propiedades
ACID. Luego, muestra a través de un ejemplo cómo usarías múltiples savepoints
para manejar errores parciales en un procedimiento que asigna un agente a un
incidente y actualiza simultáneamente el estado del incidente. ¿Qué ocurre si
falla solo la actualización del estado?


R: Una transacción es una unidad de trabajo que ejecuta sus operaciones de manera indivisible o de manera atomica en una base de datos, 
asegurando que todas las operaciones dentro de ella se completen correctamente o ninguna se aplique.
Las propiedades ACID son:
- Atomicidad: Garantiza que todas las operaciones de la transacción se completen o ninguna
- Consistencia: Mantiene la integridad de la base de datos, asegurando que las reglas y restricciones se cumplan
- Aislamiento: Asegura que las transacciones concurrentes no interfieran entre sí
- Durabilidad: Garantiza que los cambios realizados por una transacción exitosa se mantengan incluso en caso de fallos del sistema

Se puede usar múltiples savepoints para manejar errores parciales en un procedimiento almacenado. 
Por ejemplo, si se asigna un agente a un incidente y luego se intenta actualizar el estado del incidente, 
se puede establecer un savepoint antes de cada operación. 
Si la actualización del estado falla, se puede hacer un rollback al savepoint anterior, lo que permite que la asignación 
del agente permanezca intacta mientras se maneja el error de la actualización del estado.


PREGUNTA 2 (10 puntos)
¿Qué es un Data Warehouse y cómo se diferencia de una base de datos
transaccional? Describe cómo diseñarías un modelo dimensional (tabla de hechos
y al menos dos dimensiones) para analizar las horas trabajadas por agente y
por severidad de incidente. ¿Qué ventajas tiene este modelo para consultas
analíticas versus consultar directamente las tablas transaccionales?

R: Un Data Warehouse es un sistema de almacenamiento de datos diseñado para facilitar el análisis y la 
toma de decisiones empresariales. Se diferencia de una base de datos transaccional en que está optimizado para 
consultas complejas y análisis de grandes volúmenes de datos, mientras que las bases de datos transaccionales 
están diseñadas para manejar operaciones diarias y transacciones rápidas.
Para diseñar un modelo dimensional para analizar las horas trabajadas por agente y por severidad de incidente, 
se podría crear una tabla de hechos llamada detalles_Asignaciones que contenga las métricas de horas trabajadas y
el número de incidentes atendidos. Esta tabla tendría claves foráneas que se relacionen con dos dimensiones: 
Dimension_Agente (con atributos como AgenteID, Nombre, Especialidad) y Dimension_Incidente (con atributos como IncidenteID,
Severidad, Estado, FechaDeteccion).
Este modelo permite realizar consultas analíticas más eficientes y rápidas, ya que las tablas de hechos y 
dimensiones están diseñadas para optimizar la agregación y el filtrado de datos, en comparación con las tablas 
transaccionales que pueden ser más complejas y lentas para consultas analíticas debido a su estructura normalizada 
y la necesidad de unir múltiples tablas.



PREGUNTA 3 (10 puntos)
Explica cómo se implementa la herencia en Oracle usando tipos de objetos.
Da un ejemplo de una jerarquía de dos niveles: Agente → AgenteEspecialista →
AgentePentester, donde cada nivel agrega atributos y sobreescribe un método
calcular_costo(). ¿Qué implicancias tiene declarar un tipo como NOT
INSTANTIABLE?
R: En Oracle, la herencia se implementa mediante tipos de objetos, donde un tipo puede heredar atributos 
y métodos de otro tipo al igual que en programación orientada a objetos.
En el ejemplo de la jerarquía mencionada, se puede definir un tipo base Agente con 
atributos como AgenteID, Nombre, Especialidad, y un método calcular_costo(). Luego, AgenteEspecialista puede heredar 
de Agente y agregar atributos adicionales como NivelEspecializacion, y sobreescribir el método calcular_costo(). 
Finalmente, AgentePentester puede heredar de AgenteEspecialista y agregar atributos como Certificaciones, e ir modificando o sobreescribiendo 
el método calcular_costo() para agenteEspecialista y agentePentester según sus atributos.


Declarar un tipo como NOT INSTANTIABLE significa que no se pueden crear instancias de ese tipo. Se usa este prefijo para definir tipos
base que solo sirven como plantillas para otros tipos derivados, asegurando que solo se pueda crear instancias de los tipos mas especificos en la
jerarquia.
Esto ayuda a mantener la integridad del diseño y evita la creación de objetos incompletos o genéricos que no 
deberían existir por sí mismos.

PREGUNTA 4 (10 puntos)
Describe las ventajas y desventajas de usar índices y particiones en una base
de datos. ¿Cómo usarías un índice compuesto y una partición por rango para
mejorar el rendimiento de consultas en la tabla Incidentes filtradas por
Severidad y FechaDeteccion? Explica qué es el partition pruning y cómo
impacta en el plan de ejecución.

R: Los indices mejoran el rendimiento de las consultas al permitir un acceso más rápido a los datos, pero pueden
realizar operaciones de escritura más lentas debido a la necesidad de mantener el índice actualizado.
Las particiones permiten dividir una tabla grande en partes más pequeñas, lo que facilita la gestión y mejora el rendimiento 
de las consultas al permitir que solo se acceda a las particiones relevantes.
Para mejorar el rendimiento de consultas en la tabla Incidentes filtradas por Severidad y FechaDeteccion, se podría crear un 
índice compuesto en las columnas Severidad y FechaDeteccion.
Además, se podría particionar la tabla Incidentes por rango de FechaDeteccion, por ejemplo, semestralmente para un año especifico. 
Esto permitiría que las consultas que filtren por estas columnas solo accedan a las particiones relevantes, reduciendo la cantidad 
de datos que se deben escanear y mejora el tiempo de respuesta.
El partition pruning es una técnica que permite al optimizador de consultas identificar y acceder únicamente a las 
particiones que contienen los datos relevantes para una consulta específica. Esto impacta positivamente en el plan 
de ejecución, ya que reduce la cantidad de datos que se deben leer y procesar, mejorando significativamente el rendimiento de la consulta.
================================================================================
PARTE 2 - EJERCICIOS PRÁCTICOS (60 puntos)
================================================================================
*/

/*EJERCICIO 1 (20 puntos)
Escribe un procedimiento registrar_asignacion que reciba un AgenteID,
IncidenteID, Horas y Rol (parámetros IN). El procedimiento debe:
  a) Insertar una nueva asignación en Asignaciones (usa el próximo
     AsignacionID disponible).
  b) Validar que el agente no supere 100 horas totales asignadas en
     incidentes con Estado 'Abierto'.
  c) Validar que el incidente no tenga ya 3 o más agentes asignados.
  d) Usar savepoints independientes para cada validación, de modo que un
     fallo en una no deshaga operaciones previas válidas.
  e) Manejar todas las excepciones con mensajes descriptivos.
*/

CREATE OR REPLACE PROCEDURE registrar_asignacion (
      p_AgenteID IN NUMBER,
      p_IncidenteID IN NUMBER,
      p_Horas IN NUMBER,
      p_Rol IN VARCHAR2
  ) IS
      v_total_horas NUMBER;
      v_total_agentes NUMBER;
      v_next_id NUMBER;
  BEGIN
      -- a)
      SELECT NVL(MAX(AsignacionID), 0) + 1 INTO v_next_id FROM Asignaciones;

      -- Validación de horas del agente
      SAVEPOINT sp_horas;
      SELECT NVL(SUM(Horas), 0) INTO v_total_horas
      FROM Asignaciones a
      JOIN Incidentes i ON a.IncidenteID = i.IncidenteID
      WHERE a.AgenteID = p_AgenteID AND i.Estado = 'Abierto';
      -- b)
      IF (v_total_horas + p_Horas) > 100 THEN
          RAISE_APPLICATION_ERROR(-20001, 'El agente supera las 100 horas totales asignadas en incidentes abiertos.');
      END IF;

      -- Validación de número de agentes asignados al incidente
      SAVEPOINT sp_agentes;
      SELECT COUNT(*) INTO v_total_agentes
      FROM Asignaciones
      WHERE IncidenteID = p_IncidenteID;
      -- c) 
      IF v_total_agentes >= 3 THEN
          RAISE_APPLICATION_ERROR(-20002, 'El incidente ya tiene 3 o más agentes asignados.');
      END IF;

      -- Insertar la nueva asignación
      INSERT INTO Asignaciones (AsignacionID, AgenteID, IncidenteID, Horas, Rol)
      VALUES (v_next_id, p_AgenteID, p_IncidenteID, p_Horas, p_Rol);
      -- d) se realiza por cada validacion
  EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK TO sp_horas; -- Deshacer validación de horas si falla
          ROLLBACK TO sp_agentes; -- Deshacer validación de agentes si falla
          RAISE;
  END registrar_asignacion;
/


/* EJERCICIO 2 (20 puntos)
Diseña las tablas Fact_Asignaciones, Dim_Agente y Dim_Incidente para un
Data Warehouse basado en la base de datos de la prueba. Luego, escribe una
consulta analítica sobre las tablas transaccionales que muestre, para cada
agente, el total de horas trabajadas y el número de incidentes atendidos,
ordenado de mayor a menor por total de horas.
*/

CREATE TABLE Dim_Agente (
    AgenteID     NUMBER PRIMARY KEY,
    Nombre       VARCHAR2(50),
    Especialidad VARCHAR2(50),
    FechaIngreso DATE
)
/
CREATE TABLE Dim_Incidente (
    IncidenteID    NUMBER PRIMARY KEY,
    Descripcion    VARCHAR2(100),
    Severidad      VARCHAR2(20),
    Estado         VARCHAR2(20),
    FechaDeteccion DATE
)
/

CREATE TABLE Fact_Asignaciones (
    AsignacionID NUMBER PRIMARY KEY,
    AgenteID     NUMBER,
    IncidenteID  NUMBER,
    Horas        NUMBER,
    Rol          VARCHAR2(30),
    FOREIGN KEY (AgenteID) REFERENCES Dim_Agente(AgenteID),
    FOREIGN KEY (IncidenteID) REFERENCES Dim_Incidente(IncidenteID)
)
/

/* EJERCICIO 3 (20 puntos)
Crea un índice compuesto en Incidentes para las columnas Severidad y
FechaDeteccion. Luego, crea la tabla Incidentes particionada por rango de
FechaDeteccion (trimestral para 2026). Escribe una consulta que muestre el
total de horas asignadas por incidente para incidentes 'Critical' detectados
en el primer trimestre de 2026. Finalmente, muestra el plan de ejecución
con EXPLAIN PLAN e indica qué ventaja aporta la partición para esta consulta.
*/

CREATE INDEX idx_severidad_fecha ON Incidentes (Severidad, FechaDeteccion)
/
CREATE TABLE Incidentes_Particionada (
    IncidenteID    NUMBER PRIMARY KEY,
    Descripcion    VARCHAR2(100),
    Severidad      VARCHAR2(20),
    Estado         VARCHAR2(20),
    FechaDeteccion DATE
)
PARTITION BY RANGE (FechaDeteccion) (
    PARTITION p_q1_2026 VALUES LESS THAN (TO_DATE('2026-04-01','YYYY-MM-DD')),
    PARTITION p_q2_2026 VALUES LESS THAN (TO_DATE('2026-07-01','YYYY-MM-DD')),
    PARTITION p_q3_2026 VALUES LESS THAN (TO_DATE('2026-10-01','YYYY-MM-DD')),
    PARTITION p_q4_2026 VALUES LESS THAN (TO_DATE('2027-01-01','YYYY-MM-DD'))
)
SELECT i.IncidenteID, SUM(a.Horas) AS TotalHoras
FROM Incidentes_Particionada i
JOIN Asignaciones a ON i.IncidenteID = a.IncidenteID
WHERE i.Severidad = 'Critical' AND i.FechaDeteccion >= TO_DATE('2026-01-01','YYYY-MM-DD') AND i.FechaDeteccion < TO_DATE('2026-04-01','YYYY-MM-DD')
GROUP BY i.IncidenteID
ORDER BY TotalHoras DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
--================================================================================