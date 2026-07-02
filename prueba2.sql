--PARTE TEORICA
/*
PREGUNTA 1
Explica la diferencia entre un procedimiento almacenado y una función almacenada en PL/SQL. Da un ejemplo de cuándo usarías cada uno en el contexto de la base de datos de la prueba.
R: El procedimiento almacenado es una serie de código que no sobrescribe nada, sirve para mostrar o revisar valores dentro de la base de datos, a diferencia de la función almacenada que puede entrar en acción con los valores.
El procedimiento podría usarse para ver el total de incidentes, el total de agentes, cuantos incidentes hay a nombre de cada agente
La función podría usarse para calcular cuanto tiempo le llevo a un agente participar en un incidente o en que le asignaran un caso, si quiero calcular la diferencia del numero de casos entre líderes y apoyos, Cabe destacar que al ser almacenados, estan dentro de otra función o procedimiento

PREGUNTA 2
Describe cómo usarías un parámetro IN OUT en un procedimiento almacenado. Escribe un ejemplo de un procedimiento que use un parámetro IN OUT para actualizar y devolver las horas de una asignación después de un ajuste.

R: Se crea una variable que reciba el numero de horas antes de una asignación y luego se calcula y asigna a la misma variable después de la nueva asignación 
CREATE PROCEDURE ajustar_horas_asignacion (
    p_AsignacionID IN NUMBER,
    p_HorasAjuste IN NUMBER,
    p_HorasTotales IN OUT NUMBER
)
BEGIN
SELECT Horas INTO p_HorasTotales FROM Asignaciones WHERE AsignacionID = p_AsignacionID
p_HorasTotales := p_HorasTotales + p_HorasAjuste

    UPDATE Asignaciones
    SET Horas = p_HorasTotales
    WHERE AsignacionID = p_AsignacionID

PREGUNTA 3
¿Cómo se puede usar una función almacenada dentro de una consulta SQL? Escribe un ejemplo de una función que calcule el total de horas asignadas a un incidente y úsala en una consulta para listar los incidentes con su total de horas.
R: Se puede usar una función dentro de una consulta en el caso de que queramos un numero limite, es decir, puedo hacer mi consulta buscando el promedio total o de un agente en especifico y definir si quiero mostrar agentes con mayores horas o menores horas 
CREATE FUNCTION calcular_hora_incidentes (p_incidenteId)
SELECT NVL(SUM(Horas), 0) INTO v_TotalHoras FROM Asignaciones WHERE incidenteId = p_incidenteId;

for a in (select IncidenteID, Descripción, Severidad from Asignaciones ) LOOP
	DBMS(OUTPUT... || calcular_hora_incidentes(a.IncidenteID)


PREGUNTA 4
Explica qué es un trigger y menciona dos tipos de eventos que pueden dispararlo. Da un ejemplo de un trigger que se dispare después de insertar una asignación en la tabla Asignaciones y actualice el estado del incidente a 'En Proceso' si estaba en 'Abierto'.

R: Un trigger o disparador, es una modificación que se realiza según se cumplan las condiciones asignadas, es decir, son funciones que se activan luego de una accion, si por ejemplo tengo una tabla que lista a los agentes de forma mas simple y agrego un agente en la tabla principal, para no tener que hacer 2 veces lo mismo, asigno un trigger que por cada agente que se agregue en la tabla principal, se agregue de forma simplificada en la segunda.


CREATE TRIGGER estado_incidente
AFTER INSERT ON Asignaciones
FOR EACH ROW
DECLARE
v_IncidenteID NUMBER;
BEGIN
SELECT NVL(MAX(AuditoriaID), 0) + 1 INTO into v_IncidenteID from Asignaciones
UPDATE Incidentes
SET Estado = 'En Proceso'
WHERE IncidenteID = v_IncidenteID AND Estado = 'Abierto'
*/


--PARTE PRACTICA


--EJERCICIO 1: 
--Escribe un procedimiento registrar_asignacion que reciba un AgenteID, IncidenteID, Horas y Rol (parámetros IN). El procedimiento debe:
--insertar una nueva asignación en la tabla Asignaciones (usa el próximo AsignacionID disponible).
--actualizar el estado del incidente a 'En Proceso' si estaba en 'Abierto'.
--manejar excepciones si el agente o incidente no existen, o si el agente ya está asignado a ese incidente

CREATE OR REPLACE PROCEDURE registrar_asignacion (
    p_AgenteID IN NUMBER,
    p_IncidenteID IN NUMBER,
    p_Horas IN NUMBER,
    p_Rol IN VARCHAR2
) AS
    v_AsignaID NUMBER;
BEGIN
    -- Verificar si existen
    SELECT COUNT(*) INTO v_AsignaID FROM Agentes WHERE AgenteID = p_AgenteID;
    IF v_AsignaID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El agente no existe.');
    END IF;


    SELECT COUNT(*) INTO v_AsignaID FROM Incidentes WHERE IncidenteID = p_IncidenteID;
    IF v_AsignaID = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El incidente no existe.');
    END IF;

    SELECT COUNT(*) INTO v_AsignaID FROM Asignaciones 
    WHERE AgenteID = p_AgenteID AND IncidenteID = p_IncidenteID;
    IF v_AsignaID > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El agente ya está asignado a este incidente.');
    END IF;

    -- Obtener el próximo AsignacionID disponible
    SELECT NVL(MAX(AsignacionID), 0) + 1 INTO v_AsignaID FROM Asignaciones;

    -- Insertar la nueva asignación
    INSERT INTO Asignaciones (AsignacionID, AgenteID, IncidenteID, Horas, Rol)
    VALUES (v_AsignaID, p_AgenteID, p_IncidenteID, p_Horas, p_Rol);

    -- Actualizar el estado del incidente
    UPDATE Incidentes
    SET Estado = 'En Proceso'
    WHERE IncidenteID = p_IncidenteID AND Estado = 'Abierto';

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END registrar_asignacion;
/

--EJERCICIO 2:
--Escribe una función calcular_horas_agente que reciba un AgenteID (parámetro IN) y devuelva el total de horas 
--asignadas a ese agente en todos los incidentes. Luego, usa la función en un procedimiento 
--mostrar_carga_agentes que muestre el total de horas por agente para todos los agentes, indicando su nombre y especialidad.
CREATE OR REPLACE FUNCTION calcular_horas_agente (
    p_AgenteID IN NUMBER
) RETURN NUMBER AS
    v_TotalHoras NUMBER;

BEGIN
    SELECT NVL(SUM(Horas), 0) INTO v_TotalHoras FROM Asignaciones WHERE AgenteID = p_AgenteID;
    RETURN v_TotalHoras;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END calcular_horas_agente;
/

CREATE OR REPLACE PROCEDURE mostrar_carga_agentes AS
BEGIN
    FOR rec IN (SELECT AgenteID, Nombre, Especialidad FROM Agentes) LOOP
        DBMS_OUTPUT.PUT_LINE('Agente: ' || rec.Nombre || ' | Especialidad: ' || rec.Especialidad || ' | Total Horas: ' || calcular_horas_agente(rec.AgenteID));
    END LOOP;
END mostrar_carga_agentes;
/
SELECT a.AgenteID, d.Nombre, SUM(a.Horas) AS TotalHoras, COUNT(DISTINCT a.IncidenteID) AS TotalIncidentes
from Asignaciones a
join Agentes d on a.AgenteID = d.AgenteID
group by a.AgenteID, d.Nombre
order by TotalHoras desc
/
--EJERCICIO 3:
--Implementa un sistema de auditoría manual usando un trigger. Para esto, primero crea una tabla llamada 
--AuditoriaAsignaciones con las columnas necesarias. Luego, crea un trigger auditar_asignaciones que se 
--dispare después de insertar o eliminar una asignación en la tabla Asignaciones. El trigger debe registrar
-- en la tabla de auditoría el AsignacionID, AgenteID, IncidenteID, Horas, la acción realizada ('INSERT' o 'DELETE')
-- y la fecha del registro.

-- Crear tabla de auditoría
CREATE TABLE AuditoriaAsignaciones (
    AuditoriaID NUMBER PRIMARY KEY,
    AsignacionID NUMBER FOREIGN KEY REFERENCES Asignaciones(AsignacionID),
    AgenteID NUMBER FOREIGN KEY REFERENCES Agentes(AgenteID),
    IncidenteID NUMBER FOREIGN KEY REFERENCES Incidentes(IncidenteID),
    Horas NUMBER,
    Accion VARCHAR2(10),
    FechaRegistro DATE
);

CREATE TRIGGER auditar_asignaciones
AFTER INSERT OR DELETE ON Asignaciones
FOR EACH ROW
DECLARE
    v_AuditoriaID NUMBER;
BEGIN
    SELECT NVL(MAX(AuditoriaID), 0) + 1 INTO v_AuditoriaID FROM AuditoriaAsignaciones;
    IF INSERTING THEN
        INSERT INTO AuditoriaAsignaciones (AuditoriaID, AsignacionID, AgenteID, IncidenteID, Horas, Accion, FechaRegistro)
        VALUES (v_AuditoriaID, :NEW.AsignacionID, :NEW.AgenteID, :NEW.IncidenteID, :NEW.Horas, 'INSERT', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditoriaAsignaciones (AuditoriaID, AsignacionID, AgenteID, IncidenteID, Horas, Accion, FechaRegistro)
        VALUES (v_AuditoriaID, :OLD.AsignacionID, :OLD.AgenteID, :OLD.IncidenteID, :OLD.Horas, 'DELETE', SYSDATE);
    END IF;
END auditar_asignaciones;
/



