#run.sh
#!/bin/bash
cd ~/Alvalabs/transactions
.venv/bin/uvicorn main:app --reload