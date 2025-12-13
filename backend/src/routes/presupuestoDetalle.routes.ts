import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// detalles por presupuesto
router.get('/presupuesto/:idPresupuesto', async (req: Request, res: Response) => {
  const idPres = Number(req.params.idPresupuesto);

  if (!idPres || idPres <= 0) {
    return res.status(400).json({ mensaje: 'id_presupuesto no sirve' });
  }

  try {
    const resultado = await execSP('sp_presupuesto_detalle_list_by_presupuesto', {
      id_presupuesto: idPres,
    });

    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando detalle de presupuesto:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudieron traer los detalles del presupuesto' });
  }
});

// traer un detalle por id
router.get('/:id', async (req: Request, res: Response) => {
  const idDetalle = Number(req.params.id);

  if (!idDetalle || idDetalle <= 0) {
    return res.status(400).json({ mensaje: 'id_detalle invalido' });
  }

  try {
    const resultado = await execSP('sp_presupuesto_detalle_get_by_id', {
      id_detalle: idDetalle,
    });

    const detalle = resultado.recordset[0];

    if (!detalle) {
      return res.status(404).json({ mensaje: 'detalle de presupuesto no encontrado' });
    }

    return res.json(detalle);
  } catch (err) {
    console.error('error leyendo detalle de presupuesto:', err);
    return res.status(500).json({ mensaje: 'no se pudo leer el detalle del presupuesto' });
  }
});

// crear detalle_presupuesto
router.post('/', async (req: Request, res: Response) => {
  const {
    id_presupuesto,
    id_subcategoria,
    monto_asignado,
    monto_utilizado = 0,
    observaciones = null,
  } = req.body;

  if (!id_presupuesto || id_presupuesto <= 0) {
    return res.status(400).json({ mensaje: 'id_presupuesto es requerido' });
  }

  if (!id_subcategoria || id_subcategoria <= 0) {
    return res.status(400).json({ mensaje: 'id_subcategoria es requerido' });
  }

  if (!monto_asignado || monto_asignado <= 0) {
    return res.status(400).json({ mensaje: 'monto_asignado debe ser mayor a cero' });
  }

  try {
    const resultado = await execSP('sp_presupuesto_detalle_insert', {
      id_presupuesto,
      id_subcategoria,
      monto_asignado,
      monto_utilizado,
      observaciones,
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'detalle de presupuesto creado',
      id_detalle: fila?.id_detalle,
    });
  } catch (err) {
    console.error('error creando detalle de presupuesto:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudo crear el detalle de presupuesto' });
  }
});

// actualizar detalle_presupuesto
router.put('/:id', async (req: Request, res: Response) => {
  const idDetalle = Number(req.params.id);
  const { monto_asignado, monto_utilizado, observaciones } = req.body;

  if (!idDetalle || idDetalle <= 0) {
    return res.status(400).json({ mensaje: 'id_detalle invalido' });
  }

  if (!monto_asignado || monto_asignado <= 0) {
    return res.status(400).json({
      mensaje: 'monto_asignado debe ser mayor a cero para actualizar',
    });
  }

  try {
    await execSP('sp_presupuesto_detalle_update', {
      id_detalle: idDetalle,
      monto_asignado,
      monto_utilizado,
      observaciones: observaciones ?? null,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'detalle de presupuesto actualizado' });
  } catch (err) {
    console.error('error actualizando detalle de presupuesto:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudo actualizar el detalle de presupuesto' });
  }
});

// eliminar detalle_presupuesto
router.delete('/:id', async (req: Request, res: Response) => {
  const idDetalle = Number(req.params.id);

  if (!idDetalle || idDetalle <= 0) {
    return res.status(400).json({ mensaje: 'id_detalle invalido' });
  }

  try {
    await execSP('sp_presupuesto_detalle_delete', {
      id_detalle: idDetalle,
    });

    return res.json({ mensaje: 'detalle de presupuesto eliminado' });
  } catch (err) {
    console.error('error eliminando detalle de presupuesto:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudo eliminar el detalle de presupuesto' });
  }
});

export default router;
