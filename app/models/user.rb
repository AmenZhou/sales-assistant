class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  serialize :tmp_params
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy
  has_many :yelp_grabs, dependent: :destroy

  before_save :set_role

  enum role: [:admin, :normal]

  def admin?
    role == 'admin'
  end

  private

  def set_role
    role = 'normal' if role.nil?
  end
end
