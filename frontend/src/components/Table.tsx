import './Table.css'

type Column<T> = {
  key: keyof T | string
  header: string
  render?: (item: T) => React.ReactNode
}

type TableProps<T> = {
  data: T[]
  columns: Column<T>[]
  onRowClick?: (item: T) => void
}

export default function Table<T extends { id: number }>({ data, columns, onRowClick }: TableProps<T>) {
  if (data.length === 0) {
    return (
      <div className="table-empty">
        <p>No hay datos para mostrar</p>
      </div>
    )
  }

  return (
    <div className="table-container">
      <table className="table">
        <thead>
          <tr>
            {columns.map((col, idx) => (
              <th key={idx}>{col.header}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.map((item) => (
            <tr
              key={item.id}
              onClick={() => onRowClick?.(item)}
              className={onRowClick ? 'clickable' : ''}
            >
              {columns.map((col, idx) => (
                <td key={idx}>
                  {col.render
                    ? col.render(item)
                    : String(item[col.key as keyof T] ?? '')}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
