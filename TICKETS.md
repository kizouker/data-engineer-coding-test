# Övningsplan — Alva Labs kodtest

Fyra etapper. Ordningen är inte förhandlingsbar: få det att fungera, gör det
snyggt, borra i SQL, gör om det på tid.

## Etapp 1 — Få API:et att fungera

Målet är gröna tester, inget annat. Fult är tillåtet här.

1. Schema — tabeller för transaktioner
2. POST /transactions
3. GET /transactions
4. GET /transactions/{transaction_id}
5. GET /accounts/{account_id} — saldot

## Etapp 2 — Det granskningen tittar på

Halva poängen i Alvas bedömning ligger här, och syns inte i testerna.

6. Dela upp HTTP-lager och databaslager
7. Felhantering och statuskoder
8. Git-flöde — branch, små commits, PR

## Etapp 3 — SQL på djupet

Det här är den del som bär längst, både i testet och i rollen.

9. JOIN och GROUP BY — grundövningar
10. Endpoint: konton med störst transaktionsvolym
11. Löpande saldo med window function
12. Index och EXPLAIN QUERY PLAN

## Etapp 4 — Skarpt läge

Det är först här du märker vad du faktiskt kan.

13. Torrkörning på tid — bygg om från tom mapp
14. Torrkörning 2 — annan datamodell

---

## Varför den här ordningen

Etapp 1 och 2 är själva uppgiften. Etapp 3 är den enda delen som gör dig
snabbare nästa gång — resten är att lära sig en uppgift, SQL:en är att lära
sig ett verktyg. Etapp 4 är den som räknas: att ha sett en lösning är inte
samma sak som att kunna producera den med klockan igång.

Hoppa inte över 13. Det är den enda övningen som liknar det skarpa läget.
