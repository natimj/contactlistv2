# require 'csv'
require 'pg'


class Contact
  attr_accessor :name, :email
  attr_reader :id

  @@csv_file_path = 'contacts.csv'
  @@conn = PG.connect(
  host: 'localhost',
  dbname: 'contacts',
  user: 'development',
  password: 'development'
  )

  def initialize(id=nil, name, email)
    @id = id
    @name = name
    @email= email
  end

  def save
    if id 
      @@conn.exec("UPDATE contacts SET name=$2, email=$3 WHERE id=$1::int;", [id.to_i, name, email])
    else
      result = @@conn.exec("INSERT INTO contacts (name, email) VALUES ($1,$2) RETURNING id;", [name, email])
      @id=result[0]["id"].to_i
    end
  end

  def to_s
    "#{id}. Name: #{name} - Email: #{email}" # MM: add ID here
  end

  def destroy
    @@conn.exec("DELETE FROM contacts WHERE id=$1::int;", [id.to_i])
    puts "Deleted!"
  end


  class << self

    def all
      output = []
      @@conn.exec("SELECT * FROM contacts ORDER BY id ASC;").each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"]) # ID is now row[0]
      end
      output
    end

    def create(name, email)
      # Contact.search_email(email)
      if Contact.search_email(email).empty?
        obj= Contact.new(name, email)
        obj.save
        obj
      else 
        "Email already exist!"
      end
    end
    
    def find(id)
      id = id.to_i
      output=[]
      @@conn.exec("SELECT * FROM contacts WHERE id = $1::int", [id]).each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"])
        end
      output
    end

    def search(term)
      term = '%' + term + '%'
      output=[]
      @@conn.exec("SELECT * FROM contacts WHERE name LIKE $1::varchar OR email LIKE $1::varchar", [term]).each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"])
        end
      output
    end

    def search_email(term)
      term = term 
      output=[]
      @@conn.exec("SELECT * FROM contacts WHERE email = $1::varchar", [term]).each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"])
        end
        output
    end

    def update(id, new_name, new_email)
      find_id = Contact.find(id)
      find_id[0].name = new_name
      find_id[0].email = new_email

      find_id[0].save
      Contact.find(id)
    end

    def destroy(id)
      puts find_id = Contact.find(id)
      find_id[0].destroy
    end


  end

end

# Contact.find_telephone(7)

# p vagrant [Week3Day2 (orm)⚡]> bundle install
# Could not locate Gemfile or .bundle/ directoryContact.all

#!/usr/bin/env ruby
# puts Contact.all

# p Contact.create("Sammy Lee", "sam@gmail.com")
 # p Contact.create("Patrick", "patrick@gmail.com")
 # p Contact.create("Sandy", "sandy@gmail.com")
# p Contact.create("Natalia", "natalia@gmail.com")
# puts Contact.all
# puts Contact.search("eorge")
# puts Contact.find(1)
# p Contact.find(2)
# puts Contact.update(2, "Lily", "lulu@gmail.com")

# puts Contact.find(3)
  # puts Contact.destroy(5)
