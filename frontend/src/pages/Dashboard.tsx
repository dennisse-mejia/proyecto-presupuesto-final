import { useEffect, useState } from 'react'
import { useUser } from '../contexts/UserContext'
import { api } from '../api'
import type { DashboardData } from '../types'
import Card from '../components/Card'
import './Dashboard.css'

export default function Dashboard() {
  const { currentUserId } = useUser()
  const [data, setData] = useState<DashboardData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    cargarDatos()
  }, [currentUserId])

  const cargarDatos = async () => {
    try {
      setLoading(true)
      const dashboardData = await api.getDashboardData(currentUserId)
      setData(dashboardData)
      setError('')
    } catch (err) {
      setError('Error al cargar dashboard')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return <div className="loading">Cargando dashboard...</div>
  }

  if (error || !data) {
    return <div className="error-message">{error || 'Error al cargar datos'}</div>
  }

  return (
    <div className="dashboard-page">
      <div className="page-header">
        <h1>Dashboard</h1>
        <p className="page-subtitle">Resumen de tu presupuesto personal</p>
      </div>

      <div className="stats-row">
        <Card className="stat-card">
          <div className="stat-icon">💰</div>
          <div className="stat-info">
            <span className="stat-label">Total Presupuestos</span>
            <span className="stat-value">L {data.totalPresupuestos?.toLocaleString() || 0}</span>
          </div>
        </Card>

        <Card className="stat-card">
          <div className="stat-icon">📊</div>
          <div className="stat-info">
            <span className="stat-label">Total Transacciones</span>
            <span className="stat-value">{data.totalTransacciones || 0}</span>
          </div>
        </Card>

        <Card className="stat-card">
          <div className="stat-icon">🎯</div>
          <div className="stat-info">
            <span className="stat-label">Metas Cumplidas</span>
            <span className="stat-value">{data.porcentajeMetasCumplidas || 0}%</span>
          </div>
        </Card>

        <Card className="stat-card">
          <div className="stat-icon">📁</div>
          <div className="stat-info">
            <span className="stat-label">Categorías Usadas</span>
            <span className="stat-value">{data.categoriasUsadas?.length || 0}</span>
          </div>
        </Card>
      </div>

      <div className="dashboard-grid">
        <Card title="Obligaciones Próximas" className="obligations-card">
          {data.obligacionesProximas && data.obligacionesProximas.length > 0 ? (
            <div className="obligations-list">
              {data.obligacionesProximas.map((obl) => (
                <div key={obl.id_obligacion} className="obligation-item">
                  <div className="obligation-info">
                    <span className="obligation-name">{obl.nombre}</span>
                    <span className="obligation-date">
                      Día {obl.dia_vencimiento || 'N/A'} de cada mes
                    </span>
                  </div>
                  <span className="obligation-amount">L {obl.monto?.toLocaleString() || 0}</span>
                </div>
              ))}
            </div>
          ) : (
            <p className="empty-text">No hay obligaciones próximas</p>
          )}
        </Card>

        <Card title="Categorías Más Usadas" className="categories-card">
          {data.categoriasUsadas && data.categoriasUsadas.length > 0 ? (
            <div className="categories-list">
              {data.categoriasUsadas.map((cat) => (
                <div key={cat.id_categoria} className="category-item">
                  <div className="category-info">
                    <span className="category-name">{cat.nombre}</span>
                    <span className="category-count">L {cat.monto_usado?.toLocaleString() || 0}</span>
                  </div>
                  <div className="category-bar">
                    <div 
                      className="category-bar-fill"
                      style={{ width: `${cat.porcentaje || 0}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="empty-text">No hay categorías con uso registrado</p>
          )}
        </Card>
      </div>
    </div>
  )
}
