#!/bin/bash

python3 scrape_ssi.py

DOW=$(date +%u)

if [ $DOW -ge 1 ] && [ $DOW -le 5 ]; then

#    Rscript Run_all.R

#    echo "R scripts run"

    (cd ../ && git add .)
    echo "git added"
    (cd ../ && git commit -m "Update plots")
    echo "git committed"
    (cd ../ && git push origin master)
    echo "git pushed"

fi
