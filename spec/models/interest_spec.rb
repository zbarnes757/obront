# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_category_id  (category_id)
#  index_interests_on_user_id      (user_id)
#

require 'rails_helper'

RSpec.describe Interest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
