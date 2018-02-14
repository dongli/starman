create table install(
	id integer primary key,
	name varchar(30),
	version varchar(30),
	prefix varchar(255),
	options varchar(1024),
	time datetime
);
