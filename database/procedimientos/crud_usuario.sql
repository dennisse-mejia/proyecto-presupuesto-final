USE ProyectoBD;
GO

-- CRUD USUARIO
-- Tabla Usuario
-- sp_usuario_insert
-- Crea un nuevo usuario

CREATE OR ALTER PROCEDURE sp_usuario_insert
(
    @nombre           NVARCHAR(100),
    @apellido         NVARCHAR(100),
    @correo           NVARCHAR(150),
    @fecha_registro   DATE,
    @salario_mensual  DECIMAL(10,2),
    @estado           NVARCHAR(20),
    @creado_por       NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO usuario
    (
        nombre,
        apellido,
        correo,
        fecha_registro,
        salario_mensual,
        estado,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @nombre,
        @apellido,
        @correo,
        @fecha_registro,
        @salario_mensual,
        @estado,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_usuario;
END;
GO

-- sp_usuario_update

CREATE OR ALTER PROCEDURE sp_usuario_update
(
    @id_usuario       INT,
    @nombre           NVARCHAR(100),
    @apellido         NVARCHAR(100),
    @correo           NVARCHAR(150),
    @salario_mensual  DECIMAL(10,2),
    @estado           NVARCHAR(20),
    @modificado_por   NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE usuario
    SET nombre          = @nombre,
        apellido        = @apellido,
        correo          = @correo,
        salario_mensual = @salario_mensual,
        estado          = @estado,
        modificado_por  = @modificado_por,
        modificado_en   = SYSDATETIME()
    WHERE id_usuario = @id_usuario;
END;
GO

-- sp_usuario_delete_logico
-- Cambiar estado a 'INACTIVO'

CREATE OR ALTER PROCEDURE sp_usuario_delete_logico
(
    @id_usuario     INT,
    @modificado_por NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE usuario
    SET estado        = 'INACTIVO',
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_usuario = @id_usuario;
END;
GO

-- sp_usuario_get_by_id
-- Obtener un usuario por ID

CREATE OR ALTER PROCEDURE sp_usuario_get_by_id
(
    @id_usuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM usuario
    WHERE id_usuario = @id_usuario;
END;
GO

-- sp_usuario_list_activos
-- Listar todos los usuarios activos

CREATE OR ALTER PROCEDURE sp_usuario_list_activos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM usuario
    WHERE estado = 'ACTIVO'
    ORDER BY nombre, apellido;
END;
GO
