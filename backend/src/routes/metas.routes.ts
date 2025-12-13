import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// helper
function idOk(raw: string | undefined): number | null {
  const n = raw ? Number(raw) : NaN;
  return !Number.isNaN(n) && n > 0 ? n : null;
}

// metas por usuario
router.get('/usuario/:idUsuario', async (req: Request, res: Response) => {
  const idUsuario = idOk(req.params.idUsuario);

  if (!idUsuario) {
    return res.status(400).json({ mensaje: 'id_usuario no valido' });
  }

  try {
    const resultado = await execSP('sp_meta_ahorro_list_by_usuario', {
      id_usuario: idUsuario,
    });

    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando metas de ahorro del usuario:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudieron traer las metas de ahorro del usuario' });
  }
});

// meta por id
router.get('/:id', async (req: Request, res: Response) => {
  const idMeta = idOk(req.params.id);

  if (!idMeta) {
    return res.status(400).json({ mensaje: 'id_meta invalido' });
  }

  try {
    const resultado = await execSP('sp_meta_ahorro_get_by_id', {
      id_meta: idMeta,
    });

    const meta = resultado.recordset[0];

    if (!meta) {
      return res.status(404).json({ mensaje: 'meta de ahorro no encontrada' });
    }

    return res.json(meta);
  } catch (err) {
    console.error('error leyendo meta de ahorro:', err);
    return res.status(500).json({ mensaje: 'no se pudo obtener la meta de ahorro' });
  }
});

// crear meta de ahorro
router.post('/', async (req: Request, res: Response) => {
  const {
    id_usuario,
    id_subcategoria_ahorro,
    nombre,
    monto_objetivo,
    monto_actual,
    fecha_inicio,
    fecha_limite,
    estado,
  } = req.body;

  if (!id_usuario || id_usuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario obligatorio' });
  }

  if (!id_subcategoria_ahorro || id_subcategoria_ahorro <= 0) {
    return res
      .status(400)
      .json({ mensaje: 'id_subcategoria_ahorro obligatorio' });
  }

  if (!nombre) {
    return res.status(400).json({ mensaje: 'nombre de meta obligatorio' });
  }

  if (!monto_objetivo || monto_objetivo <= 0) {
    return res
      .status(400)
      .json({ mensaje: 'monto_objetivo debe ser mayor que cero' });
  }

  if (!fecha_inicio) {
    return res.status(400).json({ mensaje: 'fecha_inicio obligatoria' });
  }

  if (!estado) {
    return res.status(400).json({ mensaje: 'estado obligatorio' });
  }

  try {
    const resultado = await execSP('sp_meta_ahorro_insert', {
      id_usuario,
      id_subcategoria_ahorro,
      nombre,
      monto_objetivo,
      monto_actual: monto_actual ?? 0,
      fecha_inicio,
      fecha_limite: fecha_limite ?? null,
      estado,
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'meta de ahorro creada',
      id_meta: fila?.id_meta,
    });
  } catch (err) {
    console.error('error creando meta de ahorro:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear la meta de ahorro' });
  }
});

// actualizar meta
router.put('/:id', async (req: Request, res: Response) => {
  const idMeta = idOk(req.params.id);
  const {
    id_subcategoria_ahorro,
    nombre,
    monto_objetivo,
    monto_actual,
    fecha_inicio,
    fecha_limite,
    estado,
  } = req.body;

  if (!idMeta) {
    return res.status(400).json({ mensaje: 'id_meta invalido' });
  }

  if (!id_subcategoria_ahorro || id_subcategoria_ahorro <= 0) {
    return res
      .status(400)
      .json({ mensaje: 'id_subcategoria_ahorro obligatorio' });
  }

  if (!nombre) {
    return res.status(400).json({ mensaje: 'nombre obligatorio' });
  }

  if (!monto_objetivo || monto_objetivo <= 0) {
    return res
      .status(400)
      .json({ mensaje: 'monto_objetivo debe ser mayor que cero' });
  }

  if (!fecha_inicio) {
    return res.status(400).json({ mensaje: 'fecha_inicio obligatoria' });
  }

  if (!estado) {
    return res.status(400).json({ mensaje: 'estado obligatorio' });
  }

  try {
    await execSP('sp_meta_ahorro_update', {
      id_meta: idMeta,
      id_subcategoria_ahorro,
      nombre,
      monto_objetivo,
      monto_actual,
      fecha_inicio,
      fecha_limite: fecha_limite ?? null,
      estado,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'meta de ahorro actualizada' });
  } catch (err) {
    console.error('error actualizando meta de ahorro:', err);
    return res.status(500).json({ mensaje: 'no se pudo actualizar la meta de ahorro' });
  }
});

// eliminar meta_ahorro
router.delete('/:id', async (req: Request, res: Response) => {
  const idMeta = idOk(req.params.id);

  if (!idMeta) {
    return res.status(400).json({ mensaje: 'id_meta invalido' });
  }

  try {
    await execSP('sp_meta_ahorro_delete', {
      id_meta: idMeta,
    });

    return res.json({ mensaje: 'meta de ahorro eliminada' });
  } catch (err) {
    console.error('error eliminando meta de ahorro:', err);
    return res.status(500).json({ mensaje: 'no se pudo eliminar la meta de ahorro' });
  }
});

export default router;
