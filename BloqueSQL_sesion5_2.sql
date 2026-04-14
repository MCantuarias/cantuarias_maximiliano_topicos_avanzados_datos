DECLARE
    CURSOR c_actualizar_pedido(p_id NUMBER) IS
        SELECT PedidoID, Total FROM Pedidos 
        WHERE PedidoID = p_id
        FOR UPDATE;
        
    v_pedido_antiguo c_actualizar_pedido%ROWTYPE;
BEGIN
    OPEN c_actualizar_pedido(10);
    FETCH c_actualizar_pedido INTO v_pedido_antiguo;
    
    IF c_actualizar_pedido%FOUND THEN
        UPDATE Pedidos 
        SET Total = Total * 1.1 
        WHERE CURRENT OF c_actualizar_pedido;
        
        DBMS_OUTPUT.PUT_LINE('Original: ' || v_pedido_antiguo.Total || ' | Nuevo: ' || (v_pedido_antiguo.Total * 1.1));
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontro el pedido.');
    END IF;
    
    CLOSE c_actualizar_pedido;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF c_actualizar_pedido%ISOPEN THEN CLOSE c_actualizar_pedido; 
	END IF;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;