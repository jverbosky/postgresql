require 'pg'
require 'base64'

begin

  # connect to the database
  conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

  # example query to return all column names from details table
  # select column_name from information_schema.columns where table_name='details'

  # prepare data for iteration
  conn.prepare('q_statement', "select * from details join images on details.id = images.details_id")
  rs = conn.exec_prepared('q_statement')

  # Working on reading base64 back out of bytea field - currently getting mangled
  # conn.prepare('q_statement', "select encode(image::bytea, 'UTF8') as image from images")
  # rs = conn.exec_prepared('q_statement')

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
    puts "Image: #{row['image']}"

    # output user image to current directory, use strict base64 decoding
    # image = row['image']
    # f = File.new "#{row['name']}_#{row['id']}_output.png", "wb"
    # f.write(Base64.decode64(image))
    # f.close if f
  end

    # --- Example data ---
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