require 'pg'
require_relative 'match_table.rb'

# Class to update all columns for record using data from provided column:value hash
class UpdateRecord

  # Method to update quote to specified value for specified name
  # - hash needs to contain id of current record that needs to be updated
  # - order is not important (the id can be anywhere in the hash)
  def update_columns(columns)

    begin

      # determine the id for the current record
      id = columns["id"]

      # instantiate MatchTable class
      lookup = MatchTable.new

      # connect to the database
      conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

      # iterate through columns hash for each column/value pair
      columns.each do |column, value|

        # we do NOT want to update the id
        unless column == "id"

          # determine which table contains the specified column
          table = lookup.match_table(column)

          # workaround for table name being quoted and column name used as bind parameter
          query = "update " + table + " set " + column + " = $2 where id = $1"

          # prepare SQL statement to update column for specified id
          conn.prepare('q_statement', query)

          # execute prepared SQL statement
          rs = conn.exec_prepared('q_statement', [id, value])

          # deallocate prepared statement variable
          conn.exec("deallocate q_statement")

        end

      end

    rescue PG::Error => e

      puts 'Exception occurred'
      puts e.message

    ensure

      conn.close if conn

    end

  end

end

# Sandbox testing
# column_hash_1 = {"id" => "3", "age" => "74", "num_1" => "100", "quote" => "Set your goals high, and don't stop till you get there."}
# column_hash_2 = {"age" => "93", "num_3" => "77", "id" => "6", "quote" => "The harder the conflict, the more glorious the triumph."}
# update = UpdateRecord.new
# p update.update_columns(column_hash_1)
# p update.update_columns(column_hash_2)