# Gender Gap in the Diplomatic Environment - Data Analysis
An exploration of gender disparities in diplomatic missions worldwide, with a focus on Italy.

## Overview
This project aims to analyze gender representation in diplomacy from 1961 to 2021, focusing on global diplomatic missions and positioning Italy within a worldwide context.

The data analysis was conducted using **SQL** on a **PostgreSQL** database.

The motivation behind this project stems from my personal curiosity to understand why, in the 21st century, we still discuss gender discrimination. To address this question, I believe it’s essential to focus on every area where this issue may arise, including diplomacy! What better way to find answers than through data? :smiley:

This project was developed during my journey with [start2impact](https://www.start2impact.it/), specifically during the SQL course, and what you see here is the final project.

## Data Source
The analysis is based on data from the [GenDip dataset](https://www.gu.se/en/gendip/the-gendip-dataset-on-gender-and-diplomatic-representation).

For detailed information on the dataset and its columns, please refer to the [codebook](https://www.gu.se/sites/default/files/2023-06/GenDip_Dataset_Codebook_vJune23_2023-06-13.pdf).

## Repository Structure
The repository contains the following components:

- **Diplomazia_Italiana_al_femminile.pdf**: Project presentation
- **GenDip_Dataset_public_mainpostings_anonymous_1968-2021_2023-05-30.xlsx**: Original dataset
- **gendip_dataset.csv**: Dataset converted to CSV for processing via the DBMS - Postgres
- **gendip_query.sql**: SQL queries used for the analysis
  
## Technical Details
For the analysis, PostgreSQL 14.12 and pgAdmin 4 version 7.6 were used.

To convert the XLSX file to CSV and create the template for SQL table creation, the project Create_SQL_script_from_csv_xlsx_dataset was developed.

## Installation
To reproduce the queries, follow these steps:

1. Access pgAdmin.
2. Create a Database.
3. Create the tables: Open the file <i>gendip_query.sql</i> and run the queries from line 1 to 125, which are the queries for table creation.
4. Import the dataset.
5. Reproduce the analysis queries: Run the queries from line 127 to 834.

## License
This project is licensed under the MIT License. Feel free to use, modify, and distribute the code as per the license terms.

## Acknowledgements
I would like to express my gratitude to start2impact for providing the learning platform and resources that enabled me to develop this project.

Special thanks to the creators of the GenDip dataset for making this valuable data available for research purposes.

