class Profile < ApplicationRecord
  include ActiveSupport
  mount_uploader :image, AvatarUploader
  mount_uploader :govt_id_soft_copy, AvatarUploader
  mount_base64_uploader :govt_id_soft_copy, AvatarUploader
  mount_base64_uploader :user_current_image, AvatarUploader
  has_one :vat_number, dependent: :destroy
  has_one :emergency_contact, dependent: :destroy
  belongs_to :user
  has_many :guest_profiles, dependent: :destroy
  after_create :add_vat_number, :add_emergency_contact

  accepts_nested_attributes_for :vat_number, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :emergency_contact, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :guest_profiles, reject_if: :all_blank, allow_destroy: true

  # validate :govt_id_soft_copy, :validate_minimum_image_size

  countries = ISO3166::Country.all_names_with_codes.collect(&:first)
  calling_codes = []

  ISO3166::Country.all_names_with_codes.collect(&:first).each do |country|
    begin
      calling_codes.push("+" + ISO3166::Country.find_country_by_name("#{country}").country_code)
    rescue
      calling_codes.push(nil)
    end
  end

  COUNTRIES = Hash[countries.zip(calling_codes)]
  GENDER = ["Gender", "Male", "Female", "Others"]
  YEAR = 1918..2018
  DATE = 1..31
  MONTH = Date::MONTHNAMES - [nil]
  TIMEZONE = TimeZone.all
  LANGUAGES = ["Bahasa Indonesia", "Bahasa Melayu", "Català" , "Dansk", "Deutsch", "English", "Español", "Eλληνικά", "Français", "Hrvatski", "Italiano", "Magyar", "Nederlands", "Norsk", "Polski", "Português", "Suomi" ,"Svenska", "Türkçe","Íslenska","Čeština","Русский","ภาษาไทย</","中文 (简体)","中文 (繁體)","日本語","한국어"]
  CURRENCY = ["Argentine peso", "Australian dollar", "Brazilian real", "Bulgarian lev", "Canadian dollar", "Chilean peso", "Chinese yuan", "Colombian peso", "Costa Rican colon", "Croatian kuna", "Czech koruna", "Danish krone", "Emirati dirham", "Euro", "Hong Kong dollar", "Hungarian forint", "Indian rupee", "Israeli new shekel", "Japanese yen", "Malaysian ringgit", "Mexican peso", "Moroccan dirham", "New Taiwan dollar", "New Zealand dollar", "Norwegian krone", "Peruvian sol", "Philippine peso", "Polish zloty", "Pound sterling", "Romanian leu", "Russian ruble", "Saudi Arabian riyal", "Singapore dollar", "South African rand", "South Korean won", "Swedish krona", "Swiss franc", "Thai baht", "Turkish lira", "United States dollar", "Uruguayan peso"]

  # def validate_minimum_image_size
  #   image = MiniMagick::Image.open(Rails.application.secrets[:root_path] + govt_id_soft_copy.url)
  #   unless image[:width] > 400 && image[:height] > 300
  #     errors.add :govt_id_soft_copy, "should be 400x300px minimum!" 
  #   end
  # end

  def add_vat_number
    self.build_vat_number.save
  end

  def add_emergency_contact
    self.build_emergency_contact.save
  end

  def generate_pin
    self.otp = rand(0000..9999).to_s.rjust(4, "0")
    save
  end

  def his_or_her
    gender.eql?('Male') ? 'His' : 'Her'
  end

  def him_or_her
    gender.eql?('Male') ? 'Him' : 'Her'
  end

  def host
    user.host
  end

  def incomplete_profile?
    %w(first_name last_name gender date month year email contact_no).map{|field| send(field).blank? }.any?(true)    
  end

  def self.countries_with_calling_codes
    ISO3166::Country.all_names_with_codes.collect(&:first).each do |country|
      calling_code = ISO3166::Country.find_country_by_name("#{country}").country_code rescue ""
      countries = { "#{country}" => "#{calling_code}" }
    end
    return countries
  end

  def same_number_exist?(mobile_params)
    (contact_no == mobile_params[:contact_no].to_i && mobile_country == mobile_params[:mobile_country])
  end

  def send_pin
    Twilio::REST::Client.new.messages.create(
      to: "#{mobile_country}#{contact_no}",
      from: "+#{Rails.application.secrets.twilio[:phone]}",
      body: "Your one time OTP to verify your number on Homes2hotels is #{otp}"
    )
  end

end
