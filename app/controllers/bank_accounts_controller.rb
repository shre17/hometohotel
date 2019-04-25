class BankAccountsController < ApplicationController
  before_action :check_authentication, only: [:edit, :update]
  before_action :get_bank_details

  def edit;end

  def update
    @bank_account.update(bank_account_params)
    set_new_merchant_account unless @bank_account.errors.any?
    if @bank_account.errors.any?
      flash[:error] = @bank_account.errors.full_messages
    else
      flash[:success] = "Bank details updated successfully"
    end
    redirect_to edit_bank_accounts_path
  end

  def set_new_merchant_account
    bank_info_update
  end

  def bank_info_update
    merchant_account_params = {
      :individual => {
        :first_name => @bank_account.first_name,
        :last_name => @bank_account.last_name,
        :email => @bank_account.email,
        # :phone => "self.user.profile.contact",
        :date_of_birth => @bank_account.dob,
        :ssn => @bank_account.ssn,
        :address => {
          :street_address => @bank_account.street,
          :locality => @bank_account.locality,
          :region => @bank_account.region,
          :postal_code => @bank_account.postal_code
        }
      },
      :funding => {
        :destination => Braintree::MerchantAccount::FundingDestination::Bank,
        :email => @bank_account.email,
        :mobile_phone => @bank_account.mobile_number,
        :account_number => @bank_account.account_number,
        :routing_number => @bank_account.routing_number
      }
    }

    if @bank_account.merchant_id.present?
      Braintree::MerchantAccount.update(@bank_account.merchant_id, merchant_account_params)
    else
      merchant_account_params[:master_merchant_account_id] = Rails.application.secrets[:braintree][:master_merchant_id]
      merchant_account_params[:tos_accepted] = true
      account = Braintree::MerchantAccount.create(merchant_account_params)
      @bank_account.merchant_id = account.merchant_account.id
      @bank_account.status = account.merchant_account.status
      @bank_account.save
    end
  end

  private
    def check_authentication
      redirect_to root_path, notice: "You are not authorized to perform this action" unless (user_signed_in? && current_user.is_host?)
    end

    def get_bank_details
      @bank_account = current_user.host.bank_account
      if @bank_account.blank?
        @bank_account = current_user.host.build_bank_account
        @bank_account.save
      end
    end

    def bank_account_params
      params.require(:bank_account).permit(:first_name, :last_name, :email, :dob, :ssn, :street, :locality, :region, :postal_code, :destination, :funding_email, :mobile_number, :account_number, :routing_number)
    end
end

# def dummy_data
#   data = {}

#   data[:individual] = {}
#   @bank_account.first_name] = "Jane"
#   @bank_account.last_name] = "Doe"
#   @bank_account.email] = "jane@14ladders.com"
#   @bank_account.dob] = "1981-11-19"
#   @bank_account.ssn] = "456-45-4567"

#   @bank_account.address] = {}
#   @bank_account.street] = "111 Main St"
#   @bank_account.locality] = "Chicago"
#   @bank_account.region] = "IL"
#   @bank_account.postal_code] = "60007"

#   data[:funding] = {}
#   @bank_account.destination] = Braintree::MerchantAccount::FundingDestination::Bank
#   @bank_account.email] = "funding@blueladders.com"
#   @bank_account.mobile_phone] = "5555555555"
#   @bank_account.account_number] = "1123581321"
#   @bank_account.routing_number] = "071101307"
#   return data
# end
