import { useState, useEffect } from 'react'
import { useUser } from '../contexts/UserContext'
import { getUsuariosActivos } from '../api'
import type { Usuario } from '../types'
import './Sidebar.css'

type MenuItem = {
  id: string
  label: string
  icon: string
  path: string
}

const menuItems: MenuItem[] = [
  { id: 'dashboard', label: 'Dashboard', icon: '📊', path: '/' },
  { id: 'categorias', label: 'Categorías', icon: '📁', path: '/categorias' },
  { id: 'presupuestos', label: 'Presupuestos', icon: '💰', path: '/presupuestos' },
  { id: 'transacciones', label: 'Transacciones', icon: '💸', path: '/transacciones' },
  { id: 'metas', label: 'Metas', icon: '🎯', path: '/metas' },
]

export default function Sidebar() {
  const [activeItem, setActiveItem] = useState('dashboard')
  const [usuarios, setUsuarios] = useState<Usuario[]>([])
  const [showUserSelector, setShowUserSelector] = useState(false)
  const { currentUser, setCurrentUser } = useUser()

  useEffect(() => {
    cargarUsuarios()
  }, [])

  const cargarUsuarios = async () => {
    try {
      const data = await getUsuariosActivos()
      setUsuarios(data)
      console.log('Usuarios cargados:', data.length)
    } catch (error) {
      console.error('Error cargando usuarios:', error)
    }
  }

  const handleNavigation = (item: MenuItem) => {
    setActiveItem(item.id)
    window.dispatchEvent(new CustomEvent('navigate', { detail: item.id }))
  }

  const handleUserChange = (user: Usuario) => {
    console.log('=== CLICK DETECTADO ===')
    console.log('Cambiando a usuario:', user.nombre, user.apellido)
    console.log('Usuario actual:', currentUser?.nombre)
    alert(`Cambiando a: ${user.nombre} ${user.apellido}`)
    setCurrentUser(user)
    setShowUserSelector(false)
  }

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as HTMLElement
      if (!target.closest('.sidebar-footer')) {
        setShowUserSelector(false)
      }
    }

    if (showUserSelector) {
      document.addEventListener('click', handleClickOutside)
    }

    return () => {
      document.removeEventListener('click', handleClickOutside)
    }
  }, [showUserSelector])

  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <div className="sidebar-logo">
          <span className="logo-icon">₱</span>
          <span className="logo-text">Presupuesto</span>
        </div>
      </div>

      <nav className="sidebar-nav">
        {menuItems.map((item) => (
          <button
            key={item.id}
            className={`sidebar-item ${activeItem === item.id ? 'active' : ''}`}
            onClick={() => handleNavigation(item)}
          >
            <span className="sidebar-icon">{item.icon}</span>
            <span className="sidebar-label">{item.label}</span>
          </button>
        ))}
      </nav>

      <div className="sidebar-footer">
        <div 
          className="user-info" 
          onClick={(e) => {
            console.log('=== CLICK EN USER-INFO ===', showUserSelector)
            e.stopPropagation()
            setShowUserSelector(!showUserSelector)
            console.log('Nuevo estado:', !showUserSelector)
          }}
        >
          <div className="user-avatar">
            {currentUser?.nombre?.charAt(0) || 'U'}
          </div>
          <div className="user-details">
            <span className="user-name">
              {currentUser ? `${currentUser.nombre} ${currentUser.apellido}` : 'Usuario'}
            </span>
            <span className="user-email">{currentUser?.correo || 'usuario@ejemplo.com'}</span>
          </div>
          <span className="user-toggle">▼</span>
        </div>

        {showUserSelector && (
          <div className="user-selector" onClick={(e) => e.stopPropagation()}>
            <div className="user-selector-header">Cambiar Usuario</div>
            {usuarios.length === 0 ? (
              <div className="user-selector-empty">Cargando usuarios...</div>
            ) : (
              usuarios.map((user) => (
                <button
                  key={user.id_usuario}
                  className={`user-option ${currentUser?.id_usuario === user.id_usuario ? 'active' : ''}`}
                  onClick={(e) => {
                    e.stopPropagation()
                    handleUserChange(user)
                  }}
                >
                  <div className="user-option-avatar">
                    {user.nombre.charAt(0)}
                  </div>
                  <div className="user-option-info">
                    <span className="user-option-name">{user.nombre} {user.apellido}</span>
                    <span className="user-option-email">{user.correo}</span>
                  </div>
                  {currentUser?.id_usuario === user.id_usuario && (
                    <span className="user-option-check">✓</span>
                  )}
                </button>
              ))
            )}
          </div>
        )}
      </div>
    </aside>
  )
}
