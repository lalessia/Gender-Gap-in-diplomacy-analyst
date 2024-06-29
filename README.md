# GenderGap in Diplomacy Envirnoment - Data Analisys

## Overview

<h4>Uno sguardo sulla differenza di genere nelle missioni diplomatiche nel mondo e un focus sull’Italia</h4>

Il progetto si propone un'analisi della diplomazia dal punto di vista della rappresentanza di genere dal 1961-2021 durante le missioni diplomatiche mondiali, cercando di collocare l'Italia in un panorama mondiale.

L'obiettivo nasce da una mia esigenza personale, di capire perché nel 21° secolo dobbiamo parlare di discriminazione di genere e per rispondere a queste domande, ritengo sia necessario mettere un focus in ogni abito in cui può emeregere questa problematica, anche quello diplomatico! Quale migliore risposta, se non quella di farci aiutare dai dati :smiley:

Questo progetto è nato durante il mio percorso su [start2impact](https://www.start2impact.it/), esattamente quando ho svolto il corso di SQL e quello che state vedendo è il final project.

## Data source

L'analisi si basa sui dati provenienti dal dataset [GenDip](https://www.gu.se/en/gendip/the-gendip-dataset-on-gender-and-diplomatic-representation).

Per i chiarimenti sul dataset e sulle colonne, si rimanda la lettura del [codebook](https://www.gu.se/sites/default/files/2023-06/GenDip_Dataset_Codebook_vJune23_2023-06-13.pdf).

## Struttura della repository

All'interno della repository sono stati rilasciati i seguenti componenti:

**Diplomazia_Italiana_al_femminile.pdf**: presentazione lavoro

**GenDip_Dataset_public_mainpostings_anonymous_1968-2021_2023-05-30.xlsx**: dataset originale

**gendip_dataset.csv**: dataset trasformato in csv per permetterne la lavorazione tramite iil DBMS

**gendip_query.sql**: query svolte al fine dell'analisi


## Aspetti tecnici

Per effettuare l'analisi, sono stati usati PostgreSQL 14.12 e pgadmin4 7.6.

Per la conversione del file xlsx in csv e la creazione del template per la creazione delle tabelle sql è stato creato il progetto: [Create_SQL_script_from_csv_xlsx_dataset](https://github.com/lalessia/Create_SQL_script_from_csv_xlsx_dataset)

## Installazione

Per riprodurre le query svolte è necessario:
1. Accedere a pgadmin:
2. Creare un Database:
3. Creare le tabelle: Aprire il file <i>gendip_query.sql</i> e lanciare le query dalla riga 1 fino alla 125, che sono le query per la creazione delle tabelle
4. Importare il dataset:
5. Riprodurre le query: dalla riga 127 alla riga 834
