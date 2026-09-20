#!/bin/bash
set -e

clear
cd ~/Alvalabs/transactions

python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/pip install fastapi uvicorn pytest httpx

echo "Klart. Kör: source .venv/bin/activate"