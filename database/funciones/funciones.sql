USE ProyectoBD;
GO

-- FUNCIONES 

-- 1. fn_get_salario_anual
-- Calcular salario anual de usuario
-- Parametros:
--   @id_usuario  -> Id usuario
-- Retorno:
--   DECIMAL(12,2) -> salario_mensual * 12 (0 si no existe)

CREATE OR ALTER FUNCTION dbo.fn_get_salario_anual
(
    @id_usuario INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @resultado DECIMAL(12,2)

    SELECT @resultado = salario_mensual * 12
    FROM usuario
    WHERE id_usuario = @id_usuario

    RETURN ISNULL(@resultado, 0)
END
GO


-- 2. fn_get_total_ingresos_presupuesto
-- Obtener suma de INGRESOS de un presupuesto
-- Parametros:
--   @id_presupuesto -> Id presupuesto
-- Retorno:
--   DECIMAL(12,2) -> Total de ingresos (0 si no hay)

CREATE OR ALTER FUNCTION dbo.fn_get_total_ingresos_presupuesto
(
    @id_presupuesto INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @total DECIMAL(12,2)

    SELECT @total = ISNULL(SUM(monto), 0)
    FROM transaccion
    WHERE id_presupuesto = @id_presupuesto
      AND tipo = 'INGRESO'

    RETURN ISNULL(@total, 0)
END
GO


-- 3. fn_get_total_gastos_presupuesto
-- Obtener la suma de GASTOS de un presupuesto
-- Parametros:
--   @id_presupuesto -> Id presupuesto
-- Retorno:
--   DECIMAL(12,2) -> Total de gastos (0 si no hay)

CREATE OR ALTER FUNCTION dbo.fn_get_total_gastos_presupuesto
(
    @id_presupuesto INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @total DECIMAL(12,2)

    SELECT @total = ISNULL(SUM(monto), 0)
    FROM transaccion
    WHERE id_presupuesto = @id_presupuesto
      AND tipo = 'GASTO'

    RETURN ISNULL(@total, 0)
END
GO


-- 4. fn_get_balance_presupuesto
-- Calcular balance de presupuesto
-- Parametros:
--   @id_presupuesto -> Id presupuesto
-- Retorno:
--   DECIMAL(12,2) -> ingresos - gastos

CREATE OR ALTER FUNCTION dbo.fn_get_balance_presupuesto
(
    @id_presupuesto INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @ingresos DECIMAL(12,2)
    DECLARE @gastos   DECIMAL(12,2)

    SELECT @ingresos = dbo.fn_get_total_ingresos_presupuesto(@id_presupuesto)
    SELECT @gastos   = dbo.fn_get_total_gastos_presupuesto(@id_presupuesto)

    RETURN ISNULL(@ingresos, 0) - ISNULL(@gastos, 0)
END
GO


-- 5. fn_get_porcentaje_avance_meta
-- Calcular porcentaje de avance de una meta de ahorro
-- Parametros:
--   @id_meta -> Id meta de ahorro
-- Retorno:
--   DECIMAL(5,2) -> porcentaje (0 a 100)

CREATE OR ALTER FUNCTION dbo.fn_get_porcentaje_avance_meta
(
    @id_meta INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @objetivo DECIMAL(12,2)
    DECLARE @actual   DECIMAL(12,2)
    DECLARE @porc     DECIMAL(5,2)

    SELECT
        @objetivo = monto_objetivo,
        @actual   = ISNULL(monto_actual, 0)
    FROM meta_ahorro
    WHERE id_meta = @id_meta

    IF @objetivo IS NULL OR @objetivo = 0
        SET @porc = 0
    ELSE
        SET @porc = (@actual * 100.0) / @objetivo

    RETURN ISNULL(@porc, 0)
END
GO

-- 6. fn_get_monto_restante_meta
-- Calcular cuanto falta para completar meta de ahorro
-- Parametros:
--   @id_meta -> Id meta ahorro
-- Retorno:
--   DECIMAL(12,2) -> monto_objetivo - monto_actual (mínimo 0)

CREATE OR ALTER FUNCTION dbo.fn_get_monto_restante_meta
(
    @id_meta INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @objetivo DECIMAL(12,2)
    DECLARE @actual   DECIMAL(12,2)
    DECLARE @restante DECIMAL(12,2)

    SELECT
        @objetivo = monto_objetivo,
        @actual   = ISNULL(monto_actual, 0)
    FROM meta_ahorro
    WHERE id_meta = @id_meta

    SET @restante = ISNULL(@objetivo, 0) - ISNULL(@actual, 0)

    IF @restante < 0
        SET @restante = 0

    RETURN @restante
END
GO

-- 7. fn_get_disponible_detalle
-- Devolver el monto disponible de una subcategoría
-- dentro de un presupuesto (asignado - utilizado)
-- Parametros:
--   @id_presupuesto  -> Id presupuesto
--   @id_subcategoria -> Id subcategoria
-- Retorno:
--   DECIMAL(12,2) -> disponible (0 si no existe el detalle)

CREATE OR ALTER FUNCTION dbo.fn_get_disponible_detalle
(
    @id_presupuesto  INT,
    @id_subcategoria INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @disponible DECIMAL(12,2)

    SELECT
        @disponible = ISNULL(monto_asignado, 0) - ISNULL(monto_utilizado, 0)
    FROM presupuesto_detalle
    WHERE id_presupuesto  = @id_presupuesto
      AND id_subcategoria = @id_subcategoria

    RETURN ISNULL(@disponible, 0)
END
GO


-- 8. fn_get_nombre_usuario
-- Devolver nombre completo del usuario
-- Parametros:
--   @id_usuario -> Id usuario
-- Retorno:
--   NVARCHAR(255) -> "nombre apellido" o NULL si no existe

CREATE OR ALTER FUNCTION dbo.fn_get_nombre_usuario
(
    @id_usuario INT
)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @nombre NVARCHAR(255)

    SELECT @nombre = nombre + N' ' + apellido
    FROM usuario
    WHERE id_usuario = @id_usuario

    RETURN @nombre
END
GO


-- 9. fn_get_nombre_categoria
-- Devolver nombre de la categoria
-- Parametros:
--   @id_categoria -> Id categoria
-- Retorno:
--   NVARCHAR(255) -> nombre de la categoria o NULL

CREATE OR ALTER FUNCTION dbo.fn_get_nombre_categoria
(
    @id_categoria INT
)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @nombre NVARCHAR(255)

    SELECT @nombre = nombre
    FROM categoria
    WHERE id_categoria = @id_categoria

    RETURN @nombre
END
GO


-- 10. fn_get_nombre_subcategoria
-- Devolver el nombre de la subcategoria
-- Parametros:
--   @id_subcategoria -> Id subcategoria
-- Retorno:
--   NVARCHAR(255) -> nombre de la subcategoria o NULL

CREATE OR ALTER FUNCTION dbo.fn_get_nombre_subcategoria
(
    @id_subcategoria INT
)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @nombre NVARCHAR(255)

    SELECT @nombre = nombre
    FROM subcategoria
    WHERE id_subcategoria = @id_subcategoria

    RETURN @nombre
END
GO
