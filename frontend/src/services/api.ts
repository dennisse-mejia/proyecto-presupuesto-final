const API_URL = 'http://localhost:3000/api'

export type Categoria = {
  id_categoria: number
  id_usuario: number
  nombre: string
  descripcion?: string
  tipo: 'gasto' | 'ingreso'
  icono?: string
  color?: string
  orden?: number
}

type CrearCategoriaInput = {
  id_usuario: number
  nombre: string
  tipo: 'gasto' | 'ingreso'
  descripcion?: string
}

type CrearCategoriaResponse = {
  mensaje: string
  id_categoria: number
}

export type DashboardData = {
  totalPresupuestos: number
  totalTransacciones: number
  porcentajeMetasCumplidas: number
  obligacionesProximas: Array<{
    id_obligacion: number
    id_usuario: number
    nombre: string
    monto: number
    dia_vencimiento: number
    activa: boolean
    categoria?: string
  }>
  categoriasUsadas: Array<{
    id_categoria: number
    nombre: string
    tipo: 'gasto' | 'ingreso'
    color: string
    monto_usado: number
    porcentaje: number
  }>
}

export async function getCategoriasByUsuario(
  idUsuario: number
): Promise<Categoria[]> {
  const res = await fetch(`${API_URL}/categorias/usuario/${idUsuario}`)

  if (!res.ok) {
    const error = await res.text()
    throw new Error(error || 'Error al obtener categorías')
  }

  return res.json()
}
export const api = {
  getCategoriasByUsuario,
  crearCategoria,
  getDashboardData
}
export async function crearCategoria(
  data: CrearCategoriaInput
): Promise<CrearCategoriaResponse> {
  const payload = {
    ...data,
    tipo: data.tipo.toLowerCase(),
  }

  const res = await fetch(`${API_URL}/categorias`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  })

  if (!res.ok) {
    const error = await res.text()
    throw new Error(error || 'Error al crear categoría')
  }

  return res.json()
}

export async function getDashboardData(
  idUsuario: number
): Promise<DashboardData> {
  const res = await fetch(`${API_URL}/dashboard/${idUsuario}`)

  if (!res.ok) {
    const error = await res.text()
    throw new Error(error || 'Error al obtener datos del dashboard')
  }

  return res.json()
}