class Users::InvitationsController < Devise::InvitationsController
  before_action :change_path

  def new
    self.resource = resource_class.new
    @pending_users = User.where(invitation_accepted_at: nil, invited_by_id: current_user.id)
    @accepted_users = User.where.not(invitation_accepted_at: nil).where(invited_by_id: current_user.id)
    render :new
  end

  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?
    yield resource if block_given?
    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, :email => self.resource.email
      end
      if self.method(:after_invite_path_for).arity == 1
        respond_with resource, :location => after_invite_path_for(current_inviter)
      else
        redirect_to new_user_invitation_path, notice: "Invitation Sent"
      end
    else
      redirect_to new_user_invitation_path, notice: "Invitation Not Sent"
    end
  end

  def change_path
    redirect_to root_path
  end
end
