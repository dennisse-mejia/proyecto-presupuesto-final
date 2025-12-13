USE ProyectoBD;
GO

-- CRUD PRESUPUESTO
-- Tabla Presupuesto

-- sp_presupuesto_insert
-- Crear presupuesto usuario

CREATE OR ALTER PROCEDURE sp_presupuesto_insert
(
    @id_usuario     INT,
    @nombre         NVARCHAR(150),
    @anio_inicio    INT,
    @mes_inicio     INT,
    @anio_fin       INT,
    @mes_fin        INT,
    @estado         NVARCHAR(20),
    @creado_por     NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO presupuesto
    (
        id_usuario,
        nombre,
        anio_inicio,
        mes_inicio,
        anio_fin,
        mes_fin,
        total_ingresos,
        total_gastos,
        total_ahorro,
        fecha_creacion,
        estado,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @id_usuario,
        @nombre,
        @anio_inicio,
        @mes_inicio,
        @anio_fin,
        @mes_fin,
        0,  -- totales iniciales en 0
        0,
        0,
        SYSDATETIME(),
        @estado,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_presupuesto;
END;
GO

-- sp_presupuesto_update
-- Actualizar datos básicos presupuesto

CREATE OR ALTER PROCEDURE sp_presupuesto_update
(
    @id_presupuesto INT,
    @nombre         NVARCHAR(150),
    @anio_inicio    INT,
    @mes_inicio     INT,
    @anio_fin       INT,
    @mes_fin        INT,
    @estado         NVARCHAR(20),
    @modificado_por NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE presupuesto
    SET nombre         = @nombre,
        anio_inicio    = @anio_inicio,
        mes_inicio     = @mes_inicio,
        anio_fin       = @anio_fin,
        mes_fin        = @mes_fin,
        estado         = @estado,
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_presupuesto = @id_presupuesto;
END;
GO

-- sp_presupuesto_delete
-- Eliminar un presupuesto

CREATE OR ALTER PROCEDURE sp_presupuesto_delete
(
    @id_presupuesto INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM presupuesto
    WHERE id_presupuesto = @id_presupuesto;
END;
GO

-- sp_presupuesto_get_by_id
-- Obtener un presupuesto por ID

CREATE OR ALTER PROCEDURE sp_presupuesto_get_by_id
(
    @id_presupuesto INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM presupuesto
    WHERE id_presupuesto = @id_presupuesto;
END;
GO

-- sp_presupuesto_list_by_usuario
-- Listar presupuestos usuario

CREATE OR ALTER PROCEDURE sp_presupuesto_list_by_usuario
(
    @id_usuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM presupuesto
    WHERE id_usuario = @id_usuario
    ORDER BY fecha_creacion DESC;
END;
GO
