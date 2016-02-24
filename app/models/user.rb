# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  password_digest        :string
#  email                  :string
#  looking_for_work       :boolean          default(FALSE)
#  admin                  :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  classification         :integer          default(0)
#  phone                  :string
#  street                 :string
#  city                   :string
#  state                  :string
#  zipcode                :string
#  payment_method         :string
#  payment_address        :string
#  calendly_link          :string
#  notes                  :text
#  password_reset_token   :string
#  password_reset_sent_at :datetime
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

  attr_accessor :category

  has_many :interests
  has_many :categories, through: :interests

  enum classification: [ :not_yet_assigned, :first_assignment, :b_list, :a_list, :a_list_outliner, :trial_period, :all_star, :all_star_outliner, :proof_reader, :cover_designer ]

  scope :editors, -> { where(admin: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def has_interest?(category_id)
    ids = interests.pluck(:category_id)
    ids.include?(category_id.to_i)
  end

  def pretty_classification
    case classification
    when "not_yet_assigned"
      "Not Yet Assigned Editor"
    when "first_assignment"
      "First Assignment Editor"
    when "b_list"
      "Probationary Editor"
    when "a_list"
      "Veteran Editor"
    when "all_star"
      "All Star Editor"
    when "a_list_outliner"
      "Veteran Outliners"
    when "trial_period"
      "Trial Period Outliner"
    when "all_star_outliner"
      "All Star Outliner"
    when "proof_reader"
      "Proofreader"
    when "cover_designer"
      "Cover Designer"
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end


end
