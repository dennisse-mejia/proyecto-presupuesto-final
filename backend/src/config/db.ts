// @ts-ignore
import * as sql from 'mssql';
import 'dotenv/config';

console.log('DB_SERVER =', process.env.DB_SERVER);

const dbConfig: sql.config = {
  user: process.env.DB_USER ?? '',
  password: process.env.DB_PASSWORD ?? '',
  server: process.env.DB_SERVER ?? '',
  port: Number(process.env.DB_PORT ?? 1433),
  database: process.env.DB_DATABASE ?? '',
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  requestTimeout: 30000,
  connectionTimeout: 15000,
};

let pool: sql.ConnectionPool | null = null;


export async function getPool(): Promise<sql.ConnectionPool> {
  if (pool && pool.connected) {
    return pool;
  }

  try {
    pool = await sql.connect(dbConfig);
    console.log(' Conectado a SQL Server:', dbConfig.database);
    return pool;
  } catch (err) {
    console.error('Error conectando a SQL Server:', err);
    pool = null;
    throw err;
  }
}


export async function execSP(
  spName: string,
  params: Record<string, unknown> = {}
) {
  try {
    const pool = await getPool();
    const request = pool.request();

    for (const [key, value] of Object.entries(params)) {
      request.input(key, value as any);
    }

    console.log(`Ejecutando SP: ${spName}`, params);
    const result = await request.execute(spName);
    console.log(`SP ejecutado: ${spName}`, result.recordset?.length ?? 0, 'registros');
    return result;
  } catch (err: any) {
    console.error(`Error en SP ${spName}:`, err.message);
    throw err;
  }
}

export async function query(
  sqlQuery: string,
  params: Record<string, unknown> = {}
) {
  try {
    const pool = await getPool();
    const request = pool.request();

    for (const [key, value] of Object.entries(params)) {
      request.input(key, value as any);
    }

    console.log(` Ejecutando Query:`, sqlQuery.substring(0, 100) + '...');
    const result = await request.query(sqlQuery);
    console.log(`Query ejecutada:`, result.recordset?.length ?? 0, 'registros');
    return result;
  } catch (err: any) {
    console.error(`Error en Query:`, err.message);
    throw err;
  }
}
