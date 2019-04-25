module Api::V1
  class BankAccountsController < BaseApiController
    before_action :validate_params,  only: [:update, :show, :edit]
    before_action :get_bank_details, only: [:update, :show, :edit]



    def edit;end

    def show
      #render json: {status: "success", bank: @bank_account}
    end

    def update
      @bank_account.update(bank_account_params)
      set_new_merchant_account
      #render json: {status: "success", bank: @bank_account}
    rescue #Braintree::NotFoundError => e
      @status = "failure"
      @message = @account.message
      # render json: {status: "failure", message: @account.message, bank: @bank_account}
      #redirect_to edit_bank_accounts_path
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
          @account = Braintree::MerchantAccount.create(merchant_account_params)
          @bank_account.merchant_id = @account.merchant_account.id
          @bank_account.status = @account.merchant_account.status
          @bank_account.save
        end

    end

    private


    def validate_params
        raise "Invaid Bank ID for that Token: #{params[:id]}" unless @current_user.host.bank_account.id == params[:id].to_i
      rescue => e
        render json: {status: "failure", error: e.message}, status: 406
      end

    def get_bank_details
      @bank_account = @current_user.host.bank_account
      # if @bank_account.blank?
      #   @bank_account = @current_user.host.build_bank_account
      #   @bank_account.save
      # end
    end

    def bank_account_params
      params.require(:bank_account).permit(:first_name, :last_name, :email, :dob, :ssn, :street, :locality, :region, :postal_code, :destination, :funding_email, :mobile_number, :account_number, :routing_number)
    end
  end
end
