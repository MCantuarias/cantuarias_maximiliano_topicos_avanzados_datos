CREATE OR REPLACE PROCEDURE contar_pedidos_cliente(p_cliente_id IN NUMBER, p_cantidad OUT NUMBER) AS​

BEGIN​

	SELECT COUNT(*) INTO p_cantidad​

	FROM Pedidos​

	WHERE ClienteID = p_cliente_id;​

END;