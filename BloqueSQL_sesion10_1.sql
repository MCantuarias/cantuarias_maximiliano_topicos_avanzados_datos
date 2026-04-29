CREATE OR REPLACE PROCEDURE actualizar_total_pedidos(p_cliente_id IN NUMBER, p_porcentaje IN NUMBER DEFAULT 10) AS​ 
	CURSOR pedido_cursor IS​ SELECT PedidoID, Total​ FROM Pedidos​ 
	WHERE ClienteID = p_cliente_id​ 
	FOR UPDATE;​ 
BEGIN​ 
	FOR pedido IN pedido_cursor LOOP​ 
	UPDATE Pedidos​ 
	SET Total = pedido.Total * (1 + p_porcentaje / 100)​ 
	WHERE CURRENT OF pedido_cursor;​ 
	DBMS_OUTPUT.PUT_LINE('Pedido ' || pedido.PedidoID || ': Nuevo total: ' || (pedido.Total * (1 + p_porcentaje / 100)));​ 
	END LOOP;​ 
	IF SQL%ROWCOUNT = 0 THEN​ 
	DBMS_OUTPUT.PUT_LINE('Cliente ' || p_cliente_id || ' no tiene pedidos.');​
	ELSE​ 
	COMMIT;​ 
	END IF;​ 
EXCEPTION​ 
	WHEN OTHERS THEN​ DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);​ ROLLBACK;​ END;​ 
/​ -- Prueba​ 
EXEC actualizar_total_pedidos(1);​