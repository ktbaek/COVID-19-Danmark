# Figurer for smitteudvikling i Danmark baseret på data fra SSI
Senest opdateret 25. september 2020 efter kl 14. 

## Data

Data er hentet på [SSI's COVID-19 overvågningsside](https://www.ssi.dk/sygdomme-beredskab-og-forskning/sygdomsovervaagning/c/covid19-overvaagning) hvor de data der kan downloades opdateres mandag-fredag.

Der går typisk 2-3 dage før testdata er helt opdateret. På de grafer der viser daglige testdata er de seneste to dage derfor ikke medtaget. På grafer over nyindlagte og døde er den seneste dag ikke medtaget.  

Befolkningstal per aldersgruppe er hentet på [Danmarks Statistik](https://statbank.dk) 

Kode i R for databehandling og generering af plots findes [her](https://github.com/ktbaek/COVID-19-Danmark/tree/master/code).

Læs en uddybende forklaring af datafiler, begreber og beregninger [her](/data/Forklaring.md).

<!--
*Update: Plots over tests for forskellige aldersgrupper er indtil videre fjernet fra forsiden, da SSIs aldersopdelte datasæt, i modsætning til de øvrige datasæt brugt her, ikke tillader en præcis beregning af tidsserier. Tendensen som ses i disse plots holder dog stadig, og plotsene kan derfor stadig findes [her](https://github.com/ktbaek/COVID-19-Danmark/tree/master/figures). Jeg overvejer en anden måde at plotte disse data på.*
-->

*Siden er under løbende udvikling. Jeg påtager mig ikke ansvar for eventuelle fejl.* 

## Terminologi
#### Antal positivt testede
Antallet af positivt testede omtales også som 'antallet af påviste/konstaterede/registrerede/bekræftede smittede/tilfælde/smittetilfælde', eller ofte *misvisende* som 'antallet af smittede' eller 'smittetallet' (misvisende fordi vi ikke kender det reelle antal af smittede, kun det antal vi har opdaget ved tests). 

Positivt testede angiver personer, som *for første gang er testet positive* for COVID-19, og kan derfor også omtales som **nye positive**. De to begreber beskriver det samme.

#### Procentdel positivt testede
Procentdel positivt testede angiver den procentvise andel af personer der er testede positiv ud af hvor mange der er testet i alt. Omtales også som positivraten, positivprocenten eller positivandelen.

## Plots

Nogle af figurerne er opdaterede versioner af figurerne fra artiklen [Kurven over smittede i Danmark er misvisende](https://link.medium.com/Ldu11b9IQ8).



### Dagligt antal nye positivt testede personer
Plottet viser antallet af nye positivt testede personer for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/fig_1_test_pos.png)

### Dagligt antal testede personer
Plottet viser det totale antal testede personer og antallet af nye positivt testede personer for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/fig_2_tests.png) 

### Daglig procentdel positivt testede personer
Plottet viser procentdelen af nye positivt testede personer ifht. hvor mange der er testet for hele landet i hhv. hele perioden og fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/fig_3A_pct.png) 


![](/figures/fig_3_pct.png) 


### Dagligt antal positivt testede og procentdelen af  positivt testede
Plottet sammenligner forløbet af kurven over antal positivt testede personer med kurven over positivandelen for hele landet fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/fig_4_tests_pct.png) 

### Dagligt antal nyindlagte og dødsfald
Plottet viser antal nyindlagte og antal døde for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Deaths_over_time', 'Newly_admitted_over_time'``

![](/figures/fig_5_hosp.png) 

### Dagligt antal testede, antal nye positive og procent positive testede
Plottet viser det totale antal testede personer, antallet af nye positivt testede personer, og procentdelen af positivt testede personer for hele landet. Procentdelen af positivt testede er vist som et løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](/figures/pos_tests_pct.png) 

### Dagligt antal nyindlagte vs. hhv. antal nye positivt testede og procent positivt testede (søjleplot)
Plottene sammenligner antal nyindlagte med hhv. antal positivt testede og procentdelen af positivt testede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](/figures/postest_admitted_barplot_2.png) 

![](/figures/pct_admitted_barplot_2.png)

Se "spejlvendte" plots uden løbende gennemsnit for [antal positive](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/postest_admitted_barplot.png) og [positivprocent](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/pct_admitted_barplot.png).




### Dagligt antal døde vs. hhv. antal nye positivt testede og procent positivt testede (søjleplot)
Plottene sammenligner antal døde med hhv. antal positivt testede og procentdelen af positivt testede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage.

``SSI datasæt: 'Test_pos_over_time', 'Deaths_over_time'``

![](/figures/postest_deaths_barplot_2.png) 

![](/figures/pct_deaths_barplot_2.png)

Se "spejlvendte" plots uden løbende gennemsnit for [antal positive](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/postest_deaths_barplot.png) og [positivprocent](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/pct_deaths_barplot.png).

### Kontakttallet
SSI beregner to kontakttal (Rt værdi): ét baseret på smittetal og ét baseret på indlagte. Se plots for kontakttallene sammenlignet med hhv. [antal positive tests](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/rt_cases_pos.png), [procent positive tests](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/rt_cases_pct.png), og [antal nyindlagte](https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/rt_admitted.png). 


### Ugentligt antal nye positivt testede og antal testede for hver kommune
Plottet viser det ugentlige antal nye positivt testede og antal total testede for de kommuner som på et tidspunkt i perioden fra 1. juli til nu har haft over 20 ugentlige positive. 

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse. 

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

For at se dette plot for *alle* kommuner, klik [her](/figures/muni_all_pos_vs_test_july.png). 

For at se dette plot startende 1. april, klik [her](/figures/muni_10_pos_vs_test_april.png).

For at se plot med de **daglige** tal fra 1. august, klik [her](/figures/muni_10_pos_vs_test_daily.png).


![](/figures/muni_10_pos_vs_test_july.png) 

### Ugentlig procentdel positivt testede for hver kommune
Plottet viser den ugentlige procentdel af positivt testede for de kommuner som på et tidspunkt i perioden fra 1. juli til nu har haft over 20 ugentlige positive. 

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

For at se dette plot for *alle* kommuner, klik [her](/figures/muni_all_pct_july.png). 

For at se dette plot startende 1. april, klik [her](/figures/muni_10_pct_april.png).

For at se plot med de **daglige** tal fra 1. august, klik [her](/figures/muni_10_pct_daily.png).



![](/figures/muni_10_pct_july.png) 

### Ugentligt antal positivt testede per indbyggertal og procentdel positivt testede per testede (heatmaps)
Plottene viser hhv. den ugentlige promille positivt testede per indbyggertal og den ugentlige procent positivt testede per total testede for udvalgte kommuner.  

De udvalgte kommuner har på et tidspunkt i perioden fra 1. juli til nu har haft over 20 ugentlige positive. 

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

![](/figures/muni_10_weekly_incidens_tile.png)

For at se ovenstående plot for *alle* kommuner, klik [her](/figures/all_muni_weekly_incidens_tile.png). 

![](/figures/muni_10_weekly_pct_tile.png)

For at se ovenstående plot for *alle* kommuner, klik [her](/figures/all_muni_weekly_pos_pct_tile.png).

### Ugentligt antal nye positivt testede og antal *nye* testede for hver aldersgruppe
Plottet viser det ugentlige antal nye positivt testede og antal nye testede for hver aldersgruppe. 

Bemærk at antal testede i de aldersopdelte data er *nye* testede, altså personer som ikke tidligere er testet. Læs uddybende forklaring [her](/data/Forklaring.md#testede-og-positive-for-hver-aldersgruppe). 

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse. 

``SSI datasæt: 'Cases_by_age'``

![](/figures/age_groups_pos_tested.png)

### Ugentlig procentdel positivt testede for hver aldersgruppe
Plottet viser den ugentlige procentdel af positive tests for hver aldersgruppe.

Bemærk at antal testede i de aldersopdelte data er *nye* testede, altså personer som ikke tidligere er testet. Dette kan påvirke positivprocenten. Læs uddybende forklaring [her](/data/Forklaring.md#testede-og-positive-for-hver-aldersgruppe). 

``SSI datasæt: 'Cases_by_age'``

![](/figures/age_groups_pct.png) 

### Ugentligt antal positivt testede for hver aldersgruppe, ugentlig procentdel positivt testede for hver aldersgruppe, og ugentligt antal nye testede per aldersgruppe (heatmaps)
Plottene viser hhv. det ugentlige antal positivt testede som promille af befolkningstallet i hver aldersgruppe, den ugentlige procentdel af positivt testede i hver aldersgruppe, og det ugentlige antal nye testede som procent af befolkningstallet i hver aldersgruppe .  

Bemærk at antal testede i de aldersopdelte data er *nye* testede, altså personer som ikke tidligere er testet. Dette kan påvirke positivprocenten og antal testede. Læs uddybende forklaring [her](/data/Forklaring.md#testede-og-positive-for-hver-aldersgruppe).

``SSI datasæt: 'Cases_by_age', DST datasæt: Befolkningsfordeling på aldersgrupper``


![](/figures/age_weekly_incidens_tile.png)

![](/figures/age_weekly_pct_tile.png)

![](/figures/age_weekly_tests_tile.png)

Ugentlig procentdel positivt testede per aldersgruppe siden maj:

<img align="right" height="500"  src="https://raw.githubusercontent.com/ktbaek/COVID-19-Danmark/master/figures/age_weekly_pct_tile_may.png">

<br clear="right"/>




### Ugentligt antal positivt testede ældre (&ge; 50 år) vs. yngre (< 50 år)
Plottene viser fordelingen af positivt testede ældre (&ge; 50 år) og yngre (< 50 år). Det øverste plot viser de absolutte antal positive, det nederste viser den relative fordeling mellem de to grupper. 

``SSI datasæt: 'Cases_by_age'``

![](/figures/age_group_stack.png) 
![](/figures/age_group_fill.png)


### Ugentligt antal nyindlagte og antal nye positivt testede ældre (&ge; 50 år)
Plottet sammenligner antal nyindlagte (alle aldersgrupper) med antal nye positivt testede over 50 år.

``SSI datasæt: 'Cases_by_age', 'Newly_admitted_over_time'``

![](/figures/age_group_admitted_pos_old.png)

### Ugentligt antal nyindlagte og antal nye positivt testede yngre (< 50 år)
Plottet sammenligner antal nyindlagte (alle aldersgrupper) med antal nye positivt testede under 50 år.

``SSI datasæt: 'Cases_by_age', 'Newly_admitted_over_time'``

![](/figures/age_group_admitted_pos_young.png)



















