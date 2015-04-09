class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  serialize :tmp_params
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable

  has_many :posts
end
