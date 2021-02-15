---
image: /figures/SSI_read_graph_pct_together.png

title: Analyse af smittetal i forskellige aldersgrupper
description: Analyse af SARS-CoV-2 smittetal i forskellige aldersgrupper
---

# Analyse af SARS-CoV-2 smittetal i forskellige aldersgrupper
Kristoffer T. Bæk<br>Februar 2021

<div class="likely">
    <div class="facebook">Del</div>
    <div class="twitter">Tweet</div>
    <div class="linkedin">Del</div>
</div>
<br>




## Baggrund

Antallet af SARS-CoV-2 positivt testede har i løbet af efteråret og særligt op til jul været højest blandt de 10-29 årige (Figur 1). Men for at få en bedre idé om hvor udbredt smitten er i  forskellige aldersgrupper, bør man se de tal i lyset af hvor mange, og hvem, man tester. Jo flere man tester, jo flere smittede finder man, alt andet lige.  SSI beskriver dette forhold i bl.a. [denne rapport](https://www.ssi.dk/-/media/ssi-files/ekspertrapport-af-den-23-oktober-2020-incidens-og-fremskrivning-af-covid19-tilflde.pdf?la=da).

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

Alt i alt anser jeg aflæsningen af graferne for at være korrekt. I det følgende har jeg slået grupperne 0-2 år, 3-6 år, og 7-12 år sammen i én gruppe for overskuelighedens skyld.

## Resultater

De aflæste data for testede per 100.000 personer fremgår af Figur 4. Her kan man se en meget stor spredning i antallet af testede mellem de forskellige aldersgrupper, og en – måske overraskende – stor stigning i antallet af testede 40-64 årige siden nytår.

*Figur 4: Test-incidens for hver aldersgruppe*

![](/figures/SSI_read_graph_test_incidense_together.png)

De aflæste data for positive per 100.000 personer fremgår af Figur 5. Her kan man, ligesom på Figur 1, se at unge ligger klart i top gennem det meste af perioden, med en positiv-incidens for 13-19 årige der er ca. 3-4 gange højere end 65+ årige. Derudover ses et forhøjet niveau blandt 80+ årige, som topper kort før nytår, i modsætning til niveauet for 0-64 årige der topper i midten af december.

*Figur 5: Positiv-incidens for hver aldersgruppe*

![](/figures/SSI_read_graph_incidense_together.png)


Hvis man i stedet kigger på positivprocenten (antallet af positive i forhold til antal testede) ændres billedet dog, idet de fem aldersgrupper ikke længere er helt så forskellige (Figur 6). Man kan altså  forklare noget af forskellen i smittetallet mellem de forskellige aldersgrupper med, at der testes flere personer i nogle aldersgrupper end i andre.    

Desuden ses to toppe i december, én i første tredjedel af måneden for 13-64 årige og én omkring nytår for 0-12 og 65+ årige. Antal testede fluktuerede kraftigt omkring jul og nytår, og derfor skal man i disse uger tage positivprocenten med et vist forbehold, da positivprocenten er følsom overfor ændringer i *hvem* der testes (f.eks. asymptomatiske der vil testes før juleaften vs. risikogrupper/symptomatiske der bliver testet i juledagene). Det er muligt at stigningen i positivprocent mellem jul og nytår for 0-12 årige skyldes mere målrettet testning af f.eks syge og ikke øgning i smitten, idet stigningen i positivprocent skete samtidig med et kraftigt fald i antal testede. Stigningen blandt 65+ årige i samme periode afspejler nok i højere grad en stigning i smitte, da der ikke var store udsving i test-incidensen for denne aldersgruppe.     

*Figur 6: Positivprocenten for hver aldersgruppe*

![](/figures/SSI_read_graph_pct_together.png)

Med de ovennævnte forbehold i baghovedet er positivprocenten tættere på at beskrive den reelle smitteudbredelsen end de absolutte positivtal, fordi den tager hensyn til at antallet af testede er meget forskelligt i de forskellige aldersgrupper.

Forskellen i smitteudbredelse mellem aldersgrupperne er derfor nok ikke så stor som de rene smittetal giver anledning til at tro.  Det betyder imidlertid ikke at der ikke er forskel, idet både positivprocent og [seroprævalensstudier](https://bloddonor.dk/coronavirus/) viser at smitteudbredelsen har været størst blandt yngre og mindst blandt ældre (70+ årige opdeles dog ikke i seroprævalensstudierne, så det er muligt at der er forskelle i denne gruppe som ikke opdages på denne måde).
