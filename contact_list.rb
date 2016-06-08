require_relative 'contact'


class ContactList



  def run(parameters)
    query = parameters[0]
    case query
    when "list"
      puts "welcome"
      puts Contact.all
    when "new"
      puts "What is contact's name?"
      name = STDIN.gets.chomp
      puts "What is contact's email?"
      email = STDIN.gets.chomp
      Contact.create(name, email)
    when "show"
      puts "Please provide ID for contact"
      id = STDIN.gets.chomp.to_i
      puts Contact.find(id)
    when "search"
      puts"What term are you looking for? (Can be contact name or email)"
      term = STDIN.gets.chomp
      puts Contact.search(term)
    when "update"
      puts "Which #id do you want to update?"
      id = STDIN.gets.chomp
      puts "Please write updated name?"
      new_name = STDIN.gets.chomp
      puts "Please write updated email?"
      new_email = STDIN.gets.chomp
      puts Contact.update(id, new_name, new_email)
    when "delete"
      puts "Which #id do you want to DELETE?"
      id = STDIN.gets.chomp
      puts Contact.destroy(id)
    else
      puts "You have the following options:\n 1. Create new contact Type: \"new\"\n 2. See all contact Type: \"list\"\n 3. Search word Type: \"search\"\n 4. Show contact by providing ID Type:\"show\"\n 5. Update contact using ID Type:\"update\"\n 6. Delete contact using ID Type:\"delete\""
    end
  end

end

contact_list = ContactList.new
contact_list.run(ARGV)

# pdate(id, column, new_info)


# second_method




# if query =="new"
#     puts"What is contact\'s name?"
#     name = gets.chomp
#     puts "What is contact\'s email?"
#     email = gets.chomp
#     Contact.create(name, email)
#   elsif query =="list"
#     puts Contact.all
#   elsif query =="show"
#     puts"Please provide ID for contact"
#     id = gets.chomp.to_i
#     puts Contact.find(id)
#   elsif query =="search"
#     puts"What term are you looking for? (Can be contact name or email)"
#     term = gets.chomp
#     puts Contact.search(term)
#   end