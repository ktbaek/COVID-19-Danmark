---
id: home
image: /figures/twitter_card.png
title: Covid-19 smitteudvikling i Danmark
---
# Grafer over Covid-19 smitteudvikling i Danmark

Senest opdateret 28. december 2020 efter kl 14.

<div class="likely">
    <div class="facebook">Del</div>
    <div class="twitter">Tweet</div>
    <div class="linkedin">Del</div>
</div>

## Data

Data er hentet på [SSI's COVID-19 overvågningsside](https://covid19.ssi.dk) og hos [Danmarks Statistik](https://statbank.dk).

Der går typisk 2-3 dage før testdata er helt opdateret. På de grafer der viser daglige testdata er de seneste to dage derfor ikke medtaget. På grafer over nyindlagte og døde er den seneste dag ikke medtaget.  

Læs en uddybende forklaring af datafiler, begreber og beregninger [her](/Forklaring.md).

*Siden er under løbende udvikling. Jeg påtager mig ikke ansvar for eventuelle fejl.*


## Begreber
#### Antal positivt testede
<!--
Antallet af positivt testede omtales også som 'antallet af påviste/konstaterede/registrerede/bekræftede smittede/tilfælde/smittetilfælde', eller ofte *misvisende* som 'antallet af smittede' eller 'smittetallet' (misvisende fordi vi ikke kender det reelle antal af smittede, kun det antal vi har opdaget ved tests).
-->

Positivt testede angiver personer, som *for første gang er testet positive* for COVID-19, og kan derfor også omtales som **nye positive**. 

#### Procentdel positivt testede
Procentdel positivt testede angiver den procentvise andel af personer der er testede positiv ud af hvor mange der er testet i alt. Omtales også som positivraten, positivprocenten eller positivandelen.


## Plots: hele landet

Nogle af figurerne er opdaterede versioner af figurerne fra artiklen [Kurven over smittede i Danmark er misvisende](https://link.medium.com/Ldu11b9IQ8).

<!--
 [Download PDF (A4)](/figures/Covid-19-Danmark.pdf)
 med de vigtigste plots for hele landet.
-->

### Dagligt antal nyindlagte og dødsfald
Plottene viser antal nyindlagte og antal døde for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Deaths_over_time', 'Newly_admitted_over_time'``

![](/figures/ntl_hosp.png)
![](/figures/ntl_deaths.png)

### Daglig procentdel positivt testede personer
Plottene viser procentdelen af nye positivt testede personer ifht. hvor mange der er testet for hele landet i hhv. hele perioden og fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/ntl_pct_1.png)


![](/figures/ntl_pct_2.png)



### Dagligt antal nye positivt testede personer
Plottet viser antallet af nye positivt testede personer for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/ntl_pos.png)

### Dagligt antal testede personer
Plottet viser det totale antal testede personer og antallet af nye positivt testede personer for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/ntl_tests.png)




### Dagligt antal testede, antal nye positive og procent positive testede
Plottet viser det totale antal testede personer, antallet af nye positivt testede personer, og procentdelen af positivt testede personer for hele landet. Procentdelen af positivt testede er vist som et løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/ntl_pos_tests_pct.png)

### Dagligt antal nyindlagte vs. hhv. antal nye positivt testede og procent positivt testede
Plottene sammenligner antal nyindlagte med hhv. antal positivt testede og procentdelen af positivt testede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](/figures/ntl_postest_admitted_barplot_2.png)

![](/figures/ntl_pct_admitted_barplot_2.png)

<!--
Se "spejlvendte" plots uden løbende gennemsnit for [antal positive](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_postest_admitted_barplot.png) og [positivprocent](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_pct_admitted_barplot.png).
-->



### Dagligt antal døde vs. hhv. antal nye positivt testede og procent positivt testede
Plottene sammenligner antal døde med hhv. antal positivt testede og procentdelen af positivt testede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', 'Deaths_over_time'``

![](/figures/ntl_postest_deaths_barplot_2.png)

![](/figures/ntl_pct_deaths_barplot_2.png)

<!--
Se "spejlvendte" plots uden løbende gennemsnit for [antal positive](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_postest_deaths_barplot.png) og [positivprocent](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_pct_deaths_barplot.png).
-->

### Dagligt antal positivt testede og procentdelen af  positivt testede
Plottet sammenligner forløbet af kurven over antal positivt testede personer med kurven over positivandelen for hele landet fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

SSI datasæt: ``'Test_pos_over_time'``

![](/figures/ntl_pos_pct.png)

<!--
### Kontakttallet
SSI beregner to kontakttal (Rt værdi): ét baseret på smittetal og ét baseret på indlagte. Se plots for kontakttallene sammenlignet med hhv. [antal positive tests](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_rt_cases_pos.png), [procent positive tests](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_rt_cases_pct.png), og [antal nyindlagte](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/ntl_rt_admitted.png).

-->

[Tilbage til toppen](#)


## Plots: politiske tiltag

Se [liste](/tiltag.md) over tiltag.

### Daglige epidemi-indikatorer og tiltag
Plottene viser forløbene af de forskellige epidemi-indikatorer samt tidspunkterne for politiske tiltag. De optrukne linjer viser de løbende gennemsnit baseret på et vindue på 7 dage. Det øverste plot viser perioden fra 1. april til 1. august, det nederste plot viser perioden fra 1. juli til nu.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time', 'Deaths_over_time'``

![](/figures/ntl_tiltag_april.png)

![](/figures/ntl_tiltag_july.png)

### Relative ændringer i epidemi-indikatorer efter tiltag
Plottene viser den relative ændring i antal positive, positivprocent, og antal nyindlæggelser i perioden fra 14 dage før til 28 dage efter et tiltag trådte i kraft.

Kurverne viser løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](/figures/ntl_tiltag_pos.png)

![](/figures/ntl_tiltag_pct.png)

![](/figures/ntl_tiltag_admitted.png)

[Tilbage til toppen](#)

## Plots: kommuner og landsdele
### Dagligt antal nye positivt testede og antal testede for hver kommune
Plottet viser det daglige antal nye positivt testede og antal total testede for de seneste tre måneder for de 30 kommuner der har haft flest positivt testede den seneste måned.

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

For at se dette plot for *alle* kommuner, klik [her](/figures/muni_all_pos_vs_test_july.png).

For at se dette plot startende 1. april, klik [her](/figures/muni_10_pos_vs_test_april.png).

For at se plot med de **ugentlige** tal, klik [her](/figures/muni_10_pos_vs_test_july.png).


![](/figures/muni_10_pos_vs_test_daily.png)

### Daglig procentdel positivt testede for hver kommune
Plottet viser den daglige procentdel af positivt testede (inkl. 7-dages bagudrettet gennemsnit) for de seneste tre måneder for de 30 kommuner der har haft flest positivt testede indenfor den seneste måned.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

For at se dette plot for *alle* kommuner, klik [her](/figures/muni_all_pct_july.png).

For at se dette plot startende 1. april, klik [her](/figures/muni_10_pct_april.png).

For at se plot med de **ugentlige** tal, klik [her](/figures/muni_10_pct_july.png).

![](/figures/muni_10_pct_daily.png)

### Dagligt antal nye positivt testede og antal testede for hver landsdel
Plottet viser det daglige antal nye positivt testede og antal total testede for de seneste tre måneder for hver landsdel.

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse.

[Liste](/Geo_opdeling.md) over geografisk opdeling af Danmark.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

![](/figures/muni_pos_vs_test_landsdele.png)

### Daglig procentdel positivt testede for hver landsdel
Plottet viser den daglige procentdel af positivt testede (inkl. 7-dages bagudrettet gennemsnit) for de seneste tre måneder for hver landsdel.

[Liste](/Geo_opdeling.md) over geografisk opdeling af Danmark.

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``


![](/figures/muni_pct_landsdele.png)




### Dagligt antal positive, testede og procentdel positivt testede i København og omegn

Plottene viser det daglige antal nye positivt testede, antal total testede og procentdel af positivt testede (inkl. 7-dages bagudrettet gennemsnit).

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``


![](/figures/muni_kbharea_pos_vs_test.png)

![](/figures/muni_kbharea_pct.png)


Se tilsvarende grafer for de syv nordjyske kommuner der var nedlukket i november 
[her](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/muni_NJ7_pos_vs_test.png) og [her](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/muni_NJ7_pct.png).



### Ugentligt antal positivt testede per indbyggertal og procentdel positivt testede per testede (heatmaps)
Plottene viser hhv. den ugentlige promille positivt testede per indbyggertal og den ugentlige procent positivt testede per total testede for udvalgte kommuner.  

De udvalgte kommuner er de 30 kommuner der har haft flest positivt testede indenfor den seneste måned.  

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

![](/figures/muni_10_weekly_incidens_tile.png)

For at se ovenstående plot for *alle* kommuner, klik [her](/figures/muni_all_weekly_incidens_tile.png).

![](/figures/muni_10_weekly_pct_tile.png)

For at se ovenstående plot for *alle* kommuner, klik [her](/figures/muni_all_weekly_pos_pct_tile.png).

### Daglige epidemi-indikatorer for hver region

Øverste plot viser det daglige antal nyindlæggelser, procent positivt testede, og antal positivt testede for de seneste tre måneder for hver region.

Nederste plot viser det daglige antal nyindlæggelser og antal positivt testede per 100.000 indbyggere for de seneste tre måneder for hver region.

``SSI datasæt: 'Newly_admitted_over_time', 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series'``


![](/figures/muni_region_all.png)

![](/figures/muni_region_incidens.png)





[Tilbage til toppen](#)

## Plots: aldersgrupper

### Ugentligt antal nye positivt testede og antal førstegangstestede for hver aldersgruppe
Plottet viser det ugentlige antal nye positivt testede og antal førstegangstestede for hver aldersgruppe.

Bemærk at antal testede i de aldersopdelte data er førstegangstestede, altså personer som ikke tidligere er testet. Læs uddybende forklaring [her](/Forklaring.md#testede-og-positive-for-hver-aldersgruppe).

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse.

``SSI datasæt: 'Cases_by_age'``

![](/figures/age_groups_pos_tested.png)

<!--
### Ugentlig procentdel positivt testede for hver aldersgruppe
Plottet viser den ugentlige procentdel af positive tests for hver aldersgruppe.

Bemærk at antal testede i de aldersopdelte data er førstegangstestede, altså personer som ikke tidligere er testet. Dette kan påvirke positivprocenten. Læs uddybende forklaring [her](/Forklaring.md#testede-og-positive-for-hver-aldersgruppe).

``SSI datasæt: 'Cases_by_age'``

![](/figures/age_groups_pct.png)

-->

### Ugentligt antal positivt testede for hver aldersgruppe og ugentligt antal førstegangstestede per aldersgruppe (heatmaps)
Plottene viser hhv. det ugentlige antal positivt testede som promille af befolkningstallet i hver aldersgruppe, og det ugentlige antal førstegangstestede som procent af befolkningstallet i hver aldersgruppe.  

Bemærk at antal testede i de aldersopdelte data er førstegangstestede, altså personer som ikke tidligere er testet. Læs uddybende forklaring [her](/Forklaring.md#testede-og-positive-for-hver-aldersgruppe).

``SSI datasæt: 'Cases_by_age', Danmarks Statistik datasæt: 'FOLK1A'``


![](/figures/age_weekly_incidens_tile.png)

![](/figures/age_weekly_tests_tile.png)

<!--
Ugentlig procentdel positivt testede per aldersgruppe siden maj:

![](/figures/age_weekly_pct_tile_may.png)
-->



### Ugentligt antal positivt testede ældre (&ge; 50 år) vs. yngre (< 50 år)
Plottene viser fordelingen af positivt testede ældre (&ge; 50 år) og yngre (< 50 år). Det øverste plot viser de absolutte antal positive, det nederste viser den relative fordeling mellem de to grupper.

``SSI datasæt: 'Cases_by_age'``

![](/figures/age_group_stack.png)
![](/figures/age_group_fill.png)


### Ugentligt antal nyindlagte og antal nye positivt testede ældre (&ge; 50, 60 eller 70 år)
Plottet sammenligner antal nyindlagte (alle aldersgrupper) med antal nye positivt testede over hhv. 50, 60, eller 70 år.

``SSI datasæt: 'Cases_by_age', 'Newly_admitted_over_time'``

![](/figures/age_group_admitted_pos_old.png)

### Ugentligt antal nyindlagte og antal nye positivt testede yngre (< 50, 60 eller 70 år)
Plottet sammenligner antal nyindlagte (alle aldersgrupper) med antal nye positivt testede under hhv. 50, 60, eller 70 år.

``SSI datasæt: 'Cases_by_age', 'Newly_admitted_over_time'``

![](/figures/age_group_admitted_pos_young.png)

[Tilbage til toppen](#)

## Plots: øvrige sammenligninger

### Dagligt antal dødsfald i Danmark
Plottet viser det totale antal daglige dødsfald i 2020, det daglige antal Covid-19 relaterede dødsfald, og det gennemsnitlige antal daglige dødsfald for perioden 2015-19 (udglattet 7-dages gennemsnit). 

Total antal daglige dødsfald opdateres fredage.

``SSI datasæt: 'Deaths_over_time', Danmarks Statistik datasæt: 'DODC1'``

![](/figures/dst_deaths_covid_all.png)

### Ugentligt antal dødsfald i Danmark
Plottet viser det ugentlige antal dødsfald i 2020, opdelt på Covid-19- og ikke-Covid-19 relaterede dødsfald. Desuden vises det gennemsnitlige antal ugentlige dødsfald for perioden 2015-19. 

``SSI datasæt: 'Deaths_over_time', Danmarks Statistik datasæt: 'DODC1'``

![](/figures/dst_deaths_covid_all_wk.png)




### Dagligt antal akutindlæggelser i Danmark
Plottet viser: 

- det gennemsnitlige daglige antal akutindlæggelser for hver uge i løbet af et år for perioden 2008-18. Data for 2008-17 er justeret til befolkningstallet for 2018. 
- det daglige antal Covid-19 relaterede indlæggelser.

Data for 2008-18 stammer fra Danmarks Statistik (Susanne Brondbjerg via Ulrik Gerdes) og omfatter ikke indlæggelser på privathospitaler eller på psykiatriske afdelinger.

Det skal bemærkes at én person kan stå for flere indlæggelser, og at der er omkring dobbelt så mange *indlæggelser*  som *indlagte personer* i løbet af et år (akut + ikke-akut).

``SSI datasæt: 'Newly_admitted_over_time'``

![](/figures/dst_admissions_covid_all.png)


[Tilbage til toppen](#)

