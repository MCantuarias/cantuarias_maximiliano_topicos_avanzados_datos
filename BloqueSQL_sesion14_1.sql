CREATE OR REPLACE TYPE Vehiculo AS OBJECT (
    Marca VARCHAR2(50),
    Año NUMBER,
    MEMBER FUNCTION obtener_antiguedad RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY Vehiculo AS
    MEMBER FUNCTION obtener_antiguedad RETURN NUMBER IS
    BEGIN
        RETURN 2025 - Año;
    END;
END;

CREATE OR REPLACE TYPE Automovil UNDER Vehiculo (
    NumeroPuertas NUMBER,
    MEMBER FUNCTION descripcion RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY Automovil AS
    MEMBER FUNCTION descripcion RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Automóvil: ' || Marca || ', Año: ' || Año || ', Puertas: ' || NumeroPuertas;
    END;
END;
/