#!/bin/bash
set -e

# Skapar övningstickets som GitHub-issues.
#
# Innan du kör:
#   brew install gh
#   gh auth login
#   gh repo create Alvalabs-transactions --private --source=. --remote=origin
#
# Sen: ./create-issues.sh

command -v gh >/dev/null || { echo "gh saknas. brew install gh"; exit 1; }
git remote get-url origin >/dev/null 2>&1 || { echo "Ingen remote. Kor gh repo create forst."; exit 1; }

label() { gh label create "$1" --color "$2" --force >/dev/null; }

label "etapp-1-fungera"  "0E8A16"
label "etapp-2-kvalitet" "1D76DB"
label "etapp-3-sql"      "5319E7"
label "etapp-4-skarpt"   "D93F0B"

new() { gh issue create --title "$1" --label "$2" --body "$3"; }

# ---------------------------------------------------------------- etapp 1

new "1. Schema — tabeller for transaktioner" "etapp-1-fungera" "$(cat <<'EOF'
Skriv CREATE TABLE-satserna i `schema.sql`.

Datan: en transaktion har id, konto-id, belopp och tidpunkt. Ett konto har
id och saldo.

**Besluten du ska kunna motivera**

- Behovs en kontotabell alls, eller racker transaktionstabellen?
- Vilken typ for ett uuid i SQLite, och varfor just den?
- Belopp ar heltal i specen. Varfor heltal och inte decimaltal for pengar?
- Hur lagrar du tidpunkten sa att sortering fungerar?
- Behovs index? Pa vad?

**Klar nar**

- `sqlite3 app.db ".schema"` visar tabellerna
- Du kan svara pa alla fem fragorna utan att slå upp nagot
EOF
)"

new "2. POST /transactions" "etapp-1-fungera" "$(cat <<'EOF'
Skapa en transaktion och spara den.

FastAPI har redan gett 400 om indatan ar trasig — du behover inte kontrollera
det sjalv.

**Klar nar dessa ar grona**

- test_create_transaction_returns_201
- test_create_transaction_accepts_negative_amount
- test_each_transaction_gets_a_unique_id

**Tank pa**

- Fragetecken som platshallare i SQL, aldrig f-strangar
- Vem genererar transaction_id — appen eller databasen? Motivera valet
EOF
)"

new "3. GET /transactions" "etapp-1-fungera" "$(cat <<'EOF'
Returnera alla transaktioner.

**Klar nar dessa ar grona**

- test_list_transactions_empty
- test_list_transactions_returns_all

**Tank pa**

Tom lista ar 200 med `[]`, inte 404. Ett konto som inte finns ar nagot annat
an ett konto utan innehall.
EOF
)"

new "4. GET /transactions/{transaction_id}" "etapp-1-fungera" "$(cat <<'EOF'
Hamta en transaktion pa id, 404 om den inte finns.

**Klar nar dessa ar grona**

- test_get_transaction_by_id
- test_get_unknown_transaction_returns_404
- test_get_transaction_with_bad_id_returns_400

**Tank pa**

Skillnaden mellan 400 och 404: trasigt id ar 400, giltigt id som inte finns
ar 404. Blandar man ihop dem ar det en anmarkning i granskningen.
EOF
)"

new "5. GET /accounts/{account_id} — saldot" "etapp-1-fungera" "$(cat <<'EOF'
Returnera kontot med saldo. Saldot ar summan av kontots transaktioner.

Uppgiftens enda SQL som kraver lite tanke.

**Klar nar dessa ar grona**

- test_account_balance_sums_transactions
- test_account_balance_can_be_negative
- test_account_balance_ignores_other_accounts
- test_unknown_account_returns_404

**Fragan att besvara**

Ska saldot raknas fram vid varje anrop, eller lagras i en kolumn som
uppdateras? Bada ar forsvarbara. Kunna argumentera for ditt val — det ar
precis en sadan sak en granskare frågar om.
EOF
)"

# ---------------------------------------------------------------- etapp 2

new "6. Dela upp HTTP-lager och databaslager" "etapp-2-kvalitet" "$(cat <<'EOF'
Flytta ut SQL:en ur endpoint-funktionerna.

Efter etapp 1 ligger allt i `main.py`. Det fungerar, men en granskare ser en
enda hog. Bryt ut databaskoden till egna funktioner — `repository.py` eller
liknande.

**Klar nar**

- `main.py` innehaller ingen SQL
- Alla tester ar fortfarande grona
- Funktionerna gar att lasa utan att veta nagot om HTTP

**Varfor**

Det har ar den enskilt vanligaste anmarkningen i kodgranskningar av
take-home-uppgifter. Det kostar tjugo minuter och syns direkt.
EOF
)"

new "7. Felhantering och statuskoder" "etapp-2-kvalitet" "$(cat <<'EOF'
Ga igenom att ratt kod returneras i varje lage.

Specen namner fyra: 400 (trasig indata), 404 (finns inte), 405 (fel
HTTP-metod), 415 (fel content-type).

**Klar nar**

- Du har testat varje fall for hand med curl
- Du vet vilka FastAPI ger dig gratis och vilka du satt sjalv
- Inga oavsiktliga 500-svar vid vanlig felaktig indata

**Ovning**

Skicka medvetet trasiga anrop: fel metod, fel content-type, tomt body,
belopp som strang. Se vad som kommer tillbaka.
EOF
)"

new "8. Git-flode — branch, sma commits, PR" "etapp-2-kvalitet" "$(cat <<'EOF'
Ova pa inlamningsformen, inte bara koden.

Alva vill ha: egen branch, commits som visar progression, en pull request mot
default-branchen som INTE ar mergad.

**Klar nar**

- Du har gjort hela flodet en gang pa det har repot
- Commit-historiken lases som en berattelse, inte "final" och "fix"
- PR:en finns och ar omergad

**Varfor**

Det har ar det billigaste stallet att tappa poang. Uppgiften ar ratt lost men
inlamnad fel.
EOF
)"

# ---------------------------------------------------------------- etapp 3

new "9. JOIN och GROUP BY — grundovningar" "etapp-3-sql" "$(cat <<'EOF'
Drill pa den SQL som faktiskt dyker upp.

Skapa en liten testdatabas med konton och transaktioner och skriv fragor for
hand i `sqlite3`, utan Python emellan.

**Ova pa**

- INNER JOIN mot LEFT JOIN — nar spelar skillnaden roll
- GROUP BY med COUNT, SUM, AVG
- HAVING mot WHERE — varfor finns bada
- Konton utan transaktioner (klassisk LEFT JOIN-falla)

**Klar nar**

Du kan skriva en JOIN med GROUP BY utan att slå upp syntaxen.
EOF
)"

new "10. Endpoint: konton med storst transaktionsvolym" "etapp-3-sql" "$(cat <<'EOF'
Bygg en endpoint som returnerar hogsta antalet transaktioner och vilka konton
som har det.

Svarsform:

    {"maxVolume": 4, "accountIds": ["44a9...", "7c9b..."]}

Den har finns i Alvas API-spec men inte i niva 1 — den dyker upp i de hogre
nivaerna. Vard att gora anda: det ar en GROUP BY dar flera konton kan dela
forstaplatsen.

**Klar nar**

- Fungerar nar ett konto har flest
- Fungerar nar tva konton ar lika
- Du loser det i SQL, inte genom att lasa ut allt och rakna i Python
EOF
)"

new "11. Lopande saldo med window function" "etapp-3-sql" "$(cat <<'EOF'
Skriv en fraga som visar saldot efter varje transaktion for ett konto.

Alltsa: transaktionerna i tidsordning, med en kolumn som visar vad saldot var
just da.

Nyckeln ar `SUM(amount) OVER (PARTITION BY ... ORDER BY ...)`.

**Klar nar**

- Fragan fungerar i sqlite3
- Du kan forklara vad PARTITION BY och ORDER BY gor var for sig

**Varfor**

Window functions ar standardfraga i intervjuer for datarollen, och en av fa
SQL-saker som faktiskt ar svara att gissa sig till.
EOF
)"

new "12. Index och EXPLAIN QUERY PLAN" "etapp-3-sql" "$(cat <<'EOF'
Se vad databasen faktiskt gor.

**Ova pa**

- Kor `EXPLAIN QUERY PLAN` pa dina fragor
- Las skillnaden mellan SCAN och SEARCH
- Lagg ett index pa account_id, kor om, se vad som andras

**Klar nar**

Du kan peka pa en fraga och saga om den anvander index eller laser hela
tabellen — och motivera om det spelar roll har.

**Tank pa**

Med tio rader gor index ingen skillnad. Poangen ar att kunna resonera om det,
inte att optimera en leksaksdatabas.
EOF
)"

# ---------------------------------------------------------------- etapp 4

new "13. Torrkorning pa tid — bygg om fran tom mapp" "etapp-4-skarpt" "$(cat <<'EOF'
Gor om hela uppgiften fran ingenting. Klockan igang.

**Regler**

- Ny tom mapp
- Titta inte pa det du redan byggt
- Tva timmar, ta tid
- Dokumentation och sokningar ar tillatna — det ar de i det skarpa testet med

**Klar nar**

Allt gront, PR skapad, inom tiden.

**Efterat**

Skriv ner var du fastnade. Det ar den listan som sager vad du ska ova mer pa —
inte kanslan av hur det gick.
EOF
)"

new "14. Torrkorning 2 — annan datamodell" "etapp-4-skarpt" "$(cat <<'EOF'
Samma form, annan domän, sa du ovar formagan och inte uppgiften.

Forslag: projekt och rapporter. Ett projekt kan ha flera rapporter, rapporter
ar inte obligatoriska. CRUD pa bada, plus en endpoint som hittar alla
rapporter dar samma ord forekommer minst tre ganger.

**Klar nar**

Samma som 13 — gront och inlamnat inom tiden.

**Varfor**

Har du bara gjort transaktionsuppgiften har du lart dig transaktionsuppgiften.
Den har visar om du lart dig formen.
EOF
)"

echo
echo "Klart. Alla issues skapade."
