-- =====================================================
-- VISTAS ANALÍTICAS PARA METABASE
-- Sistema de Gestión de Presupuesto Personal
-- =====================================================

USE ProyectoBD;
GO

-- =====================================================
-- 1. VISTA: Resumen Financiero por Usuario
-- =====================================================
IF OBJECT_ID('v_resumen_financiero_usuario', 'V') IS NOT NULL
    DROP VIEW v_resumen_financiero_usuario;
GO

CREATE VIEW v_resumen_financiero_usuario AS
SELECT 
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_completo,
    u.salario_mensual,
    u.estado AS estado_usuario,
    COUNT(DISTINCT p.id_presupuesto) AS total_presupuestos,
    COUNT(DISTINCT t.id_transaccion) AS total_transacciones,
    COUNT(DISTINCT m.id_meta) AS total_metas,
    COUNT(DISTINCT o.id_obligacion) AS total_obligaciones,
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) AS total_ingresos,
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS total_gastos,
    COALESCE(SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END), 0) AS total_ahorros,
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS balance_neto
FROM usuario u
LEFT JOIN presupuesto p ON u.id_usuario = p.id_usuario
LEFT JOIN transaccion t ON u.id_usuario = t.id_usuario
LEFT JOIN meta_ahorro m ON u.id_usuario = m.id_usuario
LEFT JOIN obligacion_fija o ON u.id_usuario = o.id_usuario
GROUP BY 
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.salario_mensual,
    u.estado;
GO

-- =====================================================
-- 2. VISTA: Análisis de Transacciones Detallado
-- =====================================================
IF OBJECT_ID('v_analisis_transacciones', 'V') IS NOT NULL
    DROP VIEW v_analisis_transacciones;
GO

CREATE VIEW v_analisis_transacciones AS
SELECT 
    t.id_transaccion,
    t.fecha,
    YEAR(t.fecha) AS anio,
    MONTH(t.fecha) AS mes,
    DATENAME(MONTH, t.fecha) AS nombre_mes,
    DATEPART(QUARTER, t.fecha) AS trimestre,
    DATEPART(WEEK, t.fecha) AS semana,
    DATENAME(WEEKDAY, t.fecha) AS dia_semana,
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    c.id_categoria,
    c.nombre AS categoria,
    c.tipo AS tipo_categoria,
    c.icono AS icono_categoria,
    c.color AS color_categoria,
    s.id_subcategoria,
    s.nombre AS subcategoria,
    t.tipo AS tipo_transaccion,
    t.descripcion,
    t.monto,
    t.medio_pago,
    p.id_presupuesto,
    p.nombre AS nombre_presupuesto,
    CASE 
        WHEN t.id_obligacion IS NOT NULL THEN 'Obligación Fija'
        ELSE 'Regular'
    END AS tipo_gasto,
    o.monto AS monto_obligacion
FROM transaccion t
INNER JOIN usuario u ON t.id_usuario = u.id_usuario
INNER JOIN presupuesto p ON t.id_presupuesto = p.id_presupuesto
INNER JOIN subcategoria s ON t.id_subcategoria = s.id_subcategoria
INNER JOIN categoria c ON s.id_categoria = c.id_categoria
LEFT JOIN obligacion_fija o ON t.id_obligacion = o.id_obligacion;
GO

-- =====================================================
-- 3. VISTA: Desempeño de Presupuestos
-- =====================================================
IF OBJECT_ID('v_desempeno_presupuestos', 'V') IS NOT NULL
    DROP VIEW v_desempeno_presupuestos;
GO

CREATE VIEW v_desempeno_presupuestos AS
SELECT 
    p.id_presupuesto,
    p.nombre AS nombre_presupuesto,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    p.anio_inicio,
    p.mes_inicio,
    p.anio_fin,
    p.mes_fin,
    CAST(CAST(p.anio_inicio AS VARCHAR) + '-' + 
         RIGHT('0' + CAST(p.mes_inicio AS VARCHAR), 2) + '-01' AS DATE) AS fecha_inicio,
    CAST(CAST(p.anio_fin AS VARCHAR) + '-' + 
         RIGHT('0' + CAST(p.mes_fin AS VARCHAR), 2) + '-01' AS DATE) AS fecha_fin,
    p.total_ingresos AS presupuesto_ingresos,
    p.total_gastos AS presupuesto_gastos,
    p.total_ahorro AS presupuesto_ahorro,
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) AS real_ingresos,
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS real_gastos,
    COALESCE(SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END), 0) AS real_ahorro,
    -- Variaciones
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) - p.total_ingresos AS var_ingresos,
    p.total_gastos - COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS var_gastos,
    COALESCE(SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END), 0) - p.total_ahorro AS var_ahorro,
    -- Porcentajes de cumplimiento
    CASE 
        WHEN p.total_ingresos > 0 
        THEN (COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) / p.total_ingresos) * 100 
        ELSE 0 
    END AS pct_cumplimiento_ingresos,
    CASE 
        WHEN p.total_gastos > 0 
        THEN (COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) / p.total_gastos) * 100 
        ELSE 0 
    END AS pct_cumplimiento_gastos,
    CASE 
        WHEN p.total_ahorro > 0 
        THEN (COALESCE(SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END), 0) / p.total_ahorro) * 100 
        ELSE 0 
    END AS pct_cumplimiento_ahorro,
    p.estado AS estado_presupuesto,
    p.fecha_creacion
FROM presupuesto p
INNER JOIN usuario u ON p.id_usuario = u.id_usuario
LEFT JOIN transaccion t ON p.id_presupuesto = t.id_presupuesto
GROUP BY 
    p.id_presupuesto,
    p.nombre,
    u.nombre,
    u.apellido,
    p.anio_inicio,
    p.mes_inicio,
    p.anio_fin,
    p.mes_fin,
    p.total_ingresos,
    p.total_gastos,
    p.total_ahorro,
    p.estado,
    p.fecha_creacion;
GO

-- =====================================================
-- 4. VISTA: Análisis por Categoría y Subcategoría
-- =====================================================
IF OBJECT_ID('v_analisis_categorias', 'V') IS NOT NULL
    DROP VIEW v_analisis_categorias;
GO

CREATE VIEW v_analisis_categorias AS
SELECT 
    c.id_categoria,
    c.nombre AS categoria,
    c.tipo AS tipo_categoria,
    c.icono,
    c.color,
    s.id_subcategoria,
    s.nombre AS subcategoria,
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    COUNT(DISTINCT t.id_transaccion) AS total_transacciones,
    COALESCE(SUM(t.monto), 0) AS monto_total,
    COALESCE(AVG(t.monto), 0) AS monto_promedio,
    COALESCE(MIN(t.monto), 0) AS monto_minimo,
    COALESCE(MAX(t.monto), 0) AS monto_maximo,
    -- Totales por tipo
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) AS total_ingresos,
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS total_gastos,
    COALESCE(SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END), 0) AS total_ahorro,
    -- Conteo por tipo
    SUM(CASE WHEN t.tipo = 'ingreso' THEN 1 ELSE 0 END) AS count_ingresos,
    SUM(CASE WHEN t.tipo = 'gasto' THEN 1 ELSE 0 END) AS count_gastos,
    SUM(CASE WHEN t.tipo = 'ahorro' THEN 1 ELSE 0 END) AS count_ahorro
FROM categoria c
INNER JOIN subcategoria s ON c.id_categoria = s.id_categoria
INNER JOIN usuario u ON c.id_usuario = u.id_usuario
LEFT JOIN transaccion t ON s.id_subcategoria = t.id_subcategoria
GROUP BY 
    c.id_categoria,
    c.nombre,
    c.tipo,
    c.icono,
    c.color,
    s.id_subcategoria,
    s.nombre,
    u.id_usuario,
    u.nombre,
    u.apellido;
GO

-- =====================================================
-- 5. VISTA: Seguimiento de Metas de Ahorro
-- =====================================================
IF OBJECT_ID('v_seguimiento_metas', 'V') IS NOT NULL
    DROP VIEW v_seguimiento_metas;
GO

CREATE VIEW v_seguimiento_metas AS
SELECT 
    m.id_meta,
    m.nombre AS nombre_meta,
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    s.nombre AS subcategoria_ahorro,
    m.monto_objetivo,
    COALESCE(m.monto_actual, 0) AS monto_actual,
    m.monto_objetivo - COALESCE(m.monto_actual, 0) AS monto_faltante,
    CASE 
        WHEN m.monto_objetivo > 0 
        THEN (COALESCE(m.monto_actual, 0) / m.monto_objetivo) * 100 
        ELSE 0 
    END AS porcentaje_avance,
    m.fecha_inicio,
    m.fecha_limite,
    DATEDIFF(DAY, GETDATE(), m.fecha_limite) AS dias_restantes,
    DATEDIFF(DAY, m.fecha_inicio, GETDATE()) AS dias_transcurridos,
    DATEDIFF(DAY, m.fecha_inicio, COALESCE(m.fecha_limite, GETDATE())) AS duracion_total_dias,
    m.estado,
    CASE
        WHEN m.estado = 'completada' THEN 'Completada'
        WHEN m.fecha_limite < GETDATE() AND m.estado <> 'completada' THEN 'Vencida'
        WHEN DATEDIFF(DAY, GETDATE(), m.fecha_limite) <= 30 THEN 'Próxima a vencer'
        ELSE 'En progreso'
    END AS estado_detallado,
    -- Ahorro mensual necesario
    CASE 
        WHEN m.fecha_limite IS NOT NULL AND DATEDIFF(MONTH, GETDATE(), m.fecha_limite) > 0
        THEN (m.monto_objetivo - COALESCE(m.monto_actual, 0)) / DATEDIFF(MONTH, GETDATE(), m.fecha_limite)
        ELSE 0
    END AS ahorro_mensual_requerido
FROM meta_ahorro m
INNER JOIN usuario u ON m.id_usuario = u.id_usuario
INNER JOIN subcategoria s ON m.id_subcategoria_ahorro = s.id_subcategoria;
GO

-- =====================================================
-- 6. VISTA: Análisis de Obligaciones Fijas
-- =====================================================
IF OBJECT_ID('v_analisis_obligaciones', 'V') IS NOT NULL
    DROP VIEW v_analisis_obligaciones;
GO

CREATE VIEW v_analisis_obligaciones AS
SELECT 
    o.id_obligacion,
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    u.salario_mensual,
    c.nombre AS categoria,
    s.nombre AS subcategoria,
    o.monto AS monto_obligacion,
    (o.monto / u.salario_mensual) * 100 AS porcentaje_salario,
    o.fecha_registro,
    o.estado,
    COUNT(DISTINCT t.id_transaccion) AS total_pagos,
    COALESCE(SUM(t.monto), 0) AS total_pagado,
    COALESCE(AVG(t.monto), 0) AS promedio_pago,
    MAX(t.fecha) AS ultimo_pago,
    MIN(t.fecha) AS primer_pago
FROM obligacion_fija o
INNER JOIN usuario u ON o.id_usuario = u.id_usuario
INNER JOIN subcategoria s ON o.id_subcategoria = s.id_subcategoria
INNER JOIN categoria c ON s.id_categoria = c.id_categoria
LEFT JOIN transaccion t ON o.id_obligacion = t.id_obligacion
GROUP BY 
    o.id_obligacion,
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.salario_mensual,
    c.nombre,
    s.nombre,
    o.monto,
    o.fecha_registro,
    o.estado;
GO

-- =====================================================
-- 7. VISTA: Tendencias Mensuales
-- =====================================================
IF OBJECT_ID('v_tendencias_mensuales', 'V') IS NOT NULL
    DROP VIEW v_tendencias_mensuales;
GO

CREATE VIEW v_tendencias_mensuales AS
SELECT 
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    YEAR(t.fecha) AS anio,
    MONTH(t.fecha) AS mes,
    DATENAME(MONTH, t.fecha) AS nombre_mes,
    CAST(CAST(YEAR(t.fecha) AS VARCHAR) + '-' + 
         RIGHT('0' + CAST(MONTH(t.fecha) AS VARCHAR), 2) + '-01' AS DATE) AS fecha_mes,
    COUNT(DISTINCT t.id_transaccion) AS total_transacciones,
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) AS ingresos,
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS gastos,
    COALESCE(SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END), 0) AS ahorros,
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS balance,
    -- Tasas de ahorro
    CASE 
        WHEN SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END) > 0
        THEN (SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END) / 
              SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END)) * 100
        ELSE 0
    END AS tasa_ahorro,
    -- Porcentaje de gastos sobre ingresos
    CASE 
        WHEN SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END) > 0
        THEN (SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END) / 
              SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END)) * 100
        ELSE 0
    END AS porcentaje_gastos
FROM transaccion t
INNER JOIN usuario u ON t.id_usuario = u.id_usuario
GROUP BY 
    u.id_usuario,
    u.nombre,
    u.apellido,
    YEAR(t.fecha),
    MONTH(t.fecha),
    DATENAME(MONTH, t.fecha);
GO

-- =====================================================
-- 8. VISTA: Top Gastos por Categoría
-- =====================================================
IF OBJECT_ID('v_top_gastos_categoria', 'V') IS NOT NULL
    DROP VIEW v_top_gastos_categoria;
GO

CREATE VIEW v_top_gastos_categoria AS
SELECT 
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    c.nombre AS categoria,
    c.tipo AS tipo_categoria,
    c.color,
    c.icono,
    COUNT(t.id_transaccion) AS cantidad_transacciones,
    COALESCE(SUM(t.monto), 0) AS total_gastado,
    COALESCE(AVG(t.monto), 0) AS promedio_gasto,
    MAX(t.monto) AS gasto_maximo,
    MIN(t.monto) AS gasto_minimo,
    MAX(t.fecha) AS ultima_transaccion
FROM transaccion t
INNER JOIN usuario u ON t.id_usuario = u.id_usuario
INNER JOIN subcategoria s ON t.id_subcategoria = s.id_subcategoria
INNER JOIN categoria c ON s.id_categoria = c.id_categoria
WHERE t.tipo = 'gasto'
GROUP BY 
    u.id_usuario,
    u.nombre,
    u.apellido,
    c.nombre,
    c.tipo,
    c.color,
    c.icono;
GO

-- =====================================================
-- 9. VISTA: Flujo de Caja (Cash Flow)
-- =====================================================
IF OBJECT_ID('v_flujo_caja', 'V') IS NOT NULL
    DROP VIEW v_flujo_caja;
GO

CREATE VIEW v_flujo_caja AS
SELECT 
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    t.fecha,
    YEAR(t.fecha) AS anio,
    MONTH(t.fecha) AS mes,
    t.tipo,
    t.monto,
    CASE 
        WHEN t.tipo = 'ingreso' THEN t.monto
        ELSE -t.monto
    END AS flujo,
    SUM(CASE 
        WHEN t.tipo = 'ingreso' THEN t.monto
        ELSE -t.monto
    END) OVER (
        PARTITION BY u.id_usuario 
        ORDER BY t.fecha, t.id_transaccion
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS saldo_acumulado,
    c.nombre AS categoria,
    s.nombre AS subcategoria,
    t.descripcion,
    t.medio_pago
FROM transaccion t
INNER JOIN usuario u ON t.id_usuario = u.id_usuario
INNER JOIN subcategoria s ON t.id_subcategoria = s.id_subcategoria
INNER JOIN categoria c ON s.id_categoria = c.id_categoria;
GO

-- =====================================================
-- 10. VISTA: KPIs Principales
-- =====================================================
IF OBJECT_ID('v_kpis_principales', 'V') IS NOT NULL
    DROP VIEW v_kpis_principales;
GO

CREATE VIEW v_kpis_principales AS
SELECT 
    u.id_usuario,
    u.nombre + ' ' + u.apellido AS nombre_usuario,
    u.salario_mensual,
    -- Totales generales
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) AS total_ingresos,
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS total_gastos,
    COALESCE(SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END), 0) AS total_ahorros,
    COALESCE(SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END), 0) AS balance_total,
    -- Promedios mensuales
    COALESCE(AVG(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE NULL END), 0) AS promedio_ingreso,
    COALESCE(AVG(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE NULL END), 0) AS promedio_gasto,
    COALESCE(AVG(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE NULL END), 0) AS promedio_ahorro,
    -- Ratios financieros
    CASE 
        WHEN SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END) > 0
        THEN (SUM(CASE WHEN t.tipo = 'ahorro' THEN t.monto ELSE 0 END) / 
              SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END)) * 100
        ELSE 0
    END AS tasa_ahorro_global,
    CASE 
        WHEN SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END) > 0
        THEN (SUM(CASE WHEN t.tipo = 'gasto' THEN t.monto ELSE 0 END) / 
              SUM(CASE WHEN t.tipo = 'ingreso' THEN t.monto ELSE 0 END)) * 100
        ELSE 0
    END AS tasa_gasto_global,
    -- Metas
    COUNT(DISTINCT m.id_meta) AS total_metas,
    SUM(CASE WHEN m.estado = 'completada' THEN 1 ELSE 0 END) AS metas_completadas,
    SUM(CASE WHEN m.estado = 'activa' THEN 1 ELSE 0 END) AS metas_activas,
    -- Obligaciones
    COUNT(DISTINCT o.id_obligacion) AS total_obligaciones,
    COALESCE(SUM(o.monto), 0) AS total_obligaciones_monto,
    CASE 
        WHEN u.salario_mensual > 0
        THEN (COALESCE(SUM(o.monto), 0) / u.salario_mensual) * 100
        ELSE 0
    END AS porcentaje_obligaciones_salario,
    -- Actividad
    COUNT(DISTINCT t.id_transaccion) AS total_transacciones,
    MIN(t.fecha) AS primera_transaccion,
    MAX(t.fecha) AS ultima_transaccion,
    DATEDIFF(DAY, MIN(t.fecha), MAX(t.fecha)) AS dias_actividad
FROM usuario u
LEFT JOIN transaccion t ON u.id_usuario = t.id_usuario
LEFT JOIN meta_ahorro m ON u.id_usuario = m.id_usuario
LEFT JOIN obligacion_fija o ON u.id_usuario = o.id_usuario
GROUP BY 
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.salario_mensual;
GO

PRINT 'Vistas analíticas creadas exitosamente';
GO
