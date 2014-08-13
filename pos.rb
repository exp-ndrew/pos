require 'active_record'
require 'pry'

require './lib/clerk'
require './lib/transaction'
require './lib/purchase'
require './lib/item'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def header
  system 'clear'
  puts "$$==POINT OF SALE==$$"
  puts "\n"
end

def invalid
  puts "Invalid Entry"
  puts "[Hit 'enter' to continue]"
  gets.chomp
end

def main_menu
  header
  puts "1 > Login"
  puts "2 > Create new user"
  input = gets.chomp
  case input
  when '1'
    login
  when '2'
    new_user
  else
    invalid
    main_menu
  end
end

def new_user
  puts "Enter a name for the new user:"
  name = gets.chomp
  puts "Enter a password for this user:"
  password = gets.chomp
  Clerk.create(name: name, password: password)
  puts "New user '#{name}' created!"
  sleep (0.7)
  main_menu
end



def login
  puts "Please type in user name:"
  name = name_check('Clerk')
  puts "Please type in password:"
  password_check(name, gets.chomp)
  clerk_menu
end

def name_check(klass)
  input = gets.chomp
  result = Object.const_get(klass).find_by(name: input)
  if result == nil
    invalid
    main_menu
  end
  input
end

def password_check(name,password)
  user = Clerk.find_by(name: name)
  if password == user.password
    puts "Welcome #{name}!"
  else
    puts "!!INTRUDER DETECTED!!"
    sleep(0.7)
    main_menu
  end
end

def clerk_menu
  header
  puts "1 > Add New Product "
  input = gets.chomp
  case input
  when '1'
    add_product
  end
end

def add_product
  puts "Enter the name of the new product:"
  name = gets.chomp
  puts "Enter the price per unit: (e.g. 1.50)"
  price = gets.chomp
  Item.create(name: name, price: price)
  puts "#{name} was added to the item table!"
  sleep(0.7)
  clerk_menu
end

main_menu
