# Forklaring af datafiler, beregninger og begreber

*Denne side er ikke opdateret siden efteråret 2020, de fleste begreber har dog ikke ændret sig*

SSI's dokument som beskriver variablerne i datafilerne kan læses [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/data/SSIdata_200911/read_me.txt). Nedenstående tekst gengiver de relevante dele af dette dokument samt forklarer de foretagede beregninger.

## Generelt

### Prøvedato
Dette er datoen testen blev taget og ikke datoen, hvor prøvesvaret forelå.

### Typer af tests
Filerne bygger udelukkende på PCR-test, som er den test, der bruges til at påvise COVID-19-smitte under et aktivt sygdomsforløb. Data indeholder ikke serologitest, som er den test, der udføres, når man skal undersøge, om raske mennesker tidligere har haft COVID-19.

### Bemærkning til SSI's dashboard
I modsætning til de datasæt der benyttes her, angiver det aktuelle tal for antal bekræftede tilfælde på SSI's dashboard  antal positive prøvesvar i dag, hvor der ikke tages hensyn til datoen hvor prøven er taget.  

## Testede og positive for hele landet

### Datafil
``'Test_pos_over_time.csv'``


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

![](/figures/Tested_explanation.png)






## Testede og positive for hver kommune
### Datafiler
``'Municipality_cases_time_series.csv'`` og
``'Municipality_tested_persons_time_series.csv'``

### Antal testede og antal nye positive

**Testede** angiver antal testede personer på en given dag i en given kommune, som ikke har testet positive på en tidligere dato. En person kan kun bidrage én gang per dag, men kan godt bidrage flere gange over hele perioden.

**Nye positivt testede** angiver personer, som for første gang er testet positive for COVID-19, på en given dag i en given kommune.

**Procent positive** angiver andelen af personer som er testet positive  på en given dag i en given kommune. Dette er beregnet som **nye positivt testede** divideret med **testede**.

Bemærk altså at prøver taget på folk, som tidligere har testet positive ikke indgår i **testede** i det kommuneopdelte datasæt.

### Ugentligt opgjorte antal testede og positive
Det **ugentlige antal testede** har jeg beregnet som summen af det daglige antal testede fra mandag til og med søndag.

Det **ugentlige antal nye positive** har jeg beregnet som summen af det daglige antal nye positive fra mandag til og med søndag.

**Procent positive** angiver andelen af personer som er testet positive i en given uge i en given kommune. Dette er beregnet som det **ugentlige antal nye positivt testede** divideret med **det ugentlige antal testede**.

Den seneste uges data opgøres tidligst tirsdage kl 14.

Eftersom en person kan bidrage flere gange over hele perioden (men kun én gang per dag), vil en person der er testet to gange i samme uge tælle som to personer hvis første test er negativ. Dette tal udgør formentlig en meget lille det af det samlede antal testede på en uge.

## Testede og positive for hver aldersgruppe
### Datafiler
``'Cases_by_age.csv'``

### Antal testede og antal nye positive

SSI's datafil angiver det kumulerede antal testede personer og det kumulerede antal nye positivt testede personer i hver aldersgruppe. Det ugentlige antal testede og nye positive i hver aldersgruppe har jeg beregnet som differencen mellem de kumulerede værdier med én uges mellemrum. De ugentlige data er opgjort om onsdagen fra marts til og med 1. juli, derefter om torsdagen.  

**Nye testede** angiver antal testede personer i en given uge i en given aldersgruppe, *som ikke er testet i en tidligere uge*. En person kan kun bidrage én gang i hele perioden.

**Nye positivt testede** angiver personer, som for første gang er testet positive for COVID-19 i en given uge i en given aldersgruppe.

**Procent positive** angiver andelen af personer som for første gang er testet positive i en given uge i en given aldersgruppe. Dette har jeg beregnet som **nye positivt testede** i en given aldersgruppe divideret med **nye testede** i en given aldersgruppe.

Bemærk altså forskellen i den måde det samlede antal testede er beregnet i de aldersopdelte testdata i forhold til i de øvrige testdata. Det vil formentlig have den effekt, at de beregnede positivandele i slutningen af perioden, *alt andet lige*, vil være højere end i starten af perioden, eftersom personer som aldrig før er testet vil udgøre en stadig mindre andel af det samlede antal testede efterhånden som tiden skrider frem.

![](/figures/age_prev_tested_new_tested.png)

Note: SSI anbefaler ikke at gemme filer og lave tidsserier på basis af gamle filer, idet data nogle gange opdateres tilbage i tiden. En sammenligning mellem de beregnede ugentlige antal positive baseret på Cases_by_age datafilerne og den seneste Test_pos_over_time fil, viser dog at der er stor overenstemmelse mellem de beregnede ugentlige værdier.

![](/figures/age_dataset_comparison.png)



## Nyindlagte
### Datafil
``'Newly_admitted_over_time.csv'``

### COVID-19-relateret indlæggelse
En indlæggelse, hvor patienten blev indlagt inden for 14 dage efter prøvetagningsdato for den første positive SARS-CoV-2-prøve. Data baseres på de daglige øjebliksbilleder fra regionernes IT-systemer, som sendes hver dag kl. 7 og 15 og Landspatientregistret (LPR). Indlæggelser omfatter patienter, der har været registreret i mindst ét øjebliksbillede, eller som ifølge LPR er eller har været indlagt mere end 12 timer. Indlæggelser registeret i LPR på intensivafdeling inkluderes også når de varer mindre end 12 timer.

### COVID-19-relaterede indlæggelsesdatoer
Indlægges en person mere end 48 timer før deres første positive test for COVID-19 er taget, så tæller deres prøvetagningsdato som COVID-19-indlæggelsesdatoen. I alle andre tilfælde er det indlæggelsesdatoen, som er angivet.

### Ugentligt opgjorte antal nyindlagte
Det **ugentlige antal nyindlagte** har jeg beregnet som summen af det daglige antal nyindlagte fra torsdag til og med onsdag.



## Døde

### Datafil
``'Deaths_over_time.csv'``

### Dødsdato
Dagen hvor en person er registreret død.

### Antal døde
Antal døde registreret på en given dag. En person indgår, hvis de er registreret i enten CPR eller Dødsårsagsregisteret. Er en person registreret både i CPR og Dødsårsagsregisteret med forskellige dødsdatoer, bruges datoen angivet i CPR.

## Bagudrettet opdatering af data

### Tests

SSI foretager typisk omfattende opdatering af testdata 2 dage tilbage i tiden.

![](/figures/retrospective_data.png)


### Nyindlæggelser

SSI foretager typisk omfattende opdatering af data for nyindlæggelser 1 dag tilbage i tiden.

![](/figures/retrospective_admit.png)



### Døde

SSI foretager typisk omfattende opdatering af data for dødsfald 1-2 dage tilbage i tiden, nogle gange længere tilbage, men i mindre grad.

![](/figures/retrospective_deaths.png)
