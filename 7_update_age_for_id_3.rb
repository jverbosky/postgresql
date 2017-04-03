require 'pg'

# Method to update age to specified value for specified id
def update_age(v_id, v_age)

  begin

    # connect to the database
    conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

    # prepare SQL statement to update age for specified id
    conn.prepare('q_statement',
                 "update details
                  set age = $2
                  where id = $1")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', [v_id, v_age])

    # deallocate prepared statement variable
    conn.exec("deallocate q_statement")

    # prepare SQL statement to confirm update
    conn.prepare('q_statement',
                 "select id, name, age
                  from details
                  where id = $1")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', [v_id])

    # deallocate prepared statement variable
    conn.exec("deallocate q_statement")

    # return array of values returned by SQL statement
    return rs.values[0]

  rescue PG::Error => e

    puts 'Exception occurred'
    puts e.message

  ensure

    conn.close if conn

  end

end

# Sandbox testing
p update_age(3, 62)

# Before update
# ["3", "Jim", "61"]

# Method output after update
# ["3", "Jim", "62"]