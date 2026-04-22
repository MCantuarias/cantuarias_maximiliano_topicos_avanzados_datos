SELECT a.AgenteId, SUM(asig.Horas) FROM Agentes a JOIN Asignaciones asig on asig.AgenteId = a.AgenteId WHERE asig.Horas > 30 GROUP BY a.AgenteId


CURSOR c_agente IS
	SELECT a.AgenteId, SUM(asig.Horas) FROM Agentes a JOIN Asignaciones asig on asig.AgenteId = a.AgenteId WHERE asig.Horas > 30 GROUP BY a.AgenteId

v_horas Asignaciones.Horas%TYPE
v_agenteId Agentes.