module Api::V1
  class MessagesController < ApplicationController

    def create
      if received_by_id = Place.find_by_id(params[:message][:messagable_id]).try(:host_id)
        @message = get_current_user.messages.create(params_message.merge({received_by_id: received_by_id}))
        render json: @message
      else
        render json: {status: "failed"}
      end
    end

    private

      def params_message
        params.require(:message).permit(:message, :messagable_type, :messagable_id)
      end
  end
end