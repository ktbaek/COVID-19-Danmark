*******************************************************************************
**************************	  READ ME	  *****************************
*******************************************************************************

Her finder du en beskrivelse af indeholdet af det kommunale dashboard.
Du vil her finde en beskrivelse af tabellerne med deres tilhørende
variable navne (søjlenavne).



Forkortelser:
_______________________________________________________________________________
TCD = Test Center Danmark (hvide telte)
KMA = Klinisk microbiologisk afdeling (hospitaler)



Generel struktur:
_______________________________________________________________________________
Rækkerne i filerne er som udgangspunkt stratificeringer efter relevante 
parametre, eksempelvis aldersgruppering eller tidsopdeling. 
Der stratificeres generelt efter variablen i første søjle. 
Enkelte tabeller kan have rækker, som afviger fra dette mønster. 
I disse tabeller specificeres dette i "Noter" under tabellens 
variabelbeskrivelse. Filerne er komma-separerede.


Opdateringer:
_______________________________________________________________________________
Filerne bliver opdateret hver dag og i denne forbindelse kan tidsserier også 
ændre sig tilbage i tiden, hvis nyere data foreligger. Derfor anbefales det 
altid at benytte det senest tilgængelige data og for så vidt muligt, 
ikke at gemme filer og lave tidsserier på basis af gamle filer.


Typer af tests:
_______________________________________________________________________________
Filerne basseres primært på PCR-opgørelser, medmindre andet er angivet. 
PCR-tests og antigentests, bruges til hhv. at påvise eller mistænke covid-19-smitte under et aktivt 
sygdomsforløb. 
Data indeholder ikke serologitest, som er den test, der udføres, 
når man skal undersøge, om raske mennesker tidligere har haft covid-19.


01_Noegletal
-------------------------------------------------------------------------------
Dette er den daglige opgørelse af antallet af bekræftede tilfælde, døde,
overståede infektioner, indlæggelser, PCR-testede personer, PCR-prøver og antigenprøver,
samt ændringen siden i går, opgjort pr. region og pr. køn. 
De kummulerede opgørelser udgøre det samlede antal observerede siden pandemi
start i Danmark, hvor antallet siden i går udgøre de daglige opgørelser.
Bemærk venligst her at denne opgørelsesmetode benytter sig af svardatoer
og ikke prøvedatoer, hvorfor disse to opgørelses metoder vil afvige 
fra hindanden. Der benyttes to forskellige opgørelsesmetoder, da prøvedatoen
anses for mest retvisende. Svardatoen benyttes derimod til at give den best
mulige formodning på en given dag.



IndberetningDato			: Dato for opgørelsen
Totalt antal tests			: Kummulerede antal PCR-prøver
Antal testede personer			: Kummulerede antal PCR-testede personer
Antal bekræftede 
	tilfælde			: Kummulerede antal af bekræftede tilælde
Antal overstået 
	infektion			: Kummulerede antal af overståede infektioner	
Antal døde				: Kummulerede antal af døde
Antal nye bekræftede 
	tilfælde			: Antallet af bekræftede tilfælde siden i går	
Antal nye døde				: Antallet af døde siden i går
Antal nye overstået 
	infektion			: Antallet af overståede infektioner siden i går
Antal indlagte i dag 
	med covid-19			: Antallet af indlagte
Antal indlagt i dag og 	
	i respirator			: Antallet af indlagte i respirator
Antal indlagt i dag på 	
	intensiv			: Antallet af indlagte på intensiv i respirator
Antal nye indlæggelser			: Antallet af nye indlæggelser siden i går
Ændring i antal 
	indlæggelser			: Ændringen i antallet af indlagte siden i går	
Ændring i antal i 
	respirator			: Ændringen i antallet af indlagte på intensiv
						  i respirator siden i går
Ændring i antal på 
	intensiv			: Ændringen i antallet af indlagte på intensiv
						  siden i går
Førstegangstestede			: Antallet af PCR-testede personer siden i går
Antal prøver siden sidst		: Antallet af PCR-prøver siden i går	





02_indlaeggelser_pr_dag_kummulativt
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af indlagte pr. dag kummulativt.

Dato					: Dato for indlæggelse
Indlæggelser kumuleret			: Antallet af indlagte




03_indlæggelser_pr_aldersgrp
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af indlagte pr. aldersgruppe

Aldersgruppe			: Den 10 års aldersgruppe en person tilhørte ved
						  prøvetagning
Indlæggelser			: Antallet af indlagte


04_bekraeftede_tilfaelde_doed_pr_aldersgrp
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde og døde pr.
aldersgruppe.

Aldersgruppe			: Den 10 års aldersgruppe en person tilhørte ved
						  prøvetagning
Bekræftede tilfælde		: Antallet af bekræftede tilælde
Døde				: Antallet af døde



05_nye_indlaeggelser_pr_dag
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af nye indlæggelser pr. dag

Indlæggelsesdato		: Datoen for indlæggelse
Indlæggelser			: Antallet af nye indlæggelser


06_doed_pr_dag_kumuleret
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af døde pr. dag kummuleret

Dato					: Dato for dødsfald registreret i det 
						  dansk dødsårsags register
Kummuleret antal døde			: Kummulerede antal døde siden pandemi start.


07_bekraeftede_tilfaelde_pr_dag_pr_kommune
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde pr. dag pr.
kommune.

Kommune					: Bopæls kommunekode (kommune man boede i ved prøvetagning)
Dato					: Dato for dødsfald registreret i det 
Bekræftede tilfælde			: Antallet af bekræftede tilælde


08_Proever_pr_uge_pr_region
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af PCR-prøver pr. uge pr. region. Disse opgørelser 
inkludere kun opgørelser fradet offentlige.

uge					: Uger
Region Hovedstaden			: Antallet af PCR-prøver
Region Midtjylland			: Antallet af PCR-prøver	
Region Nordjylland			: Antallet af PCR-prøver	
Region Sjælland	  			: Antallet af PCR-prøver
Region Syddanmark			: Antallet af PCR-prøver
Statens Serum Institut			: Antallet af PCR-prøver
Test center Danmark			: Antallet af PCR-prøver
Sundhedsspor				: Antallet af PCR-prøver	
Samfundsspor				: Antallet af PCR-prøver
Total					: Det samlede antal PCR-prøver


09_tilfaelde_aldersgrp_kommuner
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde pr. aldersgruppe 
pr. kommune.

Kommune					: Bopæls kommunekode (kommune man boede i ved prøvetagning)	
Aldersgruppe				: Den 10 års aldersgruppe en person tilhørte ved
						  prøvetagning
Bekræftede tilfælde			: Antallet af bekræftede tilælde
Dagsdato				: Prøvetagnings dato


10_kort_pr_kommune
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde, bekræftede tilfælde
de seneste 7 dage, PCR-testede de seneste 7 dage, samt positivprocenten de seneste
7 dag.

Kommune					: Bopæls kommunekode (kommune man boede i ved prøvetagning)
Bekræftede tilfælde
	de seneste 7 dage		: Antallet af bekræftede tilfælde de seneste 7 dage
Testede de seneste 		
	7 dage				: Antallet af PCR-testede personer de seneste 7 dage 	
Positivprocent 			  
	de seneste 7 dage		: (antal covid-19 bekræftede personer/
						  antallet af PCR-testede personer) *100 for de seneste 7 dage



