use albums_db;
select database();
describe albums;

select *
from albums
where artist = 'Pink Floyd';

select release_date
from albums
where name = 'Sgt. Pepper\'s Lonely Hearts Club Band';

select genre
from albums
where name = 'Nevermind';

select name, release_date
from albums
where release_date between '1990' and '1999';

select name, sales
from albums
where sales < 20;

select name
from albums
where genre = 'Rock'; # selects only exact match for the text in quotes 

select name, genre
from albums
where genre like '%Rock%'; # this will get all albums with rock in the genre

