OBS 8/2 2022: Fra og med tirsdag den 8. februar 2022 er målgruppedashboardet ikke længere aktivt. Dette betyder, at målgruppedashboardet fra denne dato ikke længere opdateres, og at SSI ikke længere producerer data og filer vedrørende målgruppedashboardet. Se infoteksten i venstre side af dashboardet for uddybende forklaring.

Dette dokument beskriver indholdet af zip-filen. Variabelnavnene, som beskrives nedenfor, refererer til søjlenavne medmindre andet er beskrevet. 

Generel struktur:
Rækkerne i filerne er som udgangspunkt stratificeringer efter relevante parametre, eksempelvis aldersgruppering eller tidsopdeling. Filerne er comma-separerede.

Filerne bliver opdateret hver dag og i denne forbindelse kan tidsserier også ændre sig tilbage i tiden, hvis nyere data foreligger. Derfor anbefales det altid at benytte det senest tilgængelige data og for så vidt muligt, ikke at gemme filer og lave tidsserier på basis af gamle filer.

Filer angivet med a omhandler det regionale dashboard, mens filer angivet med b omhandler det kommunale dashboard. Nationale data har kun angivet et tal.

Bemærk:
Aldersgrupper vises både i 10-års intervaller og i såkaldte funktionelle aldersgrupper.
Desuden vises aldersdata både udregnet på vaccinationsdatoen og på kørselsdatoen (dagen tallene bliver udsendt)
 - Fil 7a, 10 og 11 indeholder data på 10-års aldersgrupper beregnet på baggrund af kørselsdatoen.
 - Fil 12, 13 og 14 indeholder data på funktionelle aldersgrupper beregnet på baggrund af vaccinationsdatoen.
 - Fil 16, 17 og 18 indeholder data på 10-års aldersgrupper beregnet på baggrund af vaccinationsdatoen.
 - Fil 19, 20 og 21 indeholder data på funktionelle aldersgrupper beregnet på baggrund af kørselsdatoen.


------------------------------------------------------

Fil 1a: Noegletal_regionale_daily

Dato: Dags dato.
Regionsnavn: Region.
Sex: K (kvinder), M (mænd)
1. stik i dag: Antal 1. stik (personer) for det givne køn i dag.
2. stik i dag: Antal 2. stik for det givne køn i dag.
3. stik idag: Antal 3. stik for det givne køn i dag.
1. stik igaar : Antal 1. stik (personer) for det givne køn igår.
2. stik igaar: Antal 2. stik for det givne køn igår.
3. stik igaar: Antal 3. stik for det givne køn igår.
1. stik difference: 1. stik i dag - 1. stik igaar.
2. stik difference: 2. stik i dag - 2. stik igaar.
3. stik difference: 3. stik idag - 3. stik igaar

------------------------------------------------------

Fil 1b: Noegletal_kommunale_daily

Dato: Dags dato.
Kommunenavn: Kommune.
Sex: K (kvinder), M (mænd)
1. stik i dag: Antal 1. stik (personer) for det givne køn i dag.
2. stik i dag: Antal 2. stik for det givne køn i dag.
3. stik idag: Antal 3. stik for det givne køn i dag.
1. stik igaar : Antal 1. stik (personer) for det givne køn igår.
2. stik igaar: Antal 2. stik for det givne køn igår.
3. stik igaar: Antal 3. stik for det givne køn igår.
1. stik difference: 1. stik i dag - 1. stik igaar.
2. stik difference: 2. stik i dag - 2. stik igaar.
3. stik difference: 3. stik idag - 3. stik igaar

------------------------------------------------------

Fil 2a: FoersteVacc_region_dag

Regionsnavn: Region.
1. stik dato: Dato for 1. stik.
Antal 1. stik: Antal 1. stik administreret.

------------------------------------------------------

Fil 2b: FoersteVacc_kommune_dag

Kommunenavn: Kommune
1. stik dato: Dato for 1. stik.
Antal 1. stik: Antal 1. stik administreret.

------------------------------------------------------

Fil 3a: FaerdigVacc_region_dag

Regionsnavn: Region.
2. stik dato: Dato for 2. stik.
Antal 2. stik: Antal 2. stik administreret. 

------------------------------------------------------

Fil 3b: FaerdigVacc_kommune_dag

Kommunenavn: Kommune
2. stik dato: Dato for 2. stik.
Antal 2. stik: Antal 2. stik administreret. 

------------------------------------------------------

Fil 4a: Vaccinationer_regioner_befolk

Regionsnavn: Region.
Antal 1. stik personer: Antal 1. stik personer.
Antal 2. stik personer: Antal 2. stik personer. 
Antal borgere: 

------------------------------------------------------

Fil 4b: Vaccinationer_kommuner_befolk

Kommunenavn: Kommune.
Antal 1. stik personer: Antal 1. stik personer.
Antal 2. stik personer: Antal 2. stik personer. 
Antal borgere: 

------------------------------------------------------

Fil 5a: Vaccinationsdaekning_region

Regionsnavn: Region.
Antal 1. stik: Antal 1. stik personer.
Antal 2. stik: Antal 2. stik personer. 
Antal 3. stik: Antal personer der har modtaget første revaccine.
Antal borgere: 
Vacc.dækning 1. stik (%): (antal 1. stik / antal borgere) x 100
Vacc.dækning 2. stik (%): (antal 2. stik / antal borgere) x 100
Vacc.dækning 3. stik (%): (antal 3. stik / antal borgere) x 100

------------------------------------------------------

Fil 5b: Vaccinationsdaekning_kommune

Kommunenavn: Kommune.
Antal 1. stik: Antal 1. stik personer.
Antal 2. stik: Antal 2. stik personer.
Antal 3. stik: Antal personer der har modtaget første revaccine.
Antal borgere: 
Vacc.dækning 1. stik (%): (antal 1. stik / antal borgere) x 100
Vacc.dækning 2. stik (%): (antal 2. stik / antal borgere) x 100
Vacc.dækning 3. stik (%): (antal 3. stik / antal borgere) x 100

------------------------------------------------------

Fil 6a: Vaccinations_Daekning_region_pr_dag

Regionsnavn: Region.
Vaccinedato: Dato for administreret vaccine.
Kumulerede antal 2. stik: Antal 2. stik kummuleret pr. dato. 
Antal borgere: 
Vacc.dækning (%): (Kumulerede antal 2. stik / antal borgere) x 100

------------------------------------------------------

Fil 7a: Vaccinations_region_aldgrp_koen

Regionsnavn: Region.
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på kørselsdatoen)
Sex: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik administreret.
antal 2. stik: Antal 2. stik administreret. 

------------------------------------------------------

Fil 8a: Vaccinationstyper_regioner

Vaccinenavn: Navn på administrede vaccinetyper. 
Regionsnavn: Region.
Antal 1. stik: Antal 1. stik administreret.
antal 2. stik: Antal 2. stik administreret. 

------------------------------------------------------

Fil 9: FaerdigVacc_daekning_DK_prdag

Geo: Nationalt
Vaccinedato: Dato for administreret vaccine.
Kumuleret antal 2. stik: Antal 2. stik kummuleret pr. dato. 
Antal borgere: 
2. stik (%): (Kumulerede antal 2. stik / antal borgere) x 100

------------------------------------------------------

Fil 10: Vaccinationer_DK_aldgrp_koen

Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på kørselsdatoen)
Køn: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel 1. stik: Andel (%) 1. stik personer
Andel 2. stik: Andel (%) 2. stik personer

------------------------------------------------------

Fil 11: FoersteVacc_FaerdigVacc_region_aldgrp_dag

Dato: Dato
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på kørselsdatoen)
Regionsnavn: Region
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer

------------------------------------------------------

Fil 12: Vaccinationer_region_fnkt_alder_koen

Regionsnavn: Region.
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på vaccinationsdatoen)
Sex: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik administreret.
antal 2. stik: Antal 2. stik administreret. 

------------------------------------------------------

Fil 13: Vaccinationer_DK_fnkt_alder_koen

Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på vaccinationsdatoen)
Køn: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel 1. stik: Andel (%) 1. stik personer
Andel 2. stik: Andel (%) 2. stik personer

------------------------------------------------------

Fil 14: FoersteVacc_FaerdigVacc_region_fnkt_alder_dag

Dato: Dato
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på vaccinationsdatoen)
Regionsnavn: Region
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer

------------------------------------------------------

Fil 15a: Revacc1_region_dag

3. stik dato: Dato for 3. stik.
Regionsnavn: Region.
Antal 3. stik: Antal 3. stik administreret. 

------------------------------------------------------

Fil 15b: Revacc1_kommune_dag

3. stik dato: Dato for 3. stik.
Kommunenavn: Kommune.
Antal 3. stik: Antal 3. stik administreret. 

------------------------------------------------------

Fil 16: Vaccinations_region_aldgrp_koen_vaccinealder

Regionsnavn: Region.
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på vaccinationsdatoen)
Sex: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik administreret.
antal 2. stik: Antal 2. stik administreret. 

------------------------------------------------------

Fil 17: Vaccinationer_DK_aldgrp_koen_vaccinealder

Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på vaccinationsdatoen)
Køn: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel 1. stik: Andel (%) 1. stik personer
Andel 2. stik: Andel (%) 2. stik personer

------------------------------------------------------

Fil 18: FoersteVacc_FaerdigVacc_region_aldgrp_dag_vaccinealder

Dato: Dato
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på vaccinationsdatoen)
Regionsnavn: Region
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer

------------------------------------------------------

Fil 19: Vaccinationer_region_fnkt_alder_koen_rapportalder

Regionsnavn: Region.
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på kørselsdatoen)
Sex: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik administreret.
antal 2. stik: Antal 2. stik administreret. 

------------------------------------------------------

Fil 20: Vaccinationer_DK_fnkt_alder_koen_rapportalder

Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på kørselsdatoen)
Køn: K (kvinder), M (mænd) 
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel 1. stik: Andel (%) 1. stik personer
Andel 2. stik: Andel (%) 2. stik personer

------------------------------------------------------

Fil 21: FoersteVacc_FaerdigVacc_region_fnkt_alder_dag_rapportalder

Dato: Dato
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på kørselsdatoen)
Regionsnavn: Region
Antal 1. stik: Antal 1. stik personer
Antal 2. stik: Antal 2. stik personer