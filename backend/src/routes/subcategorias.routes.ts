import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// funcion local
const idValido = (valor: any) => {
  const n = Number(valor);
  return Number.isInteger(n) && n > 0;
};

// listar subcategorias por categoria
router.get('/categoria/:idCategoria', async (req: Request, res: Response) => {
  const idCategoria = Number(req.params.idCategoria);

  if (!idValido(idCategoria)) {
    return res.status(400).json({ mensaje: 'id_categoria no sirve' });
  }

  try {
    const resultado = await execSP('sp_subcategoria_list_by_categoria', {
      id_categoria: idCategoria,
    });

    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando subcategorias:', err);
    return res
      .status(500)
      .json({ mensaje: 'no se pudieron traer las subcategorias de esa categoria' });
  }
});

// obtener una subcategoria
router.get('/:id', async (req: Request, res: Response) => {
  const idSub = Number(req.params.id);

  if (!idValido(idSub)) {
    return res.status(400).json({ mensaje: 'id_subcategoria invalido' });
  }

  try {
    const resultado = await execSP('sp_subcategoria_get_by_id', {
      id_subcategoria: idSub,
    });

    const subcat = resultado.recordset[0];

    if (!subcat) {
      return res.status(404).json({ mensaje: 'subcategoria no encontrada' });
    }

    return res.json(subcat);
  } catch (err) {
    console.error('error leyendo subcategoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo obtener la subcategoria' });
  }
});

// crear la subcategoria
router.post('/', async (req: Request, res: Response) => {
  const { id_categoria, nombre, descripcion, tipo, icono } = req.body;

  if (!idValido(id_categoria)) {
    return res.status(400).json({ mensaje: 'id_categoria es obligatorio' });
  }

  if (!nombre) {
    return res.status(400).json({ mensaje: 'nombre de subcategoria es obligatorio' });
  }

  if (!tipo) {
    return res.status(400).json({ mensaje: 'tipo es obligatorio' });
  }

  try {
    const resultado = await execSP('sp_subcategoria_insert', {
      id_categoria,
      nombre,
      descripcion: descripcion ?? null,
      tipo,
      icono: icono ?? null,
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'subcategoria creada',
      id_subcategoria: fila?.id_subcategoria,
    });
  } catch (err) {
    console.error('error creando subcategoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear la subcategoria' });
  }
});

// actualizar subcategoria
router.put('/:id', async (req: Request, res: Response) => {
  const idSub = Number(req.params.id);
  const { nombre, descripcion, tipo, icono } = req.body;

  if (!idValido(idSub)) {
    return res.status(400).json({ mensaje: 'id_subcategoria invalido' });
  }

  if (!nombre || !tipo) {
    return res
      .status(400)
      .json({ mensaje: 'nombre y tipo son requeridos para actualizar' });
  }

  try {
    await execSP('sp_subcategoria_update', {
      id_subcategoria: idSub,
      nombre,
      descripcion: descripcion ?? null,
      tipo,
      icono: icono ?? null,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'subcategoria actualizada' });
  } catch (err) {
    console.error('error actualizando subcategoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo actualizar la subcategoria' });
  }
});

// borrar una subcategoria
router.delete('/:id', async (req: Request, res: Response) => {
  const idSub = Number(req.params.id);

  if (!idValido(idSub)) {
    return res.status(400).json({ mensaje: 'id_subcategoria invalido' });
  }

  try {
    await execSP('sp_subcategoria_delete', {
      id_subcategoria: idSub,
    });

    return res.json({ mensaje: 'subcategoria eliminada' });
  } catch (err) {
    console.error('error eliminando subcategoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo eliminar la subcategoria' });
  }
});

export default router;
