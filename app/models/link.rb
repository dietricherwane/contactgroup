class Link < ActiveRecord::Base
	has_many :linklogs
	belongs_to :group
	belongs_to :user
end
