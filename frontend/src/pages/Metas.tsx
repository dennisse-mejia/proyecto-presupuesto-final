import { useState, useEffect } from 'react'
import { useUser } from '../contexts/UserContext'
import Card from '../components/Card'
import Button from '../components/Button'
import Table from '../components/Table'
import Modal from '../components/Modal'
import { api } from '../api'
import type { MetaAhorro, CrearMetaInput } from '../types'
import './Metas.css'

export default function Metas() {
  const { currentUserId } = useUser()
  const [metas, setMetas] = useState<MetaAhorro[]>([])
  const [subcategoriasAhorro, setSubcategoriasAhorro] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [showCreateModal, setShowCreateModal] = useState(false)

  const [formData, setFormData] = useState<CrearMetaInput>({
    id_usuario: currentUserId,
    id_subcategoria_ahorro: 0,
    nombre: '',
    monto_objetivo: 0,
    monto_actual: 0,
    fecha_inicio: new Date().toISOString().split('T')[0],
    estado: 'activa'
  })

  useEffect(() => {
    cargarDatos()
  }, [currentUserId])

  const cargarDatos = async () => {
    try {
      setLoading(true)
      const [metasData, categoriasData] = await Promise.all([
        api.getMetasByUsuario(currentUserId),
        api.getCategoriasByUsuario(currentUserId)
      ])
      
      setMetas(metasData)
      
      const categoriasAhorro = categoriasData.filter(c => c.tipo === 'ahorro')
      if (categoriasAhorro.length > 0) {
        const subs = await api.getSubcategoriasByCategoria(categoriasAhorro[0].id_categoria)
        setSubcategoriasAhorro(subs)
        if (subs.length > 0) {
          setFormData(prev => ({ ...prev, id_subcategoria_ahorro: subs[0].id_subcategoria }))
        }
      }
      
      setError('')
    } catch (err) {
      setError('Error al cargar datos')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const cargarMetas = async () => {
    try {
      const data = await api.getMetasByUsuario(1)
      setMetas(data)
    } catch (err) {
      console.error(err)
    }
  }

  const handleCreateMeta = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      await api.crearMeta(formData)
      setShowCreateModal(false)
      setFormData({
        id_usuario: currentUserId,
        id_subcategoria_ahorro: subcategoriasAhorro[0]?.id_subcategoria || 0,
        nombre: '',
        monto_objetivo: 0,
        monto_actual: 0,
        fecha_inicio: new Date().toISOString().split('T')[0],
        estado: 'activa'
      })
      await cargarMetas()
    } catch (err) {
      setError('Error al crear meta')
      console.error(err)
    }
  }

  const handleDeleteMeta = async (id: number) => {
    if (!confirm('¿Estás seguro de eliminar esta meta?')) return
    
    try {
      await api.eliminarMeta(id)
      await cargarMetas()
    } catch (err) {
      setError('Error al eliminar meta')
      console.error(err)
    }
  }

  const metaColumns = [
    { key: 'nombre', header: 'Nombre' },
    { 
      key: 'monto_objetivo', 
      header: 'Objetivo',
      render: (m: MetaAhorro) => `L ${m.monto_objetivo?.toLocaleString() || 0}`
    },
    { 
      key: 'monto_actual', 
      header: 'Actual',
      render: (m: MetaAhorro) => `L ${m.monto_actual?.toLocaleString() || 0}`
    },
    {
      key: 'progreso',
      header: 'Progreso',
      render: (m: MetaAhorro) => {
        const porcentaje = m.monto_objetivo ? (m.monto_actual / m.monto_objetivo * 100) : 0
        return (
          <div className="progress-bar-container">
            <div 
              className={`progress-bar ${porcentaje >= 100 ? 'completed' : ''}`}
              style={{ width: `${Math.min(porcentaje, 100)}%` }}
            />
            <span className="progress-text">{porcentaje.toFixed(0)}%</span>
          </div>
        )
      }
    },
    { 
      key: 'fecha_limite', 
      header: 'Fecha Límite',
      render: (m: MetaAhorro) => m.fecha_limite ? new Date(m.fecha_limite).toLocaleDateString('es') : 'Sin límite'
    },
    {
      key: 'estado',
      header: 'Estado',
      render: (m: MetaAhorro) => {
        const porcentaje = m.monto_objetivo ? (m.monto_actual / m.monto_objetivo * 100) : 0
        const hoy = new Date()
        const fechaLimite = m.fecha_limite ? new Date(m.fecha_limite) : null
        const diasRestantes = fechaLimite ? Math.ceil((fechaLimite.getTime() - hoy.getTime()) / (1000 * 60 * 60 * 24)) : 999
        
        let estado = ''
        let className = ''
        
        if (porcentaje >= 100) {
          estado = '✅ Completada'
          className = 'badge-completada'
        } else if (diasRestantes < 0) {
          estado = '❌ Vencida'
          className = 'badge-vencida'
        } else if (diasRestantes <= 7) {
          estado = '⚠️ Por vencer'
          className = 'badge-por-vencer'
        } else {
          estado = '🟢 En progreso'
          className = 'badge-en-progreso'
        }
        
        return <span className={`badge ${className}`}>{estado}</span>
      }
    },
    {
      key: 'actions',
      header: 'Acciones',
      render: (m: MetaAhorro) => (
        <Button variant="danger" onClick={() => handleDeleteMeta(m.id_meta)}>
          🗑️
        </Button>
      )
    }
  ]

  const stats = metas.reduce((acc, m) => {
    const porcentaje = m.monto_objetivo ? (m.monto_actual / m.monto_objetivo * 100) : 0
    if (porcentaje >= 100) acc.completadas++
    else acc.enProgreso++
    acc.totalObjetivo += m.monto_objetivo || 0
    acc.totalActual += m.monto_actual || 0
    return acc
  }, { completadas: 0, enProgreso: 0, totalObjetivo: 0, totalActual: 0 })

  if (loading) {
    return <div className="loading">Cargando metas...</div>
  }

  return (
    <div className="metas-page">
      <div className="page-header">
        <h1>Gestión de Metas de Ahorro</h1>
        <Button onClick={() => setShowCreateModal(true)}>
          + Nueva Meta
        </Button>
      </div>

      {error && <div className="error-message">{error}</div>}

      <div className="stats-row">
        <Card className="stat-card">
          <div className="stat-icon">🎯</div>
          <div className="stat-info">
            <span className="stat-label">Total Metas</span>
            <span className="stat-value">{metas.length}</span>
          </div>
        </Card>

        <Card className="stat-card">
          <div className="stat-icon">✅</div>
          <div className="stat-info">
            <span className="stat-label">Completadas</span>
            <span className="stat-value">{stats.completadas}</span>
          </div>
        </Card>

        <Card className="stat-card">
          <div className="stat-icon">🔄</div>
          <div className="stat-info">
            <span className="stat-label">En Progreso</span>
            <span className="stat-value">{stats.enProgreso}</span>
          </div>
        </Card>

        <Card className="stat-card">
          <div className="stat-icon">💰</div>
          <div className="stat-info">
            <span className="stat-label">Ahorro Total</span>
            <span className="stat-value">L {stats.totalActual.toLocaleString()}</span>
          </div>
        </Card>
      </div>

      <Card title="Mis Metas de Ahorro">
        <Table
          data={metas.map(m => ({ ...m, id: m.id_meta }))}
          columns={metaColumns}
        />
      </Card>

      {/* Modal Crear Meta */}
      <Modal isOpen={showCreateModal} onClose={() => setShowCreateModal(false)} title="Nueva Meta de Ahorro">
        <form onSubmit={handleCreateMeta} className="meta-form">
          <div className="form-group">
            <label>Categoría de Ahorro</label>
            <select
              value={formData.id_subcategoria_ahorro}
              onChange={(e) => setFormData({ ...formData, id_subcategoria_ahorro: parseInt(e.target.value) })}
              required
            >
              <option value="">Seleccionar subcategoría...</option>
              {subcategoriasAhorro.map((sub) => (
                <option key={sub.id_subcategoria} value={sub.id_subcategoria}>
                  {sub.nombre}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Nombre de la Meta</label>
            <input
              type="text"
              value={formData.nombre}
              onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
              required
              placeholder="Ej: Vacaciones, Fondo de emergencia, etc."
            />
          </div>

          <div className="form-row">
            <div className="form-group">
              <label>Monto Objetivo (Lempiras)</label>
              <input
                type="number"
                step="0.01"
                value={formData.monto_objetivo}
                onChange={(e) => setFormData({ ...formData, monto_objetivo: parseFloat(e.target.value) })}
                required
              />
            </div>

            <div className="form-group">
              <label>Monto Actual (Lempiras)</label>
              <input
                type="number"
                step="0.01"
                value={formData.monto_actual}
                onChange={(e) => setFormData({ ...formData, monto_actual: parseFloat(e.target.value) })}
                required
              />
            </div>
          </div>

          <div className="form-group">
            <label>Fecha Límite (opcional)</label>
            <input
              type="date"
              value={formData.fecha_limite || ''}
              onChange={(e) => setFormData({ ...formData, fecha_limite: e.target.value })}
            />
          </div>

          <div className="form-actions">
            <Button type="button" variant="secondary" onClick={() => setShowCreateModal(false)}>
              Cancelar
            </Button>
            <Button type="submit">
              Crear Meta
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
