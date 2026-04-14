DECLARE
	v_id_nuevo NUMBER := 2;
	v_nombre_nuevo VARCHAR2(50) := 'test';

BEGIN
	INSERT INTO Usuarios (id, nombre)
	VALUES(v_id_nuevo, v_nombre_nuevo);
	DBMS_OUTPUT.PUT_LINE('Insercion exitosa');
	COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: El ID ' || v_id_nuevo || ' ya existe en la tabla Usuarios.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;