Dette dokument beskriver indholdet af zip-filen, som indeholder data om det danske covid-19-vaccinationsprogram. Dette data stemmer overens med hvad der vises på SSIs vaccinations-dashboards.
Zippen udgives kl. 14 i hverdagene. Filer med daglige tidsserier kan ændre sig tilbage i tiden, hvis nyere data foreligger. Derfor anbefales det altid at benytte det senest tilgængelige data og for så vidt muligt, ikke at gemme filer og lave tidsserier på basis af gamle filer.

Filerne indeholder vaccinationsdata for forskellige undergrupper af borgere. Borgere underopdeles efter forskellige kombinationer af følgende:
 - Region
 - Kommune
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
Data opgøres enten for hele vaccinationsprogrammet, eller pr. dag eller uge.

Filer indeholder som udgangspunkt følgende data:
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)
Antal stik angiver antal borgere i den givne undergruppe, der har modtaget et vaccinestik.
Dækning udregnes som antal stik divideret med antal borgere.

Filer opgjort pr. dag eller uge indeholder følgende data:
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)
Her angiver antal stik antallet af borgere i den givne undergruppe, der har modtaget et vaccinestik den dag eller uge. 
Samlet antal stik angiver det kumulerede antal af borgere i den givne undergruppe, der har modtaget et vaccinestik op til og med den dag eller uge.
Samlet dækning udregnes som samlet antal stik divideret med antal borgere.

Små afvigelser fra systemet beskrevet ovenfor forekommer i filerne med nøgletal og vaccinetyper.

------------------------------------------------------

* NOTE OM ALDERSGRUPPER
Aldersgrupper opgøres på fire forskellige måder, som angives i sidste del af filnavnet. Som udgangspunkt bør alder på vaccinedato benyttes:
 - 10-årsintervaller ud fra alder på vaccinedato (_vaccage)
 - Funktionelle aldersgrupper ud fra alder på vaccinedato (_vaccinstage)
 - 10-årsintervaller ud fra alder på indberetningsdato (_repage)
 - Funktionelle aldersgrupper ud fra alder på indberetningsdato (_repinstage)
Funktionelle aldersgrupper er 0-2, 3-4, 5-11, 12-15, 16-19, 20-39, 40-64, 65-79 og 80+.

------------------------------------------------------

Nedenfor følger en oversigt over kolonner i de enkelte filer, med uddybende kommentarer angivet i parantes.

Vaccine_noegletal_kommune:
 - Dato
 - Kommune
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal 1. stik siden i går (ændringer i det samlede antal vaccinerede siden sidste opdatering)
 - Antal 2. stik siden i går
 - Antal 3. stik siden i går 
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_noegletal_region:
 - Dato
 - Region
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal 1. stik siden i går (ændringer i det samlede antal vaccinerede siden sidste opdatering)
 - Antal 2. stik siden i går
 - Antal 3. stik siden i går 
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_alder_koen_repage:
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_alder_koen_repinstage:
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_alder_koen_vaccage:
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_alder_koen_vaccinstage:
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_dato:
 - Dato
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_dato_kommune:
 - Dato
 - Kommune
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_dato_region:
 - Dato
 - Region
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_dato_region_alder_repage:
 - Dato
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_dato_region_alder_repinstage:
 - Dato
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_dato_region_alder_vaccage:
 - Dato
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_dato_region_alder_vaccinstage:
 - Dato
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_kommune:
 - Kommune
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_region:
 - Region
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_region_alder_koen_repage:
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_region_alder_koen_repinstage:
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_region_alder_koen_vaccage:
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_region_alder_koen_vaccinstage:
 - Region
 - Aldersgruppe (se note om aldersgrupper*)
 - Køn (M = mænd, K = kvinder)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Dækning 1. stik (%)
 - Dækning 2. stik (%)
 - Dækning 3. stik (%)

Vaccine_type_region:
 - Vaccinenavn (angiver den specifikke type covid-19-vaccine modtaget ved vaccination)
 - Region
 - Antal 1.stik
 - Antal 2.stik
 - Antal 3.stik

Vaccine_uge_alder_repage:
 - Uge
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_uge_alder_repinstage:
 - Uge
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_uge_alder_vaccage:
 - Uge
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)

Vaccine_uge_alder_vaccinstage:
 - Uge
 - Aldersgruppe (se note om aldersgrupper*)
 - Antal 1. stik
 - Antal 2. stik
 - Antal 3. stik
 - Antal borgere
 - Samlet antal 1. stik
 - Samlet antal 2. stik
 - Samlet antal 3. stik
 - Samlet dækning 1. stik (%)
 - Samlet dækning 2. stik (%)
 - Samlet dækning 3. stik (%)
