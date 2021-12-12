---
id: home
image: /figures/twitter_card.png
title: Covid-19 smitteudvikling i Danmark
---
# Grafer over Covid-19 smitteudvikling i Danmark

Senest opdateret 10. december 2021 efter kl 14.
Opdateres ca. én gang om ugen.

<div class="likely">
    <div class="facebook">Del</div>
    <div class="twitter">Tweet</div>
    <div class="linkedin">Del</div>
</div>

<div class="richandfamous">
<a href="https://twitter.com/KT_baek?ref_src=twsrc%5Etfw" class="twitter-follow-button" data-size="large" data-show-screen-name="false" data-lang="en" data-show-count="false">Follow</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<a href="https://www.buymeacoffee.com/covid19danmark" target="_blank"><img src="/assets/buymecoffee.svg" alt="Buy Me A Coffee" height="28"></a>
</div>

## Data

Data er hentet på [SSI's COVID-19 overvågningsside](https://covid19.ssi.dk) og hos [Danmarks Statistik](https://statbank.dk).

Medmindre andet er angivet, viser graferne kun resultater for PCR tests.

Der går typisk 2-3 dage før testdata er helt opdateret. På de grafer der viser daglige testdata er de seneste to dage derfor ikke medtaget. På grafer over nyindlagte og døde er den seneste dag ikke medtaget.  

*Siden er under løbende udvikling. Jeg påtager mig ikke ansvar for eventuelle fejl.*


## Hele landet

### Dagligt antal nyindlagte og dødsfald
Plottene viser antal nyindlagte og antal døde for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Deaths_over_time', 'Newly_admitted_over_time'``

![](/figures/ntl_hosp.png)
![](/figures/ntl_deaths.png)

### Dagligt antal positivt testede personer justeret for antal testede
Plottet viser positivprocenten og et smitteindeks. Smitteindekset er anden måde at vise antallet af positive justeret for antallet af testede. I modsætning til positivprocenten antager metoden, at der ikke er et 1:1 forhold mellem antal positive og antal testede: Når man tester flere, antages det at man i højere grad tester personer med lavere sandsynlighed for at være smittede. Metoden [benyttes af SSI](https://www.ssi.dk/-/media/ssi-files/ekspertrapport-af-den-23-oktober-2020-incidens-og-fremskrivning-af-covid19-tilflde.pdf?la=da).

Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/ntl_index.png)



### Dagligt antal nye positivt testede personer
Plottet viser antallet af nye positivt testede personer for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/ntl_pos.png)


### Dagligt antal testede personer
Plottet viser det totale antal testede personer for hele landet opdelt på *antigen- og PCR tests*. Der er ikke data for antigentests før 1. feb 2021.  

``SSI datasæt: 'Antigentests_pr_dag', 'Test_pos_over_time'``

![](/figures/ntl_ag_test.png)

### Dagligt antal positivt antigentestede personer
Plottet viser antallet af nye positivt testede personer for hele landet siden 1. feb 2021. Derudover angives det hvor mange af disse personer, som er blevet testet med PCR-test på samme dag eller dagen efter antigentest, samt svaret på denne test.

``SSI datasæt: 'Antigentests_pr_dag'``

![](/figures/ntl_ag_pos.png)

### 2021 versus 2020
Plottet viser forløbene af forskellige epidemi-indikatorer samt total antal døde (uanset årsag) for efteråret 2020 og efteråret 2021.

``SSI datasæt: 'Test_pos_over_time', 'Deaths_over_time', 'Newly_admitted_over_time'``
``Danmarks Statistik datasæt: 'DODC1'``

![](/figures/ntl_fall_20_21.png)


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

Plottene viser det ugentlige antal positive, testede og nyindlagte per 100.000 i aldersgruppen, og positivprocenten for hver aldersgruppe.

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

### Dagligt antal døde for hver aldersgruppe
Plottet viser det daglige antal døde (alle årsager) for hver aldersgruppe for 2020, 2021 indtil nu, og gennemsnittet for 2015-19. Antallet af døde i årene 2015-19 er justeret til befolkningstallet for 2020 indenfor hver aldersgruppe.

``Danmarks Statistik datasæt: 'DODC1'``

![](/figures/ntl_deaths_age_total.png)



[Tilbage til toppen](#)

## Vaccinationsstatus

### Total antal vaccinerede

Øverste plot viser det kumulerede antal vaccinerede.

De to nederste plot viser køns-og aldersfordeling for vaccinerede indtil nu som procentdel af antal personer i køn- og aldersgruppen.

``SSI datasæt: 'Vaccinationer_region_aldgrp_koen', 'FoersteVacc_region_dag', 'FaerdigVacc_region_dag'``

![](/figures/ntl_vax_cum.png)

![](/figures/ntl_vax_age_pct.png)

[Tilbage til toppen](#)

## Gennembrudsinfektioner

### Smittede opdelt på vaccinations- og tidligere smittestatus

Plottet viser det ugentlige antal positive per 100.000 (i alders- og immunitetsgruppen) og i absolutte tal. Anden/tredje vaccination angiver alle som har fået mindst to doser. Data for modtagere af én dosis (første vaccination) er udeladt.

*Tidligere positive* angiver ikke-vaccinerede personer med en tidligere positiv PCR test der er mere end 60 dage gammel. *Ingen vaccination* og *Anden/tredje vaccination* angiver personer der ikke tidligere har testet positiv. Personer der er vaccineret *og* tidligere testet positive udgør kun et lille antal og er ikke medtaget. For aldersgrupper 60+ er tidligere positive ikke medtaget, da antal nye positive (repositive) i disse grupper er tæt på nul.

![](/figures/bt_cases_age_time_2.png)

### Indlagte og døde opdelt på vaccinationsstatus

Plottene viser det ugentlige antal indlæggelser og døde per 100.000 (i alders- og vaccinationsgruppen) og i absolutte tal. Anden/tredje vaccination angiver alle som har fået mindst to doser. Data for modtagere af én dosis (første vaccination) er udeladt.

![](/figures/bt_admit_age_time.png)

![](/figures/bt_icu_age_time.png)

![](/figures/bt_deaths_age_time.png)

## Virusvarianter

Plottene viser en oversigt over forekomsten af varianterne Alfa, Delta, og Omikron samt tidligere varianter ("Andre") siden 1. november 2020. Det øverste plot viser absolutte antal positivt testede, og det nederste viser varianternes andel alle positivt testede.

![](/figures/ntl_all_variants_pos.png)

![](/figures/ntl_all_variants_proportion.png)

## Politiske tiltag

Se [liste](/tiltag.md) over tiltag.

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

### Dagligt antal nye positivt testede og antal testede for hver landsdel
Plottet viser det daglige antal nye positivt testede og antal total testede for de seneste tre måneder for hver landsdel.

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse.

[Liste](/Geo_opdeling.md) over geografisk opdeling af Danmark.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

![](/figures/muni_pos_vs_test_landsdele.png)

### Daglig procentdel positivt testede for hver landsdel
Plottet viser den daglige procentdel af positivt testede (inkl. 7-dages gennemsnit) for de seneste tre måneder for hver landsdel.

[Liste](/Geo_opdeling.md) over geografisk opdeling af Danmark.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``


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



<!--

### Ugentligt antal positivt testede per indbyggertal og procentdel positivt testede per testede (heatmaps)
Plottene viser hhv. den ugentlige promille positivt testede per indbyggertal og den ugentlige procent positivt testede per total testede for udvalgte kommuner.  

De udvalgte kommuner er de 30 kommuner der har haft flest positivt testede indenfor den seneste måned.  

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

![](/figures/muni_30_weekly_incidens_tile.png)

For at se ovenstående plot for *alle* kommuner, klik [her](/figures/muni_all_weekly_incidens_tile.png).

![](/figures/muni_30_weekly_pct_tile.png)

For at se ovenstående plot for *alle* kommuner, klik [her](/figures/muni_all_weekly_pos_pct_tile.png).

-->



[Tilbage til toppen](#)



## Øvrige sammenligninger

### Dagligt antal dødsfald i Danmark
Øverste plot viser det totale antal daglige dødsfald siden 1. jan 2020, det daglige antal Covid-19 relaterede dødsfald, og det gennemsnitlige antal daglige dødsfald for perioden 2015-19 (udglattet 7-dages gennemsnit).

Nederste plot viser det daglige antal dødsfald i 2020 siden 1. jan 2020, opdelt på Covid-19- og ikke-Covid-19 relaterede dødsfald. Desuden vises det gennemsnitlige antal ugentlige dødsfald for perioden 2015-19 (udglattet 7-dages gennemsnit).

Total antal daglige dødsfald opdateres fredage.

``SSI datasæt: 'Deaths_over_time', Danmarks Statistik datasæt: 'DODC1'``

![](/figures/dst_deaths_covid_all.png)

![](/figures/dst_deaths_covid_all_2.png)





### Dagligt antal akutindlæggelser i Danmark
Plottet viser:

- det gennemsnitlige daglige antal akutindlæggelser for hver uge i løbet af et år for perioden 2008-18. Data for 2008-17 er justeret til befolkningstallet for 2018.
- det daglige antal Covid-19 relaterede indlæggelser.

Data for 2008-18 stammer fra Danmarks Statistik (Susanne Brondbjerg via Ulrik Gerdes) og omfatter ikke indlæggelser på privathospitaler eller på psykiatriske afdelinger.

Det skal bemærkes at én person kan stå for flere indlæggelser, og at der er omkring dobbelt så mange *indlæggelser*  som *indlagte personer* i løbet af et år (akut + ikke-akut).

``SSI datasæt: 'Newly_admitted_over_time'``

![](/figures/dst_admissions_covid_all.png)


[Tilbage til toppen](#)
