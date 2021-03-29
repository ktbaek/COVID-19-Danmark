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

