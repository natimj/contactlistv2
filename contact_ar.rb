
# require 'pg'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "postgresql",
  :host => "localhost",
  :database => "contacts",
  :user => "development",
  :password => "development"
  )

# class Telephone < ActiveRecord::Base
#   belongs_to :contact
# end


class Contact < ActiveRecord::Base
  # has_many :telephones

  def to_s
    "#{id}, #{name} #{email}"
  end


end


puts Contact.all
