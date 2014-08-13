require 'active_record'
require 'pry'

require './lib/clerk'
require './lib/transaction'
require './lib/purchase'
require './lib/item'

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

def login
  puts "Please type in user name:"
  name = gets_check('Clerk', name:)
  puts "Please type in password:"
  puts = gets_check('Clerk', password:)
end

def gets_check(klass,attribute)
  input = gets.chomp
  result = Object.const_get(class_name).find_by(attribute input)
  if result == nil
    invalid
    main_menu
  end
end


main_menu
