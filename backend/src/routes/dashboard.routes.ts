import { Router, Request, Response } from 'express';
import { execSP, query } from '../config/db';

const router = Router();

// Dashboard principal - obtener todos los datos de un usuario
router.get('/:idUsuario', async (req: Request, res: Response) => {
  const idUsuario = Number(req.params.idUsuario);

  if (!idUsuario || idUsuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario invalido' });
  }

  try {
    // Total de presupuestos 
    const presupuestosResult = await query(`
      SELECT ISNULL(SUM(pd.monto_asignado), 0) as total_presupuestos
      FROM presupuesto_detalle pd
      INNER JOIN presupuesto p ON pd.id_presupuesto = p.id_presupuesto
      WHERE p.id_usuario = @id_usuario
    `, { id_usuario: idUsuario });

    //  Total de transacciones 
    const transaccionesResult = await query(`
      SELECT COUNT(*) as total_transacciones
      FROM transaccion
      WHERE id_usuario = @id_usuario
    `, { id_usuario: idUsuario });

    //  Porcentaje de metas cumplidas
    const metasResult = await query(`
      SELECT 
        COUNT(*) as total_metas,
        SUM(CASE WHEN estado = 'completada' THEN 1 ELSE 0 END) as metas_completadas
      FROM meta_ahorro
      WHERE id_usuario = @id_usuario
    `, { id_usuario: idUsuario });

    const totalMetas = metasResult.recordset[0].total_metas || 0;
    const metasCompletadas = metasResult.recordset[0].metas_completadas || 0;
    const porcentajeMetasCumplidas = totalMetas > 0 
      ? Math.round((metasCompletadas / totalMetas) * 100) 
      : 0;

    //  Obligaciones próximas 
    const obligacionesResult = await query(`
      SELECT TOP 5
        obf.id_obligacion,
        obf.id_usuario,
        s.nombre as nombre,
        obf.monto,
        obf.fecha_registro as dia_vencimiento,
        CAST(1 as bit) as activa,
        c.nombre as categoria
      FROM obligacion_fija obf
      INNER JOIN subcategoria s ON obf.id_subcategoria = s.id_subcategoria
      INNER JOIN categoria c ON s.id_categoria = c.id_categoria
      WHERE obf.id_usuario = @id_usuario 
        AND obf.estado = 'activa'
      ORDER BY obf.fecha_registro DESC
    `, { id_usuario: idUsuario });

    // Categorías más usadas 
    const categoriasResult = await query(`
      SELECT TOP 5
        c.id_categoria,
        c.nombre,
        c.tipo,
        ISNULL(c.color, '#667eea') as color,
        SUM(t.monto) as monto_usado,
        CASE 
          WHEN pd_total.total > 0 
          THEN CAST((SUM(t.monto) / pd_total.total * 100) as INT)
          ELSE 0
        END as porcentaje
      FROM categoria c
      LEFT JOIN subcategoria s ON c.id_categoria = s.id_categoria
      LEFT JOIN transaccion t ON s.id_subcategoria = t.id_subcategoria
      CROSS APPLY (
        SELECT ISNULL(SUM(pd.monto_asignado), 1) as total
        FROM presupuesto_detalle pd
        INNER JOIN presupuesto p ON pd.id_presupuesto = p.id_presupuesto
        WHERE p.id_usuario = @id_usuario
      ) pd_total
      WHERE c.id_usuario = @id_usuario
        AND t.tipo = 'gasto'
        AND t.id_usuario = @id_usuario
      GROUP BY c.id_categoria, c.nombre, c.tipo, c.color, pd_total.total
      ORDER BY monto_usado DESC
    `, { id_usuario: idUsuario });

    // Construir respuesta
    const dashboardData = {
      totalPresupuestos: presupuestosResult.recordset[0].total_presupuestos,
      totalTransacciones: transaccionesResult.recordset[0].total_transacciones,
      porcentajeMetasCumplidas,
      obligacionesProximas: obligacionesResult.recordset.map((o: any) => ({
        id_obligacion: o.id_obligacion,
        id_usuario: o.id_usuario,
        nombre: o.nombre,
        monto: o.monto,
        dia_vencimiento: o.dia_vencimiento ? new Date(o.dia_vencimiento).getDate() : 15,
        activa: o.activa,
        categoria: o.categoria,
      })),
      categoriasUsadas: categoriasResult.recordset.map((c: any) => ({
        id_categoria: c.id_categoria,
        nombre: c.nombre,
        tipo: c.tipo,
        color: c.color,
        monto_usado: c.monto_usado,
        porcentaje: c.porcentaje,
      })),
    };

    return res.json(dashboardData);
  } catch (err) {
    console.error('error obteniendo datos del dashboard:', err);
    return res.status(500).json({ mensaje: 'no se pudo obtener los datos del dashboard' });
  }
});

export default router;
