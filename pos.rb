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
  @clerk = nil
  puts "1 > Login"
  puts "2 > Create new user"
  input = gets.chomp
  case input
  when '1'
    login
  when '2'
    new_user
  when '/'
    @clerk = Clerk.new(name: 'cheater')
    clerk_menu
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
  @clerk = name_check('Clerk')
  puts "Please type in password:"
  password_check(@clerk.name, gets.chomp)
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
  puts "--Inventory--"
  puts "1 > List"
  puts "2 > Add"
  puts "3 > Remove"
  puts "4 > Edit"
  puts "--Cart--"
  puts "5 > Add to Cart"
  puts ""
  puts "X > Logout #{@clerk.name}"
  input = gets.chomp.downcase
  case input
  when '1'
    item_list('Item')
    puts "[Hit 'enter' to continue]"
    gets.chomp
    clerk_menu
  when '2'
    add_product
  when '3'
    remove_product
  when '4'
    edit_product
  when '5'
    add_to_cart
  when 'x'
    main_menu
  end
end

def add_product
  puts "Enter the name of the new product:"
  name = gets.chomp
  puts "Enter the price per unit: (e.g. 1.50)"
  price = gets.chomp
  puts "Enter the quantity to add to the stock:"
  quantity = gets.chomp
  grammar = ' was'
  if quantity.to_i > 1
    grammar = "s were"
  end
  Item.create(name: name, price: price, quantity: quantity)
  puts "#{quantity} #{name}#{grammar} added to the inventory!"
  wait
  wait
  clerk_menu
end

def remove_product
  item_list('Item')
  puts "Enter the name of the product you wish to remove:"
  product = name_check('Item')
  puts "#{product.name} was OBLITERATED!!"
  product.destroy
  wait
  clerk_menu
end

def edit_product
  item_list('Item')
  puts 'Enter the name of the product to edit:'
  item = name_check('Item')
  loop do
    puts ""
    puts "--Editing #{item.name}--"
    puts "1 > Change Name"
    puts "2 > Change Price"
    puts "3 > Change Quantity"
    puts "4 > Return to Clerk Menu"
    selection = gets.chomp
    case selection
    when '1'
      edit(item,'name')
    when '2'
      edit(item,'price')
    when '3'
      edit(item,'quantity')
    when '4'
      clerk_menu
    else
      invalid
      edit_product
    end
  end
end


def item_list(klass)
  puts "#{klass.capitalize} item_list:"
  puts "------------------"
  Object.const_get(klass).all.each do |object|
    puts "#{object.name}"
    puts "   - $#{sprintf "%.2f", object.price}"
    puts "   - Quantity: #{object.quantity}"
  end
  puts "------------------"
end

def edit(item, attribute)
  puts "Enter new #{attribute}:"
  change = gets.chomp
  puts "#{item.name} changed to #{change}!"
  result = item.update(attribute.to_sym => change)
end

def list(klass)
  puts ""
  puts "#{klass} list:"
  Object.const_get(klass).all.each do |item|
    puts "#{item.name}"
  end
end

def add_to_cart

  list('Item')
  puts ""
  grammar = ''
  puts "Enter item name:"
  input = gets.chomp
  puts "Enter quantity:"
  quantity_input = gets.chomp
  if quantity_input.to_i > 1
    grammar = "s"
  end
  item = Item.find_by(name: input)
  Purchase.create(item_id: item.id, quantity: quantity_input)
  puts "Added #{quantity_input} #{item.name}#{grammar} to cart!"
  wait
  clerk_menu
end


main_menu
