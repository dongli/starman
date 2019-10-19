create table install(
  id integer primary key,
  name varchar(30),
  version varchar(30),
  prefix varchar(512),
  compiler_set varchar(30),
  options varchar(2048),
  time datetime
);
