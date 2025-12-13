import { Router, Request, Response } from 'express';
import { execSP } from '../config/db';

const router = Router();

// helper local 
function leerId(param: string | undefined): number | null {
  const valor = param ? parseInt(param, 10) : NaN;
  if (Number.isNaN(valor) || valor <= 0) return null;
  return valor;
}

// lista de usuarios activos
router.get('/activos', async (_req: Request, res: Response) => {
  try {
    const resultado = await execSP('sp_usuario_list_activos');
    return res.json(resultado.recordset);
  } catch (err) {
    console.error('fallo al listar usuarios activos:', err);
    return res.status(500).json({ mensaje: 'no se pudieron traer los usuarios activos' });
  }
});

// traer un usuario por id
router.get('/:id', async (req: Request, res: Response) => {
  const id = leerId(req.params.id);

  if (!id) {
    return res.status(400).json({ mensaje: 'id_usuario no valido' });
  }

  try {
    const resultado = await execSP('sp_usuario_get_by_id', { id_usuario: id });
    const usuario = resultado.recordset[0];

    if (!usuario) {
      return res.status(404).json({ mensaje: 'usuario no encontrado' });
    }

    return res.json(usuario);
  } catch (err) {
    console.error('error buscando usuario por id:', err);
    return res.status(500).json({ mensaje: 'no se pudo obtener el usuario' });
  }
});

// crear usuario nuevo
router.post('/', async (req: Request, res: Response) => {
  const { nombre, apellido, correo, salario_mensual, estado } = req.body;

  // cosas basicas, tipo formulario
  const errores: string[] = [];
  if (!nombre) errores.push('nombre es obligatorio');
  if (!apellido) errores.push('apellido es obligatorio');
  if (!correo) errores.push('correo es obligatorio');
  if (!salario_mensual || salario_mensual <= 0) {
    errores.push('salario_mensual debe ser mayor que cero');
  }

  if (errores.length > 0) {
    return res.status(400).json({ errores });
  }

  const hoy = new Date().toISOString().slice(0, 10);

  try {
    const resultado = await execSP('sp_usuario_insert', {
      nombre,
      apellido,
      correo,
      fecha_registro: hoy,
      salario_mensual,
      estado: estado || 'ACTIVO',
      creado_por: 'api',
    });

    const fila = resultado.recordset?.[0];

    return res.status(201).json({
      mensaje: 'usuario creado',
      id_usuario: fila?.id_usuario,
    });
  } catch (err) {
    console.error('error creando usuario:', err);
    return res.status(500).json({ mensaje: 'no se pudo crear el usuario' });
  }
});

// actualizar datos del usuario
router.put('/:id', async (req: Request, res: Response) => {
  const id = leerId(req.params.id);

  if (!id) {
    return res.status(400).json({ mensaje: 'id_usuario no valido' });
  }

  const { nombre, apellido, correo, salario_mensual, estado } = req.body;

  if (!nombre || !apellido || !correo) {
    return res.status(400).json({
      mensaje: 'nombre, apellido y correo son obligatorios para actualizar',
    });
  }

  try {
    await execSP('sp_usuario_update', {
      id_usuario: id,
      nombre,
      apellido,
      correo,
      salario_mensual,
      estado: estado || 'ACTIVO',
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'usuario actualizado' });
  } catch (err) {
    console.error('error actualizando usuario:', err);
    return res.status(500).json({ mensaje: 'no se pudo actualizar el usuario' });
  }
});

// desactivamos el usuario, no lo borramos
router.delete('/:id', async (req: Request, res: Response) => {
  const id = leerId(req.params.id);

  if (!id) {
    return res.status(400).json({ mensaje: 'id_usuario no valido' });
  }

  try {
    await execSP('sp_usuario_delete_logico', {
      id_usuario: id,
      modificado_por: 'api',
    });

    return res.json({ mensaje: 'usuario desactivado' });
  } catch (err) {
    console.error('error desactivando usuario:', err);
    return res.status(500).json({ mensaje: 'no se pudo desactivar el usuario' });
  }
});

export default router;
