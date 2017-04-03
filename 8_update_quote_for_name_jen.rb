require 'pg'

# Method to update quote to specified value for specified name
def update_age(v_name, v_quote)

  begin

    # connect to the database
    conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

    # prepare SQL statement to update age for specified id
    conn.prepare('q_statement',
                 "update quotes
                  set quote = $2
                  from details
                  where name = $1
                  and details.id = quotes.details_id")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', [v_name, v_quote])

    # deallocate prepared statement variable
    conn.exec("deallocate q_statement")

    # prepare SQL statement to confirm update
    conn.prepare('q_statement',
                 "select details.id, name, age, quote
                  from details
                  join quotes on details.id = quotes.details_id
                  where name = $1")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', [v_name])

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
p update_age("Jen", "Quality is not an act, it is a habit.")

# Before update
# ["6", "Jen", "91", "If you fell down yesterday, stand up today."]

# Method output after update
# ["6", "Jen", "91", "Quality is not an act, it is a habit."]