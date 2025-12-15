import type {
  Categoria,
  Subcategoria,
  Presupuesto,
  PresupuestoDetalle,
  Transaccion,
  ObligacionFija,
  MetaAhorro,
  DashboardData,
  CrearCategoriaInput,
  CrearSubcategoriaInput,
  CrearPresupuestoInput,
  CrearPresupuestoDetalleInput,
  CrearTransaccionInput,
  CrearMetaInput,
  CrearResponse,
  Usuario,
} from '../types'

const API_URL = 'http://localhost:3000/api'

async function handleResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    const error = await response.text()
    throw new Error(error || `Error: ${response.status}`)
  }
  return response.json()
}


export async function getUsuariosActivos(): Promise<Usuario[]> {
  const res = await fetch(`${API_URL}/usuarios/activos`)
  return handleResponse<Usuario[]>(res)
}


export async function getDashboardData(idUsuario: number): Promise<DashboardData> {
  const res = await fetch(`${API_URL}/dashboard/${idUsuario}`)
  return handleResponse<DashboardData>(res)
}


export async function getCategoriasByUsuario(idUsuario: number): Promise<Categoria[]> {
  const res = await fetch(`${API_URL}/categorias/usuario/${idUsuario}`)
  return handleResponse<Categoria[]>(res)
}

export async function getCategoria(id: number): Promise<Categoria> {
  const res = await fetch(`${API_URL}/categorias/${id}`)
  return handleResponse<Categoria>(res)
}

export async function crearCategoria(data: CrearCategoriaInput): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/categorias`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function actualizarCategoria(
  id: number,
  data: Partial<CrearCategoriaInput>
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/categorias/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function eliminarCategoria(id: number): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/categorias/${id}`, {
    method: 'DELETE',
  })
  return handleResponse<CrearResponse>(res)
}


export async function getSubcategoriasByCategoria(idCategoria: number): Promise<Subcategoria[]> {
  const res = await fetch(`${API_URL}/subcategorias/categoria/${idCategoria}`)
  return handleResponse<Subcategoria[]>(res)
}

export async function getSubcategoriasByUsuario(idUsuario: number): Promise<Subcategoria[]> {
  const res = await fetch(`${API_URL}/subcategorias/usuario/${idUsuario}`)
  return handleResponse<Subcategoria[]>(res)
}

export async function crearSubcategoria(data: CrearSubcategoriaInput): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/subcategorias`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function actualizarSubcategoria(
  id: number,
  data: Partial<CrearSubcategoriaInput>
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/subcategorias/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function eliminarSubcategoria(id: number): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/subcategorias/${id}`, {
    method: 'DELETE',
  })
  return handleResponse<CrearResponse>(res)
}


export async function getPresupuestosByUsuario(idUsuario: number): Promise<Presupuesto[]> {
  const res = await fetch(`${API_URL}/presupuestos/usuario/${idUsuario}`)
  return handleResponse<Presupuesto[]>(res)
}

export async function getPresupuesto(id: number): Promise<Presupuesto> {
  const res = await fetch(`${API_URL}/presupuestos/${id}`)
  return handleResponse<Presupuesto>(res)
}

export async function crearPresupuesto(data: CrearPresupuestoInput): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/presupuestos`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function actualizarPresupuesto(
  id: number,
  data: Partial<CrearPresupuestoInput>
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/presupuestos/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function eliminarPresupuesto(id: number): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/presupuestos/${id}`, {
    method: 'DELETE',
  })
  return handleResponse<CrearResponse>(res)
}


export async function getDetallesByPresupuesto(idPresupuesto: number): Promise<PresupuestoDetalle[]> {
  const res = await fetch(`${API_URL}/presupuesto-detalle/presupuesto/${idPresupuesto}`)
  return handleResponse<PresupuestoDetalle[]>(res)
}

export async function crearPresupuestoDetalle(
  data: CrearPresupuestoDetalleInput
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/presupuesto-detalle`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function actualizarPresupuestoDetalle(
  id: number,
  monto_asignado: number
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/presupuesto-detalle/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ monto_asignado }),
  })
  return handleResponse<CrearResponse>(res)
}

export async function eliminarPresupuestoDetalle(id: number): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/presupuesto-detalle/${id}`, {
    method: 'DELETE',
  })
  return handleResponse<CrearResponse>(res)
}


export async function getTransaccionesByPresupuesto(
  idPresupuesto: number
): Promise<Transaccion[]> {
  const res = await fetch(`${API_URL}/transacciones/presupuesto/${idPresupuesto}`)
  return handleResponse<Transaccion[]>(res)
}

export async function getTransaccionesByUsuario(idUsuario: number): Promise<Transaccion[]> {
  const res = await fetch(`${API_URL}/transacciones/usuario/${idUsuario}`)
  return handleResponse<Transaccion[]>(res)
}

export async function getTransaccion(id: number): Promise<Transaccion> {
  const res = await fetch(`${API_URL}/transacciones/${id}`)
  return handleResponse<Transaccion>(res)
}

export async function crearTransaccion(data: CrearTransaccionInput): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/transacciones`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function actualizarTransaccion(
  id: number,
  data: Partial<CrearTransaccionInput>
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/transacciones/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function eliminarTransaccion(id: number): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/transacciones/${id}`, {
    method: 'DELETE',
  })
  return handleResponse<CrearResponse>(res)
}


export async function getObligacionesByUsuario(idUsuario: number): Promise<ObligacionFija[]> {
  const res = await fetch(`${API_URL}/obligaciones/usuario/${idUsuario}`)
  return handleResponse<ObligacionFija[]>(res)
}

export async function getObligacion(id: number): Promise<ObligacionFija> {
  const res = await fetch(`${API_URL}/obligaciones/${id}`)
  return handleResponse<ObligacionFija>(res)
}

export async function crearObligacion(data: {
  id_usuario: number
  id_subcategoria: number
  monto: number
  fecha_registro: string
  estado: string
}): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/obligaciones`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function actualizarObligacion(
  id: number,
  data: Partial<{
    id_subcategoria: number
    monto: number
    fecha_registro: string
    estado: string
  }>
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/obligaciones/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function eliminarObligacion(id: number): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/obligaciones/${id}`, {
    method: 'DELETE',
  })
  return handleResponse<CrearResponse>(res)
}


export async function getMetasByUsuario(idUsuario: number): Promise<MetaAhorro[]> {
  const res = await fetch(`${API_URL}/metas/usuario/${idUsuario}`)
  return handleResponse<MetaAhorro[]>(res)
}

export async function getMeta(id: number): Promise<MetaAhorro> {
  const res = await fetch(`${API_URL}/metas/${id}`)
  return handleResponse<MetaAhorro>(res)
}

export async function crearMeta(data: CrearMetaInput): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/metas`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function actualizarMeta(
  id: number,
  data: Partial<CrearMetaInput>
): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/metas/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  return handleResponse<CrearResponse>(res)
}

export async function eliminarMeta(id: number): Promise<CrearResponse> {
  const res = await fetch(`${API_URL}/metas/${id}`, {
    method: 'DELETE',
  })
  return handleResponse<CrearResponse>(res)
}

export const api = {
  getDashboardData,
  getCategoriasByUsuario,
  crearCategoria,
  actualizarCategoria,
  eliminarCategoria,
  getSubcategoriasByCategoria,
  crearSubcategoria,
  actualizarSubcategoria,
  eliminarSubcategoria,
  getPresupuestosByUsuario,
  getPresupuesto,
  crearPresupuesto,
  actualizarPresupuesto,
  eliminarPresupuesto,
  getDetallesByPresupuesto,
  getPresupuestoDetalleByPresupuesto: getDetallesByPresupuesto,
  crearPresupuestoDetalle,
  actualizarPresupuestoDetalle,
  eliminarPresupuestoDetalle,
  getTransaccionesByUsuario,
  crearTransaccion,
  actualizarTransaccion,
  eliminarTransaccion,
  getObligacionesByUsuario,
  crearObligacion,
  actualizarObligacion,
  eliminarObligacion,
  getMetasByUsuario,
  crearMeta,
  actualizarMeta,
  eliminarMeta,
}

