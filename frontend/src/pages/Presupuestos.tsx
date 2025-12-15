import { useState, useEffect } from 'react'
import { useUser } from '../contexts/UserContext'
import Card from '../components/Card'
import Button from '../components/Button'
import Table from '../components/Table'
import Modal from '../components/Modal'
import { api } from '../api'
import type { Presupuesto, PresupuestoDetalle, Categoria, Subcategoria, CrearPresupuestoInput, CrearPresupuestoDetalleInput } from '../types'
import './Presupuestos.css'

export default function Presupuestos() {
  const { currentUserId } = useUser()
  const [presupuestos, setPresupuestos] = useState<Presupuesto[]>([])
  const [presupuestoDetalle, setPresupuestoDetalle] = useState<PresupuestoDetalle[]>([])
  const [categorias, setCategorias] = useState<Categoria[]>([])
  const [subcategorias, setSubcategorias] = useState<Subcategoria[]>([])
  const [selectedPresupuesto, setSelectedPresupuesto] = useState<Presupuesto | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [showCreatePresupuestoModal, setShowCreatePresupuestoModal] = useState(false)
  const [showAddDetalleModal, setShowAddDetalleModal] = useState(false)

  const [presupuestoForm, setPresupuestoForm] = useState<CrearPresupuestoInput>({
    id_usuario: currentUserId,
    nombre: 'Presupuesto ' + new Date().toLocaleDateString(),
    mes: new Date().getMonth() + 1,
    anio: new Date().getFullYear()
  })

  const [detalleForm, setDetalleForm] = useState<CrearPresupuestoDetalleInput>({
    id_presupuesto: 0,
    id_subcategoria: 0,
    monto_asignado: 0
  })

  useEffect(() => {
    cargarDatos()
  }, [currentUserId])

  const cargarDatos = async () => {
    try {
      setLoading(true)
      const [presupData, catData] = await Promise.all([
        api.getPresupuestosByUsuario(currentUserId),
        api.getCategoriasByUsuario(currentUserId)
      ])
      setPresupuestos(presupData)
      setCategorias(catData)
      setError('')
    } catch (err) {
      setError('Error al cargar datos')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const cargarDetalles = async (idPresupuesto: number) => {
    try {
      const data = await api.getDetallesByPresupuesto(idPresupuesto)
      setPresupuestoDetalle(data)
    } catch (err) {
      console.error('Error cargando detalles:', err)
    }
  }

  const handleSelectPresupuesto = async (presupuesto: Presupuesto) => {
    setSelectedPresupuesto(presupuesto)
    await cargarDetalles(presupuesto.id_presupuesto)
  }

  const handleCreatePresupuesto = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      await api.crearPresupuesto(presupuestoForm)
      setShowCreatePresupuestoModal(false)
      setPresupuestoForm({
        id_usuario: 1,
        nombre: 'Presupuesto ' + new Date().toLocaleDateString(),
        mes: new Date().getMonth() + 1,
        anio: new Date().getFullYear()
      })
      await cargarDatos()
    } catch (err) {
      setError('Error al crear presupuesto')
      console.error(err)
    }
  }

  const handleDeletePresupuesto = async (id: number) => {
    if (!confirm('¿Estás seguro de eliminar este presupuesto?')) return
    
    try {
      await api.eliminarPresupuesto(id)
      await cargarDatos()
      if (selectedPresupuesto?.id_presupuesto === id) {
        setSelectedPresupuesto(null)
        setPresupuestoDetalle([])
      }
    } catch (err) {
      setError('Error al eliminar presupuesto')
      console.error(err)
    }
  }

  const handleCategoriaChange = async (idCategoria: number) => {
    setDetalleForm({ ...detalleForm, id_subcategoria: 0 })
    if (idCategoria) {
      const subs = await api.getSubcategoriasByCategoria(idCategoria)
      setSubcategorias(subs)
    } else {
      setSubcategorias([])
    }
  }

  const handleAddDetalle = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!selectedPresupuesto) return

    try {
      await api.crearPresupuestoDetalle({
        ...detalleForm,
        id_presupuesto: selectedPresupuesto.id_presupuesto
      })
      setShowAddDetalleModal(false)
      setDetalleForm({
        id_presupuesto: 0,
        id_subcategoria: 0,
        monto_asignado: 0
      })
      setSubcategorias([])
      await cargarDetalles(selectedPresupuesto.id_presupuesto)
    } catch (err) {
      setError('Error al agregar detalle')
      console.error(err)
    }
  }

  const handleDeleteDetalle = async (id: number) => {
    if (!confirm('¿Estás seguro de eliminar este detalle?')) return
    
    try {
      await api.eliminarPresupuestoDetalle(id)
      if (selectedPresupuesto) {
        await cargarDetalles(selectedPresupuesto.id_presupuesto)
      }
    } catch (err) {
      setError('Error al eliminar detalle')
      console.error(err)
    }
  }

  const presupuestoColumns = [
    { 
      key: 'periodo', 
      header: 'Período',
      render: (p: Presupuesto) => `${String(p.mes_inicio).padStart(2, '0')}/${p.anio_inicio}`
    },
    { 
      key: 'nombre', 
      header: 'Nombre',
      render: (p: Presupuesto) => p.nombre || 'Sin nombre'
    },
    {
      key: 'actions',
      header: 'Acciones',
      render: (p: Presupuesto) => (
        <Button variant="danger" onClick={() => handleDeletePresupuesto(p.id_presupuesto)}>
          🗑️
        </Button>
      )
    }
  ]

  const detalleColumns = [
    { 
      key: 'categoria', 
      header: 'Categoría',
      render: (d: PresupuestoDetalle) => d.categoria_nombre || 'N/A'
    },
    { 
      key: 'subcategoria', 
      header: 'Subcategoría',
      render: (d: PresupuestoDetalle) => d.subcategoria_nombre || 'N/A'
    },
    { 
      key: 'monto_asignado', 
      header: 'Monto Asignado',
      render: (d: PresupuestoDetalle) => `L ${d.monto_asignado?.toLocaleString() || 0}`
    },
    {
      key: 'actions',
      header: 'Acciones',
      render: (d: PresupuestoDetalle) => (
        <Button variant="danger" onClick={() => handleDeleteDetalle(d.id_detalle)}>
          🗑️
        </Button>
      )
    }
  ]

  if (loading) {
    return <div className="loading">Cargando presupuestos...</div>
  }

  return (
    <div className="presupuestos-page">
      <div className="page-header">
        <h1>Gestión de Presupuestos</h1>
        <Button onClick={() => setShowCreatePresupuestoModal(true)}>
          + Nuevo Presupuesto
        </Button>
      </div>

      {error && <div className="error-message">{error}</div>}

      <div className="presupuestos-layout">
        <Card title="Presupuestos" className="presupuestos-card">
          <Table
            data={presupuestos.map(p => ({ ...p, id: p.id_presupuesto }))}
            columns={presupuestoColumns}
            onRowClick={(p) => handleSelectPresupuesto(presupuestos.find(pr => pr.id_presupuesto === p.id)!)}
          />
        </Card>

        {selectedPresupuesto && (
          <Card 
            title={`Detalles - ${String(selectedPresupuesto.mes_inicio).padStart(2, '0')}/${selectedPresupuesto.anio_inicio}`} 
            className="detalles-card"
          >
            <div className="detalle-header">
              <Button onClick={() => setShowAddDetalleModal(true)}>
                + Agregar Detalle
              </Button>
            </div>
            <Table
              data={presupuestoDetalle.map(d => ({ ...d, id: d.id_detalle }))}
              columns={detalleColumns}
            />
          </Card>
        )}
      </div>

      {/* Modal Crear Presupuesto */}
      <Modal isOpen={showCreatePresupuestoModal} onClose={() => setShowCreatePresupuestoModal(false)} title="Nuevo Presupuesto">
        <form onSubmit={handleCreatePresupuesto} className="presupuesto-form">
          <div className="form-row">
            <div className="form-group">
              <label>Mes</label>
              <select
                value={presupuestoForm.mes}
                onChange={(e) => setPresupuestoForm({ ...presupuestoForm, mes: parseInt(e.target.value) })}
                required
              >
                {[...Array(12)].map((_, i) => (
                  <option key={i + 1} value={i + 1}>
                    {new Date(2000, i).toLocaleString('es', { month: 'long' })}
                  </option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label>Año</label>
              <input
                type="number"
                value={presupuestoForm.anio}
                onChange={(e) => setPresupuestoForm({ ...presupuestoForm, anio: parseInt(e.target.value) })}
                required
              />
            </div>
          </div>

          <div className="form-actions">
            <Button type="button" variant="secondary" onClick={() => setShowCreatePresupuestoModal(false)}>
              Cancelar
            </Button>
            <Button type="submit">
              Crear Presupuesto
            </Button>
          </div>
        </form>
      </Modal>

      {/* Modal Agregar Detalle */}
      <Modal isOpen={showAddDetalleModal} onClose={() => setShowAddDetalleModal(false)} title="Agregar Detalle">
        <form onSubmit={handleAddDetalle} className="presupuesto-form">
          <div className="form-group">
            <label>Categoría</label>
            <select
              onChange={(e) => handleCategoriaChange(parseInt(e.target.value))}
              required
            >
              <option value="">Seleccionar categoría...</option>
              {categorias.map((cat) => (
                <option key={cat.id_categoria} value={cat.id_categoria}>{cat.nombre}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Subcategoría</label>
            <select
              value={detalleForm.id_subcategoria}
              onChange={(e) => setDetalleForm({ ...detalleForm, id_subcategoria: parseInt(e.target.value) })}
              required
              disabled={subcategorias.length === 0}
            >
              <option value="">Seleccionar subcategoría...</option>
              {subcategorias.map((sub) => (
                <option key={sub.id_subcategoria} value={sub.id_subcategoria}>{sub.nombre}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Monto Asignado (Lempiras)</label>
            <input
              type="number"
              step="0.01"
              value={detalleForm.monto_asignado}
              onChange={(e) => setDetalleForm({ ...detalleForm, monto_asignado: parseFloat(e.target.value) })}
              required
            />
          </div>

          <div className="form-actions">
            <Button type="button" variant="secondary" onClick={() => setShowAddDetalleModal(false)}>
              Cancelar
            </Button>
            <Button type="submit">
              Agregar Detalle
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
