class Contact < ActiveRecord::Base
  validates_presence_of :name, :reply, :content
end
