Projekt: FLP, Kostra grafu
autor: Filip Brna, xbrnaf00
dátum: 19.4.2023

preloženie programu: make
príklad spustenia programu : ./flp22-log < [vstupny_subor]
odporúčane ukážkové spustenie : ./flp22-log < tests/input1.in > tests/output1.out

použité metody:
Implementácia začína volaním predikátu "start", ktorý je vstupným bodom programu. Vstup od používateľa je načítaný pomocou "prompt/2" a "read_lines/1" predikátov do zoznamu "LL", ktorý obsahuje riadky vstupu. Tieto riadky sú následne rozdelené na hrany grafu vo forme zoznamu "EdgesInListNoFilter" pomocou predikátu "split_lines/2", nasleduje filtrovanie hrán, ktoré nepozostávajú z dvoch vrcholov (vrchol je reprezentovaný ako A-Z) pomocou predikátu filter_uppercase/2. Tieto hrany sú uložené do zoznamu "EdgesInList".
Ďalším krokom je zjednodušenie zoznamu hrán grafu pomocou predikátu "simplify/2", ktorý odstraňuje zbytočné zátvorky okolo hrán a medzery. Následne sú hrany usporiadané a odstránené cykly obsahujúce jediný vrchol pomocou predikátov "sort/2" a "remove_self_loops/2".
Následne sa generuje zoznam jedinečných vrcholov grafu pomocou predikátov "unique_Nodes/2" a tieto vrcholy sú uložené do zoznamu "Nodes".
Na tomto mieste sa nachádza časť kódu, ktorá zisťuje, či je možné zo zadaných hrán zostaviť súvislý graf pomocou predikátu "all_visited/3", ak nie program sa ukončí.
V prípade, že je možné zostaviť súvislý graf, tak následuje generovanie kombinácii hrán, o veľkosti očakávaného rozmeru grafu. Kombinácie sú generované pomocou predikátu "generate_combinations/3".
Následne sú filtrované kombinácie, ktoré neobsahujú všetky vrcholy grafu, pomocou predikátu "filter_trees_without_all_nodes/4". Kombinácie, ktoré neobsahujú všetky vrcholy, sú zahodené.
Potom nasleduje filtrácia ekvivalentných stromov, čo zabezpečuje, že do výsledného zoznamu sa dostanú iba jedinečné stromy. Ekvivalentné stromy sú tie, ktoré sa líšia iba permutáciou hrán. Táto filtrácia je implementovaná pomocou predikátov "filter_equivalent_trees/2" a "is_permutation/2".
Nakoniec je výsledok vypísaný na výstup pomocou predikátov "print_output/1" a "print_combination/1", ktoré zabezpečujú formátovanie.

Program je bez priložených testovacích skriptov.
Neboli implementované žiadne rozšírenia nad rámec zadania.

Testovacie vstupy a dlžka behu programu:

    SUVISLE GRAFY TESTY

    priklad zo zadania
    time ./flp22-log < tests/input1.in > tests/output1.out
    real    0m0.026s
    user    0m0.013s
    sys     0m0.006s


    time ./flp22-log < tests/input2.in > tests/output2.out
    real    0m25.429s
    user    0m25.230s
    sys     0m0.195s


    time ./flp22-log < tests/input3.in > tests/output3.out
    real    0m0.099s
    user    0m0.083s
    sys     0m0.008s


    time ./flp22-log < tests/input4.in > tests/output4.out
    real    0m0.768s
    user    0m0.754s
    sys     0m0.011s


    NESUVISLY GRAF TEST

    time ./flp22-log < tests/input5.in > tests/output5.out
    real    0m0.030s
    user    0m0.010s
    sys     0m0.015s

Omedzenie:
Program splňa zadanie v plnom rozsahu, jediným obmedzením može byť neefiktívna kontrola ci ide o súvislý graf, pri zložitých grafoch može dôjsť k nedostatku pamäte. V kode je ale popísané ako je túto funkcionalitu, kontroly súvislého grafu možno deaktivovať. V makefile je navýšený local/global stack limit.
