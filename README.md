# Figurer for smitteudvikling i Danmark baseret på data fra SSI

## Data

Data er hentet på [SSI's COVID-19 overvågningsside](https://www.ssi.dk/sygdomme-beredskab-og-forskning/sygdomsovervaagning/c/covid19-overvaagning) hvor de data der kan downloades opdateres mandag-fredag.

De datasæt der er brugt her er:
- Antal testede og antal positive tests for hele landet
- Antal testede og antal positive tests per kommune
- Antal testede og antal positive tests per aldersgruppe for hele landet
- Antal nyindlagte og antal døde for hele landet

Der går typisk 2-3 dage før testdata for de seneste dage er helt opdateret. På de grafer der inkluderer testdata er de seneste to dage derfor ikke medtaget.   

## Plots

I mappen [figures -> artikel](https://github.com/ktbaek/COVID-19-Danmark/tree/master/figures) kan man finde opdaterede figurer fra artiklen [Kurven over smittede i Danmark er misvisende](https://link.medium.com/Ldu11b9IQ8).

### Antal positive tests
Plottet viser antallet af positive tests for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_1_test_pos.png)

### Antal testede og antal positive tests
Plottet viser det total antal testede personer og antallet af positive tests for hele landet. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_2_tests.png) 

### Procentdel af positive tests ifht. hvor mange der er testet
Plottet viser positivprocenten for hele landet fra 1. maj. Den optrukne linje viser det løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_3_pct.png) 

### Antal positive tests og procent positive tests
Plottet viser antal positive tests og positivprocenten for hele landet fra 1. maj. De optrukne linjer viser de løbende gennemsnit baseret på et vindue på 7 dage. 

![](https://github.com/ktbaek/COVID-19-Danmark/blob/master/figures/fig_4_tests_pct.png) 



