# Example program to return all data from details and quotes tables

require 'pg'
# require 'base64'  # keep for future reference

begin

  # connect to the database
  conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

  # reference - example query to return all column names from details table
  # select column_name from information_schema.columns where table_name='details'

  # prepare SQL statement
  conn.prepare('q_statement',
               "select *
                from details
                join numbers on details.id = numbers.details_id
                join quotes on details.id = quotes.details_id")

=begin
  # reference - example query to skip additional id columns in numbers and quotes
  # prepare data for iteration
  conn.prepare('q_statement',
               "select details.id, name, age, num_1, num_2, num_3, quote
               from details
               join numbers on details.id = numbers.details_id
               join quotes on details.id = quotes.details_id")
=end

  # execute prepared SQL statement
  rs = conn.exec_prepared('q_statement')

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

=begin
  # Keep for future reference, but don't use db for images
  # Working on reading base64 back out of bytea field - currently getting mangled
  # conn.prepare('q_statement', "select encode(image::bytea, 'UTF8') as image from images")
  # rs = conn.exec_prepared('q_statement')
=end

  # iterate through each row for user data and image
  rs.each do |row|

    # output user data to console
    puts "Details ID: #{row['id']}"
    puts "Images ID: #{row['details_id']}"
    puts "Name: #{row['name']}"
    puts "Age: #{row['age']}"
    puts "Favorite number 1: #{row['num_1']}"
    puts "Favorite number 2: #{row['num_2']}"
    puts "Favorite number 3: #{row['num_3']}"
    puts "Quote: #{row['quote']}"

=begin
    # Keep for future reference, but don't use db for images
    # output user image to current directory, use strict base64 decoding
    # image = row['image']
    # f = File.new "#{row['name']}_#{row['id']}_output.png", "wb"
    # f.write(Base64.decode64(image))
    # f.close if f
=end

  end

  # --- Example output ---
  # Details ID: 1
  # Images ID: 1
  # Name: John
  # Age: 41
  # Favorite number 1: 7
  # Favorite number 2: 11
  # Favorite number 3: 3
  # Quote: Research is what I'm doing when I don't know what I'm doing.
  # --------------------

rescue PG::Error => e

  puts 'Exception occurred'
  puts e.message

ensure

  conn.close if conn

end