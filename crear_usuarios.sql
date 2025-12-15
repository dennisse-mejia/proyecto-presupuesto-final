-- Script para crear nuevos usuarios en la base de datos
-- Ejecuta esto en SQL Server Management Studio o Azure Data Studio

USE ProyectoBD;
GO

-- Crear Usuario 2
EXEC sp_usuario_insert
    @nombre = 'María',
    @apellido = 'García',
    @correo = 'maria.garcia@ejemplo.com',
    @fecha_registro = '2025-12-14',
    @salario_mensual = 25000.00,
    @estado = 'ACTIVO',
    @creado_por = 'admin';
GO

-- Crear Usuario 3
EXEC sp_usuario_insert
    @nombre = 'Carlos',
    @apellido = 'Rodríguez',
    @correo = 'carlos.rodriguez@ejemplo.com',
    @fecha_registro = '2025-12-14',
    @salario_mensual = 30000.00,
    @estado = 'ACTIVO',
    @creado_por = 'admin';
GO

-- Crear Usuario 4
EXEC sp_usuario_insert
    @nombre = 'Ana',
    @apellido = 'Martínez',
    @correo = 'ana.martinez@ejemplo.com',
    @fecha_registro = '2025-12-14',
    @salario_mensual = 22000.00,
    @estado = 'ACTIVO',
    @creado_por = 'admin';
GO

-- Verificar que se crearon
SELECT id_usuario, nombre, apellido, correo, salario_mensual, estado, fecha_registro
FROM usuario
ORDER BY id_usuario;
GO
