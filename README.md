# Figurer for smitteudvikling i Danmark baseret på data fra SSI

## Data

Data er hentet på [SSI's COVID-19 overvågningsside](https://www.ssi.dk/sygdomme-beredskab-og-forskning/sygdomsovervaagning/c/covid19-overvaagning) hvor de data der kan downloades opdateres mandag-fredag.

De datasæt der er brugt her er:
- Antal testede og antal positive tests for hele landet.
- Antal testede og antal positive tests per aldersgruppe for hele landet og per kommune
- Antal nyindlagte og antal døde for hele landet

Der går typisk 2-3 dage før testdata for de seneste dage er helt opdateret. På de grafer der inkluderer testdata er de seneste to dage derfor ikke medtaget.   

Kode i R for databehandling og generering af plots findes [her](https://github.com/ktbaek/COVID-19-Danmark/tree/master/code).

## Terminologi
#### Antal positive tests
Antallet af positive tests omtales også som 'antallet af konstaterede/registrerede/bekræftede smittede/tilfælde/smittetilfælde', eller ofte *misvisende* bare som 'antallet af smittede' eller 'smittetallet' (misvisende fordi vi ikke kender det reelle antal af smittede, kun det antal vi har opdaget ved tests). 

#### Procentdel positive tests
Procentdel positive tests angiver den procentvise andel af positive tests ud af hvor mange der er testet i alt. Omtales også som positivraten eller positivandelen.

## Plots

De første seks figurer er opdaterede versioner af figurerne fra artiklen [Kurven over smittede i Danmark er misvisende](https://link.medium.com/Ldu11b9IQ8).



### Dagligt antal nye positive tests
Plottet viser antallet af positive tests for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_1_test_pos.png)

### Dagligt antal testede og antal nye positive tests
Plottet viser det total antal testede personer og antallet af positive tests for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_2_tests.png) 

### Daglig procentdel positive tests
Plottet viser procentdelen af nye positive tests ifht. hvor mange der er testet for hele landet fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_3_pct.png) 

### Dagligt antal nye positive tests og procentdelen af  positive tests
Plottet sammenligner forløbet af kurven over antal nye positive tests med kurven over positivandelen for hele landet fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_4_tests_pct.png) 

### Dagligt antal nyindlagte og dødsfald
Plottet viser antal nyindlagte og antal døde for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_5_hosp.png) 

### Dagligt antal nyindlagte og antal nye positive tests
Plottet sammenligner hvornår kurven over nyindlagte toppede med hvornår kurven over antal nye positive tests toppede. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_6_postest_hosp.png) 

### Dagligt antal nyindlagte og antal nye positive tests (søjleplot)
Plottet sammenligner antal nyindlagte med antal positive tests.

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/postest_hosp_barplot.png) 

### Dagligt antal nyindlagte og procent positive tests (søjleplot)
Plottet sammenligner antal nyindlagte med procentdelen af positive tests.

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/pct_hosp_barplot.png) 


### Ugentligt antal nye positive tests og antal testede for hver kommune (kommuner med flest smittede)
Plottet viser det ugentlige antal nye positive tests og antal testede for kommuner som på et tidspunkt i perioden fra 1. juli til nu har haft over 10 ugentlige positive. 

Plottet opdateres på mandage. Bemærk at antal positive aflæses på højre akse mens antal testede aflæses på venstre akse. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/all_muni_pos_vs_test_july.png) 

### Ugentlig procentdel positive tests for hver kommune (kommuner med flest smittede)
Plottet viser den ugentlige procentdel af positive tests for kommuner som på et tidspunkt i perioden fra 1. juli til nu har haft over 10 ugentlige positive. 

Plottet opdateres på mandage.

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/all_muni_pct_july.png) 

### Ugentlig procentdel positive tests for hver kommune (alle kommuner)
Plottet viser den ugentlige procentdel af positive tests for alle kommuner. 

<img src="https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/all_muni_weekly_pos_pct_tile.png" height="1000"/>


### Ugentlig incidens for hver kommune (alle kommuner)
Plottet viser det ugentlige antal nye positive tests per 100.000 indbyggere for alle kommuner. 

<img src="https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/all_muni_weekly_incidens_tile.png" height="1000"/>













