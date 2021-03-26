---
image: /figures/model_twitter_card.png
title: Model for Covid-19 smitteudvikling i Danmark
description: Estimering af det faktiske antal SARS-CoV-2 smittede
---

# Model for Covid-19 smitteudviklingen i Danmark
Kristoffer T. Bæk og Kasper P. Kepp, oktober 2020

Senest opdateret 26. marts 2021.

<div class="likely">
    <div class="facebook">Del</div>
    <div class="twitter">Tweet</div>
    <div class="linkedin">Del</div>
</div>
<br>




Vi foreslår en simpel model for estimering af antallet af SARS-CoV-2 smittede i Danmark fra februar 2020 til nu. Modellen er baseret på antallet af Covid-19 relaterede dødsfald og tre forskellige estimater for dødeligheden (*infection fatality rate*, IFR). Modellen er empirisk, vil korrelere tæt til dødsfald, og kan ikke bruges til forudsigelse.

## Beregningsmetode

Antal nye smittede er beregnet udfra et 7-dages bagudrettet gennemsnit af antal daglige dødsfald. Det gennemsnitlige antal døde per dag deles med IFR for det pågældende scenarie og tilbagedateres 23 dage, som er den antagede periode fra smittetidspunkt til død.  


## Modellens antagelser:

1) Der er korrelation mellem antal dødsfald og antal smittede.

2) Tid fra smittetidspunkt til død: 23 dage. Inkubationstid: 5 dage. Aktiv smitteperiode: 10 dage.

3) Modellen antager tre forskellige effektive IFR-værdier for de faktiske smittede:

0,6%, 0,37%, og 0,29%.  

IFR estimaterne er baseret på seroprævalensstudier, altså studier der måler hvor mange personer der *har været* smittet.


## Fortolkning af IFR-værdierne:

De tre scenarier kan fortolkes på flere måder, f.eks. bedre behandling og diagnose, underestimeret seroprævalens, skærmning af sårbare grupper. Vi mener ikke at IFR for befolkningen som helhed har ændret sig væsentligt over tid, men eksponeringen af ældre kan have ændret sig. Vi forventer, at de ældre har skærmet sig tidligt i forløbet bedre end gennemsnitsbefolkningen, og ikke har ændret adfærd markant siden da. En meget forsimplet fortolkning  for denne hypotese er:

- Scenarie 1: Danskere over 70 år har eksponering som resten af befolkningen (effektiv IFR = 0.6%)
- Scenarie 2: Danskere over 70 år har ca. dobbelt så god skærmning (samlet effektiv IFR = 0.37%)
- Scenarie 3: Danskere over 70 år har ca. tre gange så god skærmning (samlet effektiv IFR = 0.29%)

Baseret på den simple antagelse at:
- Mennesker under 70 år har IFR = 0.1%. Udgør 85% af befolkningen.
- Mennesker over 70 år har IFR = 3.4%. Udgør 15% af befolkningen.

Dette giver en samlet IFR = 0.6% hvis udbredelsen var konstant på tidspunktet da dødsfaldene blev registreret til IFR beregningen, hvilket de fleste store IFR-studier antager, da dødsfaldene typisk ikke vægtes med prævalensen i smittelommerne (heterogenitet).

Mere rimeligt kan de lavere IFR-værdier betragtes som en konsekvens af både dette og flere andre effekter, og det er derfor ikke rimeligt at lave modellen mere præcis end de usikkerheder, der p.t. eksisterer i IFR-estimaterne.

## Forbehold:
Vi tager forbehold for brugen af en simpel konstant IFR over tid; i virkeligheden korrelerer dødsfald og IFR med det faktiske antal smittede i hver aldersgruppe over tid, hvilket er data, der ikke kendes og derfor ikke med rimelighed kan modelleres.

Vi tager forbehold for, at verdens mange IFR estimater kan være forkerte hvis den målte seroprævalens ikke er præcis, eller hvis personer har været smittet uden at have dannet målbare antistoffer.

## Resultater

[Download planche (PDF)](/figures/Baek_Kepp_model_poster.pdf).

Det mest sandsynlige scenarie vurderes at have samlet IFR = 0.37%.

### Antal dagligt nye smittede
Kurverne angiver det estimerede antal dagligt nye smittede og angiver smittetidspunktet (eksponering).

![](/figures/BK_new_infected.png)

### Antal aktivt smittede
Kurverne angiver det estimerede antal aktivt smittede beregnet udfra en aktiv smitteperiode på 10 dage startende fra dag 5 efter eksponering.

![](/figures/BK_active_infected.png)

### Kumuleret antal smittede
Kurverne angiver det estimerede kumulerede antal smittede.

![](/figures/BK_cumulated.png)


### Dagligt antal nye smittede vs. dagligt antal nyindlæggelser.
Plottet viser det estimerede antal dagligt nye smittede (smittetidspunkt) for Scenarie 2 (IFR = 0.37%) sammenlignet med det observerede antal nyindlæggelser.

![](/figures/BK_new_infected_admitted.png)

### Antal aktivt smittede vs. dagligt antal nye positivt testede.
Plottet viser det estimerede antal aktive smittede for Scenarie 2 (IFR = 0.37%) sammenlignet med det daglige antal positivt testede.

![](/figures/BK_active_infected_cases.png)

### Antal aktivt smittede vs. positivprocent.
Kurven viser det estimerede antal aktive smittede for Scenarie 2 (IFR = 0.37%) sammenlignet med positivprocenten (antal positivt testede ifht antal testede).

![](/figures/BK_active_infected_pct.png)

## Implikationer
- Hvis modellen estimerer antal smittede siden juni korrekt, betyder det at den daglige positivprocent i samme periode overvurderer det reelle antal smittede. Dette kan bl.a. skyldes 1) at kontaktopsporing og test af symptomatiske beriger den daglige *sample* med smittede og/eller 2) at antallet af potentielt PCR positive er større end det reelle antal aktivt smittede.
- Hvis den samlede dødelighed (IFR) er lavere end antaget vil modellen undervurdere antal smittede.
- Hvis den samlede dødelighed (IFR) er højere end antaget vil modellen overvurdere antal smittede.


## Referencer

#### Dansk bloddonorstudie (IFR = 0.08% for 17-69 år)

Erikstrup, C. *et al*. [Estimation of SARS-CoV-2 Infection Fatality Rate by Real-time Antibody Screening of Blood Donors](https://academic.oup.com/cid/advance-article/doi/10.1093/cid/ciaa849/5862661). Clin. Infect. Dis. 2020, ciaa849.

#### Metastudie af estimeret IFR (IFR = 0.6% for seroprævalens-data)
Meyerowitz-Katz, G., Merone, L. [A systematic review and meta-analysis of published research data on COVID-19 infection-fatality rates.](https://www.medrxiv.org/content/10.1101/2020.05.03.20089854v4) medRxiv 2020.05.03.20089854.

#### Mediantider fra infektionstidspunkt
Wilson, N. *et al*. [Case-Fatality Risk Estimates for COVID-19 Calculated by Using a Lag Time for Fatality.](https://dx.doi.org/10.3201/eid2606.200320) Emerg. Infect. Dis. 2020;26(6):1339-1441.

Lauer, S. A. *et al*. [The Incubation Period of Coronavirus Disease 2019 (COVID-19) From Publicly Reported Confirmed Cases: Estimation and Application.](https://doi.org/10.7326/M20-0504) Ann. Intern. Med. 2020 172:9, 577-582
