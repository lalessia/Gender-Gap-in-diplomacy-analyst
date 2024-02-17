/* 
Diplomazia al femminile Query
*/

/* Import Data */

create table public.gendip_dataset
(
year integer,
cnamesend character varying,
mainposting integer,
title integer,
gender integer,
cnamereceive character varying,
ccodesend integer,
ccodealpsend character varying,
ccodeCOWsend integer,
regionsend integer,
GMEsend integer,
v2lgfemlegsend real,
FFPsend integer,
ccodereceive integer,
ccodealpreceive character varying,
ccodeCOWreceive integer,
regionreceive integer,
GMEreceive integer,
FFPreceive integer
);

/*
README: edit correct path and run next code into PLSQL TOOL

\COPY public.gendip_dataset FROM 'your_path/gendip_dataset.csv' WITH (FORMAT csv, HEADER, DELIMITER ';');
*/

create table public.region(
	id integer,
	region character varying,
	primary key (id)
);

insert into
    public.region (id, region)
values
	(0, 'Africa' ),
    (1, 'Asia' ),
    (2, 'Central and North America (including the West Indies)'),
    (3, 'Europe (including Russia)'),
    (4, 'Middle East (including Egypt and Turkey)'),
    (5, 'Nordic countries'),
    (6, 'Oceania'),
    (7, 'South America'),
    (9999, 'Missing');


create table public.gender(
	id integer,
	gender character varying,
	primary key (id)
);

insert into
    public.gender (id, gender)
values
	(0, 'Man' ),
    (1, 'Woman' ),
    (99, 'Missing');	


create table public.title(
	id integer,
	title character varying,
	primary key (id)
);

insert into
    public.title (id, title)
values
	(1, 'Chargé d’affaires' ),
    (2, 'Minister, Internuncios' ),
    (3, 'Ambassador, High Commissioners, Papal Nuncios'),
	(96, 'Acting Chargé d’affaires'),
	(97, 'Acting Ambassador'),
	(98, 'Other'),
	(99, 'Missing');


create table public.main_posting(
	id integer,
	main_posting character varying,
	primary key (id)
);

insert into
    public.main_posting (id, main_posting)
values
	(0, 'Concurrent Accreditations' ),
	(1, 'Main Posting' ),
	(99, 'Missing');


create table public.ffp(
	id integer,
	ffp character varying,
	primary key (id)
);

insert into
    public.ffp (id, ffp)
values
	(0, 'No' ),
	(1, 'Yes' );
	

create table public.gme(
	id integer,
	gme character varying,
	primary key (id)
);

insert into
    public.gme (id, gme)
values
	(0, 'Not GME' ),
	(1, 'GME' );

/* 
SQL EXTRACT DATA 
*/

/*
WORLD ANALYST
*/

/*
--Panoramica generale
*/

-- Panoramica generale mondiale: Quante donne e quanti uomini diplomatici sono stati inviati/ricevuti? 
-- Quanti in percentuale?
select
    g.gender,
    count(*) as total_diplomatic,
    round(count(*) * 100.0 / sum(count(*)) over(), 1) as percentage
from
    public.gendip_dataset as gd
    inner join public.gender as g on g.id = gd.gender
group by
    gd.gender,
    g.gender;
	
--Qual è stata la distribuzione diplomatica delle donne e degli uomini negli anni dal 1968 al 2021?
	
select gd.year, g.gender, count(*)
from 
	public.gendip_dataset as gd
    inner join public.gender as g on g.id = gd.gender
group by gd.year, gd.gender, g.gender 
order by gd.year asc, gd.gender asc;
	

/*
--Analisi incarichi
*/

-- Per ogni incarico, qual è stata la presenza femminile, quella maschile e la presenza femminile in percentuale?
select 
    t.title,
   count(case when gd.gender = '1' then 1 else null end) as total_female,
    count(case when gd.gender = '0' then 1 else null end) as total_male,
    count(case when gd.gender = '99' then 1 else null end) as total_missing,
    round(
        count(case when gd.gender = '1' then 1 else NULL end)::NUMERIC /
        (count(case when gd.gender = '1' then 1 else NULL end) +
        count(case when gd.gender = '0' then 1 else NULL end) +
        count(case when gd.gender = '99' then 1 else NULL end)) * 100.0, 1) as percentage_woman,
		round(
        count(case when gd.gender = '0' then 1 else NULL end)::NUMERIC /
        (count(case when gd.gender = '1' then 1 else NULL end) +
        count(case when gd.gender = '0' then 1 else NULL end) +
        count(case when gd.gender = '99' then 1 else NULL end)) * 100.0, 1) as percentage_man,
		round(
        count(case when gd.gender = '99' then 1 else NULL end)::NUMERIC /
        (count(case when gd.gender = '1' then 1 else NULL end) +
        count(case when gd.gender = '0' then 1 else NULL end) +
        count(case when gd.gender = '99' then 1 else NULL end)) * 100.0, 1) as percentage_missing
from 
    public.gendip_dataset gd
	inner join 
	public.title t
	on gd.title = t.id
group by 
	gd.title,
    t.title
order by 
    gd.title asc;	
	
--Estrazione numero totale di diplomatici divisi per titolo e genere
select 
    t.title,
    count(case when gd.gender = '1' then 1 else null end) as total_female,
    count(case when gd.gender = '0' then 1 else null end) as total_male,
    count(case when gd.gender = '99' then 1 else null end) as total_missing
from 
    public.gendip_dataset gd
	inner join 
	public.title t
	on gd.title = t.id
group by 
	gd.title,
    t.title
order by 
    gd.title asc;	
	
-- estrazione query precedente normalizzata in base logaritmica per permetterne una migliore 
-- visualizzazione dei dati in fase di presentazione
with normalized_data as (
    select 
        title,
        total_female,
        total_male,
        total_missing,
        round(cast(ln(total_female + 1) as NUMERIC), 2) as log_female,
        round(cast(ln(total_male + 1) as NUMERIC), 2) as log_male,
        round(cast(ln(total_missing + 1) as NUMERIC), 2) as log_missing
    from 
        (
            select 
                t.title,
                count(case when gd.gender = '1' then 1 else NULL end) as total_female,
                count(case when gd.gender = '0' then 1 else NULL end) as total_male,
                count(case when gd.gender = '99' then 1 else NULL end) as total_missing
            from 
                public.gendip_dataset gd
                inner join public.title t on gd.title = t.id
            group by 
                t.title
        ) as data
)
select 
    title,
    log_female as log_percentage_female,
    log_male as log_percentage_male,
    log_missing as log_percentage_missing
from 
    normalized_data;

--Analisi main posting: quanti ruoli sono stati assegnati univocamente e in condivisione?
select mp.main_posting, 
	count(case when gd.gender = '1' then 1 else null end) as total_female,
    count(case when gd.gender = '0' then 1 else null end) as total_male,
    count(case when gd.gender = '99' then 1 else null end) as total_missing
from 
	public.gendip_dataset gd 
	inner join 
	public.main_posting mp
	on gd.mainposting = mp.id
group by 
	mp.main_posting, 
	mp.id
order by 
    case 
        when mp.id = 1 then 0
        when mp.id = 0 then 1
      	else 2
    end;
	
--Analisi serie storica andamento main posting
select 
	gd.year,
	count(case when gd.gender = '1' then 1 else null end) as total_female,
    count(case when gd.gender = '0' then 1 else null end) as total_male,
    count(case when gd.gender = '99' then 1 else null end) as total_missing
from 
	public.gendip_dataset as gd
	inner join 
	public.main_posting as mp
	on gd.mainposting = mp.id
where 
	--mp.main_posting = 'Main Posting'
	mp.main_posting = 'Concurrent Accreditations'
group by gd.year, mp.main_posting
order by gd.year;

-- qual è la media per stato, della rappresentanza femminile nelle cariche inferiori per anno?




-------
/*
Qual è stata la rappresentanza diplomatica femminile inviate per Stato?
*/

select cnamesend, g.gender, count(*) --total sended female, --total sended male
from 
	public.gendip_dataset as gd
	inner join public.gender as g on g.id = gd.gender
group by cnamesend, gd.gender, g.gender
order by 1,3 desc


/*
Qual è stata la rappresentanza diplomatica femminile ricevuta per Stato?
*/

/*peso dei missing nella tabella gender*/
select *
from 

select cnamereceive, g.gender, count(*) --total sended female, --total sended male
from 
	public.gendip_dataset as gd
	inner join public.gender as g on g.id = gd.gender
group by cnamereceive, gd.gender, g.gender
order by 1,2

/*
Analisi incarichi
*/

/*
Analisi cariche inferiori
*/
/*
Analisi COW (Correlates of Wars)
*/
/*
Analisi GME
*/

/*
EUROPE ANALYST
*/
	
