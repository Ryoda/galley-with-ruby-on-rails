class Article < ActiveRecord::Base
	belongs_to :user
	has_many :comments
	has_many :has_tags
	has_many :tags, through: :has_tags
	before_save :set_visits_count
	after_create :save_categories

	has_attached_file :cover, styles: { medium: "1280x720", thumb: "400x200"}
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

	def tags=(value)
		@tags = value
	end

	def update_visits_count
		self.visits_count ||= 0
		self.update(visits_count: self.visits_count + 1)
	end

	private
	def set_visits_count
		self.visits_count ||= 0
	end

	def save_categories
		@tags.each do |id|
			HasTag::create(tag_id: id, article_id: self.id);
		end
	end

end
