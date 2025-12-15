import { useState, useEffect } from 'react'
import { useUser } from '../contexts/UserContext'
import Card from '../components/Card'
import Button from '../components/Button'
import Table from '../components/Table'
import Modal from '../components/Modal'
import { api } from '../api'
import type { Transaccion, Categoria, Subcategoria, CrearTransaccionInput } from '../types'
import './Transacciones.css'

export default function Transacciones() {
  const { currentUserId } = useUser()
  const [transacciones, setTransacciones] = useState<Transaccion[]>([])
  const [categorias, setCategorias] = useState<Categoria[]>([])
  const [subcategorias, setSubcategorias] = useState<Subcategoria[]>([])
  const [presupuestos, setPresupuestos] = useState<any[]>([])
  const [selectedCategoriaId, setSelectedCategoriaId] = useState<number>(0)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [showCreateModal, setShowCreateModal] = useState(false)

  const [formData, setFormData] = useState<CrearTransaccionInput>({
    id_usuario: currentUserId,
    id_presupuesto: 1,
    id_subcategoria: 0,
    monto: 0,
    fecha: new Date().toISOString().split('T')[0],
    descripcion: '',
    tipo: 'gasto'
  })

  useEffect(() => {
    cargarDatos()
  }, [currentUserId])

  const cargarDatos = async () => {
    try {
      setLoading(true)
      const [transData, catData, presData] = await Promise.all([
        api.getTransaccionesByUsuario(currentUserId),
        api.getCategoriasByUsuario(currentUserId),
        api.getPresupuestosByUsuario(currentUserId)
      ])
      setTransacciones(transData)
      setCategorias(catData)
      setPresupuestos(presData)
      
      if (presData.length > 0) {
        setFormData(prev => ({ ...prev, id_presupuesto: presData[0].id_presupuesto }))
      }
      
      setError('')
    } catch (err) {
      setError('Error al cargar datos')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const handleCategoriaChange = async (idCategoria: number) => {
    setSelectedCategoriaId(idCategoria)
    setFormData({ ...formData, id_subcategoria: 0 })
    
    if (idCategoria) {
      const categoria = categorias.find(c => c.id_categoria === idCategoria)
      if (categoria) {
        const tipo = categoria.tipo === 'ahorro' ? 'gasto' : categoria.tipo as 'gasto' | 'ingreso'
        setFormData({ ...formData, id_subcategoria: 0, tipo })
      }
      
      const subs = await api.getSubcategoriasByCategoria(idCategoria)
      setSubcategorias(subs)
    } else {
      setSubcategorias([])
    }
  }

  const handleCreateTransaccion = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      await api.crearTransaccion(formData)
      setShowCreateModal(false)
      setFormData({
        id_usuario: 1,
        id_presupuesto: 1,
        id_subcategoria: 0,
        monto: 0,
        fecha: new Date().toISOString().split('T')[0],
        descripcion: '',
        tipo: 'gasto'
      })
      setSubcategorias([])
      setSelectedCategoriaId(0)
      await cargarDatos()
    } catch (err) {
      setError('Error al crear transacción')
      console.error(err)
    }
  }

  const handleDeleteTransaccion = async (id: number) => {
    if (!confirm('¿Estás seguro de eliminar esta transacción?')) return
    
    try {
      await api.eliminarTransaccion(id)
      await cargarDatos()
    } catch (err) {
      setError('Error al eliminar transacción')
      console.error(err)
    }
  }

  const transaccionColumns = [
    { 
      key: 'fecha', 
      header: 'Fecha',
      render: (t: Transaccion) => new Date(t.fecha).toLocaleDateString('es')
    },
    { 
      key: 'tipo', 
      header: 'Tipo',
      render: (t: Transaccion) => (
        <span className={`badge badge-${t.tipo}`}>
          {t.tipo === 'gasto' ? '💸 Gasto' : t.tipo === 'ingreso' ? '💰 Ingreso' : '🎯 Ahorro'}
        </span>
      )
    },
    { 
      key: 'categoria', 
      header: 'Categoría',
      render: (t: Transaccion) => t.categoria_nombre || 'N/A'
    },
    { 
      key: 'subcategoria', 
      header: 'Subcategoría',
      render: (t: Transaccion) => t.subcategoria_nombre || 'N/A'
    },
    { 
      key: 'monto', 
      header: 'Monto',
      render: (t: Transaccion) => (
        <span className={`monto monto-${t.tipo}`}>
          {t.tipo === 'ingreso' ? '+' : '-'}L {t.monto?.toLocaleString() || 0}
        </span>
      )
    },
    { key: 'descripcion', header: 'Descripción' },
    {
      key: 'actions',
      header: 'Acciones',
      render: (t: Transaccion) => (
        <Button variant="danger" onClick={() => handleDeleteTransaccion(t.id_transaccion)}>
          🗑️
        </Button>
      )
    }
  ]

  const totales = transacciones.reduce((acc, t) => {
    if (t.tipo === 'ingreso') {
      acc.ingresos += t.monto || 0
    } else if (t.tipo === 'gasto') {
      if (t.categoria_tipo === 'ahorro') {
        acc.ahorros += t.monto || 0
      } else {
        acc.gastos += t.monto || 0
      }
    }
    return acc
  }, { ingresos: 0, gastos: 0, ahorros: 0 })

  const balance = totales.ingresos - totales.gastos - totales.ahorros

  if (loading) {
    return <div className="loading">Cargando transacciones...</div>
  }

  return (
    <div className="transacciones-page">
      <div className="page-header">
        <h1>Gestión de Transacciones</h1>
        <Button onClick={() => setShowCreateModal(true)}>
          + Nueva Transacción
        </Button>
      </div>

      {error && <div className="error-message">{error}</div>}

      <div className="stats-row">
        <Card className="stat-card stat-ingreso">
          <div className="stat-icon">💰</div>
          <div className="stat-info">
            <span className="stat-label">Ingresos</span>
            <span className="stat-value">L {totales.ingresos.toLocaleString()}</span>
          </div>
        </Card>

        <Card className="stat-card stat-gasto">
          <div className="stat-icon">💸</div>
          <div className="stat-info">
            <span className="stat-label">Gastos</span>
            <span className="stat-value">L {totales.gastos.toLocaleString()}</span>
          </div>
        </Card>

        <Card className="stat-card stat-ahorro">
          <div className="stat-icon">🎯</div>
          <div className="stat-info">
            <span className="stat-label">Ahorros</span>
            <span className="stat-value">L {totales.ahorros.toLocaleString()}</span>
          </div>
        </Card>

        <Card className={`stat-card ${balance >= 0 ? 'stat-balance-positive' : 'stat-balance-negative'}`}>
          <div className="stat-icon">{balance >= 0 ? '✅' : '⚠️'}</div>
          <div className="stat-info">
            <span className="stat-label">Balance</span>
            <span className="stat-value">L {balance.toLocaleString()}</span>
          </div>
        </Card>
      </div>

      <Card title="Historial de Transacciones">
        <Table
          data={transacciones.map(t => ({ ...t, id: t.id_transaccion }))}
          columns={transaccionColumns}
        />
      </Card>

      {/* Modal Crear Transacción */}
      <Modal isOpen={showCreateModal} onClose={() => setShowCreateModal(false)} title="Nueva Transacción">
        <form onSubmit={handleCreateTransaccion} className="transaccion-form">
          <div className="form-group">
            <label>Presupuesto</label>
            <select
              value={formData.id_presupuesto}
              onChange={(e) => setFormData({ ...formData, id_presupuesto: parseInt(e.target.value) })}
              required
            >
              <option value="">Seleccionar presupuesto...</option>
              {presupuestos.map((pres) => (
                <option key={pres.id_presupuesto} value={pres.id_presupuesto}>
                  {pres.nombre} ({String(pres.mes_inicio).padStart(2, '0')}/{pres.anio_inicio})
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Categoría</label>
            <select
              value={selectedCategoriaId}
              onChange={(e) => handleCategoriaChange(parseInt(e.target.value))}
              required
            >
              <option value="">Seleccionar categoría...</option>
              {categorias.map((cat) => (
                <option key={cat.id_categoria} value={cat.id_categoria}>
                  {cat.tipo === 'gasto' ? '💸' : cat.tipo === 'ingreso' ? '💰' : '🎯'} {cat.nombre}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Subcategoría</label>
            <select
              value={formData.id_subcategoria}
              onChange={(e) => setFormData({ ...formData, id_subcategoria: parseInt(e.target.value) })}
              required
              disabled={subcategorias.length === 0}
            >
              <option value="">Seleccionar subcategoría...</option>
              {subcategorias.map((sub) => (
                <option key={sub.id_subcategoria} value={sub.id_subcategoria}>{sub.nombre}</option>
              ))}
            </select>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label>Monto (Lempiras)</label>
              <input
                type="number"
                step="0.01"
                value={formData.monto}
                onChange={(e) => setFormData({ ...formData, monto: parseFloat(e.target.value) })}
                required
              />
            </div>

            <div className="form-group">
              <label>Fecha</label>
              <input
                type="date"
                value={formData.fecha}
                onChange={(e) => setFormData({ ...formData, fecha: e.target.value })}
                required
              />
            </div>
          </div>

          <div className="form-group">
            <label>Descripción</label>
            <textarea
              value={formData.descripcion}
              onChange={(e) => setFormData({ ...formData, descripcion: e.target.value })}
              rows={3}
            />
          </div>

          <div className="form-actions">
            <Button type="button" variant="secondary" onClick={() => setShowCreateModal(false)}>
              Cancelar
            </Button>
            <Button type="submit">
              Crear Transacción
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
