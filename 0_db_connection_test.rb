require 'pg'

begin

  # db = PGconn.open(dbname: 'test', user: 'something', password: '4321')  # also works
  conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

  rs = conn.exec('select 1 as a, 2 as b, NULL as c')

  p rs.getvalue(0,0)  # "1"
  p rs[0]['b']  # "2"
  p rs[0]['c']  # "3"
  p rs[0]  # {"a"=>"1", "b"=>"2", "c"=>nil}

rescue PG::Error => e

  puts "Exception occurred"
  puts e.message

ensure

  conn.close if conn

end
