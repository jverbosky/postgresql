# after researching, it's not possible to update multiple tables in one statement
# so need to iterate through values and update each corresponding table

# prototype for MatchTable class

require 'pg'

# Method to identify which table contains the specified column
def match_table(column)

  begin

    # connect to the database
    conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

    # reference - example query to return all column names from details table
    # select column_name from information_schema.columns where table_name='details'

    # prepare SQL statement to update age for specified id
    conn.prepare('q_statement',
                 "select column_name
                  from information_schema.columns
                  where table_name = $1")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement', ["details"])

    # deallocate prepared statement variable
    conn.exec("deallocate q_statement")

    # return array of columns in table returned by SQL statement
    columns = rs.values.flatten

    # return table name if column in table
    (columns.include? column) ? "details" : "no match"

  rescue PG::Error => e

    puts 'Exception occurred'
    puts e.message

  ensure

    conn.close if conn

  end

end

# Sandbox testing
p match_table("name")  # "details"
p match_table("num_1")  # "no match"