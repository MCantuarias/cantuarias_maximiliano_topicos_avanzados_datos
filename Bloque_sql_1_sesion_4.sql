DECLARE
    v_cantidad_pedido NUMBER;
    v_pedido_id       NUMBER := 10;
    v_guia            NUMBER := 5;

    e_cantidad_baja EXCEPTION;
BEGIN
    SELECT Cantidad INTO v_cantidad_pedido FROM DetallesPedidos 
    WHERE PedidoID = v_pedido_id;


    IF v_cantidad_pedido < v_guia THEN
        RAISE e_cantidad_baja;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Cantidad valida: ' || v_cantidad_pedido);

EXCEPTION
    WHEN e_cantidad_baja THEN
        DBMS_OUTPUT.PUT_LINE('Error: La cantidad (' || v_cantidad_pedido || ') es inferior al minimo permitido de ' || v_guia);
    
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se encontro ningun pedido con el ID ' || v_pedido_id);
    
END;

