import { useState, useEffect } from 'react'
import { UserProvider } from './contexts/UserContext'
import MainLayout from './layouts/MainLayout'
import Dashboard from './pages/Dashboard'
import Categorias from './pages/Categorias'
import Presupuestos from './pages/Presupuestos'
import Transacciones from './pages/Transacciones'
import Metas from './pages/Metas'
import './App.css'

type Page = 'dashboard' | 'categorias' | 'presupuestos' | 'transacciones' | 'metas'

function App() {
  const [currentPage, setCurrentPage] = useState<Page>('dashboard')

  useEffect(() => {
    const handleNavigate = (e: Event) => {
      const customEvent = e as CustomEvent
      setCurrentPage(customEvent.detail as Page)
    }

    window.addEventListener('navigate', handleNavigate)
    return () => window.removeEventListener('navigate', handleNavigate)
  }, [])

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard />
      case 'categorias':
        return <Categorias />
      case 'presupuestos':
        return <Presupuestos />
      case 'transacciones':
        return <Transacciones />
      case 'metas':
        return <Metas />
      default:
        return <Dashboard />
    }
  }

  return (
    <UserProvider>
      <MainLayout>
        {renderPage()}
      </MainLayout>
    </UserProvider>
  )
}

export default App