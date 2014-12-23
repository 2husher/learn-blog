# == Schema Information
#
# Table name: articles
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  body         :text
#  published_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  excerpt      :string(255)
#  location     :string(255)
#  user_id      :integer
#

class Article < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments

  validates :title, presence: true
  validates :body, presence: true
  validates :user, presence: true

  scope :published,   -> { where("published_at IS NOT NULL") }
  scope :draft,       -> { where("published_at IS NULL") }
  scope :recent,      -> { published.where("published_at > ?", 1.week.ago.to_date) }
  scope :where_title, -> (term) { where("title LIKE ?", "%#{term}%") }

  def long_title
    "#{title} - #{published_at}"
  end

  def published?
    published_at.present?
  end

  def owned_by?(owner)
    return false unless owner.is_a?(User)
    user == owner
  end
end
