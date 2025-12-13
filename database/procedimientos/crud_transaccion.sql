USE ProyectoBD;
GO

-- CRUD TRANSACCION
-- Tabla Transaccion

-- sp_transaccion_insert
-- Insertar transacción 

CREATE OR ALTER PROCEDURE sp_transaccion_insert
(
    @id_usuario      INT,
    @id_presupuesto  INT,
    @id_subcategoria INT,
    @id_obligacion   INT = NULL,
    @tipo            NVARCHAR(20),
    @descripcion     NVARCHAR(255) = NULL,
    @monto           DECIMAL(12,2),
    @fecha           DATE,
    @medio_pago      NVARCHAR(255) = NULL,
    @creado_por      NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO transaccion
    (
        id_usuario,
        id_presupuesto,
        id_subcategoria,
        id_obligacion,
        tipo,
        descripcion,
        monto,
        fecha,
        medio_pago,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @id_usuario,
        @id_presupuesto,
        @id_subcategoria,
        @id_obligacion,
        @tipo,
        @descripcion,
        @monto,
        @fecha,
        @medio_pago,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_transaccion;
END;
GO

-- sp_transaccion_update
-- Actualizar transacción

CREATE OR ALTER PROCEDURE sp_transaccion_update
(
    @id_transaccion INT,
    @id_subcategoria INT,
    @id_obligacion   INT = NULL,
    @tipo            NVARCHAR(20),
    @descripcion     NVARCHAR(255) = NULL,
    @monto           DECIMAL(12,2),
    @fecha           DATE,
    @medio_pago      NVARCHAR(255) = NULL,
    @modificado_por  NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE transaccion
    SET id_subcategoria = @id_subcategoria,
        id_obligacion   = @id_obligacion,
        tipo            = @tipo,
        descripcion     = @descripcion,
        monto           = @monto,
        fecha           = @fecha,
        medio_pago      = @medio_pago,
        modificado_por  = @modificado_por,
        modificado_en   = SYSDATETIME()
    WHERE id_transaccion = @id_transaccion;
END;
GO

-- sp_transaccion_delete
-- Eliminar transacción

CREATE OR ALTER PROCEDURE sp_transaccion_delete
(
    @id_transaccion INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM transaccion
    WHERE id_transaccion = @id_transaccion;
END;
GO

-- sp_transaccion_get_by_id
-- Obtener transacción por ID

CREATE OR ALTER PROCEDURE sp_transaccion_get_by_id
(
    @id_transaccion INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM transaccion
    WHERE id_transaccion = @id_transaccion;
END;
GO

-- sp_transaccion_list_by_presupuesto
-- Listar transacciones de presupuesto

CREATE OR ALTER PROCEDURE sp_transaccion_list_by_presupuesto
(
    @id_presupuesto INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM transaccion
    WHERE id_presupuesto = @id_presupuesto
    ORDER BY fecha, id_transaccion;
END;
GO
