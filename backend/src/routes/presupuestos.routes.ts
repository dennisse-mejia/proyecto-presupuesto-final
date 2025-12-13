import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// helper para ids
const parseIdSeguro = (valor: string | undefined) => {
  const n = valor ? Number(valor) : NaN;
  return Number.isNaN(n) || n <= 0 ? null : n;
};

// crear presupuesto
router.post('/', async (req: Request, res: Response) => {
  const { id_usuario, nombre, anio, mes, descripcion } = req.body;

  if (!id_usuario || id_usuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario es obligatorio' });
  }

  if (!nombre) {
    return res.status(400).json({ mensaje: 'nombre de presupuesto es obligatorio' });
  }

  if (!anio || !mes) {
    return res.status(400).json({ mensaje: 'anio y mes son obligatorios' });
  }

  try {
    const resultado = await execSP('sp_presupuesto_insert', {
      id_usuario,
      nombre,
      anio,
      mes,
      descripcion: descripcion ?? null,
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'presupuesto creado',
      id_presupuesto: fila?.id_presupuesto,
    });
  } catch (err) {
    console.error('error creando presupuesto:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear el presupuesto' });
  }
});

// listar presupuestos de un usuario
router.get('/usuario/:idUsuario', async (req: Request, res: Response) => {
  const idUsuario = parseIdSeguro(req.params.idUsuario);

  if (!idUsuario) {
    return res.status(400).json({ mensaje: 'id_usuario no valido' });
  }

  try {
    const resultado = await execSP('sp_presupuesto_list_by_usuario', {
      id_usuario: idUsuario,
    });

    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando presupuestos:', err);
    return res.status(500).json({ mensaje: 'no se pudieron traer los presupuestos' });
  }
});

// traer un presupuesto por id
router.get('/:id', async (req: Request, res: Response) => {
  const idPres = parseIdSeguro(req.params.id);

  if (!idPres) {
    return res.status(400).json({ mensaje: 'id_presupuesto invalido' });
  }

  try {
    const resultado = await execSP('sp_presupuesto_get_by_id', {
      id_presupuesto: idPres,
    });

    const presupuesto = resultado.recordset[0];

    if (!presupuesto) {
      return res.status(404).json({ mensaje: 'presupuesto no encontrado' });
    }

    return res.json(presupuesto);
  } catch (err) {
    console.error('error buscando presupuesto:', err);
    return res.status(500).json({ mensaje: 'no se pudo leer el presupuesto' });
  }
});

// actualizar presupuesto
router.put('/:id', async (req: Request, res: Response) => {
  const idPres = parseIdSeguro(req.params.id);
  const { nombre, anio, mes, descripcion } = req.body;

  if (!idPres) {
    return res.status(400).json({ mensaje: 'id_presupuesto invalido' });
  }

  if (!nombre || !anio || !mes) {
    return res
      .status(400)
      .json({ mensaje: 'nombre, anio y mes son necesarios para actualizar' });
  }

  try {
    await execSP('sp_presupuesto_update', {
      id_presupuesto: idPres,
      nombre,
      anio,
      mes,
      descripcion: descripcion ?? null,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'presupuesto actualizado' });
  } catch (err) {
    console.error('error actualizando presupuesto:', err);
    return res.status(500).json({ mensaje: 'no se pudo actualizar el presupuesto' });
  }
});

// eliminar presupuesto
router.delete('/:id', async (req: Request, res: Response) => {
  const idPres = parseIdSeguro(req.params.id);

  if (!idPres) {
    return res.status(400).json({ mensaje: 'id_presupuesto invalido' });
  }

  try {
    await execSP('sp_presupuesto_delete', {
      id_presupuesto: idPres,
    });

    return res.json({ mensaje: 'presupuesto eliminado' });
  } catch (err) {
    console.error('error eliminando presupuesto:', err);
    return res.status(500).json({ mensaje: 'no se pudo eliminar el presupuesto' });
  }
});

export default router;
