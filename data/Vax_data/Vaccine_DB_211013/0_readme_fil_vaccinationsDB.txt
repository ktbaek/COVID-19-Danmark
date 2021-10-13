Dette dokument beskriver indholdet af zip-filen. Variabelnavnene, som beskrives nedenfor, refererer til søjlenavne medmindre andet er beskrevet. 



Generel struktur:
Rækkerne i filerne er som udgangspunkt stratificeringer efter relevante parametre, eksempelvis aldersgruppering eller tidsopdeling. Filerne er comma-separerede.

Filerne bliver opdateret hver dag og i denne forbindelse kan tidsserier også ændre sig tilbage i tiden, hvis nyere data foreligger. Derfor anbefales det altid at benytte det senest tilgængelige data og for så vidt muligt, ikke at gemme filer og lave tidsserier på basis af gamle filer.

Filer angivet med a omhandler det regionale dashboard, mens filer angivet med b omhandler det kommunale dashboard. Nationale data har kun angivet et tal. 
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
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+
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

Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+
Køn: K (kvinder), M (mænd) 
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel første vacc.: Andel (%) førstegangsvaccinerede personer
Andel færdigvacc.: Andel (%) færdigvaccinerede personer

------------------------------------------------------

Fil 11: FoersteVacc_FaerdigVacc_region_aldgrp_dag

Dato: Dato
Aldersgruppe: 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80-89, 90+
Regionsnavn: Region
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer

------------------------------------------------------

Fil 12: Vaccinationer_region_fnkt_alder_koen

Regionsnavn: Region.
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+
Sex: K (kvinder), M (mænd) 
Antal første vacc.: Antal første vaccinationer administreret.
antal faerdigvacc.: Antal færdigvaccinationer administreret. 

------------------------------------------------------

Fil 13: Vaccinationer_DK_fnkt_alder_koen

Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+
Køn: K (kvinder), M (mænd) 
Antal første vacc.: Antal førstegangsvaccinerede personer
Antal færdigvacc.: Antal færdigvaccinerede personer
Antal borgere: Antal personer der er i alders-/køns-gruppen
Andel første vacc.: Andel (%) førstegangsvaccinerede personer
Andel færdigvacc.: Andel (%) færdigvaccinerede personer

------------------------------------------------------

Fil 14: FoersteVacc_FaerdigVacc_region_fnkt_alder_dag

Dato: Dato
Aldersgruppe: 0-2, 3-5, 6-11, 12-15, 16-19, 20-39, 40-64, 65-79, 80+
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
10C. Personer fra årgang 1967-1971, Dækning - Første vacc.: Andel af målgruppe 10C som har påbegyndt vaccination, fordelt på region
10D1. Personer fra årgang 1972-1976 og årgang 2002-2005 Dækning - Første vacc.: Andel af målgruppe 10D1 som har påbegyndt vaccination, fordelt på region
10D2. Personer fra årgang 1977-1981 og årgang 1997-2001 Dækning - Første vacc.: Andel af målgruppe 10D2 som har påbegyndt vaccination, fordelt på region
10D3. Personer fra årgang 1982-1986 og årgang 1992-1996 Dækning - Første vacc.: Andel af målgruppe 10D3 som har påbegyndt vaccination, fordelt på region
10D4. Personer fra årgang 1987-1991 Dækning - Første vacc.: Andel af målgruppe 10D4 som har påbegyndt vaccination, fordelt på region
11. Personer fra årgang 2006-2009, Dækning - Første vacc.: Andel af målgruppe 11 som har påbegyndt vaccination, fordelt på region
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
10C. Personer fra årgang 1967-1971, Dækning - Færdigvacc.: Andel af målgruppe 10C som er færdigvaccinerede, fordelt på region
10D1. Personer fra årgang 1972-1976 og årgang 2002-2005 Dækning -  Færdigvacc.: Andel af målgruppe 10D1 som er færdigvaccinerede, fordelt på region
10D2. Personer fra årgang 1977-1981 og årgang 1997-2001 Dækning - Færdigvacc.: Andel af målgruppe 10D2 som er færdigvaccinerede, fordelt på region
10D3. Personer fra årgang 1982-1986 og årgang 1992-1996 Dækning - Færdigvacc.: Andel af målgruppe 10D3 som er færdigvaccinerede, fordelt på region
10D4. Personer fra årgang 1987-1991 Dækning - Færdigvacc.: Andel af målgruppe 10D4 som er færdigvaccinerede, fordelt på region
11. Personer fra årgang 2006-2009, Dækning - Færdigvacc.: Andel af målgruppe 11 som er færdigvaccinerede, fordelt på region
99999.Resterende, Dækning - første vacc.: andel af resterende som er færdigvaccinerede, fordelt på region

------------------------------------------------------

Fil 3: Vaccinerede_pr_uge_pr_maalgruppe.csv

Ugenummer: Ugenummer
Målgruppe: Målgruppe i vaccinationskalenderen
Dækning førstegangsvaccinerede (kumulativt i %): Andelen som har modtaget første vaccination, opgjort kumulativt på ugebasis, fordelt på region og målgruppe
Dækning færdigvaccinerede (kumulativt i %): Andelen som har modtaget første vaccination, opgjort kumulativt på ugebasis, fordelt på region og målgruppe

------------------------------------------------------

Fil 4: Autorisation.csv
Bopælsregion: Bopælsregion
Antal førstevaccinerede: Antal påbegyndt vaccinerede, fordelt på autorisation og region
Antal færdigvaccinerede: Antal færdigvaccinerede, fordelt på autorisation og region
Autorisation, gældende for personer i målgruppe 4: Autorisation, gældende for personer i målgruppe 4
Population: Antal borger i gruppen

------------------------------------------------------

Fil 5: Vaccinatoner_underindelte_maalgrupper.csv
Målgruppe (underinddelt): Målgrupper underinddelt i yngre og ældre aldersgrupper. Målgrupperne 10D1, 10D2, 10D3 og 10D4 er i denne fil inddelt i undergrupperne a og b. De øvrige målgrupper er ikke underinddelt. Underinddeling a inkluderer den yngste aldersgruppe indenfor den pågældende vaccinationsgruppe, mens underinddeling b inkluderer den ældste aldersgruppe. For eksempel inkluderer målgruppe 10D1 som helhed personer fra årgang 1972-1976 og årgang 2002-2005 – i denne opgørelse inkluderer 10D1a årgang 2002-2005, og 10D1b årgang 1972-1976.
Region: Bopælsregion
Regionskode: Regionskode for bopælsregion
Antal borgere: Antal personer i den pågældende målgruppe med adresse i den pågældende region
Antal første vacc.: Antal personer der har påbegyndt et vaccinationsforløb
Antal faerdigvacc.: Antal personer der har færdiggjort et vaccinationsforløb




				*******************************************************************************
				*********************************VACCINEDOSER**********************************
				*******************************************************************************

Fil: Leverencedata:
Dato: Dato
Uge_nr: Ugenummer
Region: Region som har modtaget doserne
Vaccine: Vaccinetype
Antal_Doser: Antal doser af den givne vaccinetype modtaget


Filen indeholder leverede doser pr. region, men ikke en udregnet udnyttelsesprocent.
Udnyttelsesprocenten kan udregnes således: ((antal påbegyndt vaccinerede + (total antal færdigvaccinerede – antal færdigvaccinerede med Janssen)/leverede doser)*100.
Antal færdigvaccinerede med Janssen trækkes fra det totale antal færdigvaccinerede, da denne vaccinetype kun kræver én dosis og dermed indgår i både påbegyndt og færdigvaccinerede.


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
I opgørelsen indgår personer, der er inviteret til vaccination mod COVID-19 for mindst 7 dage siden. Det vil sige, at personer, der er inviteret inden for de sidste 7 dage ikke indgår. 

I opgørelsen tages der udgangspunkt i de forskellige trin i vaccinationsforløbet. 
Opgørelsen er lavet, så personer kun kan optræde på ét af disse trin, og de placeres på det højest muligt opnåede trin i vaccinationsforløbet, hvor påbegyndt vaccination er et højere trin
end inviteret til og booket tid til vaccination. Derfor summer andelene på de fire trin til 100 pct. 
Personer, der i forbindelse med tilvalgsordningen bliver vaccineret med vaccinen fra Johnson & Johnson vil indgå under færdigvaccinerede.

Antal inviterede er vist i antal personer, da det er personer på dette trin, som kommunerne pt. retter en særlig indsats overfor. 

Vær opmærksom på, at det afviger fra opgørelserne på det interaktive dashboard og andre opgørelser for vaccinationstilslutning på SSIs hjemmeside, 
hvor personer kan indgå i både gruppen for påbegyndt vaccination og færdigvaccineret.

Diskretionering:
Opgørelsen vil blive diskretioneret, hvis befolkningen i sognet er færre end 20 personer. I de fleste tilfælde vil personerne fortsat indgår i opgørelsen af kommunen, 
men uden at være tilknyttet et sogn. Er der under 20 personer, der ikke kan tilknyttes et sogn vil data dog blive fjernet fra opgørelsen. 
Hvis der er mindre end 10 personer i gruppen af antal inviterede, der ikke har booket eller er vaccineret, vil det fremgå som <10 og andelene vil være diskretioneret.

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

-----------------------------------------------------

