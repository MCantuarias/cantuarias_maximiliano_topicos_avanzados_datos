-- Simular fallo
DROP TABLE Productos;

-- Verificar
SELECT COUNT(*) FROM Productos; -- Error: tabla no existe

-- Recuperar con Flashback (si está habilitado)
FLASHBACK TABLE Productos TO BEFORE DROP;

-- Si Flashback no está habilitado, usar RMAN
rman target /

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
RUN {
	RESTORE TABLE curso_topicos.Productos;
	RECOVER TABLE curso_topicos.Productos;
}
ALTER DATABASE OPEN;

-- Verificar
SELECT COUNT(*) FROM Productos; -- Debería mostrar 2 filas