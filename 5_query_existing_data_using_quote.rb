# Example program to return all data for specific record in details and quotes tables

require 'pg'

# Method to return primary id and data for target user from details and quotes tables
def query_name(v_quote)

  begin

    # connect to the database
    conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

    # prepare SQL statement
    conn.prepare('q_statement',
                 "select details.id, name, age, quote
                  from details
                  join quotes on details.id = quotes.details_id
                  where quote = $1")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', [v_quote])

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
p query_name("If you fell down yesterday, stand up today.")

# Sandbox output
# ["6", "Jen", "91", "If you fell down yesterday, stand up today."]