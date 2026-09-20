"""Transaction Management API.

Modellerna och rutterna är uppsatta. Det som saknas är SQL:en - det är din del.
Varje TODO är ett hål du ska fylla i.
"""

import uuid
from contextlib import asynccontextmanager
from datetime import datetime, timezone

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

import db


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Körs när appen startar: skapar tabellerna om de inte finns."""
    db.init_db()
    yield


app = FastAPI(lifespan=lifespan)


# ---------------------------------------------------------------------------
# Modeller: hur JSON in och ut ska se ut.
# Det här är INTE databasschemat - det ligger i schema.sql.
# ---------------------------------------------------------------------------

class TransactionRequest(BaseModel):
    """Kroppen i POST /transactions."""
    account_id: uuid.UUID
    amount: int


class Transaction(BaseModel):
    """Det som skickas tillbaka."""
    transaction_id: uuid.UUID
    account_id: uuid.UUID
    amount: int
    created_at: datetime


class Account(BaseModel):
    account_id: uuid.UUID
    balance: int


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@app.get("/ping")
def ping() -> dict:
    """Healthcheck. Klar."""
    return {"status": "ok"}


@app.post("/transactions", response_model=Transaction, status_code=201)
def create_transaction(payload: TransactionRequest) -> Transaction:
    """Skapar en transaktion.

    FastAPI har redan gett 400 om account_id inte är ett uuid eller
    amount inte är ett heltal - du behöver inte kontrollera det.

    TODO:
      1. Generera ett transaction_id och en tidpunkt.
      2. Skriv INSERT-satsen.
      3. Returnera transaktionen.

    Använd frågetecken som platshållare i SQL:en, aldrig f-strängar:
        conn.execute("INSERT INTO ... VALUES (?, ?)", (a, b))
    """
    raise NotImplementedError


@app.get("/transactions", response_model=list[Transaction])
def list_transactions() -> list[Transaction]:
    """Alla transaktioner.

    TODO: SELECT allt ur transaktionstabellen.
    """
    raise NotImplementedError


@app.get("/transactions/{transaction_id}", response_model=Transaction)
def get_transaction(transaction_id: uuid.UUID) -> Transaction:
    """En transaktion på id. 404 om den inte finns.

    TODO: SELECT på id. Hittas inget -> raise HTTPException(status_code=404)
    """
    raise NotImplementedError


@app.get("/accounts/{account_id}", response_model=Account)
def get_account(account_id: uuid.UUID) -> Account:
    """Konto med saldo. 404 om kontot inte har några transaktioner.

    Det här är uppgiftens enda SQL som kräver lite tanke: saldot är
    summan av kontots transaktioner.

    TODO: räkna fram saldot. 404 om kontot är okänt.
    """
    raise NotImplementedError
