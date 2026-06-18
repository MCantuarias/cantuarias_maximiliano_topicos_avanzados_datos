-- Optimización de consulta​
--Aplicacion de Explain plan para analizar la consulta y luego crear un índice para mejorar el rendimiento.​
EXPLAIN PLAN FOR​

SELECT c.Nombre, SUM(v.Total) AS TotalVentas​
FROM Clientes c​
JOIN Ventas v ON c.ClienteID = v.ClienteID​
GROUP BY c.Nombre;​

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);​
-- Resultado inicial: Costo 5, TABLE ACCESS FULL en Ventas​

-- Mejora: Crear índice​
CREATE INDEX idx_ventas_clienteid ON Ventas(ClienteID);​

EXPLAIN PLAN FOR​
SELECT c.Nombre, SUM(v.Total) AS TotalVentas​
FROM Clientes c​
JOIN Ventas v ON c.ClienteID = v.ClienteID​
GROUP BY c.Nombre;​
​
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);