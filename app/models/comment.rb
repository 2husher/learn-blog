# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  article_id :integer
#  name       :string(255)
#  email      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  after_create :email_article_author
  after_create :send_comment_email

  belongs_to :article

  validates :name, presence: true
  validates :email, presence: true
  validates :body, presence: true
  validates :article, presence: true

  validate :article_should_be_published

  def article_should_be_published
    if article.present? && !article.published?
      errors.add(:article_id, "is not published yet")
    end
  end

  def email_article_author
    puts "We will notify #{article.user.email} in Chapter 9"
  end

  def send_comment_email
    #Notifier.comment_added(self).deliver
  end
end
