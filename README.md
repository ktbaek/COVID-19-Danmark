# Figurer for smitteudvikling i Danmark baseret på data fra SSI
Senest opdateret 7. september 2020 efter kl 14. 

## Data

Data er hentet på [SSI's COVID-19 overvågningsside](https://www.ssi.dk/sygdomme-beredskab-og-forskning/sygdomsovervaagning/c/covid19-overvaagning) hvor de data der kan downloades opdateres mandag-fredag.

Der går typisk 2-3 dage før testdata er helt opdateret. På de grafer der viser daglige testdata er de seneste to dage derfor ikke medtaget. På grafer over nyindlagte og døde er den seneste dag ikke medtaget.   

Kode i R for databehandling og generering af plots findes [her](https://github.com/ktbaek/COVID-19-Danmark/tree/master/code).

*Jeg påtager mig ikke ansvar for eventuelle fejl.* 

## Terminologi
#### Antal positive tests
Antallet af positive tests omtales også som 'antallet af konstaterede/registrerede/bekræftede smittede/tilfælde/smittetilfælde', eller ofte *misvisende* som 'antallet af smittede' eller 'smittetallet' (misvisende fordi vi ikke kender det reelle antal af smittede, kun det antal vi har opdaget ved tests). 

#### Procentdel positive tests
Procentdel positive tests angiver den procentvise andel af positive tests ud af hvor mange der er testet i alt. Omtales også som positivraten eller positivandelen.

## Plots

De første seks figurer er opdaterede versioner af figurerne fra artiklen [Kurven over smittede i Danmark er misvisende](https://link.medium.com/Ldu11b9IQ8).



### Dagligt antal nye positive tests
Plottet viser antallet af nye positive tests for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_1_test_pos.png)

### Dagligt antal testede
Plottet viser det total antal testede personer og antallet af nye positive tests for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_2_tests.png) 

### Daglig procentdel positive tests
Plottet viser procentdelen af nye positive tests ifht. hvor mange der er testet for hele landet fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_3_pct.png) 

### Dagligt antal nye positive tests og procentdelen af  positive tests
Plottet sammenligner forløbet af kurven over antal nye positive tests med kurven over positivandelen for hele landet fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_4_tests_pct.png) 

### Dagligt antal nyindlagte og dødsfald
Plottet viser antal nyindlagte og antal døde for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Deaths_over_time', 'Newly_admitted_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_5_hosp.png) 

### Dagligt antal nyindlagte og antal nye positive tests
Plottet sammenligner hvornår kurven over nyindlagte toppede med hvornår kurven over antal nye positive tests toppede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_6_postest_hosp.png) 

### Dagligt antal nyindlagte og antal nye positive tests (søjleplot)
Plottet sammenligner antal nyindlagte med antal positive tests.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/postest_hosp_barplot.png) 

### Dagligt antal nyindlagte og procent positive tests (søjleplot)
Plottet sammenligner antal nyindlagte med procentdelen af positive tests.

``SSI datasæt: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/pct_hosp_barplot.png) 

### Kontakttallet
SSI beregner to kontakttal (Rt værdi): ét baseret på smittetal og ét baseret på indlagte. Se plots for kontakttallene sammenlignet med hhv. [antal positive tests](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/rt_cases_pos.png), [procent positive tests](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/rt_cases_pct.png), og [antal nyindlagte](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/rt_admitted.png). 


### Ugentligt antal nye positive tests og antal testede for hver kommune (kommuner med flest smittede)
Plottet viser det ugentlige antal nye positive tests og antal testede for de kommuner som på et tidspunkt i perioden fra 1. juli til nu har haft over 10 ugentlige positive. 

Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse. 

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

For at se dette plot for *alle* kommuner, klik [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_all_pos_vs_test_july.png). 

For at se dette plot startende 1. april, klik [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_10_pos_vs_test_april.png).

For at se de **daglige** tal fra 1. august, klik [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_10_pos_vs_test_daily.png).


![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_10_pos_vs_test_july.png) 

### Ugentlig procentdel positive tests for hver kommune (kommuner med flest smittede)
Plottet viser den ugentlige procentdel af positive tests for de kommuner som på et tidspunkt i perioden fra 1. juli til nu har haft over 10 ugentlige positive. 

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

For at se dette plot for *alle* kommuner, klik [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_all_pct_july.png). 

For at se dette plot startende 1. april, klik [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_10_pct_april.png).

For at se de **daglige** tal fra 1. august, klik [her](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_10_pct_daily.png).



![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/muni_10_pct_july.png) 

### Ugentlig procentdel positive tests for hver kommune (alle kommuner)
Plottet viser den ugentlige procentdel af positive tests for alle kommuner.  

``SSI datasæt: 'Municipality_cases_time_series', 'Municipality_tested_persons_time_series``

<img src="https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/all_muni_weekly_pos_pct_tile.png" height="1000"/>

### Ugentligt antal nye positive tests og testede for hver aldersgruppe
Plottet viser det ugentlige antal nye positive tests og antal testede for hver aldersgruppe. 

De ugentlige data er opgjort om onsdagen. Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse. 

``SSI datasæt: 'Cases_by_age'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/age_groups_pos_tested.png)

### Ugentlig procentdel positive tests for hver aldersgruppe
Plottet viser den ugentlige procentdel af positive tests for hver aldersgruppe.

De ugentlige data er opgjort om onsdagen.

``SSI datasæt: 'Cases_by_age'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/age_groups_pct.png) 



### Ugentligt antal positive tests for hhv. ældre (> 50 år) og yngre (< 50 år)
Plottene viser fordelingen af positive tests på ældre (> 50 år) og yngre (< 50 år). Det øverste plot viser de absolutte antal positive, det nederste viser andelen. 

De ugentlige data er opgjort om onsdagen.

``SSI datasæt: 'Cases_by_age'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/age_group_stack.png) 
![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/age_group_fill.png)


### Ugentligt antal nyindlagte og antal nye positive tests for ældre (> 50 år)
Plottet sammenligner antal nyindlagte (alle aldersgrupper) med antal nye positivt testede over 50 år.

De ugentlige data er opgjort om onsdagen.

``SSI datasæt: 'Cases_by_age', 'Newly_admitted_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/age_group_admitted_pos_old.png)

### Ugentligt antal nyindlagte og antal nye positive tests for yngre (< 50 år)
Plottet sammenligner antal nyindlagte (alle aldersgrupper) med antal nye positivt testede under 50 år.

De ugentlige data er opgjort om onsdagen.

``SSI datasæt: 'Cases_by_age', 'Newly_admitted_over_time'``

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/age_group_admitted_pos_young.png)




















