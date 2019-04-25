class MessagesController < ApplicationController
  before_action :get_messages, only: [:show, :index]

  def create
    received_by_id =  if params[:message][:received_by_id].present?
                        params[:message][:received_by_id]
                      else
                        Place.find(params[:message][:messagable_id]).host.user.id
                      end
    @message = current_user.messages.create(params_message.merge({received_by_id: received_by_id}))
    if params[:message][:received_by_id].present?
      respond_to :js
    else
      redirect_to messages_path
    end
  end

  def index
    @recent_messages = []
    @contacted_user_ids = if @messages.collect(&:user_id).uniq.length > 1
                            @messages.where.not(user_id: current_user.id).pluck(:user_id).uniq
                          else
                            @messages.collect(&:user_id).uniq
                          end
    @contacted_user_ids.each do |id|
      @recent_messages.push(@messages.where("user_id = ? OR received_by_id = ?", id,id).last)
    end
  end

  def show
    @conversation = @messages.where("user_id = ? OR received_by_id = ?", params[:id], params[:id])
    @message = Message.new(received_by_id: params[:id], messagable_type: @conversation.first.messagable_type, messagable_id: @conversation.first.messagable_id)
  end

  private
    def params_message
      params.require(:message).permit(:message, :messagable_type, :messagable_id)
    end

    def get_messages
      @messages = Message.where("user_id = ? OR received_by_id = ?" ,current_user.id, current_user.id)
    end
end
