# GenderGap in Diplomacy Envirnoment - Data Analyst

## Uno sguardo sulla differenza di genere nelle missioni diplomatiche nel mondo e un focus sull’Italia

Il progetto si propone un'analisi della diplomazia dal punto di vista della rappresentanza di genere dal 1961-2021 durante le missioni diplomatiche mondiali, cercando di collocare l'Italia in un panorama mondiale.

L'obiettivo nasce da una mia esigenza personale, di capire perché nel 21° secolo dobbiamo parlare di discriminazione di genere e per rispondere a queste domande, ritengo sia necessario mettere un focus in ogni abito in cui può emeregere questa problematica, anche quello diplomatico! Quale migliore risposta, se non quella di farci aiutare dai dati :smiley:

Questo progetto è nato durante il mio percorso su [start2impact](https://www.start2impact.it/), esattamente quando ho svolto il corso di SQL e quello che state vedendo è il final project.

## Descrizione del progetto

L'analisi si basa sui dati provenienti dal dataset [GenDip](https://www.gu.se/en/gendip/the-gendip-dataset-on-gender-and-diplomatic-representation).

Per i chiarimenti sul dataset e sulle colonne, si rimanda la lettura del [codebook](https://www.gu.se/sites/default/files/2023-06/GenDip_Dataset_Codebook_vJune23_2023-06-13.pdf).

Per effettuare l'analisi, è stato usato PostgreSQL 14.12 e pgadmin4 7.6

## Struttura della repository

All'interno sono state rilasciate i seguenti componenti:

**Diplomazia_Italiana_al_femminile.pdf**: slide riassuntive che spiegano il lavoro svolto
**GenDip_Dataset_public_mainpostings_anonymous_1968-2021_2023-05-30.xlsx**: dataset originale
**gendip_dataset.csv**: dataset trasformato in csv per permetterne la lavorazione tramite iil DBMS
**gendip_query.sql**: query svolte al fine dell'analisi

## Installazione






Lo studio ha seguito 3 fasi:
1. **Analisi del Dataset** : una prima analisi del dataset per capire come fosse strutturato
     
2. **Analisi Mondiale**: una successiva analisi sella situazione mondiale sotto gli aspetti che il dataset poteva mettere a disposizione
      
3. **Analisi Italiana**: un'ultima 
P

Inizieremo con un'analisi a livello mondiale, concentrandoci sui numeri assoluti, per mettere in evidenza la rappresentanza femminile rispetto a quella maschile sotto diversi aspetti.
Successivamente, esamineremo il posizionamento dell'Italia rispetto al contesto mondiale.
Per farlo, lo studio si avvarrà di una serie di grafici che confrontano le percentuali italiane con quelle del resto del mondo, esaminando gli stessi aspetti presi in considerazione nell'analisi mondiale.

Gli step per effettuare l'analisi sono stati i seguenti:

1) descrizione del informazioni dataset
2) conversione xlsx to csv
3) Analisi del dataset
4) importazione dei dataset su postgres
5) estrazione dei dati da postgres e importati su canva per mostrare i grafici nella presentazione
6) 

## Indice
1. [Installazione](#installazione)
2. [Utilizzo](#utilizzo)
3. [Contributi](#contributi)
4. [Licenza](#licenza)
5. [Riferimenti](#riferimenti)

## Installazione

Istruzioni per installare il progetto. Includi i prerequisiti e i comandi necessari.

```bash
# Clona il repository
git clone https://github.com/tuo-username/nome-del-progetto.git

# Entra nella directory del progetto
cd nome-del-progetto

# (Opzionale) Crea un ambiente virtuale
python3 -m venv venv
source venv/bin/activate  # Su Windows usa `venv\Scripts\activate`

# Installa le dipendenze
pip install -r requirements.txt
