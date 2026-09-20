# Data Engineer Coding Test — Scaffold

Working repo for a 1–2 hour data engineering coding test (SQL + Java + Python) for an
academic-institution role. This is a ready-to-go scaffold, not a solved test — drop the
real assignment's requirements into each track below and start solving.

## Time-box plan (suggested)

- 5 min — read the prompt fully, note deliverables and constraints
- 45–50 min — SQL track (schema/queries)
- 30–35 min — Python track (ETL/analysis)
- 20–25 min — Java track (if required)
- 10 min — write up assumptions, run everything once more, commit

## Layout

```
sql/       schema.sql, seed.sql, queries.sql, docker-compose.yml (local Postgres)
python/    src/ + tests/, pytest-ready
java/      Maven project, src/main + src/test, JUnit 5
docs/      scratch notes / assumptions while solving
```

## SQL track

```bash
cd sql
docker compose up -d          # starts Postgres on localhost:5432 (db: testdb, user/pass: test)
psql postgresql://test:test@localhost:5432/testdb -f schema.sql
psql postgresql://test:test@localhost:5432/testdb -f seed.sql
psql postgresql://test:test@localhost:5432/testdb -f queries.sql
```

`schema.sql` ships a small academic domain (students, courses, enrollments) as a
starting point — replace with whatever schema the test specifies.

## Python track

```bash
cd python
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
pytest -q
```

## Java track

```bash
cd java
mvn -q test
```

## VS Code

Open `data-engineer-coding-test.code-workspace` (multi-root: root, sql, python,
java). It recommends the Python, Java Extension Pack, SQLTools (+Postgres
driver) and Docker extensions, and points the Python interpreter at
`python/.venv`.

## Notes

Use `docs/NOTES.md` to jot assumptions, edge cases, and anything you'd ask a
reviewer if you had time — worth including in the submission.
