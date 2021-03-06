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
#  employed               :boolean          default(FALSE)
#  current_capacity       :integer          default(0)
#  next_capacity          :integer          default(0)
#
# Indexes
#
#  index_users_on_admin             (admin)
#  index_users_on_email             (email)
#  index_users_on_looking_for_work  (looking_for_work)
#
require "date"

class User < ActiveRecord::Base
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  attr_accessor :category

  has_many :interests, dependent: :destroy
  has_many :categories, through: :interests

  enum classification: [ :editor,
                         :book_developer,
                         :proof_reader,
                         :cover_designer,
                         :copywriter,
                         :interior_layout_designer,
                         :book_marketer,
                         :indexer,
                         :copyeditor ]


  scope :editors, -> { where(admin: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def build_comment
%(
#{ENV['TRELLO_USER']}
email: #{email}
classification: #{pretty_classification}
phone: #{phone}
address: #{street}, #{city}, #{state}, #{zipcode}
employed full time: #{employed ? "Yes" : "No"}
payment method: #{payment_method}
payment address: #{payment_address}
calendly link: #{calendly_link}
notes: #{notes}
interests: #{categories.pluck(:pretty_name).join(', ')}
capacity this month: #{ current_capacity }
capacity next month: #{ next_capacity }
)
  end

  def monthly_comment
%(
#{ENV['TRELLO_USER']}
Work capacity for #{pretty_month(Date.today.month)}
this month: #{ current_capacity }
next month: #{ next_capacity }
)
  end

  def build_description
%(
_Choose correct labels above_
**Contact Information**:

 - Email: #{ email }
 - Cell: #{ phone }
 - Calendly Link: #{ calendly_link }

**General**:

 - Unique Skillsets: \(Example: Great "fixer\)
 - Interest/Preference: #{ categories.length > 0 ? categories.pluck(:pretty_name).join(', ') : "" }
 - Notes from Freelancer directly: #{ notes }
 - Currently Assigned Books: \(Link Project Boards\)
 - If no longer working with us: \(Insert reason/archive card\)
 - Full-time Job: #{ employed ? "Yes" : "No" }

**Additional Contact Information**:

 - #{ street != "" && city != "" && state != "" && zipcode != "" ? "#{ street }, #{ city }, #{ state }, #{ zipcode }" : "Address, City, State, Zip, Time Zone" }
 - Misc: Gender, DOB/Year \(Optional\)
 - Social Media Links \(Optional\)

**Pay Information**:

- Pay Method:
- Pay Rate/Hour:
- W-9 received: Yes/No
- Payment email if different

**Bio**:

 - Insert copy or link or attachment

**Referral**:

  - Source of referral including name if applicable

**Gift Log**:

  - Insert details if any

**Previous BIAB books**:

  - Link to closed boards

**Work Capacity**:

  - This Month: #{ current_capacity }
  - Next Month: #{ next_capacity }
)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def get_category_label
    freelancer_category_labels[classification]
  end

  def get_interest_label
    categories.pluck(:name).map { |name| interest_labels[name] }
  end

  def has_interest?(category_id)
    ids = interests.pluck(:category_id)
    ids.include?(category_id.to_i)
  end

  def pretty_classification
    case classification
    when "editor"
      "Editor"
    when "book_developer"
      "Book Developer"
    when "proof_reader"
      "Proofreader"
    when "cover_designer"
      "Cover Designer"
    when "copywriter"
      "Copywriter"
    when "interior_layout_designer"
      "Interior Layout Designer"
    when "book_marketer"
      "Book Marketer"
    when "indexer"
      "Indexer"
    when "copyeditor"
      "Copyeditor"
    end
  end

  def freelancer_category_labels
    {
      "editor" => "56c21ad3152c3f92fd0687c9",
      "book_developer" => "56c21ac8152c3f92fd068793",
      "proof_reader" => "56c21adb152c3f92fd0687e2",
      "cover_designer" => "56c21af1152c3f92fd06884f",
      "copywriter" => "56ddb3da152c3f92fd51207f",
      "interior_layout_designer" => "56c21ae5152c3f92fd06880d",
      "book_marketer" => "56ddb3f7152c3f92fd5120cd",
      "copyeditor" => "57c738cd84e677fd362ca289",
      "indexer" => "589e124bced82109ff384225"
    }
  end

  def interest_labels
    {
      "business" => "56ca0559152c3f92fd1ce619",
      "personal_finance" => "56ca0561152c3f92fd1ce61b",
      "sales_and_marketing" => "56ca056f152c3f92fd1ce64e",
      "career_development" => "56ca0575152c3f92fd1ce667",
      "self_improvement" => "56ca0580152c3f92fd1ce687",
      "health_fitness" => "56ca0587152c3f92fd1ce6a0",
      "science" => "56ca0590152c3f92fd1ce6a8",
      "spirituality" => "56ca0598152c3f92fd1ce6b5",
      "sports" => "56ca059c152c3f92fd1ce6c3",
      "technology" => "56ca05a5152c3f92fd1ce6e3",
      "memoir" => "56ca05aa152c3f92fd1ce6f8",
      "miscellaneous" => "56ca05af152c3f92fd1ce6f9"
    }
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def pretty_month(i)
    case i
    when 1
      "January"
    when 2
      "February"
    when 3
      "March"
    when 4
      "April"
    when 5
      "May"
    when 6
      "June"
    when 7
      "July"
    when 8
      "August"
    when 9
      "September"
    when 10
      "October"
    when 11
      "November"
    when 12
      "December"
    end
  end
end
