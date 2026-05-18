import mysql from "mysql2/promise";

let pool: mysql.Pool | null = null;

function getPool(): mysql.Pool {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST || "127.0.0.1",
      port: Number(process.env.DB_PORT || 3306),
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME || "ownerspecs",
      waitForConnections: true,
      connectionLimit: 5,
      queueLimit: 0,
      charset: "utf8mb4_unicode_ci",
      enableKeepAlive: true,
      keepAliveInitialDelay: 10_000,
    });
  }
  return pool;
}

export async function query<T = Record<string, unknown>>(
  sql: string,
  values?: Array<string | number | boolean | null | Date>,
): Promise<T[]> {
  const [rows] = await getPool().execute(sql, values);
  return rows as T[];
}

export async function queryOne<T = Record<string, unknown>>(
  sql: string,
  values?: Array<string | number | boolean | null | Date>,
): Promise<T | null> {
  const rows = await query<T>(sql, values);
  return rows[0] ?? null;
}
