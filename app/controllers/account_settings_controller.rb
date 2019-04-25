class AccountSettingsController < ApplicationController
  before_action :set_account_setting, only: [:edit, :update]
  before_action :set_current_user,  only: [:settings, :deactivate_account]
  before_action :check_authentication, only: [:settings]

  def edit;end

  def deactivate_account
    @user.deactivation_flag = true
    @user.update(params_for_deactivation)
    sign_out @user
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def reactivating_account
    @user = User.find(params[:id])
  end

  def reactivate_account
    @user = User.find_by_email(params[:user][:email])
    if @user.valid_password?(params[:user][:password])
      @user.update(deactivation_flag: false, selected_deactivation_reason: nil, detailed_reason_for_deactivation: nil)
      sign_in @user
      redirect_to root_path
    else
      redirect_to reactivating_account_account_setting_path(@user), notice: "Please check your password"
    end
  end

  def settings;end

  def update
    @account_setting.update(params_account_setting)
    redirect_to edit_account_setting_path(@account_setting)
  end

  def merchant_account
    merchant_account_params = {
      :individual => {
        :first_name => "approve_me",
        :last_name => "Doe",
        :email => "jane@14ladders.com",
        :phone => "5553334444",
        :date_of_birth => "1981-11-19",
        :ssn => "456-45-4567",
        :address => {
          :street_address => "111 Main St",
          :locality => "Chicago",
          :region => "IL",
          :postal_code => "60622"
        }
      },
      :business => {
        :legal_name => "approve_me",
        :dba_name => "Jane's Ladders",
        :tax_id => "98-7654321",
        :address => {
          :street_address => "111 Main St",
          :locality => "Chicago",
          :region => "IL",
          :postal_code => "60622"
        }
      },
      :funding => {
        :destination => Braintree::MerchantAccount::FundingDestination::Bank,
        :email => "sumit.yuvasoft131@gmail.com",
        :mobile_phone => "5555555555",
        :account_number => "1123581321",
        :routing_number => "071101307"
      },
      :tos_accepted => true,
      :master_merchant_account_id => "p-rro20dduc18ttion_homes2hotels",
      :id => "approve_me_testing"
    }
    result = Braintree::MerchantAccount.create(merchant_account_params)
  end

  private
    def params_account_setting
      params.require(:account_setting).permit(:message_email, :message_push_notification, :message_text_message, :reminder_email, :reminder_push_notification, :reminder_text_message, :promotion_and_tip_email, :promotion_and_tip_push_notification, :promotion_and_tip_text_message, :promotion_and_tip_phone_call, :policy_and_community_email, :policy_and_community_push_notification, :policy_and_community_text_message, :policy_and_community_phone_call, :account_support_email, :account_support_push_notification, :account_support_text_message)
    end

    def params_for_deactivation
      params.require(:user).permit(:selected_deactivation_reason, :detailed_reason_for_deactivation)
    end

    def set_account_setting
      @account_setting = current_user.account_setting
    end

    def set_current_user
      @user = current_user
    end

    def check_authentication
      redirect_to root_path, notice: "This service is temporarily on hold!"
    end
end
