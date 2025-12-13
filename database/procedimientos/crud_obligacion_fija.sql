USE ProyectoBD;
GO

-- CRUD OBLIGACION_FIJA
-- Tabla Obligacion_fija

-- sp_obligacion_fija_insert
-- Crear obligacion fija

CREATE OR ALTER PROCEDURE sp_obligacion_fija_insert
(
    @id_usuario      INT,
    @id_subcategoria INT,
    @monto           DECIMAL(12,2),
    @fecha_registro  DATE,
    @estado          NVARCHAR(20),
    @creado_por      NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO obligacion_fija
    (
        id_usuario,
        id_subcategoria,
        monto,
        fecha_registro,
        estado,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @id_usuario,
        @id_subcategoria,
        @monto,
        @fecha_registro,
        @estado,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_obligacion;
END;
GO

-- sp_obligacion_fija_update
-- Actualizar obligacion fija

CREATE OR ALTER PROCEDURE sp_obligacion_fija_update
(
    @id_obligacion   INT,
    @monto           DECIMAL(12,2),
    @estado          NVARCHAR(20),
    @modificado_por  NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE obligacion_fija
    SET monto          = @monto,
        estado         = @estado,
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_obligacion = @id_obligacion;
END;
GO

-- sp_obligacion_fija_delete
-- Eliminar obligacion fija

CREATE OR ALTER PROCEDURE sp_obligacion_fija_delete
(
    @id_obligacion INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM obligacion_fija
    WHERE id_obligacion = @id_obligacion;
END;
GO

-- sp_obligacion_fija_get_by_id
-- Obtener obligacion fija por ID

CREATE OR ALTER PROCEDURE sp_obligacion_fija_get_by_id
(
    @id_obligacion INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM obligacion_fija
    WHERE id_obligacion = @id_obligacion;
END;
GO

-- sp_obligacion_fija_list_by_usuario
-- Listar obligaciones fijas de usuario

CREATE OR ALTER PROCEDURE sp_obligacion_fija_list_by_usuario
(
    @id_usuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM obligacion_fija
    WHERE id_usuario = @id_usuario
    ORDER BY fecha_registro DESC;
END;
GO
