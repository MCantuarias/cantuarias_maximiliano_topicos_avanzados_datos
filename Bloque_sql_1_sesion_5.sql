DECLARE
    CURSOR c_detalles IS 
        SELECT PedidoID, Cantidad FROM DetallesPedidos 
        ORDER BY Cantidad DESC;
    
--Cuidado con las mayusculas
    v_pedido_id DetallesPedidos.PedidoID%TYPE;
    v_cantidad  DetallesPedidos.Cantidad%TYPE;
    v_guia      NUMBER := 5;
BEGIN
    OPEN c_detalles;
    LOOP
        FETCH c_detalles INTO v_pedido_id, v_cantidad;
        EXIT WHEN c_detalles%NOTFOUND;
        
        IF v_cantidad < v_guia THEN
            DBMS_OUTPUT.PUT_LINE('Pedido ' || v_pedido_id || ' tiene cantidad baja: ' || v_cantidad);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Pedido ' || v_pedido_id || ' tiene cantidad valida: ' || v_cantidad);
        END IF;
    END LOOP;
    CLOSE c_detalles;
END;