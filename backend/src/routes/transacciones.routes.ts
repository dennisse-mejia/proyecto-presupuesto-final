import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// crear transaccion
router.post('/', async (req: Request, res: Response) => {
  const {
    id_usuario,
    id_presupuesto,
    id_subcategoria,
    id_obligacion,
    tipo,
    descripcion,
    monto,
    fecha,
    medio_pago,
  } = req.body;

  if (!id_usuario || id_usuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario obligatorio' });
  }

  if (!id_presupuesto || id_presupuesto <= 0) {
    return res.status(400).json({ mensaje: 'id_presupuesto obligatorio' });
  }

  if (!id_subcategoria || id_subcategoria <= 0) {
    return res.status(400).json({ mensaje: 'id_subcategoria obligatorio' });
  }

  if (!tipo) {
    return res.status(400).json({ mensaje: 'tipo de transaccion obligatorio' });
  }

  if (!monto || monto <= 0) {
    return res.status(400).json({ mensaje: 'monto debe ser mayor que cero' });
  }

  if (!fecha) {
    return res.status(400).json({ mensaje: 'fecha obligatoria' });
  }

  try {
    const resultado = await execSP('sp_transaccion_insert', {
      id_usuario,
      id_presupuesto,
      id_subcategoria,
      id_obligacion: id_obligacion ?? null,
      tipo,
      descripcion: descripcion ?? null,
      monto,
      fecha,
      medio_pago: medio_pago ?? null,
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'transaccion creada',
      id_transaccion: fila?.id_transaccion,
    });
  } catch (err) {
    console.error('error creando transaccion:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear la transaccion' });
  }
});

// listar transacciones de un usuario
router.get('/usuario/:idUsuario', async (req: Request, res: Response) => {
  const idUsuario = Number(req.params.idUsuario);

  if (!idUsuario || idUsuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario invalido' });
  }

  try {
    const resultado = await execSP('sp_transaccion_list_by_usuario', {
      id_usuario: idUsuario,
    });

    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando transacciones del usuario:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudieron traer las transacciones del usuario' });
  }
});

// listar transacciones de un presupuesto
router.get('/presupuesto/:idPresupuesto', async (req: Request, res: Response) => {
  const idPres = Number(req.params.idPresupuesto);

  if (!idPres || idPres <= 0) {
    return res.status(400).json({ mensaje: 'id_presupuesto invalido' });
  }

  try {
    const resultado = await execSP('sp_transaccion_list_by_presupuesto', {
      id_presupuesto: idPres,
    });

    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando transacciones del presupuesto:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudieron traer las transacciones del presupuesto' });
  }
});

// obtener una transaccion por id
router.get('/:id', async (req: Request, res: Response) => {
  const idTrans = Number(req.params.id);

  if (!idTrans || idTrans <= 0) {
    return res.status(400).json({ mensaje: 'id_transaccion invalido' });
  }

  try {
    const resultado = await execSP('sp_transaccion_get_by_id', {
      id_transaccion: idTrans,
    });

    const transaccion = resultado.recordset[0];

    if (!transaccion) {
      return res.status(404).json({ mensaje: 'transaccion no encontrada' });
    }

    return res.json(transaccion);
  } catch (err) {
    console.error('error leyendo transaccion:', err);
    return res.status(500).json({ mensaje: 'no se pudo obtener la transaccion' });
  }
});

// actualizar la transaccion
router.put('/:id', async (req: Request, res: Response) => {
  const idTrans = Number(req.params.id);
  const {
    id_subcategoria,
    id_obligacion,
    tipo,
    descripcion,
    monto,
    fecha,
    medio_pago,
  } = req.body;

  if (!idTrans || idTrans <= 0) {
    return res.status(400).json({ mensaje: 'id_transaccion invalido' });
  }

  if (!id_subcategoria || id_subcategoria <= 0) {
    return res.status(400).json({ mensaje: 'id_subcategoria obligatorio' });
  }

  if (!tipo) {
    return res.status(400).json({ mensaje: 'tipo obligatorio' });
  }

  if (!monto || monto <= 0) {
    return res.status(400).json({ mensaje: 'monto debe ser mayor que cero' });
  }

  if (!fecha) {
    return res.status(400).json({ mensaje: 'fecha obligatoria' });
  }

  try {
    await execSP('sp_transaccion_update', {
      id_transaccion: idTrans,
      id_subcategoria,
      id_obligacion: id_obligacion ?? null,
      tipo,
      descripcion: descripcion ?? null,
      monto,
      fecha,
      medio_pago: medio_pago ?? null,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'transaccion actualizada' });
  } catch (err) {
    console.error('error actualizando transaccion:', err);
    return res.status(500).json({ mensaje: 'no se pudo actualizar la transaccion' });
  }
});

// eliminar transaccion
router.delete('/:id', async (req: Request, res: Response) => {
  const idTrans = Number(req.params.id);

  if (!idTrans || idTrans <= 0) {
    return res.status(400).json({ mensaje: 'id_transaccion invalido' });
  }

  try {
    await execSP('sp_transaccion_delete', {
      id_transaccion: idTrans,
    });

    return res.json({ mensaje: 'transaccion eliminada' });
  } catch (err) {
    console.error('error eliminando transaccion:', err);
    return res.status(500).json({ mensaje: 'no se pudo eliminar la transaccion' });
  }
});

export default router;
