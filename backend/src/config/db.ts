// @ts-ignore
import * as sql from 'mssql';
import 'dotenv/config';

console.log('DB_SERVER =', process.env.DB_SERVER);

const dbConfig: sql.config = {
  user: process.env.DB_USER ?? '',
  password: process.env.DB_PASSWORD ?? '',
  server: process.env.DB_SERVER ?? '',
  port: Number(process.env.DB_PORT ?? 1433),
  database: process.env.DB_NAME ?? '',
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

let pool: sql.ConnectionPool | null = null;


export async function getPool(): Promise<sql.ConnectionPool> {
  if (pool) {
    return pool;
  }

  pool = await sql.connect(dbConfig);
  return pool;
}


export async function execSP(
  spName: string,
  params: Record<string, unknown> = {}
) {
  const pool = await getPool();
  const request = pool.request();

  for (const [key, value] of Object.entries(params)) {
    request.input(key, value as any);
  }

  return request.execute(spName);
}
