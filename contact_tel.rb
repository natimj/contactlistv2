# require 'csv'
require 'pg'


class Contact
  attr_accessor :name, :email, :telephone
  attr_reader :id

  @@csv_file_path = 'contacts.csv'
  @@conn = PG.connect(
  host: 'localhost',
  dbname: 'contacts',
  user: 'development',
  password: 'development'
  )

  def initialize(id=nil, name, email, telephone)
    @id = id
    @name = name
    @email= email
    @telephone=telephone
  end

  def save
    if id 
      @@conn.exec("UPDATE contacts SET name=$2, email=$3 WHERE id=$1::int;", [id.to_i, name, email])
      @@conn.exec("UPDATE telephones SET telephone=$2 WHERE contact_id=$1::int;", [id.to_i, telephone])
    else
      result = @@conn.exec("INSERT INTO contacts (name, email) VALUES ($1,$2) RETURNING id;", [name, email])
      @id=result[0]["id"].to_i
      @@conn.exec("INSERT INTO telephones (contact_id, telephone) VALUES ($1,$2) RETURNING id;", [id, telephone])
    end
  end

  # def add_phone
  #   @@conn.exec("INSERT INTO telephones (contact_id, telephone) VALUES ($1,$2) RETURNING id;", [id, telephone])
  # end

  def to_s
    "#{id}. Name: #{name} - Email: #{email} - Telephone: #{telephone}"
  end

  def destroy
    @@conn.exec("DELETE FROM contacts WHERE id=$1::int;", [id.to_i])
    @@conn.exec("DELETE FROM telephones WHERE contact_id=$1::int;", [id.to_i])
    puts "Deleted!"
  end


  class << self

    def all
      output = []
      @@conn.exec("SELECT * FROM contacts LEFT JOIN telephones ON contacts.id=telephones.contact_id ORDER BY contacts.id ASC;").each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"], row["telephone"]) # ID is now row[0]
      end
      output
    end

    def create(name, email, telephone)
      # Contact.search_email(email)
      if Contact.search_email(email).empty?
        obj= Contact.new(name, email, telephone)
        obj.save
        obj
      else 
        "Email already exist!"
      end
    end
    
    def find(id)
      id = id.to_i
      output = []
      @@conn.exec("SELECT * FROM contacts LEFT JOIN telephones ON contacts.id=telephones.contact_id WHERE id = $1::int", [id]).each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"], row["telephone"]) # ID is now row[0]
      end
      output
    end

    def search(term)
      term = '%' + term + '%'
      output=[]
      @@conn.exec("SELECT * FROM contacts LEFT JOIN telephones ON contacts.id=telephones.contact_id WHERE name LIKE $1::varchar OR email LIKE $1::varchar", [term]).each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"], row["telephone"])
        end
      output
    end

    def search_email(term)
      term = term 
      output=[]
      @@conn.exec("SELECT * FROM contacts LEFT JOIN telephones ON contacts.id=telephones.contact_id WHERE email = $1::varchar", [term]).each do |row|
        output << Contact.new(row["id"].to_i, row["name"], row["email"], row["telephone"])
        end
        output
    end

    def update(id, new_name, new_email,new_telephone)
      puts find_id = Contact.find(id)
      find_id[0].name = new_name
      find_id[0].email = new_email
      find_id[0].telephone = new_telephone
      find_id[0].save
      Contact.find(id)
    end

    def destroy(id)
      puts find_id = Contact.find(id)
      find_id[0].destroy
    end

    # def find_telephone(id)
    #   output=[]
    #   @@conn.exec("SELECT * FROM telephones JOIN contacts ON contacts.id=telephones.contact_id WHERE contact_id = $1::int", [id.to_i]).each do |row|
    #     output << Contact.new(row["id"].to_i, row["contact_id"], row["telephone"])
    #     p output
    #   end
    # end

  end

end

# Contact.find_telephone(7)

# p vagrant [Week3Day2 (orm)⚡]> bundle install
# Could not locate Gemfile or .bundle/ directoryContact.all

#!/usr/bin/env ruby
# puts Contact.all
# 
# p Contact.create("Mike Lee", "mm@gmail.com", "778-283-3838")
 # p Contact.create("Patrick", "patrick@gmail.com")
 # p Contact.create("Sandy", "sandy@gmail.com")
# p Contact.create("Natalia", "natalia@gmail.com")
puts Contact.all
# puts Contact.search("om")
# puts Contact.find(1)
# p Contact.find(13)
# puts Contact.update(2, "Lily", "lulu@gmail.com", "778-999-8599")

# puts Contact.find(3)
  # puts Contact.destroy(7)
