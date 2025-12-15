USE ProyectoBD;
GO

-- CRUD PRESUPUESTO_DETALLE
-- Tabla Presupuesto_detalle

-- sp_presupuesto_detalle_insert
-- Crear un de detalle de presup

CREATE OR ALTER PROCEDURE sp_presupuesto_detalle_insert
(
    @id_presupuesto  INT,
    @id_subcategoria INT,
    @monto_asignado  DECIMAL(12,2),
    @monto_utilizado DECIMAL(12,2) = 0,
    @observaciones   NVARCHAR(255) = NULL,
    @creado_por      NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO presupuesto_detalle
    (
        id_presupuesto,
        id_subcategoria,
        monto_asignado,
        monto_utilizado,
        observaciones,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @id_presupuesto,
        @id_subcategoria,
        @monto_asignado,
        @monto_utilizado,
        @observaciones,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_detalle;
END;
GO

-- sp_presupuesto_detalle_update
-- Actualizar un detalle de presup

CREATE OR ALTER PROCEDURE sp_presupuesto_detalle_update
(
    @id_detalle      INT,
    @monto_asignado  DECIMAL(12,2),
    @monto_utilizado DECIMAL(12,2),
    @observaciones   NVARCHAR(255) = NULL,
    @modificado_por  NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE presupuesto_detalle
    SET monto_asignado  = @monto_asignado,
        monto_utilizado = @monto_utilizado,
        observaciones   = @observaciones,
        modificado_por  = @modificado_por,
        modificado_en   = SYSDATETIME()
    WHERE id_detalle = @id_detalle;
END;
GO

-- sp_presupuesto_detalle_delete
-- Eliminar un detalle de presup

CREATE OR ALTER PROCEDURE sp_presupuesto_detalle_delete
(
    @id_detalle INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM presupuesto_detalle
    WHERE id_detalle = @id_detalle;
END;
GO

-- sp_presupuesto_detalle_get_by_id
-- Obtener un detalle por ID

CREATE OR ALTER PROCEDURE sp_presupuesto_detalle_get_by_id
(
    @id_detalle INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM presupuesto_detalle
    WHERE id_detalle = @id_detalle;
END;
GO

-- sp_presupuesto_detalle_list_by_presupuesto
-- Listar detalles de presup

CREATE OR ALTER PROCEDURE sp_presupuesto_detalle_list_by_presupuesto
(
    @id_presupuesto INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        d.*,
        s.nombre AS subcategoria_nombre,
        c.nombre AS categoria_nombre
    FROM presupuesto_detalle d
    LEFT JOIN subcategoria s ON d.id_subcategoria = s.id_subcategoria
    LEFT JOIN categoria c ON s.id_categoria = c.id_categoria
    WHERE d.id_presupuesto = @id_presupuesto
    ORDER BY d.id_subcategoria;
END;
GO
