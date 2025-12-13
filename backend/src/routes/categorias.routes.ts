import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// listado de categorias por usuario
router.get('/usuario/:idUsuario', async (req: Request, res: Response) => {
  const idUsuario = parseInt(req.params.idUsuario, 10);

  if (Number.isNaN(idUsuario) || idUsuario < 1) {
    return res.status(400).json({ mensaje: 'id_usuario no tiene buen formato' });
  }

  try {
    const resultado = await execSP('sp_categoria_list_by_usuario', {
      id_usuario: idUsuario,
    });
    return res.json(resultado.recordset);
  } catch (err) {
    console.error('error listando categorias del usuario:', err);
    return res.status(500).json({ mensaje: 'no se pudieron traer las categorias' });
  }
});

// obtener categoria por id
router.get('/:id', async (req: Request, res: Response) => {
  const idCategoria = Number(req.params.id);

  if (!idCategoria || idCategoria <= 0) {
    return res.status(400).send({ mensaje: 'id_categoria invalido' });
  }

  try {
    const resultado = await execSP('sp_categoria_get_by_id', {
      id_categoria: idCategoria,
    });

    const categoria = resultado.recordset[0];

    if (!categoria) {
      return res.status(404).send({ mensaje: 'categoria no encontrada' });
    }

    return res.json(categoria);
  } catch (err) {
    console.error('fallo al buscar categoria:', err);
    return res.status(500).send({ mensaje: 'no se pudo leer la categoria' });
  }
});

// crear categoria
router.post('/', async (req: Request, res: Response) => {
  const { id_usuario, nombre, descripcion, tipo, icono } = req.body;

  if (!id_usuario || id_usuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario es requerido' });
  }

  if (!nombre) {
    return res.status(400).json({ mensaje: 'nombre de categoria es requerido' });
  }

  if (!tipo) {
    return res.status(400).json({ mensaje: 'tipo de categoria es requerido' });
  }

  try {
    const resultado = await execSP('sp_categoria_insert', {
      id_usuario,
      nombre,
      descripcion: descripcion ?? null,
      tipo,
      icono: icono ?? null,
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'categoria creada',
      id_categoria: fila?.id_categoria,
    });
  } catch (err) {
    console.error('error creando categoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear la categoria' });
  }
});

// actualizar categoria
router.put('/:id', async (req: Request, res: Response) => {
  const idCategoria = Number(req.params.id);

  if (!idCategoria || idCategoria <= 0) {
    return res.status(400).json({ mensaje: 'id_categoria invalido' });
  }

  const { nombre, descripcion, tipo, icono } = req.body;

  if (!nombre || !tipo) {
    return res
      .status(400)
      .json({ mensaje: 'nombre y tipo son obligatorios para actualizar' });
  }

  try {
    await execSP('sp_categoria_update', {
      id_categoria: idCategoria,
      nombre,
      descripcion: descripcion ?? null,
      tipo,
      icono: icono ?? null,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'categoria actualizada' });
  } catch (err) {
    console.error('error actualizando categoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo actualizar la categoria' });
  }
});

// eliminar categoria
router.delete('/:id', async (req: Request, res: Response) => {
  const idCategoria = Number(req.params.id);

  if (!idCategoria || idCategoria <= 0) {
    return res.status(400).json({ mensaje: 'id_categoria invalido' });
  }

  try {
    await execSP('sp_categoria_delete', {
      id_categoria: idCategoria,
    });

    return res.json({ mensaje: 'categoria eliminada' });
  } catch (err) {
    console.error('error eliminando categoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo eliminar la categoria' });
  }
});

export default router;
