CREATE INDEX idx_detalles_pedido_producto ON
DetallesPedidos(PedidoID, ProductoID);

EXPLAIN PLAN FOR
SELECT * FROM DetallesPedidos
WHERE PedidoID = 108 AND ProductoID =1;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM DetallesPedidos
WHERE PedidoID = 108 AND ProductoID=1;