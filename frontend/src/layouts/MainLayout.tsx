import { ReactNode } from 'react'
import Sidebar from './Sidebar'
import './MainLayout.css'

type MainLayoutProps = {
  children: ReactNode
}

export default function MainLayout({ children }: MainLayoutProps) {
  return (
    <div className="main-layout">
      <Sidebar />
      <main className="main-content">
        {children}
      </main>
    </div>
  )
}
