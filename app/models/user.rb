class User < ActiveRecord::Base
  validates :role, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Type of user
  ADMIN = 'admin'.freeze
  NORMAL = 'normal'.freeze
  # Public: generates roles
  # Returns - Array
  def self.roles
    [ADMIN, NORMAL]
  end

  # Public: checks the role of the user
  # requested_role - contains the role of the user
  # returns - boolean
  def is?(requested_role)
    role == requested_role.to_s
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id:    id,
      email: email,
      role:  role
    }
    options.empty? ? custom_response : super
  end
end
