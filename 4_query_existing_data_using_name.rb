require 'pg'

# Method to return primary id and data for target user from details and numbers tables
def query_name(v_name)

  begin

    # connect to the database
    conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

    # prepare SQL statement
    conn.prepare('q_statement',
                 "select details.id, name, age, num_1, num_2, num_3
                  from details
                  join numbers on details.id = numbers.details_id
                  where name = $1")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', [v_name])

    return rs.values[0]

    # deallocate prepared statement variable
    conn.exec("deallocate q_statement")

  rescue PG::Error => e

    puts 'Exception occurred'
    puts e.message

  ensure

    conn.close if conn

  end

end

# Sandbox testing
p query_name("Jim")

# Sandbox output
# ["3", "Jim", "61", "10", "20", "30"]