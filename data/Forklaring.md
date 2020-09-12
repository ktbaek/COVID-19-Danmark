# Forklaring af datafiler, beregninger og begreber 

Data er hentet på [SSI's COVID-19 overvågningsside](https://www.ssi.dk/sygdomme-beredskab-og-forskning/sygdomsovervaagning/c/covid19-overvaagning) hvor de data der kan downloades opdateres mandag-fredag.

SSI's dokument som beskriver variablerne i datafilerne kan læses [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/data/SSIdata_200911/read_me.txt), og nedenstående forklaringer er baseret herpå.

## Antal testede og antal nye positive for hele landet

### Datafil
'Test_pos_over_time.csv'.

### Prøvedato 
Dette er datoen testen blev taget og ikke datoen, hvor prøvesvaret forelå.

### Typer af tests
Filerne bygger udelukkende på PCR-test, som er den test, der bruges til at påvise COVID-19-smitte under et aktivt sygdomsforløb. Data indeholder ikke serologitest, som er den test, der udføres, når man skal undersøge, om raske mennesker tidligere har haft COVID-19.

### Antal testede og antal nye positive

En person kan kun bidrage én gang per dag, men kan godt bidrage flere gange over hele perioden. 

**Testede** angiver det samlede antal testede personer på en given dag. 

Testede personer kan deles op i to grupper: 
1. **Ikke tidligere positive**: Personer testet på en given dag, som ikke har testet positive på en tidligere dato. Indeholder negative tests for folk, som ikke har testet positive før, samt første positive test.
2. **Tidligere positive**: Personer testet på en given dag, som tidligere har testet positive. Den første test som er positiv indgår ikke her. Tidligere positive har siden juli ligget på 0.3% - 0.7% af alle testede personer på en given dag.  

Antallet af testede kan udregnes som **ikke tidligere positive** plus **tidligere positive**.

**Nye positivt testede** angiver personer, som for første gang er testet positive for COVID-19, på en given dag.

**Procent positive** angiver andelen af personer som er testet positive. Dette er beregnet som **nye positivt testede** divideret med **ikke tidligere positive**. Bemærk at prøver taget på folk, som tidligere har testet positive ikke er medregnet her.

Begreberne opsummeres på nedenstående figur.

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/Tested_explanation.png) 

## Antal testede og antal nye positive for hver kommune
### Datafiler
'Municipality_cases_time_series.csv' og 
'Municipality_tested_persons_time_series.csv'

### Prøvedato 
Dette er datoen testen blev taget og ikke datoen, hvor prøvesvaret forelå.

### Typer af tests
Filerne bygger udelukkende på PCR-test, som er den test, der bruges til at påvise COVID-19-smitte under et aktivt sygdomsforløb. Data indeholder ikke serologitest, som er den test, der udføres, når man skal undersøge, om raske mennesker tidligere har haft COVID-19.

### Antal testede og antal nye positive

En person kan kun bidrage én gang per dag, men kan godt bidrage flere gange over hele perioden.

**Testede** angiver det samlede antal testede personer på en given dag i en given kommune, som ikke har testet positive på en tidligere dato. 

**Nye positivt testede** angiver personer, som for første gang er testet positive for COVID-19, på en given dag.

**Procent positive** angiver andelen af personer som er testet positive. Dette er beregnet som **nye positivt testede** divideret med **testede**. 

Bemærk altså at prøver taget på folk, som tidligere har testet positive ikke er medregnet i det kommuneopdelte datasæt.

## Nyindlagte
### Datafil
'Newly_admitted_over_time.csv'

### COVID-19-relateret indlæggelse
En indlæggelse, hvor patienten blev indlagt inden for 14 dage efter prøvetagningsdato for den første positive SARS-CoV-2-prøve. Data baseres på de daglige øjebliksbilleder fra regionernes IT-systemer, som sendes hver dag kl. 7 og 15 og Landspatientregistret (LPR). Indlæggelser omfatter patienter, der har været registreret i mindst ét øjebliksbillede, eller som ifølge LPR er eller har været indlagt mere end 12 timer. Indlæggelser registeret i LPR på intensivafdeling inkluderes også når de varer mindre end 12 timer.

### COVID-19-relaterede indlæggelsesdatoer
Indlægges en person mere end 48 timer før deres første positive test for COVID-19 er taget, så tæller deres prøvetagningsdato som COVID-19-indlæggelsesdatoen. I alle andre tilfælde er det indlæggelsesdatoen, som er angivet.

## Døde

### Datafil
'Deaths_over_time.csv'

### Dødsdato
Dagen hvor en person er registreret død.

### Antal døde
Antal døde registreret på en given dag. En person indgår, hvis de er registreret i enten CPR eller Dødsårsagsregisteret. Er en person registreret både i CPR og Dødsårsagsregisteret med forskellige dødsdatoer, bruges datoen angivet i CPR.














