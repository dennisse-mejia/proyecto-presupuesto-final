USE ProyectoBD;
GO

-- TRIGGERS

-- 1. tr_transaccion_actualizar_presupuesto
-- Tabla: transaccion
-- Tipo: AFTER INSERT, UPDATE, DELETE
-- Logica:
--     Por cada presupuesto afectado en transaccion
--     llamar a sp_presupuesto_recalcular_totales para
--     refrescar total_ingresos, total_gastos y total_ahorro

CREATE OR ALTER TRIGGER dbo.tr_transaccion_actualizar_presupuesto
ON dbo.transaccion
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON

    -- Obtener todos los id_presupuesto afectados (insertados o eliminados)
    IF EXISTS (SELECT 1 FROM inserted) OR EXISTS (SELECT 1 FROM deleted)
    BEGIN
        CREATE TABLE #tmpPresupuesto (id_presupuesto INT PRIMARY KEY)

        INSERT INTO #tmpPresupuesto(id_presupuesto)
        SELECT DISTINCT id_presupuesto
        FROM (
            SELECT id_presupuesto FROM inserted
            UNION
            SELECT id_presupuesto FROM deleted
        ) AS x
        WHERE id_presupuesto IS NOT NULL

        DECLARE @id_presupuesto INT

        WHILE EXISTS (SELECT 1 FROM #tmpPresupuesto)
        BEGIN
            SELECT TOP 1 @id_presupuesto = id_presupuesto
            FROM #tmpPresupuesto

            -- Recalcular totales del presupuesto
            EXEC dbo.sp_presupuesto_recalcular_totales
                @id_presupuesto = @id_presupuesto

            DELETE FROM #tmpPresupuesto
            WHERE id_presupuesto = @id_presupuesto
        END
    END
END
GO

-- 2. tr_transaccion_actualizar_detalle
-- Tabla: transaccion
-- Tipo: AFTER INSERT, UPDATE, DELETE
-- Logica:
--     Por cada combinacion (id_presupuesto, id_subcategoria)
--     afectada en transaccion, llamar a
--     sp_presupuesto_detalle_actualizar_usado para
--     recalcular monto_utilizado del presupuesto_detalle

CREATE OR ALTER TRIGGER dbo.tr_transaccion_actualizar_detalle
ON dbo.transaccion
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON

    IF EXISTS (SELECT 1 FROM inserted) OR EXISTS (SELECT 1 FROM deleted)
    BEGIN
        CREATE TABLE #tmpDetalle
        (
            id_presupuesto  INT,
            id_subcategoria INT,
            CONSTRAINT PK_tmpDetalle PRIMARY KEY (id_presupuesto, id_subcategoria)
        )

        INSERT INTO #tmpDetalle(id_presupuesto, id_subcategoria)
        SELECT DISTINCT id_presupuesto, id_subcategoria
        FROM (
            SELECT id_presupuesto, id_subcategoria FROM inserted
            UNION
            SELECT id_presupuesto, id_subcategoria FROM deleted
        ) AS x
        WHERE id_presupuesto IS NOT NULL
          AND id_subcategoria IS NOT NULL

        DECLARE @id_presupuesto  INT
        DECLARE @id_subcategoria INT

        WHILE EXISTS (SELECT 1 FROM #tmpDetalle)
        BEGIN
            SELECT TOP 1
                @id_presupuesto  = id_presupuesto,
                @id_subcategoria = id_subcategoria
            FROM #tmpDetalle

            EXEC dbo.sp_presupuesto_detalle_actualizar_usado
                @id_presupuesto  = @id_presupuesto,
                @id_subcategoria = @id_subcategoria

            DELETE FROM #tmpDetalle
            WHERE id_presupuesto  = @id_presupuesto
              AND id_subcategoria = @id_subcategoria
        END
    END
END
GO


-- 3. tr_meta_ahorro_verificar_estado
-- Tabla: meta_ahorro
-- Tipo: AFTER INSERT, UPDATE
-- Logica:
--     Por cada meta afectada, ejecutar
--     sp_meta_ahorro_verificar_estado para marcarla
--     como COMPLETADA cuando monto_actual >= monto_objetivo

CREATE OR ALTER TRIGGER dbo.tr_meta_ahorro_verificar_estado
ON dbo.meta_ahorro
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @id_meta        INT
    DECLARE @modificado_por NVARCHAR(50)

    -- Recorremos todas las filas afectadas
    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT id_meta, ISNULL(modificado_por, N'SISTEMA')
        FROM inserted

    OPEN cur

    FETCH NEXT FROM cur INTO @id_meta, @modificado_por

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.sp_meta_ahorro_verificar_estado
            @id_meta        = @id_meta,
            @modificado_por = @modificado_por

        FETCH NEXT FROM cur INTO @id_meta, @modificado_por
    END

    CLOSE cur
    DEALLOCATE cur
END
GO


-- 4. tr_usuario_validar_salario
-- Tabla: usuario
-- Tipo: AFTER INSERT, UPDATE
-- Logica:
--   - Valida que salario_mensual sea mayor que 0
--   - Si se intenta insertar/actualizar un usuario con
--     salario_mensual <= 0, muestra error y se hace ROLLBACK

CREATE OR ALTER TRIGGER dbo.tr_usuario_validar_salario
ON dbo.usuario
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE salario_mensual IS NULL
           OR salario_mensual <= 0
    )
    BEGIN
        RAISERROR('El salario_mensual debe ser mayor que 0.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
