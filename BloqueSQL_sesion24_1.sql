-- Asigna permisos especificos a roles y usuarios
CREATE ROLE rol_usuario;​
CREATE ROLE rol_admin;​

GRANT SELECT, INSERT ON Productos TO rol_usuario;​
GRANT SELECT, INSERT ON Ventas TO rol_usuario;​
GRANT ALL PRIVILEGES ON Productos, Ventas, Clientes TO rol_admin;​

CREATE USER usuario1 IDENTIFIED BY user123;​
GRANT rol_usuario TO usuario1;​

CREATE USER admin1 IDENTIFIED BY admin123;​
GRANT rol_admin TO admin1;