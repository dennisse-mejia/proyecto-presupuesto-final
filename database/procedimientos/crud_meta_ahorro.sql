USE ProyectoBD;
GO

-- CRUD META_AHORRO
-- Tabla Meta_ahorro

-- sp_meta_ahorro_insert
-- Crear meta de ahorro

CREATE OR ALTER PROCEDURE sp_meta_ahorro_insert
(
    @id_usuario           INT,
    @id_subcategoria_ahorro INT,
    @nombre               NVARCHAR(150),
    @monto_objetivo       DECIMAL(12,2),
    @monto_actual         DECIMAL(12,2) = 0,
    @fecha_inicio         DATE,
    @fecha_limite         DATE = NULL,
    @estado               NVARCHAR(20),
    @creado_por           NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO meta_ahorro
    (
        id_usuario,
        id_subcategoria_ahorro,
        nombre,
        monto_objetivo,
        monto_actual,
        fecha_inicio,
        fecha_limite,
        estado,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @id_usuario,
        @id_subcategoria_ahorro,
        @nombre,
        @monto_objetivo,
        @monto_actual,
        @fecha_inicio,
        @fecha_limite,
        @estado,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_meta;
END;
GO

-- sp_meta_ahorro_update
-- Actualizar meta ahorro

CREATE OR ALTER PROCEDURE sp_meta_ahorro_update
(
    @id_meta             INT,
    @nombre              NVARCHAR(150),
    @monto_objetivo      DECIMAL(12,2),
    @monto_actual        DECIMAL(12,2),
    @fecha_inicio        DATE,
    @fecha_limite        DATE = NULL,
    @estado              NVARCHAR(20),
    @modificado_por      NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE meta_ahorro
    SET nombre         = @nombre,
        monto_objetivo = @monto_objetivo,
        monto_actual   = @monto_actual,
        fecha_inicio   = @fecha_inicio,
        fecha_limite   = @fecha_limite,
        estado         = @estado,
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_meta = @id_meta;
END;
GO

-- sp_meta_ahorro_delete
-- Eliminar meta ahorro

CREATE OR ALTER PROCEDURE sp_meta_ahorro_delete
(
    @id_meta INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM meta_ahorro
    WHERE id_meta = @id_meta;
END;
GO

-- sp_meta_ahorro_get_by_id
-- Obtener meta de ahorro por ID

CREATE OR ALTER PROCEDURE sp_meta_ahorro_get_by_id
(
    @id_meta INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM meta_ahorro
    WHERE id_meta = @id_meta;
END;
GO

-- sp_meta_ahorro_list_by_usuario
-- Listar metas de ahorro de usuario

CREATE OR ALTER PROCEDURE sp_meta_ahorro_list_by_usuario
(
    @id_usuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM meta_ahorro
    WHERE id_usuario = @id_usuario
    ORDER BY fecha_inicio DESC;
END;
GO
