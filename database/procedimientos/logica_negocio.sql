USE ProyectoBD;
GO

-- LOGICA DE NEGOCIO

-- 1. sp_presupuesto_recalcular_totales
-- Recalcular el total_ingresos, total_gastos y total_ahorro
-- a partir de las transacciones del presup

CREATE OR ALTER PROCEDURE sp_presupuesto_recalcular_totales
(
    @id_presupuesto INT
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE
        @total_ingresos DECIMAL(12,2),
        @total_gastos   DECIMAL(12,2),
        @total_ahorro   DECIMAL(12,2)

    SELECT
        @total_ingresos = ISNULL(SUM(CASE WHEN tipo = 'INGRESO' THEN monto END), 0),
        @total_gastos   = ISNULL(SUM(CASE WHEN tipo = 'GASTO'   THEN monto END), 0),
        @total_ahorro   = ISNULL(SUM(CASE WHEN tipo = 'AHORRO'  THEN monto END), 0)
    FROM transaccion
    WHERE id_presupuesto = @id_presupuesto

    UPDATE presupuesto
    SET total_ingresos = @total_ingresos,
        total_gastos   = @total_gastos,
        total_ahorro   = @total_ahorro,
        modificado_en  = SYSDATETIME()
    WHERE id_presupuesto = @id_presupuesto
END
GO

-- 2. sp_meta_ahorro_aplicar_aporte
-- Sumar un monto al monto_actual de una meta de ahorro

CREATE OR ALTER PROCEDURE sp_meta_ahorro_aplicar_aporte
(
    @id_meta        INT,
    @monto_aporte   DECIMAL(12,2),
    @modificado_por NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON

    UPDATE meta_ahorro
    SET monto_actual   = ISNULL(monto_actual, 0) + @monto_aporte,
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_meta = @id_meta

    SELECT *
    FROM meta_ahorro
    WHERE id_meta = @id_meta
END
GO

-- 3. sp_transaccion_registrar
-- Registrar una transaccion y actualizar totales del presupuesto

CREATE OR ALTER PROCEDURE sp_transaccion_registrar
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

    DECLARE @id_transaccion INT;

    -- tabla para agarrar el SELECT del sp_transaccion_insert
    DECLARE @t TABLE (id_transaccion INT);

    INSERT INTO @t (id_transaccion)
    EXEC sp_transaccion_insert
        @id_usuario      = @id_usuario,
        @id_presupuesto  = @id_presupuesto,
        @id_subcategoria = @id_subcategoria,
        @id_obligacion   = @id_obligacion,
        @tipo            = @tipo,
        @descripcion     = @descripcion,
        @monto           = @monto,
        @fecha           = @fecha,
        @medio_pago      = @medio_pago,
        @creado_por      = @creado_por;

    SELECT @id_transaccion = id_transaccion FROM @t;

    -- Recalcular los totales del presupuesto
    EXEC sp_presupuesto_recalcular_totales @id_presupuesto = @id_presupuesto;

    SELECT @id_transaccion AS id_transaccion;
END;
GO


-- 4. sp_obligacion_registrar_pago
-- Registrar transaccion de pago de obligacion fija
-- y actualizar totales del presupuesto

CREATE OR ALTER PROCEDURE sp_obligacion_registrar_pago
(
    @id_obligacion   INT,
    @id_usuario      INT,
    @id_presupuesto  INT,
    @id_subcategoria INT,
    @monto           DECIMAL(12,2),
    @fecha           DATE,
    @medio_pago      NVARCHAR(255) = NULL,
    @creado_por      NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON

    -- Registrar gasto attached a la obligacion
    EXEC sp_transaccion_registrar
        @id_usuario      = @id_usuario,
        @id_presupuesto  = @id_presupuesto,
        @id_subcategoria = @id_subcategoria,
        @id_obligacion   = @id_obligacion,
        @tipo            = 'GASTO',
        @descripcion     = N'Pago obligación fija',
        @monto           = @monto,
        @fecha           = @fecha,
        @medio_pago      = @medio_pago,
        @creado_por      = @creado_por
END
GO

-- 5. sp_presupuesto_resumen_mensual
-- Resumen de ingresos/gastos/ahorro por mes

CREATE OR ALTER PROCEDURE sp_presupuesto_resumen_mensual
(
    @id_usuario INT,
    @anio       INT,
    @mes        INT
)
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        t.tipo,
        SUM(t.monto) AS total
    FROM transaccion t
    WHERE t.id_usuario = @id_usuario
      AND YEAR(t.fecha) = @anio
      AND MONTH(t.fecha) = @mes
    GROUP BY t.tipo
END
GO

-- 6. sp_usuario_resumen_general
-- Resumen general de un usuario (TODOS los presupuestos)

CREATE OR ALTER PROCEDURE sp_usuario_resumen_general
(
    @id_usuario INT
)
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        SUM(CASE WHEN t.tipo = 'INGRESO' THEN t.monto END) AS total_ingresos,
        SUM(CASE WHEN t.tipo = 'GASTO'   THEN t.monto END) AS total_gastos,
        SUM(CASE WHEN t.tipo = 'AHORRO'  THEN t.monto END) AS total_ahorro
    FROM transaccion t
    WHERE t.id_usuario = @id_usuario
END
GO

-- 7. sp_presupuesto_detalle_actualizar_usado
-- Recalcular monto_utilizado de un detalle
-- en base a transacciones registradas

CREATE OR ALTER PROCEDURE sp_presupuesto_detalle_actualizar_usado
(
    @id_presupuesto  INT,
    @id_subcategoria INT
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @monto_usado DECIMAL(12,2)

    SELECT
        @monto_usado = ISNULL(SUM(monto), 0)
    FROM transaccion
    WHERE id_presupuesto  = @id_presupuesto
      AND id_subcategoria = @id_subcategoria

    UPDATE presupuesto_detalle
    SET monto_utilizado = @monto_usado
    WHERE id_presupuesto  = @id_presupuesto
      AND id_subcategoria = @id_subcategoria
END
GO

-- 8. sp_meta_ahorro_verificar_estado
-- Marcar una meta como COMPLETADA si monto_actual >= objetivo

CREATE OR ALTER PROCEDURE sp_meta_ahorro_verificar_estado
(
    @id_meta        INT,
    @modificado_por NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON

    UPDATE meta_ahorro
    SET estado        = CASE WHEN monto_actual >= monto_objetivo
                             THEN 'COMPLETADA'
                             ELSE estado
                        END,
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_meta = @id_meta

    SELECT *
    FROM meta_ahorro
    WHERE id_meta = @id_meta
END
GO
