CREATE OR REPLACE PROCEDURE calcular_costo_detalle(p_detalle_id IN NUMBER, p_costo IN OUT NUMBER) AS​ 
	v_precio NUMBER;​ 
	v_cantidad NUMBER;​ 
BEGIN​ 
	SELECT p.Precio, d.Cantidad INTO v_precio, v_cantidad​ 
	FROM DetallesPedidos d​ 
	JOIN Productos p ON d.ProductoID = p.ProductoID​ 
	WHERE d.DetalleID = p_detalle_id;​ p_costo := v_precio * v_cantidad;​ 
	DBMS_OUTPUT.PUT_LINE('Costo del detalle ' || p_detalle_id || ': ' || p_costo);​ 
EXCEPTION​ 
	WHEN NO_DATA_FOUND THEN​ 
	RAISE_APPLICATION_ERROR(-20003, 'Detalle con ID ' || p_detalle_id || ' no encontrado.');​ 
END;​ /​ 
-- Prueba​ 
DECLARE​ v_costo NUMBER := 0;​ 
BEGIN​ calcular_costo_detalle(1, v_costo);​ 
DBMS_OUTPUT.PUT_LINE('Costo calculado: ' || v_costo);​ 
END;​ /​