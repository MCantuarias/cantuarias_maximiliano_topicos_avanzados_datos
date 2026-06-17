-- Estrategia de Respaldo
-- - Respaldo completo: Cada domingo a las 23:00
-- - Respaldo incremental (nivel 1): Diariamente a las 23:00
-- - Retención: Mantener respaldos de las últimas 2 semanas
-- - Ubicación: Disco local (/u01/backup) y copia en la nube (AWS S3)

-- Script RMAN para respaldo completo
rman target /

CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 14 DAYS;
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT '/u01/backup/%U';

RUN {
	BACKUP DATABASE PLUS ARCHIVELOG;
	DELETE OBSOLETE;
}

-- Script RMAN para respaldo incremental
RUN {
	BACKUP INCREMENTAL LEVEL 1 DATABASE;
	BACKUP ARCHIVELOG ALL;
}

LIST BACKUP;
