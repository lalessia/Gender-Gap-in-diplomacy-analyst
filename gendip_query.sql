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

--run next code into PLSQL TOOL
--\COPY public.gendip_dataset FROM 'your_path/gendip_dataset.csv' WITH (FORMAT csv, HEADER, DELIMITER ';');

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

-- Panoramica generale mondiale: Quante donne e quanti uomini diplomatici sono stati inviati? 
-- Quanti in percentuale?
select
    g.gender,
    count(*) AS total_diplomatic,
    round(count(*) * 100.0 / sum(count(*)) over(), 1) as percentage
from
    public.gendip_dataset as gd
    inner join public.gender as g on g.id = gd.gender
group by
    gd.gender,
    g.gender;
	
