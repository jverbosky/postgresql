require 'pg'

begin

  # db = PGconn.open(dbname: 'test', user: 'something', password: '4321')  # also works
  conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

  res = conn.exec('select 1 as a, 2 as b, NULL as c')

  p res.getvalue(0,0)  # "1"
  p res[0]['b']  # "2"
  p res[0]['c']  # "3"
  p res[0]  # {"a"=>"1", "b"=>"2", "c"=>nil}

rescue PG::Error => e

  puts "Exception occurred"
  puts e.message

ensure

  conn.close if conn

end
