class User < ActiveRecord::Base
  include ActiveModel::Validations

  has_secure_password

  self.table_name  = 'users'
  has_many :lists
  # TO_DO: set mass assignment limits

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name,  presence: true, length: { maximum: 100 }
  validates :email,      presence: true, uniqueness: true,  format: { with: URI::MailTo::EMAIL_REGEXP }

  def as_json(options = nil)
    super({ only: [:email, :first_name, :last_name] }.merge(options || {}))
  end
end

# params = { first_name: "Akhil", last_name: "Sankar", email: "akhil@gmail.com", password: "mypassword" }