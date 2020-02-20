class User < ActiveRecord::Base
  include ActiveModel::Validations
  self.table_name  = 'users'
  has_many :tasks, through: :lists
  has_many :lists, dependent: :destroy
  # TO_DO: set mass assignment limits

  has_secure_password
  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name,  presence: true, length: { maximum: 100 }
  validates :email,      presence: true, uniqueness: true,  format: { with: URI::MailTo::EMAIL_REGEXP }

  def as_json(options = nil)
    super({ only: [:email, :first_name, :last_name] }.merge(options || {}))
  end
end

# params = { first_name: "Akhil", last_name: "Sankar", email: "akhil.sankar@gmail.com", password: "mypassword" }