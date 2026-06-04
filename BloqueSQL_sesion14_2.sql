CREATE OR REPLACE TYPE Camion UNDER Vehiculo (
    CapacidadCarga NUMBER,
    OVERRIDING MEMBER FUNCTION obtener_antiguedad RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY Camion AS
    OVERRIDING MEMBER FUNCTION obtener_antiguedad RETURN NUMBER IS
    BEGIN
        -- Lógica personalizada: suma 2 años adicionales a la antigüedad base
        RETURN (2025 - Año) + 2;
    END;
END;
/

INSERT INTO Vehiculos VALUES (Camion('Volvo', 2018, 10));

SELECT v.Marca, v.obtener_antiguedad() AS Antiguedad
FROM Vehiculos v
WHERE VALUE(v) IS OF (Camion);