-- Habilitar auditoría (requiere privilegios de administrador)​

CONNECT sys AS sysdba;​
AUDIT SELECT ON Clientes BY user_analista;​
AUDIT INSERT ON Pedidos BY user_analista;​​

-- Realizar acciones como user_analista​
CONNECT user_analista/analista123;​
SELECT * FROM Clientes;​
INSERT INTO Pedidos (PedidoID, ClienteID, Total, FechaPedido)​
VALUES (110, 2, 2000, TO_DATE('2025-06-02', 'YYYY-MM-DD'));​
​
-- Ver registros de auditoría​

CONNECT sys AS sysdba;​
SELECT username, action_name, timestamp​
FROM dba_audit_trail​
WHERE username = 'USER_ANALISTA';