# Example program to return all data for specific record in details and quotes tables

require 'pg'

begin

  # connect to the database
  conn = PG.connect(dbname: 'test', user: 'something', password: '4321')




rescue PG::Error => e

  puts 'Exception occurred'
  puts e.message

ensure

  conn.close if conn

end