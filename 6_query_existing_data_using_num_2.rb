require 'pg'

# Method to return primary id and data for target user from details and numbers tables
# Argument targets num_2 in secondary numbers table
def query_name(v_num_2)

  begin

    # connect to the database
    conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

    # prepare SQL statement
    conn.prepare('q_statement',
                 "select details.id, name, age, num_1, num_2, num_3
                  from details
                  join numbers on details.id = numbers.details_id
                  where num_2 = $1")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', [v_num_2])

    # return array of values returned by SQL statement
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
p query_name(40)

# Sandbox output
# ["5", "June", "81", "20", "40", "60"]