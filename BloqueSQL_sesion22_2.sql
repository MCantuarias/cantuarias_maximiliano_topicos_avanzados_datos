-- Consulta de solo lectura para el nodo standby​

SELECT c.ClienteID, c.Nombre, SUM(p.Total) AS TotalVentas​
FROM Clientes c​
JOIN Pedidos p ON c.ClienteID = p.ClienteID​
WHERE p.FechaPedido BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-06-30', 'YYYY-MM-DD')​
GROUP BY c.ClienteID, c.Nombre​
ORDER BY TotalVentas DESC;​

-- Uso de Active Data Guard:​
-- - El nodo standby está en modo de solo lectura mientras se sincroniza con el principal​
-- - Esta consulta se ejecuta en el standby para no afectar el rendimiento del nodo principal​
-- - Beneficio: Balanceo de carga, ya que las operaciones de escritura (INSERT, UPDATE) se realizan en el principal