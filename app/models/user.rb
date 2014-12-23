# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  hashed_password :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'digest'

class User < ActiveRecord::Base
  before_save :encrypt_new_password

  has_one :profile
  has_many :articles, -> { order('published_at DESC, title ASC') }, dependent: :nullify
  has_many :replies, through: :articles, source: :comments

  attr_accessor :password

  validates :email, uniqueness: true,
                    length: { within: 5..50 },
                    format: { with: /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/i }

  validates :password, confirmation: true,
                       length: { within: 4..20 },
                       presence: true,
                       if: :password_required?

  def self.authenticate(email, password)
    user = find_by(email: email)
    return user if user && user.authenticated?(password)
  end

  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end

  protected

    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end

    def password_required?
      hashed_password.blank? || password.present?
    end

    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end
end
