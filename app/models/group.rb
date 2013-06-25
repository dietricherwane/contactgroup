class Group < ActiveRecord::Base
	has_and_belongs_to_many :messages
	has_many :demands
	has_many :links
	belongs_to :category
	belongs_to :user
end
