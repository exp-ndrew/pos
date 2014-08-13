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

def wait
  sleep(0.7)
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
  wait
  main_menu
end

def login
  puts "Please type in user name:"
  name = name_check('Clerk').name
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
  result
end

def password_check(name,password)
  user = Clerk.find_by(name: name)
  if password == user.password
    puts "Welcome #{name}!"
    wait
  else
    puts "!!INTRUDER DETECTED!!"
    wait
    main_menu
  end
end

def clerk_menu
  header
  puts "1 > Add New Product"
  puts "2 > Remove Product"
  input = gets.chomp
  case input
  when '1'
    add_product
  when '2'
    remove_product
  end
end

def add_product
  puts "Enter the name of the new product:"
  name = gets.chomp
  puts "Enter the price per unit: (e.g. 1.50)"
  price = gets.chomp
  Item.create(name: name, price: price)
  puts "#{name} was added to the item table!"
  wait
  clerk_menu
end

def remove_product
  list('Item')
  puts "Enter the name of the product you wish to remove:"
  product = name_check('Item')
  puts "#{product.name} was OBLITERATED!!"
  product.destroy
end

def list(klass)
  puts "#{klass.capitalize} List:"
  puts "------------------"
  Object.const_get(klass).all.each { |object| puts object.name }
  puts "------------------"
end

main_menu
