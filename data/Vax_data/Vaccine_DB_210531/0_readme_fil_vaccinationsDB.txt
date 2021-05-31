Dette dokument beskriver indholdet af zip-filen. Variabelnavnene, som beskrives nedenfor, refererer til søjlenavne medmindre andet er beskrevet. 



Generel struktur:
Rækkerne i filerne er som udgangspunkt stratificeringer efter relevante parametre, eksempelvis aldersgruppering eller tidsopdeling. Filerne er comma-separerede.

Filerne bliver opdateret hver dag og i denne forbindelse kan tidsserier også ændre sig tilbage i tiden, hvis nyere data foreligger. Derfor anbefales det altid at benytte det senest tilgængelige data og for så vidt muligt, ikke at gemme filer og lave tidsserier på basis af gamle filer.

Filer angivet med a omhandler det regionale dashboard, mens filer angivet med b omhandler det kommunale dashboard. Nationale data har kun angivet et tal. 
------------------------------------------------------

Fil 1a: Noegletal_regionale_daily:

Dato: Dags dato.
Regionsnavn: Region.
Sex: K (kvinder), M (mænd)
Påbegyndt vacc. i dag: Antal påbegyndte vaccinationer (personer) for det givne køn i dag.
Færdigvacc. i dag: Antal færdigvaccinerede for det givne køn i dag.
Påbegyndt vacc. igaar : Antal påbegyndte vaccinationer (personer) for det givne køn igår.
Færdigvacc. igaar: Antal færdigvaccinerede for det givne køn igår.
Paabegyndt vacc. difference: Påbegyndt vacc. i dag - Påbegyndt vacc. igaar.
Faerdigvaccineret difference: Færdigvacc. i dag - Færdigvacc. igaar.

------------------------------------------------------

Fil 1b: Noegletal_kommunale_daily:

Dato: Dags dato.
Kommunenavn: Kommune.
Sex: K (kvinder), M (mænd)
Påbegyndt vacc. i dag: Antal påbegyndte vaccinationer (personer) for det givne køn i dag.
Færdigvacc. i dag: Antal færdigvaccinerede for det givne køn i dag.
Påbegyndt vacc. igaar : Antal påbegyndte vaccinationer (personer) for det givne køn igår.
Færdigvacc. igaar: Antal færdigvaccinerede for det givne køn igår.
Paabegyndt vacc. difference: Påbegyndt vacc. i dag - Påbegyndt vacc. igaar.
Faerdigvaccineret difference: Færdigvacc. i dag - Færdigvacc. igaar.

------------------------------------------------------

Fil 2a: FoersteVacc_region_dag:

Regionsnavn: Region.
Første vacc. dato: Dato for første vaccination.
Antal første vacc.: Antal første vaccinationer administreret.

------------------------------------------------------

Fil 2b: FoersteVacc_kommune_dag:

Kommunenavn: Kommune
Første vacc. dato: Dato for første vaccination.
Antal første vacc.: Antal første vaccinationer administreret.

------------------------------------------------------

Fil 3a: FaerdigVacc_region_dag:

Regionsnavn: Region.
Faerdigvacc. dato: Dato for færdigvaccination.
Antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 3b: FaerdigVacc_kommune_dag:

Kommunenavn: Kommune
Faerdigvacc. dato: Dato for færdigvaccination.
Antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 4a: Vaccinationer_regioner_befolk:

Regionsnavn: Region.
Antal første vacc. personer: Antal første vaccinerede personer.
Antal faerdigvacc. personer: Antal færdigvaccinerede personer. 
Antal borgere: 

------------------------------------------------------

Fil 4b: Vaccinationer_kommuner_befolk:

Kommunenavn: Kommune.
Antal første vacc. personer: Antal første vaccinerede personer.
Antal faerdigvacc. personer: Antal færdigvaccinerede personer. 
Antal borgere: 

------------------------------------------------------

Fil 5a: Vaccinationsdaekning_region:

Regionsnavn: Region.
Antal første vacc. personer: Antal første vaccinerede personer.
Antal faerdigvacc. personer: Antal færdigvaccinerede personer. 
Antal borgere: 
Vacc.dækning foerste vacc. (%): (antal første vacc. personer / antal borgere) x 100
Vacc.dækning faerdigvacc. (%): (antal faerdigvacc. personer / antal borgere) x 100

------------------------------------------------------

Fil 5b: Vaccinationsdaekning_kommune:

Kommunenavn: Kommune.
Antal første vacc. personer: Antal første vaccinerede personer.
Antal faerdigvacc. personer: Antal færdigvaccinerede personer. 
Antal borgere: 
Vacc.dækning foerste vacc. (%): (antal første vacc. personer / antal borgere) x 100
Vacc.dækning faerdigvacc. (%): (antal faerdigvacc. personer / antal borgere) x 100

------------------------------------------------------

Fil 6a: Vaccinations_Daekning_region_pr_dag:

Regionsnavn: Region.
Vaccinedato: Dato for administreret vaccine.
Kumulerede antal faerdigvacc.: Antal færdigvaccinerede kummuleret pr. dato. 
Antal borgere: 
Vacc.dækning (%): (Kumulerede antal faerdigvacc. / antal borgere) x 100

------------------------------------------------------

Fil 7a: Vaccinations_region_aldgrp_koen:

Regionsnavn: Region.
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+
Sex: K (kvinder), M (mænd) 
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 8a: Vaccinationstyper_regioner:

Vaccinenavn: Navn på administrede vaccinetyper. 
Regionsnavn: Region.
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 9: FaerdigVacc_daekning_DK_prdag:

Geo: Nationalt
Vaccinedato: Dato for administreret vaccine.
Kumuleret antal færdigvacc.: Antal færdigvaccinerede kummuleret pr. dato. 
Antal borgere: 
Færdigvacc. (%): (Kumulerede antal faerdigvacc. / antal borgere) x 100

------------------------------------------------------
				*******************************************************************************
				***********************************MÅLGRUPPER**********************************
				*******************************************************************************
Dette dokument beskriver indholdet af zip-filen. Variabelnavnene, som beskrives nedenfor, refererer til søjlenavne medmindre andet er beskrevet. 

Generel struktur:
Rækkerne i filerne er som udgangspunkt opdelt efter relevante parametre, eksempelvis aldersgruppering eller tidsopdeling. Filerne er komma-separerede.

Filerne bliver opdateret hver dag og i denne forbindelse kan tidsserier også ændre sig tilbage i tiden, hvis nyere data foreligger. Derfor anbefales det altid at benytte det senest tilgængelige data og for så vidt muligt, ikke at gemme filer og lave tidsserier på basis af gamle filer.
------------------------------------------------------

Fil 1: Noegletal_vacc_daekning.csv

Bopælsregion: Bopælsregion
Målgruppe: Vaccinationsmålgruppe ifht. Sundhedsstyrelsens vaccinationskalender
Ansættelsessted: Ansættelsessted, gældende for målgruppe 4
Antal førstevaccinerede: Antal påbegyndte vaccinationer for den givne målgruppe/undergruppe og region totalt
Antal færdigvaccinerede: Antal færdigvaccinerede for den givne målgruppe/undergruppe og region totalt
Population: Total befolkning, opdelt på målgruppe/undergruppe og region
Førstegangs vaccinerede dækning (%): Andel af befolkningen som er vaccineret mindst en gang, opdelt på målgruppe/undergruppe og region
Færdigvaccinerede dækning (%): Andel af befolkningen som er færdigvaccineret, opdelt på målgruppe/undergruppe og region


OBS: Gruppen andre_vaccinerede dækker over data som er blevet censureret fra andre grupper i henhold til GDPR.


------------------------------------------------------

Fil 2: Maalgrp_Vacc_daekning_Region.csv

Bopælsregion: Bopælsregion.
1.Plejehjemsbeboere, Dækning - Første vacc.:  Andel af målgruppe 1 som har påbegyndt vaccination, fordelt på region
2. Borgere > 65, praktisk hjælp og personlig pleje, Dækning - Første vacc.: Andel af målgruppe 2 som har påbegyndt vaccination, fordelt på region
3. Borgere fra årgang 1936 og derunder (85 år og ældre), Dækning - Første vacc.: Andel af målgruppe 3 som har påbegyndt vaccination, fordelt på region
4. Personale i sundhedsvæsenet og dele af socialvæsenet, Dækning - Første vacc.: Andel af målgruppe 4 som har påbegyndt vaccination, fordelt på region og arbejdssted
5. Udvalgte patienter med særligt øget risiko, Dækning - Første vacc.: Andel af målgruppe 5 som har påbegyndt vaccination, fordelt på region
6. Udvalgte pårørende til personer med særligt øget risiko, Dækning - Første vacc.: Andel af målgruppe 6 som har påbegyndt vaccination, fordelt på region
7. Personer fra årgang 1937-1941, Dækning - Første vacc.: Andel af målgruppe 7 som har påbegyndt vaccination, fordelt på region
8. Personer fra årgang 1942-1946, Dækning - Første vacc.: Andel af målgruppe 8 som har påbegyndt vaccination, fordelt på region
9. Personer fra årgang 1947-1956, Dækning - Første vacc.: Andel af målgruppe 9 som har påbegyndt vaccination, fordelt på region
10A. Personer fra årgang 1957-1961, Dækning - Første vacc.: Andel af målgruppe 10A som har påbegyndt vaccination, fordelt på region
10B. Personer fra årgang 1962-1966, Dækning - Første vacc.: Andel af målgruppe 10B som har påbegyndt vaccination, fordelt på region
99999.Resterende, Dækning - første vacc.: andel af resterende som har påbegyndt vaccination, fordelt på region
1.Plejehjemsbeboere, Dækning - Færdigvacc vacc.:  Andel af målgruppe 1 som er færdigvaccinerede, fordelt på region
2. Borgere > 65, praktisk hjælp og personlig pleje, Dækning - Færdigvacc.: Andel af målgruppe 2 som er færdigvaccinerede, fordelt på region
3. Borgere fra årgang 1936 og derunder (85 år og ældre), Dækning - Færdigvacc.: Andel af målgruppe 3 som er færdigvaccinerede, fordelt på region
4. Personale i sundhedsvæsenet og dele af socialvæsenet, Dækning - Færdigvacc.: Andel af målgruppe 4 som er færdigvaccinerede, fordelt på region og arbejdssted
5. Udvalgte patienter med særligt øget risiko, Dækning - Færdigvacc.: Andel af målgruppe 5 som er færdigvaccinerede, fordelt på region
6. Udvalgte pårørende til personer med særligt øget risiko, Dækning - Færdigvacc.: Andel af målgruppe 6 som er færdigvaccinerede, fordelt på region
7. Personer fra årgang 1937-1941, Dækning - Færdigvacc.: Andel af målgruppe 7 som er færdigvaccinerede, fordelt på region
8. Personer fra årgang 1942-1946, Dækning - Færdigvacc.: Andel af målgruppe 8 som er færdigvaccinerede, fordelt på region
9. Personer fra årgang 1947-1956, Dækning - Færdigvacc.: Andel af målgruppe 9 som er færdigvaccinerede, fordelt på region
10A. Personer fra årgang 1957-1961, Dækning - Færdigvacc.: Andel af målgruppe 10A som er færdigvaccinerede, fordelt på region
10B. Personer fra årgang 1962-1966, Dækning - Færdigvacc.: Andel af målgruppe 10B som er færdigvaccinerede, fordelt på region
99999.Resterende, Dækning - første vacc.: andel af resterende som er færdigvaccineret, fordelt på region



------------------------------------------------------

Fil 3: Vaccinerede_pr_uge_pr_maalgruppe.csv

Ugenummer: Ugenummer
Målgruppe: Målgruppe i vaccinationskalenderen
Dækning førstegangsvaccinerede (kumulativt i %): Andelen som har modtaget første vaccination, opgjort kumulativt på ugebasis, fordelt på region og målgruppe
Dækning færdigvaccinerede (kumulativt i %): Andelen som har modtaget første vaccination, opgjort kumulativt på ugebasis, fordelt på region og målgruppe

Fil 4: Autorisation.csv
Bopælsregion: Bopælsregion
Antal førstevaccinerede: Antal påbegyndt vaccinerede, fordelt på autorisation og region
Antal færdigvaccinerede: Antal færdigvaccinerede, fordelt på autorisation og region
Autorisation, gældende for personer i målgruppe 4: Autorisation, gældende for personer i målgruppe 4
Population: Antal borger i gruppen

------------------------------------------------------
