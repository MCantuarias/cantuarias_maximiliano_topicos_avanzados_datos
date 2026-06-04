EXPLAIN PLAN FOR
SELECT /*+ INDEX(dp idx_detalles_productoid) */
   	p.Nombre, SUM(dp.Cantidad * p.Precio) AS TotalVentas
FROM Productos p
JOIN DetallesPedidos dp ON p.ProductoID = dp.ProductoID
GROUP BY p.Nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);