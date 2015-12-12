# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  password_digest  :string
#  email            :string
#  looking_for_work :boolean          default(FALSE)
#  admin            :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  classification   :integer          default(0)
#  phone            :string
#  street           :string
#  city             :string
#  state            :string
#  zipcode          :string
#  payment_method   :string
#  payment_street   :string
#  payment_city     :string
#  payment_state    :string
#  payment_zipcode  :string
#  calendly_link    :string
#  background       :text
#  notes            :text
#
# Indexes
#
#  index_users_on_admin             (admin)
#  index_users_on_email             (email)
#  index_users_on_looking_for_work  (looking_for_work)
#

class User < ActiveRecord::Base
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  enum classification: [ :not_yet_assigned, :first_assignment, :b_list, :a_list ]

  scope :editors, -> { where(admin: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def pretty_classification
    case classification
    when "not_yet_assigned"
      "Not Yet Assigned"
    when "first_assignment"
      "First Assignment"
    when "b_list"
      "B-list"
    when "a_list"
      "A-list"
    end
  end

end
