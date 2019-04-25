class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :invitable,omniauth_providers: [:facebook,:google_oauth2]

  has_one :profile, dependent: :destroy
  has_one :host, dependent: :destroy
  has_one :account_setting, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :login_histories, dependent: :destroy
  after_create :add_host, :add_profile, :add_account_setting

  def self.from_omniauth(provider_data, user)
    if user.present? # user is current_user only if present
      unless User.where("#{provider_data.provider}_uid": provider_data.uid).present?
        user[provider_data.provider + '_uid' ] = provider_data.uid
      else
        @error = "Already connected with some other account"
      end
    else
      user = where("#{provider_data.provider}_uid": provider_data.uid).try(:first)
      unless user.present?
        user = where(email: provider_data.info.email).first_or_initialize
        if user.persisted?
          if user[provider_data.provider + '_uid' ].present?
            unless user[provider_data.provider + '_uid' ].eql?(provider_data.uid)
              @error = "Email already exist, connected with some other account"
            end
          else
            user[provider_data.provider + '_uid' ] = provider_data.uid
          end
        else
          user[provider_data.provider + '_uid' ] = provider_data.uid
          user.password = Devise.friendly_token[0, 20] if user.encrypted_password.blank?
        end
      end
    end
    user.skip_confirmation!

    user.save
    user.update_profile(provider_data)
    return user, @error
  end

  def not_left_a_review_yet?(host_profile)
    !(reviews.where(reviewable_id: host_profile.user.host.id, reviewable_type: 'Host').present?)
  end


  def taken_any_service_from_host?(host_profile)
    # host_profile.host
    # places experiences
    # reviews user_id current_user.id

    # bookings.where(bookable_type: data.class.name, bookable_id: data.id).present?
    # # check if this user have any booking with this host
    # if yes, then already left any review for the same
  end

  def booked_this_resource?(data)
    bookings.where(bookable_type: data.class.name, bookable_id: data.id).try(:last).try(:payment_status)
  end

  def has_authority_to_review?(host_profile)
    host_profile.user.is_host? && (host_profile.user != self) && not_left_a_review_yet?(host_profile)
  end

  def not_provided_any_review_yet?(data)
    data.reviews.where(user_id: id).blank?
  end

  def name
    profile.name
  end

  def reviews_about_you
    host.reviews
  end

  def reviews_by_you
    reviews
  end

  def update_profile(provider_data)
    profile.name = provider_data.info.name if profile.name.blank?
    profile.first_name = (provider_data.info.first_name || profile.name.split(' ').first) if profile.first_name.blank?
    profile.last_name = provider_data.info.last_name || profile.name.split(' ').last if profile.last_name.blank?
    profile.email = provider_data.info.email if profile.email.blank?
    # profile.image = provider_data.info.image
    profile.remote_image_url = provider_data.info.image if profile.image.blank?
    profile.save
  end

  def login_history_details(location_details)
    user_agent = "Chrome/30.0.1599.17 Safari/537.36 linux ubuntu"
    client = DeviceDetector.new(user_agent)
    days_between = (self.current_sign_in_at.day - self.last_sign_in_at.day)
    self.login_histories.create(browser: client.try(:name), device_type: client.try(:device_type), city: location_details.city, region: location_details.region, last_sign_in_at: days_between.to_s)
  end

  def generate_auth_token!
    update(auth_token: Devise.friendly_token)
  end

  def have_hosting_data?
    host.places.present? || host.experiences.present?
  end

  def is_host?
    has_role? :host
  end

  def medium_image
    profile.image.url(:medium)
  end

  def permit_for_email?(mail_for)
    account_setting.send(mail_for)
  end

  def permit_for_message?(msg_for)
    account_setting.send(msg_for)
  end

  def thumb_image
    profile.image.url(:thumb)
  end

  private

    def add_host
      self.build_host.save
    end

    def add_profile
      self.build_profile.save
    end

    def add_account_setting
      self.build_account_setting.save
    end
end
