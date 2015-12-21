class Tag < ActiveRecord::Base
	validates :name, presence: true
	has_many :has_tags
	has_many :articles, through: :has_tags
end
