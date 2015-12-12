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

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
