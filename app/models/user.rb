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

  has_many :interests, dependent: :destroy
  has_many :categories, through: :interests

  enum classification: [ :editor,
                         :book_developer,
                         :proof_reader,
                         :cover_designer,
                         :copywriter,
                         :interior_layout_designer,
                         :book_marketer ]


  scope :editors, -> { where(admin: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def build_comment
    "#{ENV['TRELLO_USER']}\nemail: #{email}\nclassification: #{pretty_classification}\nphone: #{phone}\naddress: #{street}, #{city}, #{state}, #{zipcode}\npayment method: #{payment_method}\npayment address: #{payment_address}\ncalendly link: #{calendly_link}\nnotes: #{notes}\ninterests: #{categories.pluck(:pretty_name).join(', ')} "
  end

  def build_description
    %(
      \n\<Choose correct labels above\>
      \nContact Information:
      \n-#{ email }
      -#{ phone != "" ? phone : "\<Cell\>" }
      -#{ calendly_link != "" ? calendly_link : "\<Calendly Link\>" }
      General:
      \n-Unique Skillsets: \<Insert/example: Great "fixer\>
      -Interest/Preference: #{categories.length > 0 ? categories.pluck(:pretty_name).join(', ') : "\<Insert\>"}
      -Notes from Freelancer directly: #{ notes != "" || "\<Insert\>" }
      -Currently Assigned Books: \<Link Project Boards\>
      -If no longer working with us: \<Insert reason/archive card - need "firing process?"\>
      Additional Contact Information:
      \n-#{ street != "" && city != "" && state != "" && zipcode != "" ? "#{street}, #{city}, #{state}, #{zipcode}" : "\<Address, City, State, Zip, Time Zone\)" }
      -\<Misc: Gender, DOB/Year, Optional\>
      -\<Social Media Links, Optional\>
      Pay Information:
      \n-\<Pay Rate/Hour\>
      -\<W-9 received, Yes/No\>
      -\<Payment email if different\>
      Bio:
      \n-\<Insert copy or link or attachment\>
      Referral:
      \n-\<Source of referral including name if applicable\>
      Gift Log:
      \n-\<Insert details if any\>
      Previous BIAB books:
      \n-\<Link to closed boards\>
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
      "book_marketer" => "56ddb3f7152c3f92fd5120cd"
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


end
