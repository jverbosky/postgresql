require 'pg'
require 'base64'

begin

  # user data sets
  user_1 = ["John", 41, 7, 11, 3, "Research is what I'm doing when I don't know what I'm doing."]
  user_2 = ["Jane", 51, 1, 2, 3, "Life is 10% what happens to you and 90% how you react to it."]
  user_3 = ["Jim", 61, 10, 20, 30, "In order to succeed, we must first believe that we can."]
  user_4 = ["Jill", 71, 11, 22, 33, "It does not matter how slowly you go as long as you do not stop"]
  user_5 = ["June", 81, 20, 40, 60, "Problems are not stop signs, they are guidelines."]
  user_6 = ["Jen", 91, 2, 4, 6, "If you fell down yesterday, stand up today."]
  user_7 = ["Jeff", 101, 37, 47, 87, "The way to get started is to quit talking and begin doing."]

  # aggregate user data into multi-dimensional array for iteration
  users = []
  users.push(user_1, user_2, user_3, user_4, user_5, user_6, user_7)

  # connect to the database
  conn = PG.connect(dbname: 'test', user: 'something', password: '4321')

  # determine current max index (id) in details table
  max_id = conn.exec('select max(id) from details')[0]

  # set index variable based on current max index value
  max_id["max"] == nil ? v_id = 1 : v_id = max_id["max"].to_i + 1

  # iterate through multi-dimensional users array for data
  users.each do |user|

    # initialize variables for SQL insert statements
    v_name = user[0]
    v_age = user[1]
    v_num_1 = user[2]
    v_num_2 = user[3]
    v_num_3 = user[4]
    v_quote = user[5]
    d_statement = 'd_statement' + v_id.to_s
    i_statement = 'i_statement' + v_id.to_s

    # # prepare image for database insertion (use strict base64 encoding)
    file_open = File.binread("./public/images/user_#{v_id}.png")
    blob = Base64.strict_encode64(file_open)

    # insert user data into details table
    conn.prepare(d_statement, 'insert into details (id, name, age, num_1, num_2, num_3, quote)
                               values($1, $2, $3, $4, $5, $6, $7)')
    conn.exec_prepared(d_statement, [v_id, v_name, v_age, v_num_1, v_num_2, v_num_3, v_quote])

    # insert user image into images table
    conn.prepare(i_statement, 'insert into images (id, details_id, image)
                               values($1, $2, $3)')
    conn.exec_prepared(i_statement, [v_id, v_id, blob])

    # increment index value for next iteration
    v_id += 1

  end

rescue PG::Error => e

  puts "Exception occurred"
  puts e.message

ensure

  conn.close if conn

end