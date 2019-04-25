module Api::V1
  class AccountSettingsController < BaseApiController
    before_action :set_account_setting, only: [:edit, :update, :show]
    before_action :validate_params, only: [:update, :edit, :show]

    def edit
      render json: {account_setting: @account_setting}
    end

    def update
      @account_setting.update(params_account_setting)
      #render json: {account_setting: @account_setting}
    end

    def show
      #render json: {account_setting: @account_setting}
    end

    private
      def params_account_setting
        params.require(:account_setting).permit(:message_email, :message_push_notification, :message_text_message, :reminder_email, :reminder_push_notification, :reminder_text_message, :promotion_and_tip_email, :promotion_and_tip_push_notification, :promotion_and_tip_text_message, :promotion_and_tip_phone_call, :policy_and_community_email, :policy_and_community_push_notification, :policy_and_community_text_message, :policy_and_community_phone_call, :account_support_email, :account_support_push_notification, :account_support_text_message)
      end

      def set_account_setting
        @account_setting = @current_user.account_setting
      end

      def validate_params
        raise "Invaid Token for User ID: #{params[:id]}" unless @current_user.id == params.require(:id).to_i
      rescue => e
        render json: {status: "failure", error: e.message}, status: 406
      end
  end
end
