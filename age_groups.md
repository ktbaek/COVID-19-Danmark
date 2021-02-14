---
image: /figures/SSI_read_graph_pct_together.png

title: Analyse af smittetal i forskellige aldersgrupper
description: Analyse af SARS-CoV-2 smittetal i forskellige aldersgrupper
---

# Analyse af SARS-CoV-2 smittetal i forskellige aldersgrupper
Kristoffer T. Bæk, februar 2021

<div class="likely">
    <div class="facebook">Del</div>
    <div class="twitter">Tweet</div>
    <div class="linkedin">Del</div>
</div>
<br>




## Baggrund

Antallet af SARS-CoV-2 positivt testede har i løbet af efteråret og særligt op til jul været højest blandt de 10-29 årige (Figur 1). Men hvis man vil have en idé om hvor udbredt smitten er i  forskellige aldersgrupper, bør man se de tal i lyset af hvor mange, og hvem, man tester. Jo flere man tester, jo flere smittede finder man, alt andet lige.  SSI beskriver dette forhold i bl.a. [denne rapport](https://www.ssi.dk/-/media/ssi-files/ekspertrapport-af-den-23-oktober-2020-incidens-og-fremskrivning-af-covid19-tilflde.pdf?la=da).

*Figur 1: Positivt testede per aldersgruppe*

![](/figures/age_groups_pos.png)

SSI har indtil d. 9. feb, 2021 ikke offentliggjort data for hvor mange man tester i hver aldersgruppe, og det har derfor været umuligt at beregne positivprocenten og dermed få en idé om hvor udbredt smitten er i forskellige aldersgrupper.

Nu er de data så offenliggjort og kan ses i figur 10.1 i SSI's [ugentlige opgørelser](https://covid19.ssi.dk/overvagningsdata/ugentlige-opgorelser-med-overvaagningsdata), og jeg har brugt de data til at beregne positivprocenten for at vurdere smitteudbredelsen fra september til februar i de forskellige aldersgrupper.

## Metode

Desværre er data for antal testede kun tilgængelige i SSI's figur 10.1 og ikke i en datafil, og jeg har derfor aflæst værdierne fra grafen efter bedste evne (Figur 2). De aflæste værdier kan downloades [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/data/SSI_age_data_10_1.csv).

*Figur 2: SSI's figurer med tilføjet grid til aflæsning*

![](/figures/SSI_fig_10_1.png)

For at sikre mig at jeg har aflæst værdierne nogenlunde korrekt, sammenligner jeg med de kendte tal for positive og testede for alle aldersgrupper. Da de aflæste værdier angiver positive og testede per 100.000, udregner jeg først de absolutte værdier vha. befolkningsdata fra Danmarks Statistik, tager summen af alle aldersgrupperne, og sammenligner så dette tal med det kendte tal for positive og testede for hver uge (Figur 3).

*Figur 3: Test af om jeg har aflæst rigtigt*

![](/figures/SSI_read_graph_test.png)

Man kan se af venstre panel for antal positive per uge, at min aflæsning af graferne er ret præcis. Til gengæld er de aflæste tal for testede generelt ca. 10% lavere end de kendte data (jeg har sammenlignet med tallene for "ikke tidligere positivt testede", da dette tal normalt bruges til beregning af positivprocent). Jeg tror forskellen skyldes, at SSI's graf – helt korrekt – korrigerer for personer der testes flere gange per uge, hvorimod denne korrektion ikke er lavet (det er ikke muligt med de tilgængelige data, se forklaring [her](https://covid19danmark.dk/Forklaring.html#ugentligt-opgjorte-antal-testede-og-positive)) i min opgørelse over det ugentligt antal testede. Grafen til højre kan derfor give et indblik i hvor mange der testes flere gange om ugen.

Alt i alt anser jeg aflæsningen af graferne for at være korrekt.

## Resultater

De aflæste data for testede per 100.000 personer fremgår af Figur 4. Her kan man se en ret stor spredning i antallet af testede mellem de forskellige aldersgrupper, og en – måske overraskende – stor stigning i antallet af testede 40-64 årige siden nytår.

*Figur 4: Test-incidens for hver aldersgruppe*

![](/figures/SSI_read_graph_test_incidense_together.png)

De aflæste data for positive per 100.000 personer fremgår af Figur 5. Her kan man se, ligesom på Figur 1,  at 13-39 årige ligger klart i top gennem det meste af perioden. Derudover ses også et forhøjet niveau blandt 65+ årige fra midt december til kort efter nytår.

*Figur 5: Positiv-incidens for hver aldersgruppe*

![](/figures/SSI_read_graph_incidense_together.png)


Hvis man i stedet kigger på positivprocenten (antallet af positive i forhold til antal testede) ændres billedet dog, idet de fem aldersgrupper ikke længere er helt så forskellige (Figur 6). Man kan altså  forklare noget af forskellen i smittetallet mellem de forskellige aldersgrupper med, at der testes flere personer i nogle aldersgrupper end i andre.    

Desuden ses to toppe i december, én i første tredjedel af måneden for 13-64 årige og én omkring nytår for 0-7 og 65+ årige. Antal testede fluktuerede kraftigt omkring jul og nytår, og derfor skal man i disse uger tage positivprocenten med et vist forbehold, da positivprocenten er følsom overfor ændringer i *hvem* der testes (f.eks. asymptomatiske der vil testes før juleaften vs. risikogrupper/symptomatiske der bliver testet i juledagene). Det er muligt at stigningen i positivprocent mellem jul og nytår for 0-12 årige skyldes mere målrettet testning af f.eks syge og ikke øgning i smitten, idet stigningen i positivprocent skete samtidig med et kraftigt fald i antal testede.    

Men bortset fra juleperioden er positivprocenten dog tættere på at beskrive smitteudbredelsen end de absolutte positivtal fordi den tager hensyn til, at antallet af testede er meget forskelligt i de forskellige aldersgrupper.

*Figur 6: Positivprocenten for hver aldersgruppe*

![](/figures/SSI_read_graph_pct_together.png)

Selvom udbredelsen af smitte formentlig ikke varierer så meget mellem aldersgrupperne som de rene smittetal giver anledning til at tro, viser både positivprocent og [seroprævalensstudier](https://bloddonor.dk/coronavirus/) dog at smitteudbredelsen er størst blandt yngre og mindst blandt ældre.
