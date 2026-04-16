CREATE OR REPLACE PROCEDURE aumentar_precio_producto(p_producto_id IN NUMBER, p_porcentaje IN NUMBER) AS​

BEGIN​

	UPDATE Productos​

	SET Precio = Precio * (1 + p_porcentaje / 100)​

	WHERE ProductoID = p_producto_id;​

	IF SQL%ROWCOUNT = 0 THEN​

    		RAISE NO_DATA_FOUND;

	END IF;​

	DBMS_OUTPUT.PUT_LINE('Precio del producto ' || p_producto_id || ' aumentado en ' || p_porcentaje || '%.');​

	COMMIT;​

EXCEPTION​

	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Error: El product ' || p_producto_id || ' no encontrado.')
	WHEN OTHERS THEN​

    	DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);​

END;​