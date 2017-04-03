require 'pg'

# Class to return the table that contains the specified column
# - needed for generalizing the update statement
class MatchTable

  # Method to identify which table contains the specified column
  def match_table(column)

    begin

      tables = ["details", "numbers", "quotes"]
      target = ""

      # connect to the database
      conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

      # iterate through each table to determine which contains the specified column
      tables.each do |table|

        # prepare SQL statement to update age for specified id
        conn.prepare('q_statement',
                     "select column_name
                      from information_schema.columns
                      where table_name = $1")

        # execute prepared SQL statement
        rs = conn.exec_prepared('q_statement', [table])

        # deallocate prepared statement variable
        conn.exec("deallocate q_statement")

        # return array of columns in table returned by SQL statement
        columns = rs.values.flatten

        # update target with table name if column in table
        target = table if columns.include? column

      end

      return target

    rescue PG::Error => e

      puts 'Exception occurred'
      puts e.message

    ensure

      conn.close if conn

    end

  end

end

# Sandbox testing
# lookup = MatchTable.new
# p lookup.match_table("name")  # "details"
# p lookup.match_table("num_1")  # "numbers"
# p lookup.match_table("quote")  # "quotes"
# p lookup.match_table("garbage")  # ""