--========================================================================
--SENTENCIAS SIMPLES======================================================
SQL> select * from Productos;

PRODUCTOID NOMBRE                                                 PRECIO
---------- -------------------------------------------------- ----------
         1 Laptop                                                   1200
         2 Mouse                                                      25

SQL> select * from Clientes;

 CLIENTEID NOMBRE
---------- --------------------------------------------------
CIUDAD                                             FECHANACI
-------------------------------------------------- ---------
         1 Juan Perez
Santiago                                           15-MAY-90

         2 Mar??a Gomez
Valparaiso                                         20-OCT-85

         3 Ana Lopez
Santiago                                           10-MAR-95

--========================================================================

--SENTENCIAS CON FUNCIONES AGREGADAS======================================
--Nombre del cliente con pedido mayor a 500===============================

SQL> SELECT c.nombre FROM Clientes c JOIN Pedidos p ON c.ClienteID = p.ClienteID  WHERE p.Total > 500;

NOMBRE
--------------------------------------------------
Juan Perez
Mar??a Gomez
Total gastado por cliente

--========================================================================
--Clientes sin pedidos====================================================

SQL> SELECT c.nombre FROM Clientes c LEFT JOIN Pedidos p ON c.ClienteID = p.ClienteID WHERE p.PedidoID IS NULL;

NOMBRE
--------------------------------------------------
Ana Lopez

--========================================================================

--SENTENCIAS CON EXPRESIONES REGULARES====================================
--Pedido mas caro=========================================================

SQL> SELECT * FROM Pedidos WHERE Total = (SELECT MAX(Total) FROM Pedidos);

  PEDIDOID  CLIENTEID      TOTAL FECHAPEDI
---------- ---------- ---------- ---------
       103          2        800 03-MAR-25

--========================================================================
--Clientes que han hecho pedidos mas caros que el promedio================

SQL> SELECT c.nombre, p.total FROM Clientes c join Pedidos p ON c.ClienteID = p.ClienteID WHERE p.total > (SELECT AVG(Total) FROM Pedidos);

NOMBRE                                                  TOTAL
-------------------------------------------------- ----------
Juan Perez                                                600
Mar??a Gomez                                              800

--========================================================================
--VISTAS==================================================================
--Pedidos con Clientes==============================================
CREATE VIEW Vista_PedidosClientes AS SELECT p.PedidoID, c.Nombre, p.Total, p.FechaPedido FROM Pedidos p JOIN Clientes c ON p.ClienteID = c.ClienteID;
SQL> select * from Vista_PedidosClientes;

  PEDIDOID NOMBRE                                                  TOTAL
---------- -------------------------------------------------- ----------
FECHAPEDI
---------
       101 Juan Perez                                                600
01-MAR-25

       102 Juan Perez                                                300
02-MAR-25

       103 Mar??a Gomez                                              800
03-MAR-25
--========================================================================
--Total Comprado por cliente==============================================
CREATE OR REPLACE VIEW Vista_DetalleClientes AS SELECT c.ClienteID, c.Nombre AS Cliente, SUM(dp.Cantidad * pr.Precio) AS TotalCompra FROM Pedidos p JOIN Clientes c ON p.ClienteID = c.ClienteID JOIN DetallesPedidos dp ON p.PedidoID = dp.PedidoID JOIN Productos pr ON dp.ProductoID = pr.ProductoID GROUP BY c.ClienteID, c.Nombre;

SQL> select * from Vista_DetalleClientes;

 CLIENTEID CLIENTE                                            TOTALCOMPRA
---------- -------------------------------------------------- -----------
         1 Juan Perez                                                2775
         2 Mar??a Gomez                                              1200
