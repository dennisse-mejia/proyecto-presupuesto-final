export type Usuario = {
  id_usuario: number
  nombre: string
  apellido: string
  correo: string
  fecha_registro: string
  salario_mensual: number
  estado: string
  creado_por: string
  creado_en: string
  modificado_por: string | null
  modificado_en: string | null
  email?: string
  activo?: boolean
  fecha_creacion?: string
}

export type Categoria = {
  id_categoria: number
  id_usuario: number
  nombre: string
  descripcion?: string
  tipo: 'gasto' | 'ingreso' | 'ahorro'
  icono?: string
  color?: string
  orden?: number
  creado_en?: string
  modificado_en?: string
}

export type Subcategoria = {
  id_subcategoria: number
  id_categoria: number
  nombre: string
  descripcion?: string
  activa: boolean
  categoria_nombre?: string
  categoria_tipo?: string
  creado_en?: string
}

export type Presupuesto = {
  id_presupuesto: number
  id_usuario: number
  nombre: string
  anio_inicio: number
  mes_inicio: number
  anio_fin: number
  mes_fin: number
  total_ingresos?: number
  total_gastos?: number
  total_ahorro?: number
  fecha_creacion?: string
  estado?: string
  anio?: number
  mes?: number
}

export type PresupuestoDetalle = {
  id_detalle: number
  id_presupuesto: number
  id_subcategoria: number
  monto_asignado: number
  monto_utilizado?: number
  monto_gastado?: number
  categoria_nombre?: string
  subcategoria_nombre?: string
  nombre_categoria?: string
  nombre_subcategoria?: string
}

export type Transaccion = {
  id_transaccion: number
  id_usuario: number
  id_presupuesto: number
  id_subcategoria: number
  id_obligacion?: number
  tipo: 'gasto' | 'ingreso'
  descripcion?: string
  monto: number
  fecha: string
  medio_pago?: string
  subcategoria_nombre?: string
  categoria_nombre?: string
  categoria_tipo?: 'gasto' | 'ingreso' | 'ahorro'
  nombre_categoria?: string
  nombre_subcategoria?: string
  creado_en?: string
}

export type ObligacionFija = {
  id_obligacion: number
  id_usuario: number
  id_subcategoria: number
  monto: number
  fecha_registro: string
  estado: 'activa' | 'inactiva' | 'completada'
  subcategoria_nombre?: string
  categoria_nombre?: string
  dia_vencimiento?: number
  activa?: boolean
  nombre?: string
}

export type MetaAhorro = {
  id_meta: number
  id_usuario: number
  id_subcategoria_ahorro: number
  nombre: string
  monto_objetivo: number
  monto_actual: number
  fecha_inicio: string
  fecha_limite?: string
  estado: 'activa' | 'completada' | 'cancelada'
  subcategoria_nombre?: string
  completada?: boolean
}

export type DashboardData = {
  totalPresupuestos: number
  totalTransacciones: number
  porcentajeMetasCumplidas: number
  obligacionesProximas: ObligacionFija[]
  categoriasUsadas: CategoriaConUso[]
}

export type CategoriaConUso = {
  id_categoria: number
  nombre: string
  tipo: 'gasto' | 'ingreso' | 'ahorro'
  color: string
  monto_usado: number
  porcentaje: number
}

export type CrearCategoriaInput = {
  id_usuario: number
  nombre: string
  tipo: 'gasto' | 'ingreso' | 'ahorro'
  descripcion?: string
  color?: string
  icono?: string
}

export type CrearSubcategoriaInput = {
  id_categoria: number
  nombre: string
  descripcion?: string
}

export type CrearPresupuestoInput = {
  id_usuario: number
  nombre: string
  anio: number
  mes: number
  descripcion?: string
}

export type CrearPresupuestoDetalleInput = {
  id_presupuesto: number
  id_subcategoria: number
  monto_asignado: number
}

export type CrearTransaccionInput = {
  id_usuario: number
  id_presupuesto: number
  id_subcategoria: number
  id_obligacion?: number
  tipo: 'gasto' | 'ingreso'
  descripcion?: string
  monto: number
  fecha: string
  medio_pago?: string
}

export type CrearMetaInput = {
  id_usuario: number
  id_subcategoria_ahorro: number
  nombre: string
  monto_objetivo: number
  monto_actual: number
  fecha_inicio: string
  fecha_limite?: string
  estado: 'activa' | 'completada' | 'cancelada'
}

export type ApiResponse<T> = {
  mensaje: string
  data?: T
}

export type CrearResponse = {
  mensaje: string
  id?: number
}
