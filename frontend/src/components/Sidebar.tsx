import './Sidebar.css'

type SidebarProps = {
  activeSection?: string
}

export default function Sidebar({ activeSection = 'dashboard' }: SidebarProps) {
  return (
    <aside className="sidebar">
      <div className="sidebar-logo">
        <div className="logo-icon">₱</div>
      </div>

      <nav className="sidebar-nav">
        <button
          className={`sidebar-item ${activeSection === 'dashboard' ? 'active' : ''}`}
          title="Dashboard"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <rect x="3" y="3" width="7" height="7" />
            <rect x="14" y="3" width="7" height="7" />
            <rect x="14" y="14" width="7" height="7" />
            <rect x="3" y="14" width="7" height="7" />
          </svg>
        </button>

        <button
          className={`sidebar-item ${activeSection === 'presupuestos' ? 'active' : ''}`}
          title="Presupuestos"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
          </svg>
        </button>

        <button
          className={`sidebar-item ${activeSection === 'transacciones' ? 'active' : ''}`}
          title="Transacciones"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M17 9.5l-5 5-5-5M17 14.5l-5 5-5-5" />
          </svg>
        </button>

        <button
          className={`sidebar-item ${activeSection === 'categorias' ? 'active' : ''}`}
          title="Categorías"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z" />
          </svg>
        </button>

        <button
          className={`sidebar-item ${activeSection === 'metas' ? 'active' : ''}`}
          title="Metas"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="12" cy="12" r="10" />
            <path d="M12 6v6l4 2" />
          </svg>
        </button>
      </nav>

      <div className="sidebar-footer">
        <button className="sidebar-item" title="Configuración">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="12" cy="12" r="3" />
            <path d="M12 1v6m0 6v6M4.22 4.22l4.24 4.24m7.08 7.08l4.24 4.24M1 12h6m6 0h6M4.22 19.78l4.24-4.24m7.08-7.08l4.24-4.24" />
          </svg>
        </button>
      </div>
    </aside>
  )
}
