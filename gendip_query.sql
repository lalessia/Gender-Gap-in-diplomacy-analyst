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
World Overview
*/

/*
OUTPUT 
columns: 
	gender -> 'Man'/'Woman'/'Missing'
	total_diplomatic -> total diplomats by gender
	percentage -> percentage of diplomats compared to the total
*/
select
    g.gender,
    count(*) as total_diplomatic,
    round(count(*) * 100.0 / sum(count(*)) over(), 1) as percentage
from
    public.gendip_dataset as gd
    inner join public.gender as g on g.id = gd.gender
group by
    g.id,
    g.gender
order by
	g.id;
	
/*
OUTPUT: total diplomats by gender and year
columns: 
	year -> [1968-2021]
	total_man -> total male diplomats for that year
	total_woman -> total female diplomats for that year
	total_missing -> total missing diplomats for that year
*/
select 
	gd.year,
	count(case when gd.gender = '0' then 1 else null end) as total_man,
	count(case when gd.gender = '1' then 1 else null end) as total_woman,
    count(case when gd.gender = '99' then 1 else null end) as total_missing
from 
	public.gendip_dataset as gd
group by 
	gd.year
order by 
	gd.year;
/*
End - World Overview
*/
	
/*
World Analysis - Job title
*/

/*
OUTPUT: for each title shows the presence of gender
columns: 
	title -> [1968-2021]
	percentage_woman -> percentages of women per job title
	percentage_man -> percentages of men per job title
	percentage_missing -> percentages of missing per job title
*/
select 
    t.title,
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

/*
OUTPUT
columns: 
	perc_lower_position -> percentage of presence in lower charge
*/
select 
	round(avg(percentage)::numeric, 1) as perc_lower_position
from(
	select 
		gd.v2lgfemlegsend as percentage, 
		gd.year, 
		gd.cnamesend
	from 
		public.gendip_dataset as gd
	where 
		gd.v2lgfemlegsend != 9999
	group by 
		gd.v2lgfemlegsend, 
		gd.year, 
		gd.cnamesend
);

/*
End World Analysis - Job title
*/

/*
 World Analysis - Mainposting
*/

/*
OUTPUT: total number of diplomats by type of assignment(main_posting/concurrency accreditation) and gender
columns: 
	main_posting -> 'Main Posting'/'Concurrency Accreditations'/'missing'
	total_woman -> total woman by type assignment
	total_man -> total man by type assignment
	total_missing -> total missing by type assignment
*/
select mp.main_posting, 
	count(case when gd.gender = '1' then 1 else null end) as total_woman,
    count(case when gd.gender = '0' then 1 else null end) as total_man,
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
	
/*
OUTPUT: data by mainposting in percentage
columns: 
	main_posting -> 'Main Posting'/'Concurrency Accreditations'/'missing'
	percentage_woman -> percentage woman by type assignment
	percentage_man -> percentage man by type assignment
	percentage_missing -> percentage missing by type assignment
*/
select mp.main_posting, 
	round((count(case when gd.gender = '1' then 1 else null end)::numeric/count(*))*100, 2) as percentage_woman,
    round((count(case when gd.gender = '0' then 1 else null end)::numeric/count(*))*100, 2) as percentage_man,
    round((count(case when gd.gender = '99' then 1 else null end)::numeric/count(*))*100, 2) as percentage_missing
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
/*
 End World Analysis - Mainposting
*/
	
/*
World Analysis - COW
*/
/*
OUTPUT: total diplomats sent with the same COW range, divided by gender
columns: 
ccodecowreceive_range -> range of cow [1-100],[101-200]...[901-1000]
	total_woman -> total woman by COW
	total_man -> total man by COW
	total_missing -> total missing by COW
*/
select 
	case 
		when gd.ccodecowreceive between 1 and 100 then '[1-100]'
		when gd.ccodecowreceive between 101 and 200 then '[101-200]'
		when gd.ccodecowreceive between 201 and 300 then '[201-300]'
		when gd.ccodecowreceive between 301 and 400 then '[301-400]'
		when gd.ccodecowreceive between 401 and 500 then '[401-500]'
		when gd.ccodecowreceive between 501 and 600 then '[501-600]'
		when gd.ccodecowreceive between 601 and 700 then '[601-700]'
		when gd.ccodecowreceive between 701 and 800 then '[701-800]'
		when gd.ccodecowreceive between 801 and 900 then '[801-900]'
		else '[901-1000]'
	end as ccodecowreceive_range,
	sum(case when gd.gender = '0' then 1 else 0 end) as total_man,
	sum(case when gd.gender = '1' then 1 else 0 end) as total_woman,
	sum(case when gd.gender = '99' then 1 else 0 end) as total_missing
from 
	public.gendip_dataset as gd
where 
	gd.ccodecowreceive != 9999
group by 
	case 
		when gd.ccodecowreceive between 1 and 100 then '[1-100]'
		when gd.ccodecowreceive between 101 and 200 then '[101-200]'
		when gd.ccodecowreceive between 201 and 300 then '[201-300]'
		when gd.ccodecowreceive between 301 and 400 then '[301-400]'
		when gd.ccodecowreceive between 401 and 500 then '[401-500]'
		when gd.ccodecowreceive between 501 and 600 then '[501-600]'
		when gd.ccodecowreceive between 601 and 700 then '[601-700]'
		when gd.ccodecowreceive between 701 and 800 then '[701-800]'
		when gd.ccodecowreceive between 801 and 900 then '[801-900]'
		else '[901-1000]'
	end
order by 
	ccodecowreceive_range;
/*
End World Analysis - COW
*/

/*
World Analysis - GME
*/
/*
OUTPUT: total diplomats sent from non-GME countries to GME countries and organized by gender
columns: 
	year -> [1968-2021]
	total_woman -> total women sent to GME states
	total_man -> total men sent to GME states
	total_missing -> total missing sent to GME states
*/
select 
	gd.year,
	count(case when gd.gender = '1' then 1 else null end) as total_woman,
    count(case when gd.gender = '0' then 1 else null end) as total_man,
    count(case when gd.gender = '99' then 1 else null end) as total_missing
from 
	public.gendip_dataset as gd
where 
	gd.gmesend = 0
	and gd.gmereceive = 1
group by 
	gd.year
order by 
	gd.year;
/*
End World Analysis - GME
*/


/*
WORLD VS ITALIAN ANALYSIS
*/

/*
Italy Overview
*/

/*
OUTPUT
columns: 
	percentage_woman -> Percentage of female diplomats in the world from 1968-2021
*/
select 
	round(count(case when gd.gender = '1' then 1 else null end)*100::numeric/count(*), 2) as percent_woman
from
    public.gendip_dataset as gd;
	
/*
OUTPUT
columns: 
	percentage_woman -> Percentage of female diplomats in Italy from 1968-2021
*/
select 
	round(count(case when gd.gender = '1' then 1 else null end)*100::numeric/count(*), 2) as percent_woman
from
    public.gendip_dataset as gd
where
	gd.cnamesend = 'Italy';

/*
OUTPUT: Historical series: percentages of female diplomats in Italy and around the world from 1968 to 2021
columns: 
	year -> [1968-2021]
	world_perc -> percentage of diplomatic representation in the world for the year
	italy_perc -> percentage of diplomatic representation in Italy for the year
	gap_it -> difference between Italy and the world
*/
select 
	w_perc.year, 
	w_perc.perc_world_dip_w as world_perc, 
	i_perc.perc_it_dip_w as italy_perc,
	(i_perc.perc_it_dip_w - w_perc.perc_world_dip_w) as gap_it
from (
	--Get global percentage year-by-year about women rapretentation in the world
	select 
		gd.year,
		round(count(case when gd.gender = '1' then 1 else null end)*100::numeric/count(*), 2) as perc_world_dip_w
	from public.gendip_dataset as gd
	group by 
		gd.year
	) 
	as w_perc
inner join (
	-- Get percentage year-by-year about women rapretentation in Italy
	select 
		gd.year,
		round(count(case when gd.gender = '1' then 1 else null end)*100::numeric/count(*), 2) as perc_it_dip_w
	from 
		public.gendip_dataset as gd
	where 
		gd.cnamesend = 'Italy'
	group by 
		gd.year
) as i_perc
on w_perc.year = i_perc.year
order by 
	year;
	
/*total country*/
/*
OUTPUT
columns: 
	total_country -> total country in dataset
*/
select count(distinct(cnamesend)) as total_country
from public.gendip_dataset as gd
--211

/*
OUTPUT: positioning of Italy in a ranking from the state with the greatest female representation to the least
columns: 
	country -> Italy
	perc_woman -> percentage of women present
	woman_percentage_rank -> position
*/
select 
	country,
	round(woman_percentage,2) as perc_woman_rapres,
	woman_percentage_rank
from(
	select
		country,
		woman_percentage,
		rank() over (order by woman_percentage desc) as woman_percentage_rank
	from (
		select 
			gd.cnamesend as country, 
			count(case when gd.gender = '1' then 1 else NULL end)::numeric / count(gd.gender) as woman_percentage
		from 
			public.gendip_dataset as gd
		group by 
			gd.cnamesend
	)
)
where 
	country = 'Italy';

/*
End Italy Overview
*/

/*
Italy vs World - Job Titles 
*/
/*
OUTPUT
columns: 
	title -> job position
	perc_world_by_title -> percentage of female representation in the world for the specific job title
	perc_italy_by_title -> percentage of female representation in italy for the specific job title
*/
select 
	world_title.title, 
	world_title.perc_world_by_title, 
	coalesce(italy_title.perc_italy_by_title, 0.0) as perc_italy_by_title
from (
	select 
		t.id,
		t.title,
		round(count(case when gd.gender = '1' then 1 else null end)*100::numeric/count(*), 1) as perc_world_by_title
	from 
		public.gendip_dataset as gd
		inner join
		public.title as t on gd.title = t.id
	group by 
		t.id,
		t.title
) as world_title
left join (
	select 
		t.id,
		t.title,
		round(count(case when gd.gender = '1' then 1 else null end)*100::numeric/count(*), 1) as perc_italy_by_title
	from 
		public.gendip_dataset as gd
		inner join
		public.title as t on gd.title = t.id
	where 
		gd.cnamesend = 'Italy' 
	group by 
		t.id,
		t.title) as italy_title
		on italy_title.id = world_title.id
order by world_title.id;

/*Job title - lower charge percentages from Italy*/
/*
OUTPUT
columns: 
	title -> job position
	perc_world_by_title -> percentage of female representation in the world for the specific job title
	perc_italy_by_title -> percentage of female representation in italy for the specific job title
*/
select round(avg(v2lgfemlegsend)::numeric, 2)
from(
	select 
		gd.v2lgfemlegsend
	from 
		public.gendip_dataset as gd
	where 
		gd.cnamesend = 'Italy'
		and gd.v2lgfemlegsend != 9999
	group by 
		gd.v2lgfemlegsend, 
		gd.year
);

/*
OUTPUT
columns: 
	perc_lower_position -> percentage of presence in Italy in lower charge
*/
select 
	round(avg(percentage)::numeric, 1) as perc_lower_position
from(
	select 
		gd.v2lgfemlegsend as percentage, 
		gd.year, 
		gd.cnamesend
	from 
		public.gendip_dataset as gd
	where 
		gd.v2lgfemlegsend != 9999
	group by 
		gd.v2lgfemlegsend, 
		gd.year, 
		gd.cnamesend
);
/*
End Italy vs World - Job Titles 
*/

/*
Italy vs World - mainposting
*/

/*
OUTPUT: percentage of diplomatic missions assigned solely (main posting) to Italian women
columns: 
	mainposting_it_percentage -> percentage of presence in Italy in main_posting
*/
select 
	round(((count(case when gd.gender = '1' then 1 else null end)::numeric)/count(gd.gender)) * 100, 2) as mainposting_it_percentage
from public.gendip_dataset as gd
where 
	gd.cnamesend = 'Italy'
	and gd.mainposting = 1;

/*
OUTPUT: percentage of diplomatic missions assigned solely (main posting) to women worldwide
columns: 
	mainposting_it_percentage -> percentage of presence in world in main_posting
*/
select 
	round(((count(case when gd.gender = '1' then 1 else null end)::numeric)/count(gd.gender)) * 100, 2) as mainposting_world_percentage
from public.gendip_dataset as gd
where 
	gd.mainposting = 1;

/*
OUTPUT: historical series: percentages of women who have had a main posting in Italy and around the world
columns: 
	year -> [1968-2021]
	world_perc -> world percentage
	italy_perc -> italy percentage
*/
select 
world_main_by_year_perc.year,
world_main_by_year_perc.woman_percentage as world_perc,
it_main_by_year_perc.woman_percentage as italy_perc
from(
	select 
		gd.year,
		round((((count(case when gd.gender = '1' then 1 else null end)::numeric)/count(*))*100),2) as woman_percentage
	from 
		public.gendip_dataset as gd
	where 
		gd.mainposting = 1
	group by 
		gd.year
	order by 
		gd.year
) as world_main_by_year_perc
inner join (
	select 
		gd.year,
		round((((count(case when gd.gender = '1' then 1 else null end)::numeric)/count(*))*100),2) as woman_percentage
	from 
		public.gendip_dataset as gd
	where 
		gd.mainposting = 1
		and gd.cnamesend = 'Italy'
	group by 
		gd.year
	order by 
		gd.year
)as it_main_by_year_perc on it_main_by_year_perc.year = world_main_by_year_perc.year;
/*
end Italy vs World - mainposting
*/

/*
Italy vs World - COW
*/
/*
OUTPUT: percentage of women sent based on the COW of the receiving country
columns: 
	cow_range -> [1-100], [101-200]...[901-1000]
	perc_italy -> italy percentage
	perc_world -> world percentage
*/
select 
	cow_italy.ccodecowreceive_range as cow_range, 
	cow_italy.perc_female as perc_italy,
	cow_world.perc_female as perc_world
from (
	--subquery to get statistical element about Italy
	select 
		case 
			when gd.ccodecowreceive between 1 and 100 then '[1-100]'
			when gd.ccodecowreceive between 101 and 200 then '[101-200]'
			when gd.ccodecowreceive between 201 and 300 then '[201-300]'
			when gd.ccodecowreceive between 301 and 400 then '[301-400]'
			when gd.ccodecowreceive between 401 and 500 then '[401-500]'
			when gd.ccodecowreceive between 501 and 600 then '[501-600]'
			when gd.ccodecowreceive between 601 and 700 then '[601-700]'
			when gd.ccodecowreceive between 701 and 800 then '[701-800]'
			when gd.ccodecowreceive between 801 and 900 then '[801-900]'
			else '[901-1000]'
		end as ccodecowreceive_range,
		sum(case when gd.gender = '0' then 1 else 0 end) as male,
		sum(case when gd.gender = '1' then 1 else 0 end) as female,
		sum(case when gd.gender = '99' then 1 else 0 end) as missing,
		count(*) as total,
		round((sum(case when gd.gender = '1' then 1 else 0 end)::numeric)*100/count(*), 1) as perc_female,
		round((sum(case when gd.gender = '0' then 1 else 0 end)::numeric)*100/count(*), 1) as perc_male
	from 
		public.gendip_dataset as gd
	where 
		gd.ccodecowreceive != 9999
		and gd.cnamesend = 'Italy'
	group by 
		case 
			when gd.ccodecowreceive between 1 and 100 then '[1-100]'
			when gd.ccodecowreceive between 101 and 200 then '[101-200]'
			when gd.ccodecowreceive between 201 and 300 then '[201-300]'
			when gd.ccodecowreceive between 301 and 400 then '[301-400]'
			when gd.ccodecowreceive between 401 and 500 then '[401-500]'
			when gd.ccodecowreceive between 501 and 600 then '[501-600]'
			when gd.ccodecowreceive between 601 and 700 then '[601-700]'
			when gd.ccodecowreceive between 701 and 800 then '[701-800]'
			when gd.ccodecowreceive between 801 and 900 then '[801-900]'
			else '[901-1000]'
		end
) as cow_italy 
inner join (
	--subquery to get statistical element about world 
	select 
		case 
			when gd.ccodecowreceive between 1 and 100 then '[1-100]'
			when gd.ccodecowreceive between 101 and 200 then '[101-200]'
			when gd.ccodecowreceive between 201 and 300 then '[201-300]'
			when gd.ccodecowreceive between 301 and 400 then '[301-400]'
			when gd.ccodecowreceive between 401 and 500 then '[401-500]'
			when gd.ccodecowreceive between 501 and 600 then '[501-600]'
			when gd.ccodecowreceive between 601 and 700 then '[601-700]'
			when gd.ccodecowreceive between 701 and 800 then '[701-800]'
			when gd.ccodecowreceive between 801 and 900 then '[801-900]'
			else '[901-1000]'
		end as ccodecowreceive_range,
		sum(case when gd.gender = '0' then 1 else 0 end) as male,
		sum(case when gd.gender = '1' then 1 else 0 end) as female,
		sum(case when gd.gender = '99' then 1 else 0 end) as missing,
		count(*) as total,
		round((sum(case when gd.gender = '1' then 1 else 0 end)::numeric)*100/count(*), 1) as perc_female,
		round((sum(case when gd.gender = '0' then 1 else 0 end)::numeric)*100/count(*), 1) as perc_male
	from 
		public.gendip_dataset as gd
	where 
		gd.ccodecowreceive != 9999
	group by 
		case 
			when gd.ccodecowreceive between 1 and 100 then '[1-100]'
			when gd.ccodecowreceive between 101 and 200 then '[101-200]'
			when gd.ccodecowreceive between 201 and 300 then '[201-300]'
			when gd.ccodecowreceive between 301 and 400 then '[301-400]'
			when gd.ccodecowreceive between 401 and 500 then '[401-500]'
			when gd.ccodecowreceive between 501 and 600 then '[501-600]'
			when gd.ccodecowreceive between 601 and 700 then '[601-700]'
			when gd.ccodecowreceive between 701 and 800 then '[701-800]'
			when gd.ccodecowreceive between 801 and 900 then '[801-900]'
			else '[901-1000]'
		end
) as cow_world
on cow_world.ccodecowreceive_range = cow_italy.ccodecowreceive_range;
/*
End Italy vs World - COW
*/

/*
Italy vs World - GME
*/

/*
OUTPUT
columns: 
	perc_female -> Percent send women in GME zone from Italy
*/
select 
	round((sum(case when gd.gender = '1' then 1 else 0 end)::numeric)*100/count(*), 1) as perc_female
from 
	public.gendip_dataset as gd
where 
	gd.gmereceive = 1
	and gd.gmesend = 0
	and gd.cnamesend = 'Italy';

/*
OUTPUT
columns: 
	perc_female -> Percent send women in GME zone from world
*/
select 
	round((sum(case when gd.gender = '1' then 1 else 0 end)::numeric)*100/count(*), 1) as perc_female
from 
	public.gendip_dataset as gd
where 
	gd.gmereceive = 1
	and gd.gmesend = 0;

/*
OUTPUT: Percent send women in GME zone year-by-year from Italy and World
columns: 
	year -> [1968-2021]
	perc_wor_women -> percentage of women sent to GME states in the specific year
	perc_ita_women -> percentage of women from italy sent to GME states in the specific year
*/
with tot_numbers as(
	select 
		year,
		gd.cnamesend,
		sum(case when gd.gender = '0' then 1 else 0 end) as male,
		sum(case when gd.gender = '1' then 1 else 0 end) as female,
		sum(case when gd.gender = '99' then 1 else 0 end) as missing
	from public.gendip_dataset as gd
	where 
		gd.gmereceive = 1
		and gd.gmesend = 0
	group by 
		gd.year,
		gd.cnamesend
)
select 
	percent_women_gme_world_by_year.year,
	percent_women_gme_world_by_year.percent_women as perc_wor_women,
	percent_women_gme_italy_by_year.percent_women as perc_ita_women
from (
	select 
		tn.year, 
		round((sum(female)::numeric/(sum(male)+sum(female)+sum(missing)))*100, 2) as percent_women
	from 
		tot_numbers tn
	group by 
		tn.year
) as percent_women_gme_world_by_year
inner join 
(
	select 
		tn.year, 
		round((sum(female)::numeric/(sum(male)+sum(female)+sum(missing)))*100, 2) as percent_women
	from 
		tot_numbers tn
	where 
		tn.cnamesend='Italy'
	group by 
		tn.year
) as percent_women_gme_italy_by_year
on percent_women_gme_italy_by_year.year = percent_women_gme_world_by_year.year
order by 
	year;

/*
End Italy vs World - GME
*/