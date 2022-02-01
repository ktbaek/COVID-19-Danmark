---
id: home
image: /figures/twitter_card.png
title: Covid-19 smitteudvikling i Danmark
---
# Grafer over Covid-19 smitteudvikling i Danmark

Senest opdateret  1. februar 2022 kl. 14:32.
Opdateres et par gange om ugen.

[SSI's datasæt]: https://github.com/ktbaek/COVID-19-Danmark/tree/master/data/SSIdata_220121

<div class="likely">
    <div class="facebook">Del</div>
    <div class="twitter">Tweet</div>
    <div class="linkedin">Del</div>
</div>

Kristoffer T. Bæk, 2020-2022

<div class="richandfamous">
<a href="https://twitter.com/KT_baek?ref_src=twsrc%5Etfw" class="twitter-follow-button" data-size="large" data-show-screen-name="false" data-lang="en" data-show-count="false">Follow</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<a href="https://www.buymeacoffee.com/covid19danmark" target="_blank"><img src="/assets/buymecoffee.svg" alt="Buy Me A Coffee" height="28"></a>
</div>

## Data

Data er hentet på [SSI's COVID-19 overvågningsside](https://covid19.ssi.dk) og hos [Danmarks Statistik](https://statbank.dk).

Medmindre andet er angivet viser graferne kun resultater for PCR tests, og antal positive inkluderer *ikke* repositive (altså positive der tidligere har testet positiv).

Der går typisk 2-3 dage før testdata er helt opdateret. På de grafer der viser daglige testdata er de seneste to dage derfor ikke medtaget. På grafer over nyindlagte og døde er den seneste dag ikke medtaget.


*Siden er under løbende udvikling. Jeg påtager mig ikke ansvar for eventuelle fejl.*


## Hele landet

### Dagligt antal nyindlæggelser og dødsfald
Plottene viser antal nyindlæggelser og antal døde for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

Tallene for nyindlagte og døde er pr. 21. december 2021 baseret på alle positive tests (inkl. reinfektioner).

``SSI datasæt: 'Deaths_over_time', 'Newly_admitted_over_time'``

![](/figures/ntl_hosp.png)
![](/figures/ntl_deaths.png)

### Dagligt antal indlagte
Plottet viser antal indlagte, heraf indlagte på intensiv. Den optrukne linje viser det løbende gennemsnit for det samlede antal indlagte baseret på et vindue på 7 dage.

Tallene for indlagte er pr. 21. december 2021 baseret på alle positive tests (inkl. reinfektioner).

``Danmarks statistik datasæt: 'SMIT1'``

![](/figures/dst_hosp_icu.png)


### Dagligt antal positivt testede personer
Plottet viser antallet af positivt testede personer for hele landet opdelt på nye positive og repositive. Repositive er defineret som positive som tidligere har modtaget en positiv test, og hvis tidligere positive test er mere end 60 dage gammel. Den optrukne linje viser det løbende gennemsnit for det samlede antal positive baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', '24_reinfektioner_daglig_region'``

![](/figures/ntl_pos.png)

### Daglig positivprocent
Plottet viser hvor stor en procentdel af PCR testede der tester positive. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. Vær opmærksom på at positivprocenten er påvirket af hvem der testes, f.eks kan man antage at når man tester flere, tester man i højere grad personer med lavere sandsynlighed for at være smittede.

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/ntl_pct.png)


### Dagligt antal testede personer
Plottet viser det totale antal testede personer for hele landet opdelt på *antigen- og PCR tests*. Der er ikke data for antigentests før 1. feb 2021.  

``SSI datasæt: 'Antigentests_pr_dag', 'Test_pos_over_time'``

![](/figures/ntl_ag_test.png)

### Dagligt antal positivt antigentestede personer
Plottet viser antallet af nye positivt testede personer for hele landet siden 1. feb 2021. Derudover angives det hvor mange af disse personer, som er blevet testet med PCR-test på samme dag eller dagen efter antigentest, samt svaret på denne test.

``SSI datasæt: 'Antigentests_pr_dag'``

![](/figures/ntl_ag_pos.png)

### 2021/22 versus 2020/21
Plottene viser forløbene af forskellige epidemi-indikatorer samt total antal døde (uanset årsag) for efterår/vinter 2020/21 og efterår/vinter 2021/22.

``SSI datasæt: 'Test_pos_over_time', 'Deaths_over_time', 'Newly_admitted_over_time'``
``Danmarks Statistik datasæt: 'DODC1'``

![](/figures/ntl_fall_20_21.png)

![](/figures/ntl_four_compare_20_21.png)


### Dagligt antal nyindlagte vs. hhv. antal nye positivt testede og procent positivt testede
Plottene sammenligner antal nyindlagte med hhv. antal positivt testede og procentdelen af positivt testede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](/figures/ntl_pos_admit.png)

![](/figures/ntl_pct_admit.png)


### Dagligt antal døde vs. hhv. antal nye positivt testede og procent positivt testede
Plottene sammenligner antal døde med hhv. antal positivt testede og procentdelen af positivt testede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', 'Deaths_over_time'``

![](/figures/ntl_pos_deaths.png)

![](/figures/ntl_pct_deaths.png)

[Tilbage til toppen](#)

## Aldersgrupper

### Ugentligt antal positive, testede og nyindlagte for hver aldersgruppe

Plottene viser det ugentlige antal positive, testede og nyindlagte per 100.000 i aldersgruppen, og positivprocenten for hver aldersgruppe. Datoerne angiver mandagen i hver uge.

``SSI datasæt: '18_fnkt_alder_uge_testede_positive_nyindlagte'``
``Danmarks Statistik datasæt: 'FOLK1A'``

![](/figures/ntl_pos_age.png)

![](/figures/ntl_test_age.png)

![](/figures/ntl_pct_age.png)

![](/figures/ntl_hosp_age.png)

### Ugentlig andel af positivt testede der indlægges

Plottet viser andelen af PCR positive der efterfølgende indlægges for hvert kvartal siden 1. juli 2020. Andelene er beregnet ved lineær regression mellem 1) antal positive i en enkelt uge og 2) gennemsnittet af antal indlæggelser i samme uge eller de to følgende uger (det er den periode en positiv test kan give anledning til at en indlæggelse registreres som en COVID-19 relateret indlæggelse). Korrelationskoefficienterne under søjlerne angiver hvor god sammenhængen mellem antal positive og antal indlæggelser er.

``SSI datasæt: '18_fnkt_alder_uge_testede_positive_nyindlagte'``

![](/figures/ntl_pos_admit_bars_quarter.png)

<!--
### Dagligt antal døde for hver aldersgruppe

*Ikke fuldt opdateret*

Plottet viser det daglige antal døde (alle årsager) for hver aldersgruppe for 2020, 2021 indtil nu, og gennemsnittet for 2015-19. Antallet af døde i årene 2015-19 er justeret til befolkningstallet for 2020 indenfor hver aldersgruppe.

``Danmarks Statistik datasæt: 'DODC1'``

![](/figures/ntl_deaths_age_total.png)

-->

[Tilbage til toppen](#)

## Vaccinationsstatus

### Total antal vaccinerede

Plottet viser det kumulerede antal vaccinerede for alle aldre opdelt på dose.

``SSI datasæt: 'FoersteVacc_region_dag', 'FaerdigVacc_region_dag', 'Revacc1_region_dag'``

![](/figures/ntl_vax_cum.png)

### Andel vaccinerede i hver aldersgruppe

<!--
Det øverste plot viser det kumulerede antal vaccinerede som procentdel af antal personer i aldersgruppen. Antal personer som har opnået fuld effekt efter tredje dose (fuld effekt definerer SSI til 14 dage efter enten anden eller tredje dose) er beregnede ugentlige værdier på baggrund af et separat datasæt og er derfor ikke fuldstændig sammenlignelige med data for første og anden dose.
-->

Plottet viser køns-og aldersfordeling for vaccinerede indtil nu som procentdel af antal personer i køn- og aldersgruppen.

``SSI datasæt: 'Vaccinationer_region_aldgrp_koen', 'FoersteVacc_FaerdigVacc_region_fnkt_alder_dag', 'Gennembrudsinfektioner_table2'``
``Danmarks Statistik datasæt: 'FOLK1A'``


![](/figures/ntl_vax_age_pct.png)

[Tilbage til toppen](#)

## Gennembrudsinfektioner

### Antal personer i hver vaccinationsgruppe

Plottet viser det ugentlige antal personer i hver alders- og vaccinationsgruppe. Inkluderer kun personer der ikke tidligere har testet positiv. "Fuld effekt" definerer SSI som 14 dage efter modtaget dose. Grupper der ikke er inkluderet: Personer der har modtaget 2 doser, men endnu ikke har opnået fuld effekt.

``SSI datasæt: 'Gennembrudsinfektioner_table2'``

![](/figures/bt_personer_vaxgroup_age_time.png)

### Smittede opdelt på vaccinationsstatus

Plottet viser det ugentlige antal positive per 100.000 (i alders- og vaccinationssgruppen) og i absolutte tal.  Inkluderer kun personer der ikke tidligere har testet positiv. "Fuld effekt" definerer SSI som 14 dage efter modtaget dose.

Grupper der ikke er inkluderet: personer der har modtaget én dosis (første vaccination), personer der har modtaget 2 doser men endnu ikke har opnået fuld effekt, 0-5 årige der har modtaget 2. dose, og 0-15 årige der har modtaget 3. dose.

Datoerne angiver mandagen i hver uge.

``SSI datasæt: 'Gennembrudsinfektioner_table2'``

![](/figures/bt_pos_age_time.png)

### Testjusteret smittetal opdelt på vaccinationsstatus

Det øverste plot viser antal PCR testede personer per 100.000 (i alders- og vaccinationsgruppen).

Det nederste plot viser et *forsøg* på at testjustere antal positive per 100.000 (i alders- og vaccinationsgruppen) hvor *beta* er sat til 0.5, hvilket er et kvalificeret gæt. I modsætning til positivprocenten antager denne type testjustering, at der ikke er et 1:1 forhold mellem antal positive og antal testede: Når man tester flere, antages det at man i højere grad tester personer med lavere sandsynlighed for at være smittede. Metoden er [beskrevet her](https://www.ssi.dk/-/media/ssi-files/ekspertrapport-af-den-23-oktober-2020-incidens-og-fremskrivning-af-covid19-tilflde.pdf?la=da).

I begge plot er kun inkluderet personer der ikke tidligere har testet positiv. Grupper der derudover ikke er inkluderet: personer der har modtaget én dosis (første vaccination), personer der har modtaget 2 doser men endnu ikke har opnået fuld effekt, 0-5 årige der har modtaget 2. dose, og 0-15 årige der har modtaget 3. dose.

Datoerne angiver mandagen i hver uge.

``SSI datasæt: 'Gennembrudsinfektioner_table2'``

![](/figures/bt_tests_age_time.png)

![](/figures/bt_tac_age_time.png)

<!--
### Smittede opdelt på vaccinations- og tidligere smittestatus

*Midlertidigt fjernet fra siden pga usikkerhed om SSI's definition af tidligere positive*


Plottet viser det ugentlige antal positive per 100.000 (i alders- og immunitetsgruppen) og i absolutte tal. Data for modtagere af én dosis (første vaccination) er udeladt.

*Tidligere positive* angiver ikke-vaccinerede personer med en tidligere positiv PCR test der er mere end 60 dage gammel. *Ingen vaccination*, *fuld effekt 2 doser*, og *fuld effekt 3 doser* angiver personer der ikke tidligere har testet positiv. "Fuld effekt" definerer SSI som 14 dage efter modtaget dose. Personer der er vaccineret *og* tidligere testet positive er ikke medtaget. For aldersgrupper 60+ er tidligere positive ikke medtaget, da antal nye positive (repositive) i disse grupper er meget små. Det samme gør sig gældende for modtagere af 3. dosis i aldersgrupper under 20 år.

Datoerne angiver mandagen i hver uge.

``SSI datasæt: 'Gennembrudsinfektioner_table1', 'Gennembrudsinfektioner_table2'``

![](/figures/bt_cases_age_time_2.png)

### Testjusteret smittetal opdelt på vaccinations- og tidligere smittestatus

Grupperne er defineret som ovenfor.

Det øverste plot viser antal PCR testede per 100.000 (i alders- og immunitetsgruppen). Det nederste plot viser det testjusterede antal positive per 100.000 (i alders- og immunitetsgruppen) hvor *beta* er sat til 0.5, hvilket er et kvalificeret gæt. I modsætning til positivprocenten antager denne type testjustering, at der ikke er et 1:1 forhold mellem antal positive og antal testede: Når man tester flere, antages det at man i højere grad tester personer med lavere sandsynlighed for at være smittede. Metoden er [beskrevet her](https://www.ssi.dk/-/media/ssi-files/ekspertrapport-af-den-23-oktober-2020-incidens-og-fremskrivning-af-covid19-tilflde.pdf?la=da). Datoerne angiver mandagen i hver uge.

``SSI datasæt: 'Gennembrudsinfektioner_table1', 'Gennembrudsinfektioner_table2'``

![](/figures/bt_tests_age_time.png)

![](/figures/bt_tac_age_time_1.png)
-->


### Indlagte og døde opdelt på vaccinationsstatus

Plottene viser det ugentlige antal indlæggelser og døde per 100.000 (i alders- og vaccinationsgruppen) og i absolutte tal. Kun personer som ikke tidligere har testet positiv indgår. "Fuld effekt" definerer SSI som 14 dage efter modtaget dose. Datoerne angiver mandagen i hver uge.

Grupper der ikke er inkluderet: personer der har modtaget én dosis (første vaccination) og personer der har modtaget 2 doser, men endnu ikke har opnået fuld effekt.

Vaccinestatus er defineret ud fra tidspunktet for den positive test, ikke tidspunktet for indlæggelse eller død.

``SSI datasæt: 'Gennembrudsinfektioner_table2'``

![](/figures/bt_admit_age_time.png)

![](/figures/bt_icu_age_time.png)

![](/figures/bt_deaths_age_time.png)

## Virusvarianter

*Opdateres ikke efter 2. januar 2022*

### Ugentlige antal positive opdelt på varianter

Plottene viser en oversigt over forekomsten af varianterne Alfa, Delta, og Omikron samt tidligere varianter ("Andre") siden 1. november 2020. Det øverste plot viser absolutte antal positivt testede, og det nederste viser varianternes andel af alle positivt testede. Datoerne angiver mandagen i hver uge.

``SSI datasæt: Virusvariant pdf-rapporter``

![](/figures/ntl_all_variants_pos.png)

![](/figures/ntl_all_variants_proportion.png)

### Daglige antal: Omikron

Plottet viser det daglige antal positive opdelt på de to nuværende varianter, Delta og Omikron.

``SSI datasæt: Omikron pdf-rapport, Table 2``

![](/figures/ntl_omikron_daily_pos.png)




## Politiske tiltag

Se [liste](/tiltag.md) over tiltag.
*Ikke fuldt opdateret*.

### Daglige epidemi-indikatorer og tiltag
Plottet viser forløbene af de forskellige epidemi-indikatorer samt tidspunkterne for politiske tiltag. De optrukne linjer viser de løbende gennemsnit baseret på et vindue på 7 dage fra 1. januar til nu.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time', 'Deaths_over_time'``

![](/figures/ntl_tiltag_january.png)

[English version](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_tiltag_january_EN.png) of this plot.

Lignende plots for [forår/sommer 2020](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_tiltag_april.png) og [efterår 2020](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_tiltag_july.png).

[Tilbage til toppen](#)


## Kommuner, landsdele og regioner
### Dagligt antal nye positivt testede og antal testede for hver kommune
Plottet viser det daglige antal nye positivt testede og antal total testede for de seneste tre måneder for de 30 kommuner der har haft flest positivt testede den seneste måned.

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

Individuelle grafer for hver kommune kan ses [her](https://github.com/ktbaek/COVID-19-Danmark/tree/master/figures/Kommuner)

Dette plot for *alle* kommuner kan ses [her](/figures/muni_all_pos_vs_test.png).

Dette plot startende 1. marts 2020 kan ses [her](/figures/muni_30_pos_vs_test_march.png).


![](/figures/muni_30_pos_vs_test.png)

### Daglig procentdel positivt testede for hver kommune
Plottet viser den daglige procentdel af positivt testede (inkl. 7-dages gennemsnit) for de seneste tre måneder for de 30 kommuner der har haft flest positivt testede indenfor den seneste måned.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

Individuelle grafer for hver kommune kan ses [her](https://github.com/ktbaek/COVID-19-Danmark/tree/master/figures/Kommuner)

Dette plot for *alle* kommuner kan ses [her](/figures/muni_all_pct.png).

Dette plot startende 1. maj 2020 kan ses [her](/figures/muni_30_pct_may.png).


![](/figures/muni_30_pct.png)

### Dagligt antal positive, testede og procentdel positivt testede for hver landsdel
Plottene viser det daglige antal nye positivt testede, antal total testede og procentdel af positivt testede (inkl. 7-dages gennemsnit) for de seneste tre måneder for hver landsdel.

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse.

[Liste](/Geo_opdeling.md) over geografisk opdeling af Danmark.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

![](/figures/muni_pos_vs_test_landsdele.png)

![](/figures/muni_pct_landsdele.png)


### Dagligt antal positive, testede og procentdel positivt testede i København og omegn

Plottene viser det daglige antal nye positivt testede, antal total testede og procentdel af positivt testede (inkl. 7-dages gennemsnit).

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``


![](/figures/muni_kbharea_pos_vs_test.png)

![](/figures/muni_kbharea_pct.png)

### Daglige epidemi-indikatorer for hver region

Øverste plot viser det daglige antal nyindlæggelser, procent positivt testede, og antal positivt testede for de seneste tre måneder for hver region.

Nederste plot viser det daglige antal nyindlæggelser og antal positivt testede per 100.000 indbyggere for de seneste tre måneder for hver region.

``SSI datasæt: 'Newly_admitted_over_time', 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series'``


![](/figures/muni_region_all.png)

![](/figures/muni_region_incidens.png)

[Tilbage til toppen](#)

## Øvrige sammenligninger

### Dagligt antal dødsfald i Danmark
Øverste plot viser det totale antal daglige dødsfald siden 1. jan 2020, det daglige antal Covid-19 relaterede dødsfald, og det gennemsnitlige antal daglige dødsfald for perioden 2015-19 (7-dages gennemsnit).

Nederste plot viser det daglige antal dødsfald i 2020 siden 1. jan 2020, opdelt på Covid-19- og ikke-Covid-19 relaterede dødsfald. Desuden vises det gennemsnitlige antal ugentlige dødsfald for perioden 2015-19 (7-dages gennemsnit).

Bemærk at gennemsnittet for 2015-19 ikke er justeret for forandret befolkningsstørrelse eller -alderssammensætning.

Total antal daglige dødsfald opdateres fredage.

``SSI datasæt: 'Deaths_over_time', Danmarks Statistik datasæt: 'DODC1'``


![](/figures/dst_deaths_covid_all.png)

![](/figures/dst_deaths_covid_all_2.png)


### Kumuleret overdødelighed per år

Plottene viser den årskumulerede overdødelighed per 100.000 personer i hver køns- og aldersgruppe for årene 2015 til 2021. Baseline er gennemsnittet for årene 2015 - 2019.

Beregning: Først er dødsfald per dag per 100.000 i hver gruppe beregnet og disse tal er derefter kumuleret for hvert år fra årets start. Dernæst er baseline beregnet som gennemsnittet af kumulerede dødsfald per 100.000 for årene 2015 - 2019. Over/underdødelighed er tilsidst beregnet som forskellen mellem kumuleret antal dødsfald per 100.000 og baseline.   

Bemærk varierende y-akser.

``Danmarks Statistik datasæt: 'DODC1', 'FOLK1A'``

Kombineret datasæt [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/data/tidy_dst_age_sex_2015_22.csv).

![](/figures/DST_deaths_19_20_21/dst_deaths_age_sex_xscum_rel_young.png)

![](/figures/DST_deaths_19_20_21/dst_deaths_age_sex_xscum_rel_mid.png)

![](/figures/DST_deaths_19_20_21/dst_deaths_age_sex_xscum_rel_old.png)



### Dagligt antal akutindlæggelser i Danmark
Plottet viser:

- det gennemsnitlige daglige antal akutindlæggelser for hver uge i løbet af et år for perioden 2008-18. Data for 2008-17 er justeret til befolkningstallet for 2018.
- det daglige antal Covid-19 relaterede indlæggelser.

Data for 2008-18 stammer fra Danmarks Statistik (Susanne Brondbjerg via Ulrik Gerdes) og omfatter ikke indlæggelser på privathospitaler eller på psykiatriske afdelinger.

Det skal bemærkes at én person kan stå for flere indlæggelser, og at der er omkring dobbelt så mange *indlæggelser*  som *indlagte personer* i løbet af et år (akut + ikke-akut).

``SSI datasæt: 'Newly_admitted_over_time'``

![](/figures/dst_admissions_covid_all.png)


[Tilbage til toppen](#)
