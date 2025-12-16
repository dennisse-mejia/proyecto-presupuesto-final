import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// LISTAR CATEGORIAS POR USUARIO
router.get('/usuario/:idUsuario', async (req: Request, res: Response) => {
  const idUsuario = Number(req.params.idUsuario);

  if (!idUsuario || idUsuario <= 0) {
    return res.status(400).json({ mensaje: 'id_usuario inválido' });
  }

  try {
    const result = await execSP('dbo.sp_categoria_list_by_usuario', {
      id_usuario: idUsuario,
    });

    return res.json(result.recordset);
  } catch (err) {
    console.error('Error listando categorias:', err);
    return res.status(500).json({ mensaje: 'no se pudieron traer las categorias' });
  }
});


// CREAR CATEGORIA

router.post('/', async (req: Request, res: Response) => {
  const { id_usuario, nombre, descripcion, tipo, icono } = req.body;

  if (!id_usuario || !nombre || !tipo) {
    return res.status(400).json({
      mensaje: 'id_usuario, nombre y tipo son obligatorios',
    });
  }

  try {
    const result = await execSP('dbo.sp_categoria_insert', {
      id_usuario,
      nombre,
      descripcion: descripcion ?? null,
      tipo,
      icono: icono ?? null,
      color: '#FF9800',
      orden: 1,
      creado_por: 'api',
    });

    return res.status(201).json({
      mensaje: 'categoria creada',
      id_categoria: result.recordset?.[0]?.id_categoria,
    });
  } catch (err) {
    console.error('Error creando categoria:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear la categoria' });
  }
});

export default router;