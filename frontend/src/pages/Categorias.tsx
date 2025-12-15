import { useState, useEffect } from 'react'
import { useUser } from '../contexts/UserContext'
import Card from '../components/Card'
import Button from '../components/Button'
import Table from '../components/Table'
import Modal from '../components/Modal'
import { api } from '../api'
import type { Categoria, Subcategoria, CrearCategoriaInput, CrearSubcategoriaInput } from '../types'
import './Categorias.css'

export default function Categorias() {
  const { currentUserId } = useUser()
  const [categorias, setCategorias] = useState<Categoria[]>([])
  const [subcategorias, setSubcategorias] = useState<Subcategoria[]>([])
  const [selectedCategoria, setSelectedCategoria] = useState<Categoria | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [showCreateModal, setShowCreateModal] = useState(false)
  const [showEditModal, setShowEditModal] = useState(false)
  const [showSubcategoryModal, setShowSubcategoryModal] = useState(false)

  const [formData, setFormData] = useState<CrearCategoriaInput>({
    id_usuario: currentUserId,
    nombre: '',
    tipo: 'gasto',
    descripcion: ''
  })

  const [subcategoriaForm, setSubcategoriaForm] = useState<CrearSubcategoriaInput>({
    id_categoria: 0,
    nombre: '',
    descripcion: ''
  })

  useEffect(() => {
    cargarCategorias()
  }, [currentUserId])

  const cargarCategorias = async () => {
    try {
      setLoading(true)
      const data = await api.getCategoriasByUsuario(currentUserId)
      setCategorias(data)
      setError('')
    } catch (err) {
      setError('Error al cargar categorías')
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  const cargarSubcategorias = async (idCategoria: number) => {
    try {
      const data = await api.getSubcategoriasByCategoria(idCategoria)
      setSubcategorias(data)
    } catch (err) {
      console.error('Error cargando subcategorías:', err)
    }
  }

  const handleSelectCategoria = async (categoria: Categoria) => {
    setSelectedCategoria(categoria)
    await cargarSubcategorias(categoria.id_categoria)
  }

  const handleCreateCategoria = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      await api.crearCategoria(formData)
      setShowCreateModal(false)
      setFormData({ id_usuario: 1, nombre: '', tipo: 'gasto', descripcion: '' })
      await cargarCategorias()
    } catch (err) {
      setError('Error al crear categoría')
      console.error(err)
    }
  }

  const handleEditCategoria = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!selectedCategoria) return
    
    try {
      await api.actualizarCategoria(selectedCategoria.id_categoria, {
        nombre: formData.nombre,
        tipo: formData.tipo,
        descripcion: formData.descripcion
      })
      setShowEditModal(false)
      setSelectedCategoria(null)
      setFormData({ id_usuario: 1, nombre: '', tipo: 'gasto', descripcion: '' })
      await cargarCategorias()
    } catch (err) {
      setError('Error al actualizar categoría')
      console.error(err)
    }
  }

  const handleDeleteCategoria = async (id: number) => {
    if (!confirm('¿Estás seguro de eliminar esta categoría?')) return
    
    try {
      await api.eliminarCategoria(id)
      await cargarCategorias()
      if (selectedCategoria?.id_categoria === id) {
        setSelectedCategoria(null)
        setSubcategorias([])
      }
    } catch (err) {
      setError('Error al eliminar categoría')
      console.error(err)
    }
  }

  const handleCreateSubcategoria = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!selectedCategoria) return

    try {
      await api.crearSubcategoria({
        ...subcategoriaForm,
        id_categoria: selectedCategoria.id_categoria
      })
      setShowSubcategoryModal(false)
      setSubcategoriaForm({ id_categoria: 0, nombre: '', descripcion: '' })
      await cargarSubcategorias(selectedCategoria.id_categoria)
    } catch (err) {
      setError('Error al crear subcategoría')
      console.error(err)
    }
  }

  const handleDeleteSubcategoria = async (id: number) => {
    if (!confirm('¿Estás seguro de eliminar esta subcategoría?')) return
    
    try {
      await api.eliminarSubcategoria(id)
      if (selectedCategoria) {
        await cargarSubcategorias(selectedCategoria.id_categoria)
      }
    } catch (err) {
      setError('Error al eliminar subcategoría')
      console.error(err)
    }
  }

  const openEditModal = (categoria: Categoria) => {
    setSelectedCategoria(categoria)
    setFormData({
      id_usuario: 1,
      nombre: categoria.nombre,
      tipo: categoria.tipo,
      descripcion: categoria.descripcion || ''
    })
    setShowEditModal(true)
  }

  const categoriaColumns = [
    { key: 'nombre', header: 'Nombre' },
    { 
      key: 'tipo', 
      header: 'Tipo',
      render: (cat: Categoria) => (
        <span className={`badge badge-${cat.tipo}`}>
          {cat.tipo === 'gasto' ? '💸 Gasto' : cat.tipo === 'ingreso' ? '💰 Ingreso' : '🎯 Ahorro'}
        </span>
      )
    },
    { key: 'descripcion', header: 'Descripción' },
    {
      key: 'actions',
      header: 'Acciones',
      render: (cat: Categoria) => (
        <div className="action-buttons">
          <Button variant="secondary" onClick={() => openEditModal(cat)}>
            ✏️
          </Button>
          <Button variant="danger" onClick={() => handleDeleteCategoria(cat.id_categoria)}>
            🗑️
          </Button>
        </div>
      )
    }
  ]

  const subcategoriaColumns = [
    { key: 'nombre', header: 'Nombre' },
    { key: 'descripcion', header: 'Descripción' },
    {
      key: 'actions',
      header: 'Acciones',
      render: (sub: Subcategoria) => (
        <Button variant="danger" onClick={() => handleDeleteSubcategoria(sub.id_subcategoria)}>
          🗑️
        </Button>
      )
    }
  ]

  if (loading) {
    return <div className="loading">Cargando categorías...</div>
  }

  return (
    <div className="categorias-page">
      <div className="page-header">
        <h1>Gestión de Categorías</h1>
        <Button onClick={() => setShowCreateModal(true)}>
          + Nueva Categoría
        </Button>
      </div>

      {error && <div className="error-message">{error}</div>}

      <div className="categorias-layout">
        <Card title="Categorías" className="categorias-card">
          <Table
            data={categorias.map(c => ({ ...c, id: c.id_categoria }))}
            columns={categoriaColumns}
            onRowClick={(cat) => handleSelectCategoria(categorias.find(c => c.id_categoria === cat.id)!)}
          />
        </Card>

        {selectedCategoria && (
          <Card title={`Subcategorías de "${selectedCategoria.nombre}"`} className="subcategorias-card">
            <div className="subcategoria-header">
              <Button onClick={() => setShowSubcategoryModal(true)}>
                + Nueva Subcategoría
              </Button>
            </div>
            <Table
              data={subcategorias.map(s => ({ ...s, id: s.id_subcategoria }))}
              columns={subcategoriaColumns}
            />
          </Card>
        )}
      </div>

      {/* Modal Crear Categoría */}
      <Modal isOpen={showCreateModal} onClose={() => setShowCreateModal(false)} title="Nueva Categoría">
        <form onSubmit={handleCreateCategoria} className="categoria-form">
          <div className="form-group">
            <label>Nombre</label>
            <input
              type="text"
              value={formData.nombre}
              onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
              required
            />
          </div>

          <div className="form-group">
            <label>Tipo</label>
            <select
              value={formData.tipo}
              onChange={(e) => setFormData({ ...formData, tipo: e.target.value as 'gasto' | 'ingreso' | 'ahorro' })}
              required
            >
              <option value="gasto">💸 Gasto</option>
              <option value="ingreso">💰 Ingreso</option>
              <option value="ahorro">🎯 Ahorro</option>
            </select>
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
              Crear Categoría
            </Button>
          </div>
        </form>
      </Modal>

      {/* Modal Editar Categoría */}
      <Modal isOpen={showEditModal} onClose={() => setShowEditModal(false)} title="Editar Categoría">
        <form onSubmit={handleEditCategoria} className="categoria-form">
          <div className="form-group">
            <label>Nombre</label>
            <input
              type="text"
              value={formData.nombre}
              onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
              required
            />
          </div>

          <div className="form-group">
            <label>Tipo</label>
            <select
              value={formData.tipo}
              onChange={(e) => setFormData({ ...formData, tipo: e.target.value as 'gasto' | 'ingreso' | 'ahorro' })}
              required
            >
              <option value="gasto">💸 Gasto</option>
              <option value="ingreso">💰 Ingreso</option>
              <option value="ahorro">🎯 Ahorro</option>
            </select>
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
            <Button type="button" variant="secondary" onClick={() => setShowEditModal(false)}>
              Cancelar
            </Button>
            <Button type="submit">
              Guardar Cambios
            </Button>
          </div>
        </form>
      </Modal>

      {/* Modal Crear Subcategoría */}
      <Modal isOpen={showSubcategoryModal} onClose={() => setShowSubcategoryModal(false)} title="Nueva Subcategoría">
        <form onSubmit={handleCreateSubcategoria} className="categoria-form">
          <div className="form-group">
            <label>Nombre</label>
            <input
              type="text"
              value={subcategoriaForm.nombre}
              onChange={(e) => setSubcategoriaForm({ ...subcategoriaForm, nombre: e.target.value })}
              required
            />
          </div>

          <div className="form-group">
            <label>Descripción</label>
            <textarea
              value={subcategoriaForm.descripcion}
              onChange={(e) => setSubcategoriaForm({ ...subcategoriaForm, descripcion: e.target.value })}
              rows={3}
            />
          </div>

          <div className="form-actions">
            <Button type="button" variant="secondary" onClick={() => setShowSubcategoryModal(false)}>
              Cancelar
            </Button>
            <Button type="submit">
              Crear Subcategoría
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  )
}
