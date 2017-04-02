require 'pg'

begin

  # connect to the database
  conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

  # drop images table if it exists
  conn.exec 'drop table if exists details'

  # create a data table
  conn.exec 'create table details (
      id int primary key,
      name varchar(50),
      age int,
      num_1 int,
      num_2 int,
      num_3 int,
      quote varchar(255)
    )'

  # drop images table if it exists
  conn.exec 'drop table if exists images'

  # create an image table with implied foreign key (details_id)
  conn.exec 'create table images (
      id int primary key,
      details_id int,
      image bytea
    )'

rescue PG::Error => e

  puts "Exception occurred"
  puts e.message

ensure

  conn.close if conn

end