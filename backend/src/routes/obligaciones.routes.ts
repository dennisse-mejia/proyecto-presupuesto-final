import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// listar obligaciones de un usuario
router.get('/usuario/:idUsuario', async function (req: Request, res: Response) {
  const idUsuario = Number(req.params.idUsuario);

  if (!idUsuario || idUsuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario invalido' });
  }

  try {
    const resultado = await execSP('sp_obligacion_fija_list_by_usuario', {
      id_usuario: idUsuario,
    });

    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando obligaciones fijas:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudieron traer las obligaciones fijas del usuario' });
  }
});

// obtener una obligacion por id
router.get('/:id', async function (req: Request, res: Response) {
  const idObl = Number(req.params.id);

  if (!idObl || idObl <= 0) {
    return res.status(400).json({ mensaje: 'id_obligacion invalido' });
  }

  try {
    const resultado = await execSP('sp_obligacion_fija_get_by_id', {
      id_obligacion: idObl,
    });

    const obligacion = resultado.recordset[0];

    if (!obligacion) {
      return res.status(404).json({ mensaje: 'obligacion fija no encontrada' });
    }

    return res.json(obligacion);
  } catch (err) {
    console.error('error leyendo obligacion fija:', err);
    return res.status(500).json({ mensaje: 'no se pudo obtener la obligacion fija' });
  }
});

// crear obligacion fija
router.post('/', async function (req: Request, res: Response) {
  const { id_usuario, id_subcategoria, monto, fecha_registro, estado } = req.body;

  if (!id_usuario || id_usuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario obligatorio' });
  }

  if (!id_subcategoria || id_subcategoria <= 0) {
    return res.status(400).json({ mensaje: 'id_subcategoria obligatorio' });
  }

  if (!monto || monto <= 0) {
    return res.status(400).json({ mensaje: 'monto debe ser mayor que cero' });
  }

  if (!fecha_registro) {
    return res.status(400).json({ mensaje: 'fecha_registro obligatoria' });
  }

  if (!estado) {
    return res.status(400).json({ mensaje: 'estado obligatorio' });
  }

  try {
    const resultado = await execSP('sp_obligacion_fija_insert', {
      id_usuario,
      id_subcategoria,
      monto,
      fecha_registro,
      estado,
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'obligacion fija creada',
      id_obligacion: fila?.id_obligacion,
    });
  } catch (err) {
    console.error('error creando obligacion fija:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear la obligacion fija' });
  }
});

// actualizar la obligacion fija
router.put('/:id', async function (req: Request, res: Response) {
  const idObl = Number(req.params.id);
  const { id_subcategoria, monto, fecha_registro, estado } = req.body;

  if (!idObl || idObl <= 0) {
    return res.status(400).json({ mensaje: 'id_obligacion invalido' });
  }

  if (!id_subcategoria || id_subcategoria <= 0) {
    return res.status(400).json({ mensaje: 'id_subcategoria obligatorio' });
  }

  if (!monto || monto <= 0) {
    return res.status(400).json({ mensaje: 'monto debe ser mayor que cero' });
  }

  if (!fecha_registro) {
    return res.status(400).json({ mensaje: 'fecha_registro obligatoria' });
  }

  if (!estado) {
    return res.status(400).json({ mensaje: 'estado obligatorio' });
  }

  try {
    await execSP('sp_obligacion_fija_update', {
      id_obligacion: idObl,
      id_subcategoria,
      monto,
      fecha_registro,
      estado,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'obligacion fija actualizada' });
  } catch (err) {
    console.error('error actualizando obligacion fija:', err);
    return res.status(500).json({ mensaje: 'no se pudo actualizar la obligacion fija' });
  }
});

// eliminar la obligacion fija
router.delete('/:id', async function (req: Request, res: Response) {
  const idObl = Number(req.params.id);

  if (!idObl || idObl <= 0) {
    return res.status(400).json({ mensaje: 'id_obligacion invalido' });
  }

  try {
    await execSP('sp_obligacion_fija_delete', {
      id_obligacion: idObl,
    });

    return res.json({ mensaje: 'obligacion fija eliminada' });
  } catch (err) {
    console.error('error eliminando obligacion fija:', err);
    return res.status(500).json({ mensaje: 'no se pudo eliminar la obligacion fija' });
  }
});

export default router;
