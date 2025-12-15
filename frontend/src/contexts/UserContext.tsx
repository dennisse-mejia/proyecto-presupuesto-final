import { createContext, useContext, useState, useEffect } from 'react'
import type { ReactNode } from 'react'
import type { Usuario } from '../types'

type UserContextType = {
  currentUser: Usuario | null
  setCurrentUser: (user: Usuario) => void
  currentUserId: number
}

const UserContext = createContext<UserContextType | undefined>(undefined)

export function UserProvider({ children }: { children: ReactNode }) {
  const [currentUser, setCurrentUserState] = useState<Usuario | null>(null)

  useEffect(() => {
    const savedUser = localStorage.getItem('currentUser')
    if (savedUser) {
      setCurrentUserState(JSON.parse(savedUser))
    } else {
      const defaultUser: Usuario = {
        id_usuario: 1,
        nombre: 'Test',
        apellido: 'User',
        correo: 'test@test.com',
        fecha_registro: '2025-12-14',
        salario_mensual: 30000,
        estado: 'ACTIVO',
        activo: true,
        creado_por: 'sistema',
        creado_en: new Date().toISOString(),
        modificado_por: null,
        modificado_en: null
      }
      setCurrentUserState(defaultUser)
      localStorage.setItem('currentUser', JSON.stringify(defaultUser))
    }
  }, [])

  const setCurrentUser = (user: Usuario) => {
    setCurrentUserState(user)
    localStorage.setItem('currentUser', JSON.stringify(user))
    window.location.reload()
  }

  return (
    <UserContext.Provider
      value={{
        currentUser,
        setCurrentUser,
        currentUserId: currentUser?.id_usuario || 1
      }}
    >
      {children}
    </UserContext.Provider>
  )
}

export function useUser() {
  const context = useContext(UserContext)
  if (context === undefined) {
    throw new Error('useUser must be used within a UserProvider')
  }
  return context
}
