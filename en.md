---
image: /figures/twitter_card.png
title: Covid-19 in Denmark 
Description: Plots showing the Covid-19 epidemic in Denmark
---

# Plots showing the development of the Covid-19 epidemic in Denmark.

Last updated 14 October

[🇩🇰](/index.md) (more plots)

<div class="likely">
    <div class="facebook">Share</div>
    <div class="twitter">Tweet</div>
    <div class="linkedin">Share</div>
</div>
<br>

*New*: See [model](/model.md) for an estimation of the real number of infected (in Danish).

## Data

Data is from the [SSI COVID-19 surveillance site](https://www.ssi.dk/sygdomme-beredskab-og-forskning/sygdomsovervaagning/c/covid19-overvaagning).

On plots showing daily test data, the last two days are not included. On plots showing admitted and deaths, the last day is not included.

Lines show running 7-day average. 

*Cases* indicate people tested positive. 

## Plots
 
### Daily new cases (positive tests) 

``SSI dataset: 'Test_pos_over_time'``

![](/figures/en_test_pos.png)

### Daily number of tested people and cases

``SSI dataset: 'Test_pos_over_time'``

![](/figures/en_tests.png) 

### Daily percentage of positives
Upper plot shows the whole time period, lower plot shows from May 1. 

``SSI dataset: 'Test_pos_over_time'``

![](/figures/en_pct_2.png) 


![](/figures/en_pct.png) 




### Daily admitted and deaths

``SSI dataset: 'Deaths_over_time', 'Newly_admitted_over_time'``

![](/figures/en_hosp.png) 
![](/figures/en_deaths.png) 

### Daily admitted vs. cases and percent positives, respectively

``SSI dataset: 'Test_pos_over_time', 'Newly_admitted_over_time'``

![](/figures/en_postest_admitted_barplot_2.png) 

![](/figures/en_pct_admitted_barplot_2.png)


### Daily deaths vs. cases and percent positives, respectively

``SSI dataset: 'Test_pos_over_time', 'Deaths_over_time'``

![](/figures/en_postest_deaths_barplot_2.png) 

![](/figures/en_pct_deaths_barplot_2.png)


### Daily indicators vs. reopening/restrictions
Upper plots shows the time period from April 1 to August 1, lower plot the time period from July 1 to now. 

``SSI dataset: 'Test_pos_over_time', 'Newly_admitted_over_time', 'Deaths_over_time'``

See [list](/tiltag.md) of reopening/restrictions (in Danish).

![](/figures/en_tiltag_april.png) 

![](/figures/en_tiltag_july.png) 





