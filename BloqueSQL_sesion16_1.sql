EXPLAIN PLAN FOR
SELECT c.Nombre, COUNT(p.PedidoID) AS TotalPedidos
FROM Clientes c, Pedidos p
WHERE c.ClienteID = p.ClienteID
AND c.Ciudad = 'Santiago'
AND p.FechaPedido >= TO_DATE('2025-03-01', 'YYYY-MM-DD')
GROUP BY c.Nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_clientes_ciudad ON Clientes(Ciudad);

EXPLAIN PLAN FOR
SELECT /*+ INDEX(c idx_clientes_ciudad) INDEX(p idx_pedidos_clienteid) */
   	c.Nombre, COUNT(p.PedidoID) AS TotalPedidos
FROM Clientes c
JOIN Pedidos p ON c.ClienteID = p.ClienteID
WHERE c.Ciudad = 'Santiago'
AND p.FechaPedido >= TO_DATE('2025-03-01', 'YYYY-MM-DD')
GROUP BY c.Nombre;

