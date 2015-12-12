# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string
#  pretty_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_categories_on_name         (name)
#  index_categories_on_pretty_name  (pretty_name)
#

class Category < ActiveRecord::Base
  has_many :interests
  has_many :users, through: :interests

  def self.pretty_names
    pluck(:pretty_name)
  end
end
