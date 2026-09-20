"""Databaskoppling. Den här filen är klar - du behöver inte ändra i den."""

import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).parent / "app.db"
SCHEMA_PATH = Path(__file__).parent / "schema.sql"


def get_connection() -> sqlite3.Connection:
    """Öppnar en koppling till databasen.

    row_factory gör att du kan läsa kolumner med namn: row["amount"]
    istället för row[2]. Lättare att läsa, och går inte sönder om
    kolumnordningen ändras.
    """
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


def init_db() -> None:
    """Kör schema.sql. Anropas när appen startar."""
    schema = SCHEMA_PATH.read_text()
    with get_connection() as conn:
        conn.executescript(schema)


def reset_db() -> None:
    """Tömmer databasen. Används av testerna så varje test börjar rent."""
    if DB_PATH.exists():
        DB_PATH.unlink()
    init_db()
