"""Tester mot API:et. Kör med: pytest -v

Röd -> grön -> nästa. Börja med test_ping, jobba nedåt.
"""

import uuid

import pytest
from fastapi.testclient import TestClient

import db
from main import app


@pytest.fixture(autouse=True)
def clean_db():
    """Töm databasen före varje test."""
    db.reset_db()
    yield


@pytest.fixture
def client():
    return TestClient(app)


def new_uuid() -> str:
    return str(uuid.uuid4())


# --- ping ------------------------------------------------------------------

def test_ping(client):
    assert client.get("/ping").status_code == 200


# --- skapa -----------------------------------------------------------------

def test_create_transaction_returns_201(client):
    account_id = new_uuid()
    response = client.post("/transactions", json={"account_id": account_id, "amount": 7})

    assert response.status_code == 201
    body = response.json()
    assert body["account_id"] == account_id
    assert body["amount"] == 7
    assert "transaction_id" in body
    assert "created_at" in body


def test_create_transaction_accepts_negative_amount(client):
    response = client.post("/transactions", json={"account_id": new_uuid(), "amount": -4})
    assert response.status_code == 201
    assert response.json()["amount"] == -4


def test_create_transaction_rejects_missing_fields(client):
    response = client.post("/transactions", json={"amount": 7})
    assert response.status_code in (400, 422)


def test_create_transaction_rejects_bad_types(client):
    response = client.post("/transactions", json={"account_id": "inte-ett-uuid", "amount": 7})
    assert response.status_code in (400, 422)


def test_each_transaction_gets_a_unique_id(client):
    account_id = new_uuid()
    first = client.post("/transactions", json={"account_id": account_id, "amount": 1}).json()
    second = client.post("/transactions", json={"account_id": account_id, "amount": 1}).json()

    assert first["transaction_id"] != second["transaction_id"]


# --- hämta ut --------------------------------------------------------------

def test_list_transactions_empty(client):
    response = client.get("/transactions")
    assert response.status_code == 200
    assert response.json() == []


def test_list_transactions_returns_all(client):
    client.post("/transactions", json={"account_id": new_uuid(), "amount": 7})
    client.post("/transactions", json={"account_id": new_uuid(), "amount": -4})

    response = client.get("/transactions")
    assert response.status_code == 200
    assert len(response.json()) == 2


def test_get_transaction_by_id(client):
    created = client.post("/transactions", json={"account_id": new_uuid(), "amount": 7}).json()

    response = client.get(f"/transactions/{created['transaction_id']}")
    assert response.status_code == 200
    assert response.json()["transaction_id"] == created["transaction_id"]
    assert response.json()["amount"] == 7


def test_get_unknown_transaction_returns_404(client):
    assert client.get(f"/transactions/{new_uuid()}").status_code == 404


def test_get_transaction_with_bad_id_returns_400(client):
    assert client.get("/transactions/inte-ett-uuid").status_code in (400, 422)


# --- saldo -----------------------------------------------------------------

def test_account_balance_sums_transactions(client):
    account_id = new_uuid()
    client.post("/transactions", json={"account_id": account_id, "amount": 10})
    client.post("/transactions", json={"account_id": account_id, "amount": -3})

    response = client.get(f"/accounts/{account_id}")
    assert response.status_code == 200
    assert response.json() == {"account_id": account_id, "balance": 7}


def test_account_balance_can_be_negative(client):
    account_id = new_uuid()
    client.post("/transactions", json={"account_id": account_id, "amount": -7})

    assert client.get(f"/accounts/{account_id}").json()["balance"] == -7


def test_account_balance_ignores_other_accounts(client):
    mine, theirs = new_uuid(), new_uuid()
    client.post("/transactions", json={"account_id": mine, "amount": 5})
    client.post("/transactions", json={"account_id": theirs, "amount": 100})

    assert client.get(f"/accounts/{mine}").json()["balance"] == 5


def test_unknown_account_returns_404(client):
    assert client.get(f"/accounts/{new_uuid()}").status_code == 404
