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
Påbegyndt vacc. i dag: Antal påbegyndte vaccinationer (personer) for det givne køn i dag.
Færdigvacc. i dag: Antal færdigvaccinerede for det givne køn i dag.
Revacc. 1 idag: Antal revaccinerede (første revaccination) for det givne køn i dag.
Påbegyndt vacc. igaar : Antal påbegyndte vaccinationer (personer) for det givne køn igår.
Færdigvacc. igaar: Antal færdigvaccinerede for det givne køn igår.
Revacc. 1 igaar: Antal revaccinerede (første revaccination) for det givne køn igår.
Paabegyndt vacc. difference: Påbegyndt vacc. i dag - Påbegyndt vacc. igaar.
Faerdigvaccineret difference: Færdigvacc. i dag - Færdigvacc. igaar.
Revacc. 1 difference: Revacc. 1 idag - Revacc. 1 igaar

------------------------------------------------------

Fil 1b: Noegletal_kommunale_daily

Dato: Dags dato.
Kommunenavn: Kommune.
Sex: K (kvinder), M (mænd)
Påbegyndt vacc. i dag: Antal påbegyndte vaccinationer (personer) for det givne køn i dag.
Færdigvacc. i dag: Antal færdigvaccinerede for det givne køn i dag.
Revacc. 1 idag: Antal revaccinerede (første revaccination) for det givne køn i dag.
Påbegyndt vacc. igaar : Antal påbegyndte vaccinationer (personer) for det givne køn igår.
Færdigvacc. igaar: Antal færdigvaccinerede for det givne køn igår.
Revacc. 1 igaar: Antal revaccinerede (første revaccination) for det givne køn igår.
Paabegyndt vacc. difference: Påbegyndt vacc. i dag - Påbegyndt vacc. igaar.
Faerdigvaccineret difference: Færdigvacc. i dag - Færdigvacc. igaar.
Revacc. 1 difference: Revacc. 1 idag - Revacc. 1 igaar

------------------------------------------------------

Fil 2a: FoersteVacc_region_dag

Regionsnavn: Region.
Første vacc. dato: Dato for første vaccination.
Antal første vacc.: Antal første vaccinationer administreret.

------------------------------------------------------

Fil 2b: FoersteVacc_kommune_dag

Kommunenavn: Kommune
Første vacc. dato: Dato for første vaccination.
Antal første vacc.: Antal første vaccinationer administreret.

------------------------------------------------------

Fil 3a: FaerdigVacc_region_dag

Regionsnavn: Region.
Faerdigvacc. dato: Dato for færdigvaccination.
Antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 3b: FaerdigVacc_kommune_dag

Kommunenavn: Kommune
Faerdigvacc. dato: Dato for færdigvaccination.
Antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 4a: Vaccinationer_regioner_befolk

Regionsnavn: Region.
Antal første vacc. personer: Antal første vaccinerede personer.
Antal faerdigvacc. personer: Antal færdigvaccinerede personer. 
Antal borgere: 

------------------------------------------------------

Fil 4b: Vaccinationer_kommuner_befolk

Kommunenavn: Kommune.
Antal første vacc. personer: Antal første vaccinerede personer.
Antal faerdigvacc. personer: Antal færdigvaccinerede personer. 
Antal borgere: 

------------------------------------------------------

Fil 5a: Vaccinationsdaekning_region

Regionsnavn: Region.
Antal første vacc.: Antal første vaccinerede personer.
Antal faerdigvacc.: Antal færdigvaccinerede personer. 
Antal 1. revacc.: Antal personer der har modtaget første revaccine.
Antal borgere: 
Vacc.dækning foerste vacc. (%): (antal første vacc. / antal borgere) x 100
Vacc.dækning faerdigvacc. (%): (antal faerdigvacc. / antal borgere) x 100
Vacc.dækning 1. revacc. (%): (antal 1. revacc. / antal borgere) x 100

------------------------------------------------------

Fil 5b: Vaccinationsdaekning_kommune

Kommunenavn: Kommune.
Antal første vacc.: Antal første vaccinerede personer.
Antal faerdigvacc.: Antal færdigvaccinerede personer.
Antal 1. revacc.: Antal personer der har modtaget første revaccine.
Antal borgere: 
Vacc.dækning foerste vacc. (%): (antal første vacc. / antal borgere) x 100
Vacc.dækning faerdigvacc. (%): (antal faerdigvacc. / antal borgere) x 100
Vacc.dækning 1. revacc. (%): (antal 1. revacc. / antal borgere) x 100

------------------------------------------------------

Fil 6a: Vaccinations_Daekning_region_pr_dag

Regionsnavn: Region.
Vaccinedato: Dato for administreret vaccine.
Kumulerede antal faerdigvacc.: Antal færdigvaccinerede kummuleret pr. dato. 
Antal borgere: 
Vacc.dækning (%): (Kumulerede antal faerdigvacc. / antal borgere) x 100

------------------------------------------------------

Fil 7a: Vaccinations_region_aldgrp_koen

Regionsnavn: Region.
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på kørselsdatoen)
Sex: K (kvinder), M (mænd) 
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 8a: Vaccinationstyper_regioner

Vaccinenavn: Navn på administrede vaccinetyper. 
Regionsnavn: Region.
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 9: FaerdigVacc_daekning_DK_prdag

Geo: Nationalt
Vaccinedato: Dato for administreret vaccine.
Kumuleret antal færdigvacc.: Antal færdigvaccinerede kummuleret pr. dato. 
Antal borgere: 
Færdigvacc. (%): (Kumulerede antal faerdigvacc. / antal borgere) x 100

------------------------------------------------------

Fil 10: Vaccinationer_DK_aldgrp_koen

Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på kørselsdatoen)
Køn: K (kvinder), M (mænd) 
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel første vacc.: Andel (%) førstegangsvaccinerede personer
Andel færdigvacc.: Andel (%) færdigvaccinerede personer

------------------------------------------------------

Fil 11: FoersteVacc_FaerdigVacc_region_aldgrp_dag

Dato: Dato
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på kørselsdatoen)
Regionsnavn: Region
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer

------------------------------------------------------

Fil 12: Vaccinationer_region_fnkt_alder_koen

Regionsnavn: Region.
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på vaccinationsdatoen)
Sex: K (kvinder), M (mænd) 
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 13: Vaccinationer_DK_fnkt_alder_koen

Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på vaccinationsdatoen)
Køn: K (kvinder), M (mænd) 
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel første vacc.: Andel (%) førstegangsvaccinerede personer
Andel færdigvacc.: Andel (%) færdigvaccinerede personer

------------------------------------------------------

Fil 14: FoersteVacc_FaerdigVacc_region_fnkt_alder_dag

Dato: Dato
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på vaccinationsdatoen)
Regionsnavn: Region
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer

------------------------------------------------------

Fil 15a: Revacc1_region_dag

Revacc. 1 dato: Dato for 1. revaccination.
Regionsnavn: Region.
Antal revacc. 1: Antal revaccinationer (1. stik) administreret. 

------------------------------------------------------

Fil 15b: Revacc1_kommune_dag

Revacc. 1 dato: Dato for 1. revaccination.
Kommunenavn: Kommune.
Antal revacc. 1: Antal revaccinationer (1. stik) administreret. 

------------------------------------------------------

Fil 16: Vaccinations_region_aldgrp_koen_vaccinealder

Regionsnavn: Region.
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på vaccinationsdatoen)
Sex: K (kvinder), M (mænd) 
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 17: Vaccinationer_DK_aldgrp_koen_vaccinealder

Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på vaccinationsdatoen)
Køn: K (kvinder), M (mænd) 
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel første vacc.: Andel (%) førstegangsvaccinerede personer
Andel færdigvacc.: Andel (%) færdigvaccinerede personer

------------------------------------------------------

Fil 18: FoersteVacc_FaerdigVacc_region_aldgrp_dag_vaccinealder

Dato: Dato
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+ (beregnet på vaccinationsdatoen)
Regionsnavn: Region
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer

------------------------------------------------------

Fil 19: Vaccinationer_region_fnkt_alder_koen_rapportalder

Regionsnavn: Region.
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på kørselsdatoen)
Sex: K (kvinder), M (mænd) 
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 20: Vaccinationer_DK_fnkt_alder_koen_rapportalder

Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på kørselsdatoen)
Køn: K (kvinder), M (mænd) 
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel første vacc.: Andel (%) førstegangsvaccinerede personer
Andel færdigvacc.: Andel (%) færdigvaccinerede personer

------------------------------------------------------

Fil 21: FoersteVacc_FaerdigVacc_region_fnkt_alder_dag_rapportalder

Dato: Dato
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+ (beregnet på kørselsdatoen)
Regionsnavn: Region
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer


				*******************************************************************************
				*********************************VACCINER SOGNE********************************
				*******************************************************************************


Dette dokument beskriver indholdet af filen Vaccination_sogne. Variabelnavnene, som beskrives nedenfor, refererer til søjlenavne.
Filen bliver opdateret hver onsdag, med data fra tirsdag. 

Datakilder og opgørelsesfrekvenser:
•	CPR-registeret: Opgjort tirsdag
•	Målgruppedata (TcDK): Opgjort mandag
•	Det Danske Vaccinationsregister: Opgjort tirsdag
•	Bookingdata: Opdateres mandag aften


Generel beskrivelse:
Population primær vaccination:I opgørelsen indgår personer, der er inviteret til vaccination mod COVID-19 for mindst 7 dage siden. Det vil sige, at personer, der er inviteret inden for de sidste 7 dage ikke indgår. 
Population revaccination:I opgørelsen indgår personer, der er inviteret til revaccination mod COVID-19 for mindst 7 dage siden. Det vil sige, at personer, der er inviteret inden for de sidste 7 dage ikke indgår.

I opgørelsen tages der udgangspunkt i de forskellige trin i vaccinations-/revaccinationsforløbet. 
Opgørelsen er lavet, så personer kun kan optræde på ét trin i henholdsvis det primære vaccinationsforløb og revaccinationsforløbet. Der indplaceres på det højeste trin i forløbet, hvor vaccination er et højere trin
end inviteret til og booket tid til vaccination. Derfor summer andelene på de fire trin for primære vaccinationsforløb og de tre trin i revaccinatinsforløbet hver især til 100 pct. 
Personer, der i forbindelse med tilvalgsordningen har fået en primær vaccination med vaccinen fra Johnson & Johnson vil indgå under færdigvaccinerede.

Antal inviterede er for begge forløb vist i antal personer, da det er personer på disse trin, som kommunerne retter en særlig indsats overfor. 

Vær opmærksom på, at opgørelsen over det primære vaccinationsforløb afviger fra opgørelserne på det interaktive dashboard og andre opgørelser for vaccinationstilslutning på SSIs hjemmeside, 
hvor personer kan indgå i både gruppen for påbegyndt vaccination og færdigvaccineret.


Diskretionering:
Opgørelsen vil blive diskretioneret, hvis befolkningen i sognet er færre end 20 personer. I de fleste tilfælde vil personerne fortsat indgå i opgørelsen af kommunen, 
men uden at være tilknyttet et sogn. Er der under 20 personer, der ikke kan tilknyttes et sogn vil data dog blive fjernet fra opgørelsen. 
Hvis der er mindre end 10 personer i gruppen af antal inviterede, der ikke har booket eller er vaccineret, vil det fremgå som <10 og andelene vil være diskretioneret.


------------------------------------------------------

Beskrivelse af variable:

Bo_kom_today:			Bopælskommune på opgørelsestidspunktet.
Sognekode:			Koden på sognet.
Sogn: 				Bopælssogn på opgørelsestidspunktet. Enkelte sogne fordeler sig geografisk over flere kommuner og vil derfor fremgå flere gange.
				Personer, der ikke har en adresse, kan ikke placeres i et sogn. De vil fremgå under kommunen, men uden et sogn (se også under diskretionering).

Variable relateret til det primærevaccinationsforløb:
Inviterede_i_sognet:            Det samlede antal personer, som opgørelsen tager udgangspunkt i.
Antal_inviteret_ikke_booket:    Antal personer, som er inviteret, men endnu ikke har booket tid, er påbegyndt eller har færdiggjort vaccination.
Andel_inviteret_ikke_booket:    Andel personer, som er inviteret, men endnu ikke har booket tid, er påbegyndt eller har færdiggjort vaccination.
Andel_booket:                   Andel personer, som har booket tid, men som ikke er påbegyndt eller har færdiggjort vaccination.
Andel_påbegyndt:                Andel personer, som er påbegyndt vaccination, men ikke har færdiggjort vaccination.
Andel_færdigvaccineret:         Andel personer, som har færdiggjort vaccination.

Variable relateret til revaccinationsforløb:
Invi_i_sognet_revac:		Det samlede antal personer, som er inviteret til revaccination i det givne sogn.
Antal_invi_ikke_booket_revac: 	Antal personer, som er inviteret til revaccination, men endnu ikke har booket tid eller er blevet revaccineret.
Andel_invi_ikke_booket_revac:	Andel personer, som er inviteret til revaccination, men endnu ikke har booket tid eller er blevet revaccineret.
Andel_booket_revac:		Andel personer, som har booket tid til revaccination, men som ikke er blevet revaccineret.
Andel_revaccineret:		Andel personer, som er blevet revaccineret. 
-----------------------------------------------------

------------------------------------------------------

Beskrivelse af variable:

Bo_kom_today:			Bopælskommune på opgørelsestidspunktet.
Sognekode:			Koden på sognet.
Sogn: 				Bopælssogn på opgørelsestidspunktet. Enkelte sogne fordeler sig geografisk over flere kommuner og vil derfor fremgå flere gange.
				Personer, der ikke har en adresse, kan ikke placeres i et sogn. De vil fremgå under kommunen, men uden et sogn (se også under diskretionering).
Inviterede_i_sognet:            Det samlede antal personer, som opgørelsen tager udgangspunkt i.
Antal_inviteret_ikke_booket:    Antal personer, som er inviteret, men endnu ikke har booket tid, er påbegyndt eller har færdiggjort vaccination.
Andel_inviteret_ikke_booket:    Andel personer, som er inviteret, men endnu ikke har booket tid, er påbegyndt eller har færdiggjort vaccination.
Andel_booket:                   Andel personer, som har booket tid, men som ikke er påbegyndt eller har færdiggjort vaccination.
Andel_påbegyndt:                Andel personer, som er påbegyndt vaccination, men ikke har færdiggjort vaccination.
Andel_færdigvaccineret:         Andel personer, som har færdiggjort vaccination.