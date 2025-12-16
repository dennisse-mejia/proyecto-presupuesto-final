-- =====================================================
-- SCRIPT DE VERIFICACIÓN Y EJECUCIÓN DE VISTAS
-- Sistema de Gestión de Presupuesto Personal
-- =====================================================

USE ProyectoBD;
GO

PRINT '========================================';
PRINT 'APLICANDO VISTAS ANALÍTICAS';
PRINT '========================================';
PRINT '';

-- Ejecutar el script de vistas
:r vistas_analiticas.sql

PRINT '';
PRINT '========================================';
PRINT 'VERIFICACIÓN DE VISTAS';
PRINT '========================================';
PRINT '';

-- Verificar que las vistas se crearon correctamente
IF OBJECT_ID('v_resumen_financiero_usuario', 'V') IS NOT NULL
    PRINT '✓ Vista v_resumen_financiero_usuario creada';
ELSE
    PRINT '✗ Error: Vista v_resumen_financiero_usuario NO creada';

IF OBJECT_ID('v_analisis_transacciones', 'V') IS NOT NULL
    PRINT '✓ Vista v_analisis_transacciones creada';
ELSE
    PRINT '✗ Error: Vista v_analisis_transacciones NO creada';

IF OBJECT_ID('v_desempeno_presupuestos', 'V') IS NOT NULL
    PRINT '✓ Vista v_desempeno_presupuestos creada';
ELSE
    PRINT '✗ Error: Vista v_desempeno_presupuestos NO creada';

IF OBJECT_ID('v_analisis_categorias', 'V') IS NOT NULL
    PRINT '✓ Vista v_analisis_categorias creada';
ELSE
    PRINT '✗ Error: Vista v_analisis_categorias NO creada';

IF OBJECT_ID('v_seguimiento_metas', 'V') IS NOT NULL
    PRINT '✓ Vista v_seguimiento_metas creada';
ELSE
    PRINT '✗ Error: Vista v_seguimiento_metas NO creada';

IF OBJECT_ID('v_analisis_obligaciones', 'V') IS NOT NULL
    PRINT '✓ Vista v_analisis_obligaciones creada';
ELSE
    PRINT '✗ Error: Vista v_analisis_obligaciones NO creada';

IF OBJECT_ID('v_tendencias_mensuales', 'V') IS NOT NULL
    PRINT '✓ Vista v_tendencias_mensuales creada';
ELSE
    PRINT '✗ Error: Vista v_tendencias_mensuales NO creada';

IF OBJECT_ID('v_top_gastos_categoria', 'V') IS NOT NULL
    PRINT '✓ Vista v_top_gastos_categoria creada';
ELSE
    PRINT '✗ Error: Vista v_top_gastos_categoria NO creada';

IF OBJECT_ID('v_flujo_caja', 'V') IS NOT NULL
    PRINT '✓ Vista v_flujo_caja creada';
ELSE
    PRINT '✗ Error: Vista v_flujo_caja NO creada';

IF OBJECT_ID('v_kpis_principales', 'V') IS NOT NULL
    PRINT '✓ Vista v_kpis_principales creada';
ELSE
    PRINT '✗ Error: Vista v_kpis_principales NO creada';

PRINT '';
PRINT '========================================';
PRINT 'PRUEBAS DE CONSULTA';
PRINT '========================================';
PRINT '';

-- Probar cada vista con un SELECT TOP 1
PRINT 'Probando v_resumen_financiero_usuario...';
SELECT TOP 1 * FROM v_resumen_financiero_usuario;

PRINT 'Probando v_analisis_transacciones...';
SELECT TOP 1 * FROM v_analisis_transacciones;

PRINT 'Probando v_desempeno_presupuestos...';
SELECT TOP 1 * FROM v_desempeno_presupuestos;

PRINT 'Probando v_analisis_categorias...';
SELECT TOP 1 * FROM v_analisis_categorias;

PRINT 'Probando v_seguimiento_metas...';
SELECT TOP 1 * FROM v_seguimiento_metas;

PRINT 'Probando v_analisis_obligaciones...';
SELECT TOP 1 * FROM v_analisis_obligaciones;

PRINT 'Probando v_tendencias_mensuales...';
SELECT TOP 1 * FROM v_tendencias_mensuales;

PRINT 'Probando v_top_gastos_categoria...';
SELECT TOP 1 * FROM v_top_gastos_categoria;

PRINT 'Probando v_flujo_caja...';
SELECT TOP 1 * FROM v_flujo_caja;

PRINT 'Probando v_kpis_principales...';
SELECT TOP 1 * FROM v_kpis_principales;

PRINT '';
PRINT '========================================';
PRINT 'VISTAS LISTAS PARA METABASE';
PRINT '========================================';
PRINT '';
PRINT 'Total de vistas creadas: 10';
PRINT 'Todas las vistas están listas para usar en Metabase';
PRINT '';
