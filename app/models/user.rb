class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :accounts
  has_many :requests, through: :accounts
  has_many :memberships, through: :accounts
  has_many :groups, through: :memberships

  validates_presence_of :full_name, :phone

  def admin?
    has_role? :admin
  end

  def group_ids
    memberships.pluck(:group_id)
  end
end
