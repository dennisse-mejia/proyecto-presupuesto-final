import express from 'express';
import cors from 'cors';
import usuariosRouter from './routes/usuarios.routes';
import categoriasRouter from './routes/categorias.routes';
import subcategoriasRouter from './routes/subcategorias.routes';
import presupuestosRouter from './routes/presupuestos.routes';
import presupuestoDetalleRouter from './routes/presupuestoDetalle.routes';
import transaccionesRouter from './routes/transacciones.routes';
import obligacionesRouter from './routes/obligaciones.routes';
import metasRouter from './routes/metas.routes';

const app = express();

app.use(express.json());

app.use(
  cors({
    // CUIDADO, si cambiamos el puerto hay que actualizarlo
    origin: 'http://localhost:5173',
  })
);

app.use('/api/usuarios', usuariosRouter);
app.use('/api/categorias', categoriasRouter);
app.use('/api/subcategorias', subcategoriasRouter);
app.use('/api/presupuestos', presupuestosRouter);
app.use('/api/presupuesto-detalle', presupuestoDetalleRouter);
app.use('/api/transacciones', transaccionesRouter);
app.use('/api/obligaciones', obligacionesRouter);
app.use('/api/metas', metasRouter);

const PORT = Number(process.env.PORT || 3000);

app.listen(PORT, () => {
  console.log(`API escuchando en http://localhost:${PORT}`);
});
